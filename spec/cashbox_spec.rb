require 'rspec'
require_relative '../lib/cashbox'

describe Cashbox do
  let(:cashbox) { Object.new.extend Cashbox }

  describe '#cash' do
    it { expect(cashbox.cash).to eq(0)}
  end

  describe '#put_money' do
    it 'fails on negative amounts' do
      expect { cashbox.put_money(-5) }.to raise_error ArgumentError, 'Amount should be positive, -5 passed'
    end

     it 'updates cash' do
      expect { cashbox.put_money(20) }.to change(cashbox, :cash).from(0).to(20)
    end
  end

  describe '#take' do
    before { cashbox.put_money(10) }

    context 'bank' do
      subject {cashbox.take('Bank') }
      it { expect{ subject }.to change(cashbox, :cash).from(10).to(0) }
      it { expect{ subject }.to  output("Encashment was carried out\n").to_stdout}
    end

    context 'gansta' do
       subject {cashbox.take('gansta') }
       it { expect{ subject }.to  raise_error ArgumentError, 'We call the police!'}
       it { expect(cashbox.cash).to eq(10) }
    end

  end

end
