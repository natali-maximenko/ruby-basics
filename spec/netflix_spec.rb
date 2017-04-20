require 'rspec'
require 'date'
require 'timecop'
require 'money'
require_relative '../lib/netflix'

describe Netflix do
  let(:netflix) { Netflix.new('movies.txt') }

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
        let(:amount) { 5 }
        before do
          date = Date.today
          time = Time.local(date.year, date.month, date.day, 10, 0, 0)
          Timecop.freeze(time)
        end
        it { is_expected.to match(/Now showing: Some Like It Hot|The Graduate|The Apartment|Singin' in the Rain 10:00 - \d:\d\n/) }
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
