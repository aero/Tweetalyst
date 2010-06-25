package Tweetalyst::Web::Model::API;

use Moose;
extends 'Catalyst::Model::Adaptor';

__PACKAGE__->config( 
    class => 'Tweetalyst::API',
    args  => { connect_info => [
                   'dbi:SQLite:db/tweetalyst.db', # dsn
                   '', # user
                   '', # password
                   { sqlite_unicode => 1, }, # options
               ]
             },  
);

1;
