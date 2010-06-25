package Tweetalyst::Schema::Result::Follow;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Tweetalyst::Schema::Result::Follow

=cut

__PACKAGE__->table("follow");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 source

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 destination

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "source",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "destination",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 destination

Type: belongs_to

Related object: L<Tweetalyst::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "destination",
  "Tweetalyst::Schema::Result::User",
  { username => "destination" },
  { on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 source

Type: belongs_to

Related object: L<Tweetalyst::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "source",
  "Tweetalyst::Schema::Result::User",
  { username => "source" },
  { on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-20 17:19:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zcG3UzHsvsodQrxW1SzlJg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
