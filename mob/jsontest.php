<?php
define('DRUPAL_ROOT', '/vhost/mholding/timi.hu');
chdir(DRUPAL_ROOT);
require './includes/bootstrap.inc';
drupal_bootstrap(DRUPAL_BOOTSTRAP_DATABASE);
global $databases;
$username = $databases["default"]["default"]["username"];
$password = $databases["default"]["default"]["password"];
$database = $databases["default"]["default"]["database"];
$con = mysqli_connect("localhost",$username,$password,$database);
mysqli_set_charset($con,"utf8");

mysqli_close($con);
?>