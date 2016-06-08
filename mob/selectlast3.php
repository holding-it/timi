<?php
$root = $_SERVER['DOCUMENT_ROOT'];
$base_url = $GLOBALS['base_url'];
define('DRUPAL_ROOT', $root);
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

function clean_input($data) {
	$data = trim($data);
	$data = stripslashes($data);
	$data = htmlspecialchars($data);
	return $data;
}

// Ha atjott az fbid a mobil eszkozrol
// echo json_encode($data);
// $fbid_v= $_GET['fbid'];
$owner = clean_input($_GET['owner']);
$owner = mysqli_real_escape_string($con,$owner);
$language = clean_input($_GET['language']);
$language = mysqli_real_escape_string($con,$language);
// echo(json_encode($ownerid));// this will print the output in json

// *****************************************************************************************

// mysql_query("SET NAMES utf8");
// mysql_query("SET collation_connection = 'utf8'");

// $result = mysql_query("select mobowner.id from mobowner where mobowner.fbid like '".$fbid_v."' ");

// while($row = mysql_fetch_array($result))
//  {
//    $ownerid = $row[0];
//  }

    // echo(json_encode($ownerid));

// ****************************************************************************************

// Megvan a tulajdonos fbid-je!
$sql=mysqli_query($con,"SELECT DISTINCT mob_tickets.locationname, mob_tickets.description, mob_tickets.date AS date, mob_subcategories.name AS subcatname, mob_pictures.filename, mob_categories.name AS catname, mob_statuses.text AS statustext, mob_tickets.ticketgroup_id AS ticketgroup
FROM mob_tickets, mob_ticketgroups, mob_subcategories, mob_pictures, mob_categories, mob_statuses
WHERE mob_tickets.ticketgroup_id = mob_ticketgroups.ticketgroup_id
AND mob_tickets.subcategory_id = mob_subcategories.subcategory_id
AND mob_tickets.ticket_id = mob_pictures.ticket_id
AND mob_subcategories.category_id = mob_categories.category_id
AND mob_tickets.act_status = mob_statuses.status_id 
AND mob_tickets.ownerid = $owner 
AND mob_categories.language_id=$language 
AND mob_subcategories.language_id=$language
AND mob_statuses.language_id=$language
ORDER BY mob_tickets.date DESC LIMIT 3");

while($row=mysqli_fetch_assoc($sql))
    $output[]=$row;

// Ha a meddigvolt elem null erteku, akkor kicsereljuk Folyamatban stringre a teljes tombben
/*foreach($output as $index=>$result_row) {
        if( !$result_row["meddigvolt"] ) {
            $output[$index]["meddigvolt"] = "Folyamatban";
        }
    //        if( !$result_row["status"] ) {
    //            $output[$index]["status"] = "Új eset";
    //        }
}*/


//$output=$row;
echo(json_encode($output));// this will print the output in json

// mysql_close();
mysqli_close($con);

?>