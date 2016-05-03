<?php

// MySQL csatlakozas adatai
// mysql_connect("localhost","root","cwr11SQL");
// mysql_select_db("megafile_db");

$icon = mysql_connect("localhost","root","cwr11SQL");
if(!$icon)
{
die('Nem lehet csatlakozni : ' . mysql_error());
}
mysql_select_db("appdb", $icon)or die("Nem megfelelo adatbazis");

mysql_query("SET NAMES utf8");
mysql_query("SET collation_connection = 'utf8'");

$language = $_GET["language"];

// Fokategoriak adatait olvassuk
$sql=mysql_query("SELECT category_id, name FROM mob_categories WHERE language='$language'");

while($row=mysql_fetch_assoc($sql))
$output[]=$row;

//$output=$row;
echo(json_encode($output));// this will print the output in json

mysql_close($icon);

?>