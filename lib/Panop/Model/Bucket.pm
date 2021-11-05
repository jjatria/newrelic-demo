package Panop::Model::Bucket;

use Mojo::Base -base, -signatures;
use Mojo::mysql;

use Carp;
use Scalar::Util;

my $sql = Mojo::mysql->strict_mode($ENV{PANOP_DB_DSN});

has 'id';
has 'content' => sub { [] };

sub new {
    my $self = shift->SUPER::new(@_);

    Carp::croak "'$1' is not an allowed name for a bucket"
        if $self->id =~ /^(config)$/;

    $self;
}

sub exists ($self) {
    my $id = $self->id or return;

    my $res = $sql->db->query( <<'SQL', $self->id );
        SELECT EXISTS ( SELECT * FROM bucket WHERE id = ? )
SQL

    $res->array->[0];
}

sub save ($self) {
    my $id = $self->id or die 'Cannot save bucket without an ID';

    $sql->db->query( <<'SQL', $self->id );
        INSERT INTO bucket
                SET id = ?
       ON DUPLICATE KEY
             UPDATE id = VALUES(id)
SQL
    $self;
}

sub delete ($self) {
    my $id = $self->id or die 'Cannot delete bucket without an ID';

    $sql->db->delete( bucket => { id => $id } );
    $self;
}

sub fetch ($self) {
    my $id = $self->id or die 'Cannot get bucket without an ID';

    my $res = $sql->db->select(
        document => (
            [qw( id content )],
            { bucket => $self->id },
        )
    );

    $self->content(
        $res->hashes->map( sub ($row) {
            my $doc = Panop::Model::Document->new(
                $row->%{id}, bucket => $self,
            );

            # NOTE: these documents have weakened buckets
            Scalar::Util::weaken $doc->{bucket};

            $doc;
        })
    );
}

1;
