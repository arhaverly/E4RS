<?php

	function display(){
	    echo "hello ".$_POST["studentname"];
	}

	if(isset($_POST['submit'])){
	   display();
	} 

	$myfile = fopen("newfile.txt", "a") or die("Unable to open file!");
	fwrite($myfile, $_POST["name"]);
	fwrite($myfile, $_POST["email"]);
	fwrite($myfile, $_POST["multi"]);
	fclose($myfile);

?>