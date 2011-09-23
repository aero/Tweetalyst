package Tweetalyst::API::Follow;
use Moose;
use namespace::autoclean;

with 'Tweetalyst::API::WithDBIC';

sub is_a_following_b {
    my ($self, $a, $b) = @_;
    return $self->resultset->search( { source => $a, destination => $b } )->count;
}

__PACKAGE__->meta->make_immutable();

1;
