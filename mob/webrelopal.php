<?php

header("Content-type: text/html; charset=UTF-8");
$con=mysqli_connect("localhost","root","cwr11SQL","appdb");

// A kapcsolat ellenorzese
if (mysqli_connect_errno())
  {
    echo "Nem sikerult a MySQL kapcsolodas: " . mysqli_connect_error();    
  }

mysqli_query($con,"SET NAMES utf8");
mysqli_query($con,"SET collation_connection = 'utf8'");

$result = mysqli_query($con,"select mob_tickets.locationname, mob_tickets.latitude, mob_tickets.longitude, mob_categories.name, mob_subcategories.name, mob_tickets.ticket_id, mob_pictures.title, mob_pictures.filename from mob_tickets
    join mob_subcategories on mob_tickets.subcategory_id = mob_subcategories.subcategory_id
    join mob_categories on mob_subcategories.category_id = mob_categories.category_id
    join mob_pictures on mob_tickets.ticket_id = mob_pictures.ticket_id order by mob_tickets.ticket_id desc");

while($row = mysqli_fetch_array($result))
  {
    $img = $row[7];
    echo "<a href='$img' target=blank><img src='$img' width=200 /> </a>";  
  }

mysqli_close($con);
?>
