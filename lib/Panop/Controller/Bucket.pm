package Panop::Controller::Bucket;

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Panop::Model::Bucket;

sub create ($self) {
    Panop::Model::Bucket->new( id => $self->param('bucket') )->save;
    $self->render( json => { ok => \1 } );
}

sub read ($self) {
    my $bucket = Panop::Model::Bucket->new( id => $self->param('bucket') );

    return $self->reply
        ->exception('No bucket by that name')
        ->rendered(404)
        unless $bucket->exists;

    $bucket->fetch;

    $self->render(
        json => {
            ok => \1,
            documents => [ map { id => $_->id }, $bucket->content->@* ],
        }
    );
}

sub delete ($self) {
    Panop::Model::Bucket->new( id => $self->param('bucket') )->delete;
    $self->render( json => { ok => \1 } );
}

1;
