<?php

$servername = "localhost";
$dBUsername = "root";
$dbPassword = "root";
$dBName = "medproject";

$conn = mysqli_connect($servername, $dBUsername, $dbPassword, $dBName);

if(!$conn){
	echo "Databese Connection Failed";
}

?>
