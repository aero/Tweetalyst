#!/usr/bin/env perl
use strict;
use warnings;
use lib '../lib';
use Tweetalyst::API;

my $api = Tweetalyst::API->new( connect_info => [
        'dbi:SQLite:../db/tweetalyst.db', # dsn
        '', # user
        '', # password
        {}, # options
    ] );

print $api->find('User')->default_moniker,"\n";
my @users = $api->find('User')->resultset->all;
foreach my $user (@users) {
    print $user->username, " ", $user->password, "\n";
}
print "-----------------------\n";
use Data::Dump;
my $hash_ref = $api->find('User')->get_followers_for('tester');
foreach ( keys %$hash_ref ) {
    dd( $hash_ref->{$_} );
}
print "-----------------------\n";
$hash_ref = $api->find('User')->get_followed_by('tester');
foreach ( keys %$hash_ref ) {
    dd( $hash_ref->{$_} );
}
print "-----------------------\n";
my $array_ref = $api->find('Post')->search_posts(qw/test content/);
foreach ( @$array_ref ) {
    dd( $_ );
}
print "-----------------------\n";
$array_ref = $api->find('Post')->fetch_posts_by(qw/tester tester1/);
foreach ( @$array_ref ) {
    dd( $_ );
}

