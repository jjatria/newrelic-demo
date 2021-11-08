requires 'Mojo::mysql';
requires 'Mojolicious', '9.22';
requires 'NewFangle';
requires 'Plack';
requires 'Starman';
requires 'Devel::Peek';
requires 'Hash::Merge';
requires 'Scalar::Util';
requires 'Storable';
requires 'Syntax::Keyword::Defer';
requires 'YAML::XS';
requires 'namespace::clean';

recommends 'NewFangle';
recommends 'Plack';

on test => sub {
    requires 'File::Share';
    requires 'Test2::Suite';
};
