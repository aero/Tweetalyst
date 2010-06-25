package Tweetalyst::Web::View::JSON;

use strict;
use base 'Catalyst::View::JSON';

__PACKAGE__->config({ expose_stash => [ qw/username content date answer/ ] });

=head1 NAME

Tweetalyst::Web::View::JSON - Catalyst JSON View

=head1 SYNOPSIS

See L<Tweetalyst::Web>

=head1 DESCRIPTION

Catalyst JSON View.

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
