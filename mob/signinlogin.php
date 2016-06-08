<?php

//
// Uj user regisztracioja vagy letezo user jelszo ellenorzese
//

// Drupal betöltése
$root = $_SERVER['DOCUMENT_ROOT'];
define('DRUPAL_ROOT', $root);
chdir(DRUPAL_ROOT);
require './includes/bootstrap.inc';
drupal_bootstrap(DRUPAL_BOOTSTRAP_DATABASE);

global $databases;
$host = $databases["default"]["default"]["host"];
$username = $databases["default"]["default"]["username"];
$password = $databases["default"]["default"]["password"];
$database = $databases["default"]["default"]["database"];
$con = mysqli_connect($host,$username,$password,$database);
mysqli_set_charset($con,"utf8");

function clean_input($data) {
	$data = trim($data);
	$data = stripslashes($data);
	$data = htmlspecialchars($data);
	return $data;
}

//
// Ha atjott az email cim a mobil eszkozrol
//
$facebook_id_v = clean_input($_GET['facebook_id']);
$facebook_id_v = mysqli_real_escape_string($con,$facebook_id_v);
$name_v = clean_input($_GET['name']);
$name_v = mysqli_real_escape_string($con,$name_v);
$username_v = clean_input($_GET['username']);
$username_v = mysqli_real_escape_string($con,$username_v);
$email_v = clean_input($_GET['email']);
$email_v = mysqli_real_escape_string($con,$email_v);
$md5passwd_v = clean_input($_GET['jelszo']);
$md5passwd_v = mysqli_real_escape_string($con,$md5passwd_v);

// *****************************************************************************************
$ownerid = '0';
$status = '0';

// Email formatum ellenorzes
// Ha rossz, akkor nem kerul az adatbazisba
if (filter_var($email_v, FILTER_VALIDATE_EMAIL))
{
 // Ha jo az email cim formatuma
 mysqli_query($con,"SET NAMES utf8");
 mysqli_query($con,"SET collation_connection = 'utf8'");
 $result = mysqli_query($con,"select mob_owners.id, mob_owners.password from mob_owners where mob_owners.email = '".$email_v."'");
 while($row = mysqli_fetch_array($result))
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
	mysqli_query($con,"SET NAMES utf8");
	mysqli_query($con,"SET collation_connection = 'utf8'");
	$sql=mysqli_query($con,"insert into mob_owners (name, email, password) values ('".$name_v."', '".$email_v."', '".$md5passwd_v."') ");
	$result2 = mysqli_query($con,"select mob_owners.id, mob_owners.password from mob_owners where mob_owners.email = '".$email_v."' ");
	while($row = mysqli_fetch_array($result2))
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
      mysqli_query($con,"SET NAMES utf8");
      mysqli_query($con,"SET collation_connection = 'utf8'");
      $result = mysqli_query($con,"select mob_owners.id, mob_owners.password from mob_owners where mob_owners.facebook_id = '".$facebook_id_v."'");
      while($row = mysqli_fetch_array($result))
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
	  mysqli_query($con,"SET NAMES utf8");
	  mysqli_query($con,"SET collation_connection = 'utf8'");
	  $sql=mysqli_query($con,"insert into mob_owners (name, facebook_id, password) values ('".$name_v."', '".$facebook_id_v."', '".$md5passwd_v."') ");
	  $result2 = mysqli_query($con,"select mob_owners.id, mob_owners.password from mob_owners where mob_owners.facebook_id = '".$facebook_id_v."' ");
	  while($row = mysqli_fetch_array($result2))
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

mysqli_close($con);

?>