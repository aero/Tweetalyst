package Tweetalyst::Web::Model::User;
use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Model' }

has schema => ( is => 'rw' );

sub ACCEPT_CONTEXT {
    my ($self ,$c) = @_;
    if (! $self->schema ) {
        $self->schema($c->model('API')->schema);
    }
    return $self->schema->resultset('User');
}

__PACKAGE__->meta->make_immutable();

1;
