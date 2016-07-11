<?php
// Database connection
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

// Clean input
function clean_input($data) {
	$data = trim($data);
	$data = stripslashes($data);
	$data = htmlspecialchars($data);
	return $data;
}

// Get values
$protocol = clean_input($_POST["protocol"]);
$protocol = mysqli_real_escape_string($con,$protocol);
$device_id = clean_input($_POST["device_id"]);
$device_id = mysqli_real_escape_string($con,$device_id);
$device_time = clean_input($_POST["device_time"]);
$device_time = mysqli_real_escape_string($con,$device_time);
$valid = clean_input($_POST["valid"]);
$valid = mysqli_real_escape_string($con,$valid);
$latitude = clean_input($_POST["latitude"]);
$latitude = mysqli_real_escape_string($con,$latitude);
$longitude = clean_input($_POST["longitude"]);
$longitude = mysqli_real_escape_string($con,$longitude);
$altitude = clean_input($_POST["altitude"]);
$altitude = mysqli_real_escape_string($con,$altitude);
$speed = clean_input($_POST["speed"]);
$speed = mysqli_real_escape_string($con,$speed);
$course = clean_input($_POST["course"]);
$course = mysqli_real_escape_string($con,$course);
$address = clean_input($_POST["address"]);
$address = mysqli_real_escape_string($con,$address);
$attributes = clean_input($_POST["attributes"]);
$attributes = mysqli_real_escape_string($con,$attributes);
$watchid = clean_input($_POST["watchid"]);
$watchid = mysqli_real_escape_string($con,$watchid);

$server_time = date("Y-m-d H:i:s",time());
$fix_time = 0; // Ideiglenesen


// Insert
$insert = "INSERT INTO mob_routes(protocol,device_id,server_time,device_time,fix_time,valid,latitude,longitude,altitude,speed,course,address,attributes,watch_id) VALUES ('$protocol',$device_id,'$server_time','$device_time','$fix_time',$valid,$latitude,$longitude,$altitude,$speed,$course,'$address','$attributes',$watchid)";
$insert = str_replace(",,",",null,",$insert);
$insert = str_replace(",'',",",null,",$insert);
mysqli_query($con, $insert) or die("$insert >> HIBA!: ".mysqli_error($con));
mysqli_close($con);

echo "OK!";
?>