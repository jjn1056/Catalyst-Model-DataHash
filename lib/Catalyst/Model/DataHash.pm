package Catalyst::Model::DataHash;

use Moo;
our $VERSION = '0.001';

extends 'Catalyst::Model';
with 'Catalyst::Component::InstancePerContext';
with 'Data::Perl::Role::Collection::Hash';

sub build_per_context_instance {
  my ($self, $c, %args) = @_;
  return $self->new(%args);
}

sub AUTOLOAD {
  my ($self, @args) = @_;
  my $key = our $AUTOLOAD;
  $key =~ s/.*:://;
  return $self->get($key);
}
 
sub DESTROY {}

1;

=head1 NAME

Catalyst::Model::DataHash - Expose Perl::Data::Collection::Hash as a Per Request Model

=head1 SYNOPSIS

Create a Model Subclass:

    package MyApp::Model::Foo;

    use Moose;
    extends 'Catalyst::Model::DataHash';

    __PACKAGE__->meta->make_immutable;

Use it in a controller:

    sub myaction :Local {
      my ($self, $c) = @_;
      $c->model('DataHash')->set(a=>1, b=>2);
      $c->model('DataHash')->get('a'); # 1
      $c->model('DataHash')->get('b'); # 2

      #alternative accessors
      $c->model('DataHash')->a; # 1
    }

You might find it useful to make this your default model:

    MyApp->config(default_model=>'DataHash');

So that you can use this without naming the model:

    sub myaction :Local {
      my ($self, $c) = @_;
      $c->model->set(a=>1, b=>2);
      $c->model->get('a'); # 1
      $c->model->get('b'); # 2

      #alternative accessors
      $c->model->a; # 1
    }

Which makes it less verbose.  Alternatively you can use the included plugin
L<Catalyst::Plugin::DataHash> which injects a DataHash model for you into your
application, and sets it to be the default model:

    package MyApp;

    use Catalyst qw/DataHash/;

    MyApp->setup;

=head1 DESCRIPTION

The most common way that a controller shares information between actions and the
view is to set key / values in the stash:

    $c->stash(a=>1, b=>2);

The stash suffers from several downsides, some of which include the fact it is
a global hash and is prone to typos and related confusion.  This L<Catalyst>
model offers an approach to providing stash-like features with a slightly less
error prone interface.  It is also hoped that it might inspire you to think about
how to better use models in your L<Catalyst> application to properly type your
interfaces.

=head1 SEE ALSO

L<Catalyst>, L<Data::Perl>.

=head1 AUTHOR
 
John Napiorkowski L<email:jjnapiork@cpan.org>
  
=head1 COPYRIGHT & LICENSE
 
Copyright 2015, John Napiorkowski L<email:jjnapiork@cpan.org>
 
This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
