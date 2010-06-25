package Tweetalyst::API::Post;
use Moose;
use namespace::autoclean;

with 'Tweetalyst::API::WithDBIC';

# this returns our search results
sub search_posts {
    my ($self,@item_to_search) = @_;
    my @condition;
    foreach (@item_to_search) {
        push @condition, ( 'posts.content' => { like => "%$_%" } );
    }
    my $rs = $self->resultset('User')->search(
                     {
                         -or => [ @condition ],
                     },
                     {
                         join => 'posts',
                         select => [qw/me.username posts.id me.gravatar
                                       posts.content posts.date/],
                         as => [qw/username id gravatar content date/],
                         order_by => ['posts.date'],
                     },
                 );
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    return [ $rs->all ];
}

# this returns sorted posts from all users in @users
sub fetch_posts_by {
    my ($self,@users) = @_;
    my @condition;
    foreach (@users) {
        push @condition, ( 'me.username' => $_ );
    }
    my $rs = $self->resultset('User')->search(
                     {
                         -or => [ @condition ],
                     },
                     {
                         join => 'posts',
                         select => [qw/me.username posts.id me.gravatar
                                       posts.content posts.date/],
                         as => [qw/username id gravatar content date/],
                         order_by => ['posts.date'],
                     },
                 );
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    return [ $rs->all ];
}

__PACKAGE__->meta->make_immutable();

1;
