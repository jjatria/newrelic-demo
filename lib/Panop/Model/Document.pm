package Panop::Model::Document;

use Mojo::Base -base, -signatures;
use Mojo::mysql;
use Mojo::JSON;
use Panop::Model::Bucket;

use experimental 'isa';

my $sql = Mojo::mysql->strict_mode($ENV{PANOP_DB_DSN});

has 'id';
has 'content' => '';

sub new {
    my $self = shift->SUPER::new(@_);
    $self->bucket( $self->{bucket} );
}

sub bucket ( $self, $bucket = undef ) {
    return $self->{bucket} unless $bucket;

    $self->{bucket} = $bucket isa Panop::Model::Bucket
        ? $bucket
        : Panop::Model::Bucket->new( id => $bucket );

    $self;
}

sub save ($self) {
    my $id     = $self->id     or die 'Cannot save document without an ID';
    my $bucket = $self->bucket or die 'Cannot save document without bucket';

    my $tx = $sql->db->begin;
    $sql->db->query( <<'SQL', $id, $bucket->save->id, $self->content );
        INSERT INTO document
                SET id      = ?,
                    bucket  = ?,
                    content = ?
       ON DUPLICATE KEY
             UPDATE content = VALUES(content);
SQL
    $tx->commit;

    $self;
}

sub delete ($self) {
    my $id     = $self->id     or die 'Cannot delete DB without an ID';
    my $bucket = $self->bucket or die 'Cannot delete DB without bucket';

    $sql->db->delete( document => { id => $id, bucket => $bucket->id } );
    $self;
}

sub fetch ( $self ) {
    my $id     = $self->id     or die 'Cannot fetch document without an ID';
    my $bucket = $self->bucket or die 'Cannot fetch document without bucket';

    my $row = $sql->db->select(
        document => ['content'] => { bucket => $bucket->id, id => $id },
    );

    die 'No such document' unless $row->rows;

    $self->content( $row->hash->{content} );
}

sub exists ($self) {
    my $id = $self->id or return;

    my $res = $sql->db->query( <<'SQL', $self->id, $self->bucket->id );
        SELECT EXISTS ( SELECT * FROM document WHERE id = ? AND bucket = ? )
SQL

    $res->array->[0];
}

sub json ( $self ) {
    my $content = $self->content or return {};
    eval { Mojo::JSON::decode_json $content };
}

1;
