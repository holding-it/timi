<?php

// MySQL csatlakozás adatai
// mysql_connect("localhost","root","cwr11SQL");
// mysql_select_db("mobdb");

$icon = mysql_connect("localhost","root","cwr11SQL");
if(!$icon)
{
die('Nem lehet csatlakozni : ' . mysql_error());
}
mysql_select_db("appdb", $icon)or die("Nem megfelelo adatbazis");

// Karakterkeszlet illesztes adatai
mysql_query("SET NAMES utf8");
mysql_query("SET collation_connection = 'utf8'");

// A helyadatokbol igy visszafele a kategoriaig el lehet jutni.
$sql=mysql_query("select mobtick.holvan, mobtick.latitude, mobtick.longitude, mobalkat.kategoriaid from mobtick 
		join mobalkat on mobtick.alkategoriaid = mobalkat.id");

while($row=mysql_fetch_assoc($sql))
$output[]=$row;

//$output=$row;
echo(json_encode($output));// this will print the output in json

// mysql_close();
mysql_close($icon);

?>