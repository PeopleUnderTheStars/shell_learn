<?php
$q = $_SERVER['REQUEST_URI'];

if($q == '/portal'){
        //$url = $_SESSION["url"];
        //header("Location: ".$url);
		header("Location: https://www.baidu.com/");
        exit;
}

if($q == '/login'){
        if ($_GET["name"] == "Joey"){  
                header("location: http://10.10.10.254:2060/wifidog/auth?token=123");
        } else {  
                header("location: http://10.10.10.254/www");  
        }
        exit;

}

if($q == '/auth'){
        $token =  $_GET['token']  ;
        if($token == '123') print "Auth: 1"; 
        else print "Auth: 0"; 
        exit;
}

if($q == '/ping') print 'Pong' ;

?>