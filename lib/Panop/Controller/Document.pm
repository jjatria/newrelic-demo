package Panop::Controller::Document;

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Panop::Model::Document;

sub create ($self) {
    Panop::Model::Document->new(
        id      => $self->param('document'),
        bucket  => $self->param('bucket'),
        content => $self->req->body,
    )->save;

    $self->render( json => { ok => \1 } );
}

sub read ($self) {
    my $doc = Panop::Model::Document->new(
        id     => $self->param('document'),
        bucket => $self->param('bucket'),
    );

    return $self->reply
        ->exception('Document was not found')
        ->rendered(404)
        unless $doc->exists;

    $doc->fetch;

    if ( my $json = $doc->json ) {
        $self->render( json => $json );
    }
    else {
        $self->render( data => $doc->content );
    }
}

sub delete ($self) {
    my $doc = Panop::Model::Document->new(
        id     => $self->param('document'),
        bucket => $self->param('bucket'),
    )->delete;

    $self->render( json => { ok => \1 } );
}

1;
