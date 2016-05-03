<?php

$icon = mysql_connect("localhost","root","cwr11SQL");
if(!$icon)
{
die('Nem lehet csatlakozni : ' . mysql_error());
}
mysql_select_db("appdb", $icon) or die("Nem megfelelo adatbazis");
mysql_query("SET NAMES utf8");
mysql_query("SET collation_connection = 'utf8'");
$sql=mysql_query("select * from mobkat");

while($row=mysql_fetch_assoc($sql))
    $output[]=$row;

echo(json_encode($output));// this will print the output in json

mysql_close($icon);
?>