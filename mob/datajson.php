<?php
	header('Access-Control-Allow-Origin: *');

	// Database connection
	$con = mysqli_connect("localhost","timi","PcaqYs5HwFsQV7xG","timi");
	if (!$con) {
		die('Nem lehet csatlakozni: ' . mysqli_error($con));
	}
	mysqli_set_charset($con,"utf8");
	
	// GET
	$getlanguage = $_GET["Language"];
	$getversion = $_GET["Version"];
	$gettask = $_GET["Task"];
	
	// Get current language version
	if ($gettask=="langversion") {	
		$select = "SELECT version FROM mob_languages WHERE language_id=$getlanguage";
		$sql = mysqli_query($con, $select);
		$result = mysqli_fetch_array($sql);
		$act_version = $result[0];
		if ($getversion!=$act_version) echo "obsolete";		
	}
	
	// Get all languages
	if ($gettask=="languages") {	
		$select = "SELECT language_id, name, version FROM mob_languages";
		$sql = mysqli_query($con, $select);
		$max = mysqli_num_rows($sql);
		$i = 0;
		echo "{\"elements\":[";
		while ($result = mysqli_fetch_array($sql)) {
			$id = $result["language_id"];
			$name = $result["name"];
			$version = $result["version"];
			?>
			{"id": "<?=$id;?>", "name": "<?=$name;?>", "version": "<?=$version;?>"}
			<?php
			if ($i<$max-1) echo ",";
			$i++;
		}
		echo "]}";
	}
	
	else if ($gettask=="contents") {
		// Contents
		$select = "SELECT id, type, code, language_id, page, content_id FROM mob_contents WHERE language_id='$getlanguage' OR page='index' OR page='language'";
		$sql = mysqli_query($con, $select);
		$max = mysqli_num_rows($sql);
		$i = 0;
		echo "{\"elements\":[";
		while ($result = mysqli_fetch_array($sql)) {
			$id = $result["id"];
			$type = $result["type"];
			$code = $result["code"];
			$language = $result["language_id"];
			$page = $result["page"];
			$content_id = $result["content_id"];
			?>
			{"id": "<?=$id;?>", "type": "<?=$type;?>", "language": "<?=$language;?>", "page": "<?=$page;?>", "content_id": "<?=$content_id;?>", "code": "<?=$code;?>"}
			<?php
			if ($i<$max-1) echo ",";
			$i++;
		}
		echo "],";
		
		// Main categories
		echo "\"categories\":[";
		$select = "SELECT id, category_id, name, language_id FROM mob_categories WHERE language_id=$getlanguage";
		$sql = mysqli_query($con,$select);
		$max = mysqli_num_rows($sql);
		$i = 0;
		while ($result = mysqli_fetch_array($sql)) {
			$id = $result["id"];
			$category_id = $result["category_id"];
			$name = $result["name"];
			$language = $result["language_id"];
			?>
			{"id": "<?=$id;?>", "category_id": "<?=$category_id;?>", "name": "<?=$name;?>", "language": "<?=$language;?>"}
			<?php
			if ($i<$max-1) echo ",";
			$i++;	
		}
		echo "],";
		
		// Subcategories
		echo "\"subcategories\":[";
		$select = "SELECT id, subcategory_id, category_id, name, language_id FROM mob_subcategories WHERE language_id=$getlanguage";
		$sql = mysqli_query($con,$select);
		$max = mysqli_num_rows($sql);
		$i = 0;
		while ($result = mysqli_fetch_array($sql)) {
			$id = $result["id"];
			$subcategory_id = $result["subcategory_id"];
			$category_id = $result["category_id"];
			$name = $result["name"];
			$language = $result["language_id"];
			?>
			{"id": "<?=$id;?>", "subcategory_id": "<?=$subcategory_id;?>", "category_id": "<?=$category_id;?>", "name": "<?=$name;?>", "language": "<?=$language;?>"}
			<?php
			if ($i<$max-1) echo ",";
			$i++;	
		}
		echo "]}";
	}
	
	// Adatbázis kapcsolat lezárása
	mysqli_close($con);
?>