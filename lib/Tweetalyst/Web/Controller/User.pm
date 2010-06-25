package Tweetalyst::Web::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

# this controls a user's page
sub user :Chained('/user') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    my $user = $c->stash->{username};
    # who this user is following?
    my $following = $c->model('API')->find('User')->get_followed_by($user);

    # fetch posts by user and, if the user is looking at its own page,
    # show posts from people he/she is following too!
    my @targets = ( $user );
    if ( $c->user_exists() && $c->user->username eq $user ) {
        push @targets, keys %$following;
    }
    my $posts = $c->model('API')->find('Post')->fetch_posts_by(@targets);

    # check if this user is already followed by our visitor,
    # so we display the appropriate "follow/unfollow" link
    if ( $c->user_exists()
         && $c->model('API')->find('Follow')
              ->is_a_following_b( $c->user->username, $user ) ) {
        $c->stash->{followed} = 1;
    } else {
        $c->stash->{followed} = 0;
    }
    # fill our stash with information for the template
    $c->stash(
        user        => $c->model('API')->find('User')->resultset->find($user),
        posts       => $posts || [],
        followers   => $c->model('API')->find('User')->get_followers_for($user),
        following   => $following,
        total_posts => $c->model('API')->find('Post')->resultset
                         ->search( { username => $user } )->count,
    );
}


# user wants to follow another
sub follow :Chained('/user') :PathPart('follow') :Args(0) {
    my ( $self, $c ) = @_;

    my ($source, $target) = ($c->user->username, $c->stash->{username});

    $c->model('API')->find('Follow')->resultset->create({
                                                source => $source,
                                                destination => $target,
    });
    $c->res->redirect("/$target");
}

# user doesn't want to follow anymore
sub unfollow :Chained('/user') :PathPart('unfollow') :Args(0) {
    my ( $self, $c ) = @_;

    my ($source, $target) = ($c->user->username, $c->stash->{username});

    $c->model('API')->find('Follow')->resultset->search({
                                                source => $source,
                                                destination => $target,
    })->delete;
    $c->res->redirect("/$target");
}

__PACKAGE__->meta->make_immutable;

1;
