require 'rspec'
require './netflix.rb'

describe Netflix do
  let(:netflix) { Netflix.new('movies.txt') }

  describe '#pay' do
    it 'updates account' do
      expect { netflix.pay(25) }.to change(netflix, :account).from(0).to(25)
    end

    it 'fails on negative amounts' do
      expect { netflix.pay(-5) }.to raise_error ArgumentError, "Amount should be positive, -5 passed"
    end
  end

  describe '#show' do
    let(:payments) { {not_enough: 1, okey: 5} }
    let(:classic_comedies) { {genre: 'Comedy', period: :classic} }

    context 'when no money' do
      it 'fails' do
        expect { netflix.show(classic_comedies) }.to raise_error ArgumentError, "You have no money on your account"
      end
    end

    context 'when need more money' do
      before(:example) do
        netflix.pay(payments[:not_enough])
      end

      it 'fails' do
        price = Netflix::PRICES[:classic]
        expect { netflix.show(classic_comedies) }.to raise_error ArgumentError, "Need more money. Film cost #{price}, you have #{netflix.account} on your account"
      end
    end

    context 'all ok' do
      before(:example) do
        netflix.pay(payments[:okey])
      end
      it 'shows selected film' do
        movie = netflix.filter(classic_comedies).first
        start_time = Time.now
        end_time = start_time + 60 * movie.length.to_i
        message = "Now showing: #{movie.title}"+ start_time.strftime(" %I:%M%p") + end_time.strftime(" - %I:%M%p")+"\n"
        expect { netflix.show(classic_comedies) }.to output(message).to_stdout
      end
    end

  end

  describe '#how_match?' do
    it 'fails when film not found' do
      expect { netflix.how_much?('Mortal Combat') }.to raise_error ArgumentError, "Movie 'Mortal Combat' not found"
    end

    Netflix::PRICES.each_pair do |period, price|
      context "when movie from #{period} period" do
        let(:title) { netflix.filter(period: period).first.title }
        subject { netflix.how_much?(title) }
        it { is_expected.to eq price }
      end
    end
  end
end