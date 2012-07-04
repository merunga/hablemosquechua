<?php

require 'tmhOAuth.php';
$tmhOAuth = new tmhOAuth(array(
  'consumer_key'    => 'TWITTER_CONSUMER_KEY',
  'consumer_secret' => 'TWITTER_CONSUMER_SECRET',
  'user_token'      => 'TWITTER_USER_TOKEN',
  'user_secret'     => 'TWITTER_USER_SECRET'
    
));

include("source.php");
$line = $source[(rand(0,count($source)-1))];
list($genero, $es, $quechua) = split(',', $line);

include("frases.php");
$frase = $frases[(rand(0,count($frases)-1))];
$hom = $genero=='f'?2:1;

$vars = array("{genero}", "{es}", "{quechua}");
$values  = array($frase[$hom], $es, $quechua);

$tweet = $frase[0];
for($i=0;$i<3;$i++) {
    $tweet = str_replace($vars[$i], $values[$i], $tweet);
}

$tmhOAuth->request('POST', $tmhOAuth->url('statuses/update'), array(
//'status' => utf8_encode($ message)
  'status' => $tweet //changed this nlarion
));

if ($tmhOAuth->response['code'] == 200) {
  $tmhOAuth->pr(json_decode($tmhOAuth->response['response']));
} else {
  $tmhOAuth->pr(htmlentities($tmhOAuth->response['response']));
}

?>

