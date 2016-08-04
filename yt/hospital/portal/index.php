<?php

	session_start();
	$url = $_SESSION["url"];
	if(!empty($url) && isset($url)){
        	header("Location: ".$url);
	} else {
		header("Location: https://m.baidu.com");
	}
?>
