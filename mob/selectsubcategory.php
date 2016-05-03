<?php

// MySQL csatlakozas adatai
// mysql_connect("localhost","root","cwr11SQL");
// mysql_select_db("appdb");

$icon = mysql_connect("localhost","timi","PcaqYs5HwFsQV7xG");;
if(!$icon)
{
die('Nem lehet csatlakozni : ' . mysql_error());
}
mysql_select_db("timi", $icon)or die("Nem megfelelo adatbazis");

mysql_query("SET NAMES utf8");
mysql_query("SET collation_connection = 'utf8'");

// echo json_encode($data);
$language = $_GET["language"];

// Alkategoriakat olvassuk ki egy megadott fokategoriahoz
$sql=mysql_query("SELECT subcategory_id, category_id, name FROM mob_subcategories WHERE language_id='$language'");

while($row=mysql_fetch_assoc($sql))
$output[]=$row;
//$output=$row;
echo(json_encode($output));// this will print the output in json

// Kapcsolat lezarasa
mysql_close($icon);

?>