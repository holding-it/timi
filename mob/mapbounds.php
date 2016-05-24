<?php
$root = $_SERVER['DOCUMENT_ROOT'];
define('DRUPAL_ROOT', $root);
chdir(DRUPAL_ROOT);
require './includes/bootstrap.inc';
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);
echo views_embed_view('mapbounds');
?>