<?php

use Elasticsearch\ClientBuilder;

require 'vendor/autoload.php';

$client = ClientBuilder::create()->build();

$params = [
    'index' => 'my_index',
    'type' => 'type1',
    'body' => [
        'user' => 'dilbert',
        'postDate' => '2011-12-15',
        'body' => 'Search is hard. Search should be easy.',
        'title' => 'On search',
    ]
];

$response =  $client->index($params);
print_r($response);

$params = [
    'index' => 'my_index',
    'type' => 'type1',
    'body' => [
        'user' => 'dilbert',
        'postDate' => '2011-12-15',
        'body' => 'Search is easy. Search should be easier.',
        'title' => 'On search',
    ]
];

$response =  $client->index($params);
print_r($response);

$params = [
    'index' => 'my_index',
    'type' => 'type1',
    'body' => [
        'user' => 'dilbert',
        'postDate' => '2011-12-15',
        'body' => 'My mama said, your mama is fat !',
        'title' => 'On search',
    ]
];

$response =  $client->index($params);
print_r($response);