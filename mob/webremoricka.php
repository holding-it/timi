<?php

header("Content-type: text/html; charset=UTF-8");
define('DRUPAL_ROOT', '/vhost/mholding/timi.hu');
chdir(DRUPAL_ROOT);
require './includes/bootstrap.inc';
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);
global $databases;
$username = $databases["default"]["default"]["username"];
$password = $databases["default"]["default"]["password"];
$database = $databases["default"]["default"]["database"];
$con = mysqli_connect("localhost",$username,$password,$database);

mysqli_query($con,"SET NAMES utf8");
mysqli_query($con,"SET collation_connection = 'utf8'");

/*$result = mysqli_query($con,"select mob_tickets.locationname, mob_tickets.latitude, mob_tickets.longitude, mob_categories.name, mob_subcategories.name, mob_tickets.ticket_id, mob_pictures.title, mob_pictures.filename from mob_tickets
    join mob_subcategories on mob_tickets.subcategory_id = mob_subcategories.subcategory_id 
    join mob_categories on mob_subcategories.category_id = mob_categories.category_id
    join mob_pictures on mob_tickets.ticket_id = mob_pictures.ticket_id order by mob_tickets.ticket_id desc");*/
	
$result = mysqli_query($con,"SELECT mob_tickets.locationname, mob_tickets.latitude, mob_tickets.longitude, mob_categories.name, mob_subcategories.name, mob_tickets.ticket_id, mob_pictures.title, mob_pictures.filename, mob_languages.name, mob_tickets.description, mob_statuslogs.status_id, mob_tickets.manual FROM mob_tickets, mob_subcategories, mob_categories, mob_pictures, mob_languages, mob_statuslogs WHERE mob_tickets.subcategory_id = mob_subcategories.subcategory_id AND mob_subcategories.category_id = mob_categories.category_id AND mob_tickets.ticket_id = mob_pictures.ticket_id AND mob_tickets.language_id = mob_languages.language_id AND mob_statuslogs.ticket_id = mob_tickets.ticket_id GROUP BY mob_tickets.ticket_id ORDER BY mob_tickets.ticket_id DESC");

echo "<table border='1'>
<tr>
<th>Ticket ID</th>
<th>Latitude</th>
<th>Longitude</th>
<th>Category name</th>
<th>Subcategory name</th>
<th>Location</th>
<th>Description</th>
<th>Language</th>
<th>Title</th>
<th>Filename</th>
<th>Statuscode</th>
<th>Nid</th>
</tr>";

while($row = mysqli_fetch_array($result))
  {
  echo "<tr>";
  echo "<td>" . $row[5] . "</td>";
  echo "<td>" . $row[1] . "</td>";
  echo "<td>" . $row[2] . "</td>";

// $row[3] = utf8_encode($row[3]);
  echo "<td>" . $row[3] . "</td>";

// $row[4] = utf8_encode($row[4]);
  echo "<td>" . $row[4] . "</td>";
  echo "<td>" . $row[0] . "</td>";
  echo "<td>" . $row[9] . "</td>";
  echo "<td>" . $row[8] . "</td>";
  echo "<td>" . $row[6] . "</td>";

  $img = $row[7];
  echo "<td><a href='$img' target=blank><img src='$img' width=200 /> </a></td>";
  echo "<td>" . $row[10] . "</td>";
  echo "<td>" . $row[11] . "</td>";
  echo "</tr>";
  }
echo "</table>";

mysqli_close($con);
?>
