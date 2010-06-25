package Tweetalyst::API;
use Moose;
use Tweetalyst::Schema;
use namespace::autoclean;

with qw/Tweetalyst::Trait::WithAPI Tweetalyst::Trait::WithDBIC/;

sub _build_schema {
    my $self = shift;
    return Tweetalyst::Schema->connect( @{ $self->connect_info } );
}

sub _build_apis {
    my $self = shift;

    my %apis;
    foreach my $module ( qw/Follow Post User/ ) {
        my $class = "Tweetalyst::API::$module";
        if (! Class::MOP::is_class_loaded($class)) {
            Class::MOP::load_class($class);
        }

        $apis{ $module } = $class->new(schema => $self->schema);
    }

    return \%apis;
}

__PACKAGE__->meta->make_immutable();

1;

