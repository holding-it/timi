<?php
// Szukseges a tomboket deklaralni, mert a lekerdezeseknek lehet NULL eredmenye!!!
$output = array();
$output2 = array();
// Database connection
$root = $_SERVER['DOCUMENT_ROOT'];
define('DRUPAL_ROOT', $root);
chdir(DRUPAL_ROOT);
require './includes/bootstrap.inc';
drupal_bootstrap(DRUPAL_BOOTSTRAP_DATABASE);
// Dinamikus parameteratadas
global $databases;
$host = $databases["default"]["default"]["host"];
$username = $databases["default"]["default"]["username"];
$password = $databases["default"]["default"]["password"];
$database = $databases["default"]["default"]["database"];

$icon = mysql_connect($host,$username,$password);
if(!$icon)
{
die('Nem lehet csatlakozni : ' . mysql_error());
}
mysql_select_db($database, $icon)or die("Nem megfelelo adatbazis");

mysql_query("SET NAMES utf8");
mysql_query("SET collation_connection = 'utf8'");
// -----------------
// Egyedi hibajegyek
// Kizarolag a Varakozo - 30, Elharitas folyamatban - 32, Megoldva - 33 allapotu jegyek
// WHERE t1.ticketgroup_id = 0 AND t2.language_id = 35 AND t1.act_status IN (30,32,33) legyen a feltétel!
$sql=mysql_query("SELECT t1.act_status AS Allapotkod, t2.text AS Allapot, COUNT(t1.description) AS Darab
FROM  `mob_tickets` AS t1
INNER JOIN  `mob_statuses` AS t2 ON t1.act_status = t2.status_id
WHERE t1.ticketgroup_id = 0 AND t2.language_id = 35 AND t1.act_status IN (30,32,33)
GROUP BY t1.act_status, t2.text
ORDER BY t1.act_status ASC");
while($row=mysql_fetch_assoc($sql))
$output[]=$row;
// ----------------------------------------------
// A moderator altal csoportba foglalt hibajegyek
// Kizarolag a Varakozo - 30, Elharitas folyamatban - 32, Megoldva - 33 allapotu jegyek
$sql2=mysql_query("SELECT t1.status_id AS Allapotkod, t2.text AS Allapot, COUNT(*) AS Darab
FROM  `mob_ticketgroups` AS t1
INNER JOIN  `mob_statuses` AS t2 ON t1.status_id = t2.status_id
WHERE t1.deleted = 0 AND t2.language_id = 35 AND t1.status_id IN (30,32,33)
GROUP BY t1.status_id, t2.text
ORDER BY t1.status_id ASC");
while($row2=mysql_fetch_assoc($sql2))
$output2[]=$row2;
// ----------------------
// Osszefuzi a ket tombot
$array3 = array_merge($output, $output2);
// Szummazza a ket tomb megfelelo elemeit
$sum = array_reduce($array3, function ($a, $b) {
    isset($a[$b['Allapotkod']]) ? $a[$b['Allapotkod']]['Darab'] += $b['Darab'] : $a[$b['Allapotkod']] = $b;
    return $a;
});
// --------------------------
// Elkesziti a JSON kimenetet
echo(header("Access-Control-Allow-Origin: *"));
echo(header("Content-Type: application/json; charset=UTF-8"));
echo(json_encode($sum));// eloallitja a JSON tombot
// ------------------
// Kapcsolat lezarasa
mysql_close($icon);

?>
