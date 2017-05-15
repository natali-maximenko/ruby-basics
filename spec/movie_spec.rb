require 'rspec'
require 'rspec/its'
require_relative '../lib/movie'
require_relative '../lib/movie_collection'

describe Cinema::Movie do
  describe '#create' do
    subject { Cinema::Movie.create(movie) }

    context 'when invalid movie year' do
      let(:movie) { ['http://imdb.com/title/tt0021749/?ref_=chttp_tt_35','City Lights','y1931','USA','1931-03-07','Comedy,Drama,Romance','87 min','8.6','Charles Chaplin','Charles Chaplin,Virginia Cherrill,Florence Lee'] }
      it { expect { subject }.to raise_error ArgumentError, 'y1931 is not valid year' }
    end

    context 'when movie year not our century' do
      let(:movie) { ['http://imdb.com/title/tt0021749/?ref_=chttp_tt_35','City Lights','931','USA','1931-03-07','Comedy,Drama,Romance','87 min','8.6','Charles Chaplin','Charles Chaplin,Virginia Cherrill,Florence Lee'] }
      it { expect { subject }.to raise_error ArgumentError, '931 is not valid year' }
    end

    context 'when ancient film' do
      let(:movie) { ['http://imdb.com/title/tt0021749/?ref_=chttp_tt_35','City Lights','1931','USA','1931-03-07','Comedy,Drama,Romance','87 min','8.6','Charles Chaplin','Charles Chaplin,Virginia Cherrill,Florence Lee']}
      it { is_expected.to be_an(Cinema::AncientMovie) }
    end

    context 'when classic film' do
      let(:movie) { ['http://imdb.com/title/tt0053291/?ref_=chttp_tt_111','Some Like It Hot','1959','USA','1959-03-29','Comedy','120 min','8.3','Billy Wilder','Marilyn Monroe,Tony Curtis,Jack Lemmon'] }
      it { is_expected.to be_an(Cinema::ClassicMovie) }
    end

    context 'when modern film' do
      let(:movie) { ['http://imdb.com/title/tt0078788/?ref_=chttp_tt_47','Apocalypse Now','1979','USA','1979-08-15','Drama,War','153 min','8.5','Francis Ford Coppola','Martin Sheen,Marlon Brando,Robert Duvall'] }
      it { is_expected.to be_an(Cinema::ModernMovie) }
    end

    context 'when new film' do
      let(:movie) { ['http://imdb.com/title/tt1305806/?ref_=chttp_tt_135','The Secret in Their Eyes','2009','Argentina','2010-05-21','Drama,Mystery,Thriller','129 min','8.3','Juan José Campanella','Ricardo Darín,Soledad Villamil,Pablo Rago'] }
      it { is_expected.to be_an(Cinema::NewMovie) }
    end
  end
end

describe Cinema::AncientMovie do
  subject { Cinema::AncientMovie.new(link: 'http://imdb.com/title/tt0043014/?ref_=chttp_tt_49', title: 'Sunset Blvd.', year: '1950', country: 'USA', date: '1950-08-25', genre: ['Drama', 'Film-Noir'], length: '110 min', rating: '8.5', director: 'Billy Wilder', actors: ['William Holden', 'Gloria Swanson', 'Erich von Stroheim']) }
  its(:to_s) { is_expected.to eq('Sunset Blvd. - old movie (1950 year)') }
end

describe Cinema::ClassicMovie do
  let(:collection) { instance_double(Cinema::MovieCollection) }
  subject { Cinema::ClassicMovie.new(link: 'http://imdb.com/title/tt0053291/?ref_=chttp_tt_111', title: 'Some Like It Hot', year: '1959', country: 'USA', date: '1959-03-29', genre: ['Comedy'], length: '120 min', rating: '8.3', director: 'Billy Wilder', actors: ['Marilyn Monroe', 'Tony Curtis', 'Jack Lemmon'], collection: collection) }
  before { expect(collection).to receive(:filter).with(director: 'Billy Wilder').and_return(double(count: 5)) }

  its(:to_s) { is_expected.to eq('Some Like It Hot - classic movie, director Billy Wilder (5 movies in top-250)') }
end

describe Cinema::ModernMovie do
  subject { Cinema::ModernMovie.new(link:'http://imdb.com/title/tt0169547/?ref_=chttp_tt_63', title: 'American Beauty', year: '1999', country: 'USA', date: '1999-10-01', genre: ['Drama', 'Romance'], length: '122 min', rating: '8.4', director: 'Sam Mendes', actors: ['Kevin Spacey', 'Annette Bening', 'Thora Birch']) }
  its(:to_s) { is_expected.to eq('American Beauty - modern movie: play Kevin Spacey,Annette Bening,Thora Birch') }
end

describe Cinema::NewMovie do
  subject { Cinema::NewMovie.new(link: 'http://imdb.com/title/tt1305806/?ref_=chttp_tt_135', title: 'The Secret in Their Eyes', year: '2009', country: 'Argentina', date: '2010-05-21', genre: ['Drama', 'Mystery', 'Thriller'], length: '129 min', rating: '8.3', director: 'Juan José Campanella', actors: ['Ricardo Darín', ' Soledad Villamil', 'Pablo Rago']) }
  its(:to_s) { is_expected.to eq('The Secret in Their Eyes - latest, was released 8 years ago!') }
end
