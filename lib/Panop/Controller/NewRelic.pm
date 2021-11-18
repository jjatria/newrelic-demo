package Panop::Controller::NewRelic;

use Mojo::Base 'Mojolicious::Controller', -signatures;
use NewFangle::Agent::Config;

sub config ($self) {
    $self->render( json => NewFangle::Agent::Config->local_settings );
}

1;
