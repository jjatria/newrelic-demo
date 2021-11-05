package Panop;

use Mojo::Base 'Mojolicious', -signatures;

sub startup ($self) {
    # Load configuration from config file
    my $config = $self->plugin('NotYAMLConfig');

    $self->hook(
        before_render => sub ( $c, $args ) {
            return unless ( $args->{template} // '' ) eq 'exception';
            return unless $c->accepts('json');

            chomp( my $error = $c->stash('exception') );
            $error =~ s/ at \/[\w\/]+\.pm .*//;

            $args->{json} = { ok => \0, error => $error };
        },
    );

    # Configure the application
    $self->secrets( $config->{secrets} );

    my $router = $self->routes;

    $router->get('/')->to( cb => sub { shift->reply->static('api.html') });

    $router->get('/config')->to('NewRelic#config');

    $router->put('/:bucket')->to('Bucket#create');
    $router->get('/:bucket')->to('Bucket#read');
    $router->delete('/:bucket')->to('Bucket#delete');

    $router->put('/:bucket/:document')->to('Document#create');
    $router->get('/:bucket/:document')->to('Document#read');
    $router->delete('/:bucket/:document')->to('Document#delete');
}

1;
