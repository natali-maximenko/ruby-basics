require 'rspec'
require './movie.rb'
require './movie_collection.rb'

describe Movie do
  describe '#create' do

    context 'when ancient film' do
      let(:movie) { ['http://imdb.com/title/tt0021749/?ref_=chttp_tt_35','City Lights','1931','USA','1931-03-07','Comedy,Drama,Romance','87 min','8.6','Charles Chaplin','Charles Chaplin,Virginia Cherrill,Florence Lee']}
      subject { Movie.create(movie) }
      it 'created ancient film' do
        expect(subject.class.name).to eq('AncientMovie')
      end
    end

    context 'when classic film' do
      let(:movie) { ['http://imdb.com/title/tt0053291/?ref_=chttp_tt_111','Some Like It Hot','1959','USA','1959-03-29','Comedy','120 min','8.3','Billy Wilder','Marilyn Monroe,Tony Curtis,Jack Lemmon'] }
      subject { Movie.create(movie) }
      it 'created classic film' do
        expect(subject.class.name).to eq('ClassicMovie')
      end
    end

    context 'when modern film' do
      let(:movie) { ['http://imdb.com/title/tt0078788/?ref_=chttp_tt_47','Apocalypse Now','1979','USA','1979-08-15','Drama,War','153 min','8.5','Francis Ford Coppola','Martin Sheen,Marlon Brando,Robert Duvall'] }
      subject { Movie.create(movie) }
      it 'created modern film' do
        expect(subject.class.name).to eq('ModernMovie')
      end
    end

    context 'when new film' do
      let(:movie) { ['http://imdb.com/title/tt1305806/?ref_=chttp_tt_135','The Secret in Their Eyes','2009','Argentina','2010-05-21','Drama,Mystery,Thriller','129 min','8.3','Juan José Campanella','Ricardo Darín,Soledad Villamil,Pablo Rago'] }
      subject { Movie.create(movie) }
      it 'created new film' do
        expect(subject.class.name).to eq('NewMovie')
      end
    end
  end
end

describe AncientMovie do
  let(:movie) { AncientMovie.load_from_csv('http://imdb.com/title/tt0043014/?ref_=chttp_tt_49|Sunset Blvd.|1950|USA|1950-08-25|Drama,Film-Noir|110 min|8.5|Billy Wilder|William Holden,Gloria Swanson,Erich von Stroheim')}
  it 'return movie description like <title> - old movie (<year> year)' do
    expect(movie.to_s).to eq('Sunset Blvd. - old movie (1950 year)')
  end
end

describe ClassicMovie do
  let(:collection) { MovieCollection.new('movies.txt') }
  let(:info) { ['http://imdb.com/title/tt0053291/?ref_=chttp_tt_111','Some Like It Hot','1959','USA','1959-03-29','Comedy','120 min','8.3','Billy Wilder','Marilyn Monroe,Tony Curtis,Jack Lemmon', collection] }
  let(:movie) { ClassicMovie.new(*info) }
  it 'return movie description' do
    expect(movie.to_s).to eq('Some Like It Hot - classic movie, director Billy Wilder (5 movies in top-250)')
  end
end

describe ModernMovie do
  let(:movie) { ModernMovie.load_from_csv('http://imdb.com/title/tt0169547/?ref_=chttp_tt_63|American Beauty|1999|USA|1999-10-01|Drama,Romance|122 min|8.4|Sam Mendes|Kevin Spacey,Annette Bening,Thora Birch') }
  it 'return movie description' do
    expect(movie.to_s).to eq('American Beauty - modern movie: play Kevin Spacey,Annette Bening,Thora Birch')
  end
end

describe NewMovie do
  let(:movie) { NewMovie.load_from_csv('http://imdb.com/title/tt1305806/?ref_=chttp_tt_135|The Secret in Their Eyes|2009|Argentina|2010-05-21|Drama,Mystery,Thriller|129 min|8.3|Juan José Campanella|Ricardo Darín,Soledad Villamil,Pablo Rago') }
  it 'return movie description like <title> - ' do
    expect(movie.to_s).to eq('The Secret in Their Eyes - latest, was released 8 years ago!')
  end
end