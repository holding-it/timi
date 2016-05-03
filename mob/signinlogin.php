<?php

//
// Uj user regisztracioja vagy letezo user jelszo ellenorzese
//

$icon = mysql_connect("localhost","timi","PcaqYs5HwFsQV7xG");
if(!$icon)
{
die('Nem lehet csatlakozni : ' . mysql_error());
}
mysql_select_db("timi", $icon) or die("Nem megfelelo adatbazis");

//
// Ha atjott az email cim a mobil eszkozrol
//
$facebook_id_v = $_GET['facebook_id'];
$name_v = $_GET['name'];
$username_v = $_GET['username'];
$email_v = $_GET['email'];
$md5passwd_v = $_GET['jelszo'];

// *****************************************************************************************
$ownerid = '0';
$status = '0';

// Email formatum ellenorzes
// Ha rossz, akkor nem kerul az adatbazisba
if (filter_var($email_v, FILTER_VALIDATE_EMAIL))
{
 // Ha jo az email cim formatuma
 mysql_query("SET NAMES utf8");
 mysql_query("SET collation_connection = 'utf8'");
 $result = mysql_query("select mob_owners.id, mob_owners.password from mob_owners where mob_owners.email = '".$email_v."'");
 while($row = mysql_fetch_array($result))
  {
    // Letezik ilyen felhasznalo
    $ownerid = $row[0];
    $status = '1';
    if ($md5passwd_v == $row[1]) $status = '2';
  }
 
 // Uj felhasznalo tarolasa az adatbazisban
 if ($ownerid == 0)
 {
   if (strlen($name_v)>4)
    {
	mysql_query("SET NAMES utf8");
	mysql_query("SET collation_connection = 'utf8'");
	$sql=mysql_query("insert into mob_owners (name, email, password) values ('".$name_v."', '".$email_v."', '".$md5passwd_v."') ");
	$result2 = mysql_query("select mob_owners.id, mob_owners.password from mob_owners where mob_owners.email = '".$email_v."' ");
	while($row = mysql_fetch_array($result2))
	{
	    $ownerid = $row[0];
	    $status = '3';
	    if ($md5passwd_v == $row[1]) $status = '4';
	}
    }else $status = 7; // Rovid a nev
 }
}else $status = 5; // Rossz az email formatuma !! Ekkor a status = 5 !

// Ha nem jo az email cím, akkor meg johetett Facebook ID-val
// akkor viszont jon a nev, facebook_id, meg a nev MD5 változata jelszokent
// $num = (double)$facebook_id_v;
if ($status == 5)
{
  if ((strlen($facebook_id_v)>8) && (ctype_digit($facebook_id_v)))
  {
      // Bár rossz volt az email, de van Facebook ID, amely legalabb 9 karakteres es csupa szamjegybol all
      mysql_query("SET NAMES utf8");
      mysql_query("SET collation_connection = 'utf8'");
      $result = mysql_query("select mob_owners.id, mob_owners.password from mob_owners where mob_owners.facebook_id = '".$facebook_id_v."'");
      while($row = mysql_fetch_array($result))
        {
        // Letezik ilyen Facebook felhasznalo
        $ownerid = $row[0];
        $status = '1';
        if ($md5passwd_v == $row[1]) $status = '2';
        }
      // Uj Facebook felhasznalo tarolasa az adatbazisban
      if ($ownerid == 0)
      {
        if (strlen($name_v)>4)
        {
	  mysql_query("SET NAMES utf8");
	  mysql_query("SET collation_connection = 'utf8'");
	  $sql=mysql_query("insert into mob_owners (name, facebook_id, password) values ('".$name_v."', '".$facebook_id_v."', '".$md5passwd_v."') ");
	  $result2 = mysql_query("select mob_owners.id, mob_owners.password from mob_owners where mob_owners.facebook_id = '".$facebook_id_v."' ");
	  while($row = mysql_fetch_array($result2))
	    {
	      $ownerid = $row[0];
	      $status = '3';
	      if ($md5passwd_v == $row[1]) $status = '4';
	    }
        }else $status = 7; // Rovid a nev
      }
  }else $status = 6; // Sem az email nem jo, sem pedig facebook_id  nem erkezett !!
}

//
// Csinalunk egy JSON szabvanyu asszociativ tombot
//
// $output[] = array('status' => $status, 'ownerid' => $ownerid); // Igy lesz tomb!
$output = array('status' => $status, 'ownerid' => $ownerid); // Igy meg nem lesz tomb!
echo(json_encode($output));

mysql_close($icon);

?>