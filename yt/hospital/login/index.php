<?php

	session_start(); 
	if(!empty($_GET["url"]) && isset($_GET["url"])){
			$_SESSION['url']=$_GET["url"];
	}
	if ($_GET["name"] == "Joey"){
                header("location: http://10.10.10.254:2060/wifidog/auth?token=123");
    } else {
                header("location: http://10.10.10.254:81/www/");  
    }
?>
