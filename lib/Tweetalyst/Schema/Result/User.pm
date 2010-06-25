package Tweetalyst::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Tweetalyst::Schema::Result::User

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 username

  data_type: 'text'
  is_nullable: 0

=head2 password

  data_type: 'text'
  is_nullable: 0

=head2 email

  data_type: 'text'
  is_nullable: 1

=head2 gravatar

  data_type: 'text'
  is_nullable: 1

=head2 bio

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "username",
  { data_type => "text", is_nullable => 0 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "email",
  { data_type => "text", is_nullable => 1 },
  "gravatar",
  { data_type => "text", is_nullable => 1 },
  "bio",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("username");

=head1 RELATIONS

=head2 posts

Type: has_many

Related object: L<Tweetalyst::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "Tweetalyst::Schema::Result::Post",
  { "foreign.username" => "self.username" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 follow_destinations

Type: has_many

Related object: L<Tweetalyst::Schema::Result::Follow>

=cut

__PACKAGE__->has_many(
  "follow_destinations",
  "Tweetalyst::Schema::Result::Follow",
  { "foreign.destination" => "self.username" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 follow_sources

Type: has_many

Related object: L<Tweetalyst::Schema::Result::Follow>

=cut

__PACKAGE__->has_many(
  "follow_sources",
  "Tweetalyst::Schema::Result::Follow",
  { "foreign.source" => "self.username" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-20 17:19:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vxJxJz3O8wMx5aNmKqX5zg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
