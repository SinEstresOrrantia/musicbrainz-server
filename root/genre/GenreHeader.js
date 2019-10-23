/*
 * @flow
 * Copyright (C) 2019 MetaBrainz Foundation
 *
 * This file is part of MusicBrainz, the open internet music database,
 * and is licensed under the GPL version 2, or (at your option) any
 * later version: http://www.gnu.org/licenses/gpl-2.0.txt
 */

import React from 'react';

import EntityHeader from '../components/EntityHeader';
import EntityLink from '../static/scripts/common/components/EntityLink';

type Props = {
  genre: GenreT,
  page: string,
};

const GenreHeader = ({genre, page}: Props) => (
  <EntityHeader
    entity={genre}
    headerClass="genreheader"
    heading={
      <EntityLink entity={genre} />
    }
    page={page}
    subHeading={l('Genre')}
  />
);

export default GenreHeader;