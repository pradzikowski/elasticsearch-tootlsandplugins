<?php

use Elasticsearch\ClientBuilder;

require 'vendor/autoload.php';

$client = ClientBuilder::create()->build();

$params = [
    'index' => 'my_index',
    'body' => [
        'settings' => [
            'number_of_shards' => 2,
            'number_of_replicas' => 0
        ],
        'mappings' => [
            'type1' => [
                'properties' => [
                    'user' => ['type' => 'text', 'analyzer' => 'keyword'],
                    'postDate' => ['type' => 'date',],
                    'body' => ['type' => 'text', 'analyzer' => 'simple'],
                    'title' => ['type' => 'text', 'analyzer' => 'simple'],
                ]
            ]
        ]
    ]
];

$response = $client->indices()->create($params);
print_r($response);