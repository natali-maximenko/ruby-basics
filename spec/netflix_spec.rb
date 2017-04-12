require 'rspec'
require_relative '../lib/netflix'

describe Netflix do
  let(:netflix) { Netflix.new('movies.txt') }

  describe '#pay' do
    it 'updates account' do
      expect { netflix.pay(25) }.to change(netflix, :account).from(0).to(25)
    end

    it 'fails on negative amounts' do
      expect { netflix.pay(-5) }.to raise_error ArgumentError, 'Amount should be positive, -5 passed'
    end
  end

  describe '#show' do
    let(:classic_comedies) { {genre: 'Comedy', period: :classic} }

    context 'when no money' do
      subject { netflix.show(classic_comedies) }
      it 'fails' do
        expect{ subject }.to raise_error ArgumentError, 'You have no money on your account'
      end
    end

    context 'when paid' do
      before { netflix.pay(amount) }
      subject { netflix.show(classic_comedies) }

      context 'when not enough' do
        let(:amount) { 1 }
        it 'fails' do
          expect { subject }.to raise_error ArgumentError, 'Need more money. Film cost 1.5, you have 1 on your account'
        end
      end

      context 'when enough' do
        let(:amount) { 5 }
        let(:movie_title) { "Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb" }
        let(:movie_length) { 95 }
        let(:message) do
          start_time = Time.now
          end_time = start_time + 60 * movie_length
          "Now showing: #{movie_title}"+ start_time.strftime(" %I:%M%p") + end_time.strftime(" - %I:%M%p")+"\n"
        end
        it 'shows selected film' do
          expect { subject }.to output(message).to_stdout
        end
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