package MusicBrainz::Server::Report::PlaceReport;
use Moose::Role;

with 'MusicBrainz::Server::Report::QueryReport';

around inflate_rows => sub {
    my $orig = shift;
    my $self = shift;

    my $items = $self->$orig(@_);

    my $places = $self->c->model('Place')->get_by_ids(
        map { $_->{place_id} } @$items
    );

    $self->c->model('Area')->load(values %$places);
    $self->c->model('Area')->load_containment(map { $_->area } values %$places);

    return [
        map +{
            %$_,
            place => $places->{ $_->{place_id} }
        }, @$items
    ];
};

1;

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 MetaBrainz Foundation

This file is part of MusicBrainz, the open internet music database,
and is licensed under the GPL version 2, or (at your option) any
later version: http://www.gnu.org/licenses/gpl-2.0.txt

=cut
