package Tweetalyst::API::WithDBIC;
use Moose::Role;
use namespace::autoclean;

with 'Tweetalyst::Trait::WithDBIC' => {
    -excludes => '_build_default_moniker',
};
# You can add a cache layer here.

sub _build_default_moniker {
    if ((blessed $_[0]) =~ /API::(.+)$/) {
        return $1;
    }
    return;
}

1;
