<?php
echo "{
    \"type\": \"FeatureCollection\",
    \"features\": [";
$kat = $_GET["Kat"];
$con = mysqli_connect("localhost","timi","PcaqYs5HwFsQV7xG","timi");
if (!$con) {
    die('Could not connect: ' . mysqli_error($con));
}
mysqli_set_charset($con,"utf8");
$sql = "SELECT mob_tickets.latitude, mob_tickets.longitude, mob_tickets.locationname, mob_tickets.description, mob_pictures.filename, mob_tickets.language_id FROM mob_tickets, mob_pictures, mob_subcategories WHERE mob_tickets.subcategory_id=mob_subcategories.subcategory_id AND mob_subcategories.category_id=$kat AND mob_tickets.ticket_id=mob_pictures.ticket_id AND mob_tickets.latitude>0 AND mob_tickets.longitude>0 GROUP BY mob_tickets.ticket_id;";
$result = mysqli_query($con,$sql);
$markerek = "";
$i = 0;
$max = mysqli_num_rows($result);
while($row = mysqli_fetch_array($result)) {
	$lat = $row[0];
	$lon = $row[1];
	$cim = $row[2];
	$szoveg = $row[3];
	$kep = $row[4];
	$language = $row[5];
	if ($kep == "photos/nincs_kep_feltoltve.jpg") $kep=""; else $kep="http://www.timi.hu/mob/".$kep;
	echo "    
		{
            \"type\": \"Feature\",
            \"geometry\": {
                \"type\": \"Point\",
                \"coordinates\": [$lon,$lat]
            },
            \"properties\": {
                \"popupContent\": \"<b>$cim</b><br>$szoveg\",
				\"popupImage\": \"$kep\",
				\"language\": \"$language\"
            }
        }";
	if ($i!=$max-1) echo ",";
	$i++;
}
echo "
    ]
}";
?>


