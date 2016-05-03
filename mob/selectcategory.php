<?php

// MySQL csatlakozás adatai
// mysql_connect("localhost","root","cwr11SQL");
// mysql_select_db("appdb");

$icon = mysql_connect("localhost","timi","PcaqYs5HwFsQV7xG");
if(!$icon)
{
die('Nem lehet csatlakozni : ' . mysql_error());
}
mysql_select_db("timi", $icon)or die("Nem megfelelo adatbazis");

mysql_query("SET NAMES utf8");
mysql_query("SET collation_connection = 'utf8'");

$language = $_GET["language"];

// Kategoriak es alkategoriak adatainak olvasasa
$sql=mysql_query("SELECT mob_subcategories.subcategory_id, mob_subcategories.category_id, mob_subcategories.name AS subcategory, 
		mob_categories.name AS category from mob_subcategories, mob_categories WHERE mob_subcategories.category_id = mob_categories.category_id AND mob_categories.language_id=$language ORDER BY mob_subcategories.category_id");

while($row=mysql_fetch_assoc($sql))
$output[]=$row;
//$output=$row;
echo(json_encode($output));// this will print the output in json

// mysql_close();
mysql_close($icon);

?>