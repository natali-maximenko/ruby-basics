require 'rspec'
require 'date'
require 'timecop'
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
    subject { netflix.show(classic_comedies) }

    context 'when no money' do
      it 'fails' do
        expect { subject }.to raise_error ArgumentError, 'You have no money on your account'
      end
    end

    context 'when paid' do
      before { netflix.pay(amount) }

      context 'when not enough' do
        let(:amount) { 1 }
        it 'fails' do
          expect { subject }.to raise_error ArgumentError, 'Need more money. Film cost 1.5, you have 1 on your account'
        end
      end

      context 'when enough' do
        let(:amount) { 5 }
        before do
          date = Date.today
          time = Time.local(date.year, date.month, date.day, 10, 0, 0)
          Timecop.freeze(time)
        end
        it { expect { subject }.to output("Now showing: Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb 10:00 - 11:35\n").to_stdout }
      end
    end

  end

  describe '#how_match?' do
    subject { netflix.how_much?(title) }

    context 'when film not found' do
      let(:title) { 'Mortal Combat' }
      it { expect { subject }.to raise_error ArgumentError, "Movie 'Mortal Combat' not found" }
    end

    Netflix::PRICES.each_pair do |period, price|
      context "when movie from #{period} period" do
        let(:title) { netflix.filter(period: period).first.title }
        it { is_expected.to eq price }
      end
    end
  end
end