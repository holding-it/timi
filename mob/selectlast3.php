<?php

$icon = mysql_connect("localhost","root","cwr11SQL");
if(!$icon)
{
die('Nem lehet csatlakozni : ' . mysql_error());
}
mysql_select_db("appdb", $icon) or die("Nem megfelelo adatbazis");

// Ha atjott az fbid a mobil eszkozrol
// echo json_encode($data);
// $fbid_v= $_GET['fbid'];
$ownerid= $_GET['fbid'];
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

// Karakterkeszlet illesztes adatai
mysql_query("SET NAMES utf8");
mysql_query("SET collation_connection = 'utf8'");

// Megvan a tulajdonos fbid-je!
$sql=mysql_query("select mobtick.miahiba, date(mobtick.mikortolvan) as mikortolvan, mobalkat.megnevezes as alkatnev, mobpic.filename, 
			 mobkat.megnevezes as katnev, mobtgrp.statustext as allapota from mobtick  
			 join mobtgrp on mobtick.tgroupid = mobtgrp.id
			 join mobalkat on mobtick.alkategoriaid = mobalkat.id 
			 join mobpic on mobtick.id = mobpic.ticketid  
			 join mobkat on mobalkat.kategoriaid = mobkat.id  where mobtick.ownerid =  '".$ownerid."' order by mobtick.mikortolvan desc limit 3");

while($row=mysql_fetch_assoc($sql))
    $output[]=$row;

// Ha a meddigvolt elem null erteku, akkor kicsereljuk Folyamatban stringre a teljes tombben
foreach($output as $index=>$result_row) {
        if( !$result_row["meddigvolt"] ) {
            $output[$index]["meddigvolt"] = "Folyamatban";
        }
    //        if( !$result_row["allapota"] ) {
    //            $output[$index]["allapota"] = "Új eset";
    //        }
}


//$output=$row;
echo(json_encode($output));// this will print the output in json

// mysql_close();
mysql_close($icon);

?>