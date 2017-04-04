require 'rspec'
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