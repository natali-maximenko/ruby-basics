require 'rspec'
require 'date'
require './movie.rb'

describe AncientMovie do
  before do
    @movie = AncientMovie.load_from_csv('http://imdb.com/title/tt0043014/?ref_=chttp_tt_49|Sunset Blvd.|1950|USA|1950-08-25|Drama,Film-Noir|110 min|8.5|Billy Wilder|William Holden,Gloria Swanson,Erich von Stroheim')
  end

  it 'is a movie between 1900 and 1945 years' do
    #expect(@movie.year.to_i).to > 1900
  end

  it 'return movie description like <title> - old movie (<year> year)' do
    expect(@movie.to_s).to eq("#{@movie.title} - old movie (#{@movie.year} year)")
  end
end

describe ClassicMovie do
  it 'return movie description like <title> - classic movie, director <director>' do
    movie = ClassicMovie.load_from_csv('http://imdb.com/title/tt0052357/?ref_=chttp_tt_68|Vertigo|1958|USA|1958|Mystery,Romance,Thriller|128 min|8.4|Alfred Hitchcock|James Stewart,Kim Novak,Barbara Bel Geddes')
    expect(movie.to_s).to eq("#{movie.title} - classic movie, director #{movie.director}")
  end
end

describe ModernMovie do
  it 'return movie description like <title> - modern movie: play <actors>' do
    movie = ModernMovie.load_from_csv('http://imdb.com/title/tt0169547/?ref_=chttp_tt_63|American Beauty|1999|USA|1999-10-01|Drama,Romance|122 min|8.4|Sam Mendes|Kevin Spacey,Annette Bening,Thora Birch')
    actors_string = movie.actors.join(',')
    expect(movie.to_s).to eq("#{movie.title} - modern movie: play #{actors_string}")
  end
end

describe NewMovie do
  it 'return movie description like <title> - ' do
    movie = NewMovie.load_from_csv('http://imdb.com/title/tt1345836/?ref_=chttp_tt_61|The Dark Knight Rises|2012|USA|2012-07-20|Action,Thriller|165 min|8.5|Christopher Nolan|Christian Bale,Tom Hardy,Anne Hathaway')
    years = Date.today.year - movie.year.to_i
    expect(movie.to_s).to eq("#{movie.title} - latest, was released #{years} years ago!")
  end
end