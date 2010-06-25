package Tweetalyst::Web::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Tweetalyst::Web::Controller::Root - Root Controller for Tweetalyst::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    #$c->response->body( 'Hello World' );
}

sub search :Local {
    my ( $self, $c ) = @_;
    my @items = split /\s+/, $c->req->params->{query};
    $c->stash->{post_results} = $c->model('API')->find('Post')->search_posts(@items);
}

# these two control a user registering
sub join :Local {
    my ( $self, $c ) = @_;
    if ( ! $c->user_exists() && $c->req->method eq 'POST' ) {
        my $user = $c->req->params->{username};
        my $error = $c->model('API')->find('User')->validate( $user, $c->req->params->{pwd}, $c->req->params->{'re-pwd'});
        $c->stash->{error} = $error;
        $c->detach() if $error;
        if ( $self->action_for($user) ) {
            $error = 'sorry, invalid username';
            $c->stash->{error} = $error;
            $c->detach() if $error;
        }
        $c->model('API')->find('User')->create_user(
                $c->req->params->{username},
                $c->req->params->{pwd},
                $c->req->params->{email},
                $c->req->params->{gravatar},
                $c->req->params->{bio},
                );

        # auto-login the user after he joins, and show his/her homepage
        if ( $c->authenticate({
                username => $c->req->params->{username},
                password => $c->req->params->{pwd},
                })
        ) {
            $c->res->redirect('/'.$c->user->username);
        }
    }
}

# user login
sub login :Local {
    my ( $self, $c ) = @_;
    if ( $c->user_exists() ) {
        return;
    } elsif ( exists($c->req->params->{username}) ) {
        if ( $c->authenticate({
                    username => $c->req->params->{username},
                    password => $c->req->params->{password},
                    }) )
        {
            $c->res->redirect('/'.$c->user->username);

        } else {
            $c->stash->{error} = 1;
        }
    }
}

# user logout is just a matter of expiring the session
sub logout :Local {
    my ( $self, $c ) = @_;
    $c->logout();
    $c->res->redirect('/');
}

# this controls a user's page
sub user :Chained('/') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $user ) = @_;
    # renders our error page unless the user exists
    if ( ! $c->model('API')->find('User')
            ->resultset->find($user) ) {
        $c->detach('/not_found');
    }

    $c->stash->{username} = $user;
}

sub not_found :Local {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'not_found.tt';
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
