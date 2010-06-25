package Tweetalyst::Web::Controller::Post;
use Moose;
use JSON;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

# this one handles users creating new posts ('message')
sub post :Chained('/user') :PathPart('post') :Args(0) {
    my ( $self, $c ) = @_;
    
    my $user = $c->user->username;
    if ( $c->req->params->{message} ) {
        my $post = $c->model('API')->find('Post')->resultset
                     ->create( {
                         username => $user,
                         content  => $c->req->params->{message},
                         date => time,
                       } );
        my %post = $post->get_columns;
        # if it's an Ajax request, return a JSON object of post and gravatar
        my $header = $c->req->headers->header('X-Requested-With') || '';
        if ( $header eq 'XMLHttpRequest' ) {
            my $gravatar = $c->model('API')->find('User')->resultset
                             ->find($user)->gravatar;
            $c->stash->{$_} = $post{$_} for keys %post;
            $c->stash->{current_view} = 'JSON';
            $c->detach();
        }
    }
    $c->res->redirect( '/'.$c->stash->{username} );
}

sub post_id :Chained('/user') :PathPart('post') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash->{id} = $id;
}

sub post_delete :Chained('post_id') :PathPart('delete') :Args(0) {
    my ( $self, $c ) = @_;

    my $post = $c->model('API')->find('Post')->resultset->find($c->stash->{id});
    $post->delete if $post;

    # if it was an Ajax request, we return a JSON object in confirmation
    my $header = $c->req->headers->header('X-Requested-With') || '';
    if ( $header eq 'XMLHttpRequest' ) {
        $c->stash->{answer} = 1;
        $c->stash->{current_view} = 'JSON';
        $c->detach();
    }
    $c->res->redirect( '/'.$c->stash->{username} );
}

__PACKAGE__->meta->make_immutable;

1;
