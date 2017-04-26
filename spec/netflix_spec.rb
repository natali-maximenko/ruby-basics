require 'rspec'
require 'date'
require 'timecop'
require 'money'
require_relative '../lib/netflix'
require_relative '../lib/movie'

describe Cinema::Netflix do
  let(:netflix) { Cinema::Netflix.new('movies.txt') }

  describe '#pay' do
    it 'updates balance' do
      expect { netflix.pay(25) }.to change(netflix, :user_balance).from(Money.new(0, "USD")).to(Money.new(2500, "USD"))
    end

    it 'fails on negative amounts' do
      expect { netflix.pay(-5) }.to raise_error ArgumentError, 'Amount should be positive, -500 passed'
    end
  end

  describe '#show' do
    let(:classic_comedies) { {genre: 'Comedy', period: :classic} }
    subject { netflix.show(classic_comedies) }

    context 'when no money' do
      it 'fails' do
        expect { subject }.to raise_error ArgumentError, 'You have no money on your balance'
      end
    end

    context 'when paid' do
      before { netflix.pay(amount) }

      context 'when not enough' do
        let(:amount) { 1 }
        it 'fails' do
          expect { subject }.to raise_error ArgumentError, 'Need more money. Film cost 1.50, you have 1.00 on your balance'
        end
      end

      context 'when enough' do
        let(:amount) { 15 }
        let(:filters) { { genre: 'Drama', period: :modern, rating: '8.8' } }
        subject { netflix.show(filters) }
        before do
          date = Date.today
          time = Time.local(date.year, date.month, date.day, 10, 0, 0)
          Timecop.freeze(time)
        end
        it { expect { subject }.to output("Now showing: Forrest Gump 10:00 - 12:22\n").to_stdout }
      end
    end

  end

  describe '#how_match?' do
    subject { netflix.how_much?(title) }

    context 'when film not found' do
      let(:title) { 'Mortal Combat' }
      it { expect { subject }.to raise_error ArgumentError, "Movie 'Mortal Combat' not found" }
    end

    Cinema::Netflix::PRICES.each_pair do |period, price|
      context "when movie from #{period} period" do
        let(:title) { netflix.filter(period: period).first.title }
        it { is_expected.to eq price }
      end
    end
  end

  describe '#filter' do
    subject { netflix.filter(filters) }

    context 'simple filter' do
      let(:filters) do { genre: 'Drama', period: :classic, country: 'Japan' } end
      it do
        is_expected.to all have_attributes(period: :classic, country: 'Japan', genre: array_including('Drama'))
      end
    end

    context 'simpe custom filter' do
      before { netflix.define_filter(:new_sci_fi) { |movie| movie.genre.include?('Sci-Fi') && movie.country != 'UK' && movie.period == :new } }
      let(:filters) do { new_sci_fi: true } end
      it do
        #is_expected.to all match { |m| m.is_a?(Cinema::NewMovie) && m.country != 'UK' && m.genre.include?('Sci-Fi') }
        is_expected.to all ( be_a(Cinema::NewMovie) )
        is_expected.to all have_attributes(period: :new, genre: array_including('Sci-Fi'))
      end
    end

    context 'custom filter and some attribute' do
      before { netflix.define_filter(:sci_fi) { |movie| movie.genre.include?('Sci-Fi') && movie.country != 'UK' } }
      let(:filters) do { sci_fi: true, director: 'Christopher Nolan' } end
      it do
        subject.each do |movie|
          expect(movie.country).not_to eq 'UK'
        end
        is_expected.to all have_attributes(director: 'Christopher Nolan', genre: array_including('Sci-Fi'))
      end
    end

    context 'custom filter with parameter' do
      before { netflix.define_filter(:sci_fi) { |movie, year| movie.year > year && movie.genre.include?('Sci-Fi') && movie.country != 'UK' } }
      let(:filters) { { sci_fi: 2010 } }
      it do
        subject.each do |movie|
          expect(movie.country).not_to eq 'UK'
        end
        is_expected.to all have_attributes(genre: array_including('Sci-Fi'), :year => (a_value > 2010) )
      end
    end

    context 'define filter based on other' do
      before do
        netflix.define_filter(:sci_fi) { |movie, year| movie.year > year && movie.genre.include?('Sci-Fi') && movie.country != 'UK' }
        netflix.define_filter(:sci_fi_latest, arg: 2014, from: :sci_fi)
      end
      let(:filters) { { sci_fi_latest: true } }
      it do
        subject.each do |movie|
          expect(movie.country).not_to eq 'UK'
        end
        is_expected.to all have_attributes(genre: array_including('Sci-Fi'), :year => (a_value > 2014) )
      end
    end
  end

end
