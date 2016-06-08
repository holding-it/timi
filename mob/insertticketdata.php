<?php
// OS és Browser felderitese
$user_agent = $_SERVER['HTTP_USER_AGENT'];
    function getOS() { 
        global $user_agent;
        $os_platform    =   'Windows';
        $os_array       =   array (
            '/windows nt 6.2/i'     => 'Windows 8',
            '/windows nt 6.1/i'     => 'Windows 7',
            '/windows nt 6.0/i'     => 'Windows Vista',
            '/windows nt 5.2/i'     => 'Windows Server 2003/XP x64',
            '/windows nt 5.1/i'     => 'Windows XP',
            '/windows xp/i'         => 'Windows XP',
            '/windows nt 5.0/i'     => 'Windows 2000',
            '/windows me/i'         => 'Windows ME',
            '/win98/i'              => 'Windows 98',
            '/win95/i'              => 'Windows 95',
            '/win16/i'              => 'Windows 3.11',
            '/macintosh|mac os x/i' => 'Mac OS X',
            '/mac_powerpc/i'        => 'Mac OS 9',
            '/linux/i'              => 'Linux',
            '/ubuntu/i'             => 'Ubuntu',
            '/iphone/i'             => 'iPhone',
            '/ipod/i'               => 'iPod',
            '/ipad/i'               => 'iPad',
            '/android/i'            => 'Android',
            '/blackberry/i'         => 'BlackBerry',
            '/webos/i'              => 'Mobile'
        );
        foreach ($os_array as $regex => $value) { 
            if (preg_match($regex, $user_agent)) $os_platform = $value;
        }   
        return $os_platform;
    }

    function getBrowser() {
        global $user_agent;
        $browser        =   "Browser";
        $browser_array  =   array (
            '/msie/i'       => 'Internet Explorer',
            '/firefox/i'    => 'Firefox',
            '/safari/i'     => 'Safari',
            '/chrome/i'     => 'Chrome',
            '/opera/i'      => 'Opera',
            '/netscape/i'   => 'Netscape',
            '/maxthon/i'    => 'Maxthon',
            '/konqueror/i'  => 'Konqueror',
            '/mobile/i'     => 'Handheld Browser'
        );
        foreach ($browser_array as $regex => $value) { 
            if (preg_match($regex, $user_agent)) $browser = $value;
        }
        return $browser;
    }
    $user_os        =   getOS();
    $user_browser   =   getBrowser();

$output = array();
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

// echo json_encode($data);
$owner_v= clean_input($_POST['fbid']);
$owner_v = mysqli_real_escape_string($con,$owner_v);
$name_v= clean_input($_POST['name']);
$name_v = mysqli_real_escape_string($con,$name_v);
$locationname_v= clean_input($_POST['locationname']);
$locationname_v = mysqli_real_escape_string($con,$locationname_v);
$latitude_v= clean_input($_POST['latitude']);
$latitude_v = mysqli_real_escape_string($con,$latitude_v);
$longitude_v = clean_input($_POST['longitude']);
$longitude_v = mysqli_real_escape_string($con,$longitude_v);
$description_v = clean_input($_POST['description']);
$description_v = mysqli_real_escape_string($con,$description_v);
$file_v = clean_input($_POST['file']);
$file_v = mysqli_real_escape_string($con,$file_v);
$subcategory_id_v = clean_input($_POST['subcategory_id']);
$subcategory_id_v = mysqli_real_escape_string($con,$subcategory_id_v);
$language_v = clean_input($_POST['language']);
$language_v = mysqli_real_escape_string($con,$language_v);
$name_v = clean_input($_POST['name']);
$name_v = mysqli_real_escape_string($con,$name_v);
$name = round($name_v/1000);

// Uj hibajegy keszul, amelynek ownerid-je itt mar megvan.
// Bekerules utan statusza: "Uj hibajegy" lesz, ennek kodja: 1
$insert3 = mysqli_query($con,"INSERT INTO mob_tickets (ownerid, subcategory_id, description, locationname, latitude, longitude, date, ticketgroup_id, language_id, act_status) 
    VALUES ('".$owner_v."', '".$subcategory_id_v."', '".$description_v."', '".$locationname_v."', '".$latitude_v."', '".$longitude_v."', now(), 0, $language_v, 27)");

// A legutobb beszurt rekord szama kerul a $ticket_v valtozoba
$ticket_v = mysqli_insert_id($con);

// A mob_statuslogs tablaba keruljon be a hibajegy status valtozasa: uj jegy
// a ticket.id mar megvan a $ticket_v valtozoban
/*mysqli_query($con,"SET NAMES utf8");
mysqli_query($con,"SET collation_connection = 'utf8'");*/
$insert5 = mysqli_query($con,"INSERT INTO mob_statuslogs (ticket_id, status_id, changestatus) VALUES ('".$ticket_v."', 27, now())");

// Az erkezo base64 formatumu stringet keppe alakitja,
// es menti JPEG fajlkent a photos mappaba.
// A fajl utvonalat es nevet rogziti az adatbazis dmpic tablajaban.
$ImageData = $file_v;
$ImageData = str_replace("data:image/jpg;base64,","",$ImageData);
$ImageData = str_replace("data:image/png;base64,","",$ImageData);
$ImageData = str_replace(" ", "+", $ImageData);
$ImageData = base64_decode($ImageData);
//file_put_contents($filename, $ImageData);
//$img = imagecreatefromstring(base64_decode($file_v));
//if($img != false)
if (strlen($ImageData)>100)
{
	//header('Content-Type: image/jpeg');
	// Erkezett kep es raadasul megfelelo meretu
	// $filename='photos/img'.time().'.jpg';
	$date = date("Y-m-d",time());
	$ticketgallery = "../sites/default/files/ticket/images/$date";
	$isdirexist = file_exists($ticketgallery);
	if ($isdirexist==false) mkdir($ticketgallery);
	
	
	$filename="$ticketgallery/img_".date('Ymd_His',$name).'.jpg';	
	$title_v = $user_os.date('-Y-m-d-H-i-s');
	//imagejpeg($img, $filename); // Menti a kepet a photos mappaba.		
	/*mysqli_query($con,"SET NAMES utf8");
	mysqli_query($con,"SET collation_connection = 'utf8'");	*/
	$filename = str_replace("..","",$filename);
	$insert1 = mysqli_query($con,"INSERT INTO mob_pictures (ticket_id,title,filename) VALUES ('".$ticket_v."','".$title_v."', '".$filename."')");		
} else {
	header('Content-Type: image/jpeg');
	// Nem erkezett kep
	// $filename='photos/nincs_kep_feltoltve.jpg'
	$title_v = $user_os.date('-Y-m-d-H-i-s');
	$filename='/sites/default/files/ticket/images/nincs_kep_feltoltve.jpg';				
	/*mysqli_query($con,"SET NAMES utf8");
	mysqli_query($con,"SET collation_connection = 'utf8'");	*/
	$insert1 = mysqli_query($con,"INSERT INTO mob_pictures (ticket_id,title,filename) VALUES ('".$ticket_v."','".$title_v."', '".$filename."')");
}
// Kiuriti a memoriat
	imagedestroy($img);

mysqli_close($con);
	
if($insert1)
{
    $output["success"] = 1;
    $output["message"] = "Sikeres adatkuldes";
    // echoing JSON response
    echo json_encode($output);
}
else
{
    $output["success"] = 0;
    $output["message"] = "Sikertelen adatkuldes......";
    // echoing JSON response
    echo json_encode($output);
}
?>