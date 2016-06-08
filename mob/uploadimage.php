<?php
function clean_input($data) {
	$data = trim($data);
	$data = stripslashes($data);
	$data = htmlspecialchars($data);
	return $data;
}

$file_v = clean_input($_POST['file']);
$name_v = clean_input($_POST['name']);
$name = round($name_v/1000);
$ImageData = $file_v;
$ImageData = str_replace("data:image/jpg;base64,","",$ImageData);
$ImageData = str_replace("data:image/png;base64,","",$ImageData);
$ImageData = str_replace(" ", "+", $ImageData);
$ImageData = base64_decode($ImageData);
$message = "ERROR!";
if (strlen($ImageData)>100)
{
	$date = date("Y-m-d",time());
	$ticketgallery = "../sites/default/files/ticket/images/$date";
	$isdirexist = file_exists($ticketgallery);
	if ($isdirexist==false) mkdir($ticketgallery);
	$filename="$ticketgallery/img_".date('Ymd_His',$name).'.jpg';	
	file_put_contents($filename, $ImageData);
	$message = "$filename is uploaded!";
}
imagedestroy($img);
echo $message;
?>