package Tweetalyst::API::User;
use Moose;
use Digest::SHA1 qw/sha1_hex/;
use namespace::autoclean;

with 'Tweetalyst::API::WithDBIC';

#sub _build_resultset_constraints { return +{ username => {like => 'test%'} } };

# this returns who follows our user.
# # Each element is a hash of usernames and gravatars
sub get_followers_for {
    my ($self, $user) = @_;
    my $rs = $self->resultset->search(
                     {
                         'follow_sources.destination' => $user
                     },
                     {
                         join => 'follow_sources',
                         select => [qw/username gravatar/],
                     },
                 );
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my %hash;
    while ( my $row = $rs->next ) {
        $hash{$row->{username}} = $row;
    }
    return \%hash;

#    return Model->selectall_hashref(
#              'SELECT username, gravatar FROM user, follow
#WHERE user.username = follow.source
#AND follow.destination = ?',
#              'username', {} , $_[0],
#            );
}

# this returns who our user follows
sub get_followed_by {
    my ($self, $user) = @_;
    my $rs = $self->resultset->search(
                     {
                         'follow_destinations.source' => $user
                     },
                     {
                         join => 'follow_destinations',
                         select => [qw/username gravatar/],
                     },
                 );
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my %hash;
    while ( my $row = $rs->next ) {
        $hash{$row->{username}} = $row;
    }
    return \%hash;
#    return Model->selectall_hashref(
#              'select username, gravatar from user, follow
#where user.username = follow.destination
#and follow.source = ?',
#              'username', {}, $_[0],
#        );
}

sub validate {
    my ($self, $user, $pass, $pass2, $routes) = @_;
    return 'username field must not be blank' unless $user && length $user;
    return 'password field must not be blank' unless $pass && length $pass;
    return 'please re-type your password' unless $pass2 && length $pass2;
    return "passwords don't match" unless $pass eq $pass2;
    return 'sorry, this user already exists'
        if $self->resultset->find($user);

    # let's not allow usernames that are part of a valid route
    #return 'sorry, invalid username'
       #if grep { length $_->name && index($user, $_->name) == 0 } @$routes;

    return;


}

sub create_user {
    my ($self, $username, $password, $email, $gravatar, $bio) = @_;

    $self->resultset->create({
                    username => $username,
                    password => sha1_hex($password),
                    email    => $email,
                    gravatar => sha1_hex($gravatar),
                    bio      => $bio,
    });
}

__PACKAGE__->meta->make_immutable();

1;
