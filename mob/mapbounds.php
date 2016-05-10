<?php
define('DRUPAL_ROOT', '/vhost/mholding/timi.hu');
chdir(DRUPAL_ROOT);
require './includes/bootstrap.inc';
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);
echo views_embed_view('mapbounds');
?>