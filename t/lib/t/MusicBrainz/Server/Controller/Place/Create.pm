package t::MusicBrainz::Server::Controller::Place::Create;
use Test::Routine;
use Test::More;
use MusicBrainz::Server::Test qw( html_ok );

with 't::Mechanize', 't::Context';

test 'Area and area containment shown in conjunction with place' => sub {
    my $test = shift;
    my $mech = $test->mech;
    my $c    = $test->c;

    MusicBrainz::Server::Test->prepare_test_database($c, '+area');
    MusicBrainz::Server::Test->prepare_test_database($c, '+area_hierarchy');
    MusicBrainz::Server::Test->prepare_test_database($c, <<'EOSQL');
INSERT INTO editor (id, name, password, ha1, privs, email, email_confirm_date) VALUES
    (1, 'alice', '{CLEARTEXT}password', '343cbae85500be826a413b9b6b242669', 0, 'alice@example.net', '2014-04-20');
EOSQL
    $mech->get_ok('/login');
    $mech->submit_form( with_fields => { username => 'alice', password => 'password' } );

    $mech->get_ok('/place/create');
    html_ok($mech->content);
    $mech->submit_form(
        with_fields => {
            'edit-place.name' => 'Somewhere',
            'edit-place.area_id' => 1178,
        }
    );
    ok($mech->success);

    ok($mech->uri =~ qr{/place/([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})$}, 'redirected to new place page');
    html_ok($mech->content);
    $mech->content_contains('London', 'mentions area');
    $mech->content_contains('England', 'mentions containing subdivision');
    $mech->content_contains('United Kingdom', 'mentions containing country');

    my $edit = MusicBrainz::Server::Test->get_latest_edit($c);
    isa_ok($edit, 'MusicBrainz::Server::Edit::Place::Create');
    $mech->get_ok('/edit/' . $edit->id, 'fetch the edit page');
    html_ok($mech->content);
    $mech->content_contains('London', 'mentions area');
    $mech->content_contains('England', 'mentions containing subdivision');
    $mech->content_contains('United Kingdom', 'mentions containing country');
};

1;
