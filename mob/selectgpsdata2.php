<?php
define('DRUPAL_ROOT', '/var/www/timi');
chdir(DRUPAL_ROOT);
require './includes/bootstrap.inc';
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);
global $databases;
$host = $databases["default"]["default"]["host"];
$username = $databases["default"]["default"]["username"];
$password = $databases["default"]["default"]["password"];
$database = $databases["default"]["default"]["database"];
$con = mysqli_connect($host,$username,$password,$database);
mysqli_set_charset($con,"utf8");


echo "{
    \"type\": \"FeatureCollection\",
    \"features\": [";
$kat = $_GET["Kat"];
$stat = $_GET["Stat"];
$ticket = $_GET["Ticket"];
$langcode = $_GET["Langcode"];
$islangid = is_numeric($langcode);
if ($islangid==true) {
	$sql = mysqli_query($con,"SELECT code FROM mob_languages WHERE language_id=$langcode");
	$result = mysqli_fetch_array($sql);
	$langcode = $result[0];
}

if ($langcode!="") $langcodeSQL = "AND mob_categories.language_id=(SELECT language_id FROM mob_languages WHERE code='$langcode') AND mob_subcategories.language_id=(SELECT language_id FROM mob_languages WHERE code='$langcode')";
else $langcodeSQL="";

if ($kat!=0) $katSQL = "AND mob_categories.category_id=$kat"; else $katSQL="";
if ($stat!=0) $statSQLticket = "AND mob_statuslogs.status_id=$stat"; else $statSQLticket="";

// TICKET with PUBLIC AND ACTIVE status, ACTIVE category, ACTIVE subcategory, NOT GROUPED, WITH COORDINATES, NOT REJECTED
$sql = "SELECT mob_tickets.latitude, mob_tickets.longitude, mob_tickets.locationname, mob_tickets.description, mob_pictures.filename, mob_tickets.language_id, mob_subcategories.subcategory_id FROM mob_tickets, mob_pictures, mob_subcategories, mob_categories, mob_statuslogs, mob_statuses WHERE mob_tickets.subcategory_id=mob_subcategories.subcategory_id $katSQL AND mob_tickets.ticket_id=mob_pictures.ticket_id AND mob_tickets.latitude>0 AND mob_tickets.longitude>0 AND mob_subcategories.category_id = mob_categories.category_id AND mob_categories.inactive=0 AND mob_subcategories.inactive=0 AND mob_tickets.ticket_id = mob_statuslogs.ticket_id AND mob_statuslogs.status_id = mob_statuses.status_id AND mob_statuses.public = 1 AND mob_statuses.inactive=0 AND mob_subcategories.inactive=0 AND mob_categories.inactive=0 AND mob_tickets.ticketgroup_id=0 AND mob_tickets.rejection_id=0 $statSQLticket GROUP BY mob_tickets.ticket_id; $ticket";
$result = mysqli_query($con,$sql);
$markerek = "";
$i = 0;
$maxt = mysqli_num_rows($result);
while($row = mysqli_fetch_array($result)) {
	$subcat = $row[6];
	$sql2 = mysqli_query($con,"SELECT name FROM mob_subcategories WHERE subcategory_id=$subcat AND language_id=(SELECT language_id FROM mob_languages WHERE code='$langcode')");
	$row2 = mysqli_fetch_array($sql2);
	$lat = $row[0];
	$lon = $row[1];
	$cim = $row[2];
	if ($cim!="") $cim = "<b>$cim</b><br>";
	$szoveg = $row[3];
	if ($szoveg=="") $szoveg = $row2[0];
	$kep = $row[4];
	$language = $row[5];
	$kep="http://www.timi.hu".$kep;
	$mit = array("timi.huphotos");	
	$mire = array("timi.hu/mob/photos");
	$kep = str_replace($mit,$mire,$kep);
	echo "    
		{
            \"type\": \"Feature\",
            \"geometry\": {
                \"type\": \"Point\",
                \"coordinates\": [$lon,$lat]
            },
            \"properties\": {
                \"popupContent\": \"$cim$szoveg\",
				\"popupImage\": \"$kep\",
				\"language\": \"$language\"
            }
        }";
	if ($i!=$maxt-1) echo ",";
	$i++;
}

if ($stat!=0) $statSQLticketgroup = "AND mob_ticketgroups.status_id=$stat"; else $statSQLticketgroup="";
// TICKETGROUP with PUBLIC AND ACTIVE status, ACTIVE category, ACTIVE subcategory, NOT DELETED
$sql = "SELECT DISTINCT mob_ticketgroups.latitude, mob_ticketgroups.longitude, mob_ticketgroups.location, GROUP_CONCAT(DISTINCT(mob_ticketgroups.moderator_description) SEPARATOR '<br>'), mob_ticketgroups.picture_url, mob_subcategories.name, GROUP_CONCAT(DISTINCT(mob_tickets.ticket_id) ORDER BY mob_tickets.ticket_id SEPARATOR ', '), mob_categories.name, mob_ticketgroups.ticketgroup_id FROM mob_ticketgroups, mob_subcategories, mob_categories, mob_statuses, mob_tickets WHERE mob_tickets.ticketgroup_id = mob_ticketgroups.ticketgroup_id AND mob_ticketgroups.subcategory_id = mob_subcategories.subcategory_id AND mob_subcategories.category_id = mob_categories.category_id $katSQL AND mob_categories.inactive=0 AND mob_subcategories.inactive=0 AND mob_ticketgroups.status_id = mob_statuses.status_id AND mob_statuses.inactive=0 AND mob_statuses.public=1 AND mob_ticketgroups.deleted=0 $statSQLticketgroup $langcodeSQL GROUP BY mob_ticketgroups.ticketgroup_id";
$result = mysqli_query($con,$sql);
$i = 0;
$maxtg = mysqli_num_rows($result);
if (($maxt>0)&&($maxtg>0)) echo ",";
while($row = mysqli_fetch_array($result)) {
	$lat = $row[0];
	$lon = $row[1];
	$cim = $row[2];
	if ($cim!="") $cim = "<b>$cim</b><br>";
	$szoveg = $row[3];
	$kep = $row[4];
	$kep="http://www.timi.hu".$kep;
	$mit = array("timi.huphotos");	
	$mire = array("timi.hu/mob/photos");
	$kep = str_replace($mit,$mire,$kep);
	if ($szoveg=="") $szoveg = $row[5];
	if ($ticket!="") {
		$subcategory = $row[5];
		$category = $row[7];
		$tickets = $row[6];
		$nid = $row[8];
		$cim = "<a href='/node/$nid'>$cim</a>";
		$szoveg = "<u>$category<br>$subcategory</u><br>$szoveg<br><b>$tickets</b>";
	}
	$language = 0;
	echo "    
		{
            \"type\": \"Feature\",
            \"geometry\": {
                \"type\": \"Point\",
                \"coordinates\": [$lon,$lat]
            },
            \"properties\": {
                \"popupContent\": \"$cim$szoveg\",
				\"popupImage\": \"$kep\",
				\"language\": \"$language\"
            }
        }";
	if ($i!=$maxtg-1) echo ",";
	$i++;
}

echo "
    ]
}";

mysqli_close($con);
?>


