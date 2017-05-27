describe Cinema::Cashbox do
  let(:cashbox) { Object.new.extend Cinema::Cashbox }

  describe '#cash' do
    it { expect(cashbox.cash).to eq(Money.new(0, "USD"))}
  end

  describe '#put_money' do
    it 'fails on negative amounts' do
      expect { cashbox.put_money(-5) }.to raise_error ArgumentError, 'Amount should be positive, -5 passed'
    end

     it 'updates cash' do
      expect { cashbox.put_money(Money.new(2000, "USD")) }.to change(cashbox, :cash).from(Money.new(0, "USD")).to(Money.new(2000, "USD"))
    end
  end

  describe '#take' do
    before { cashbox.put_money(Money.new(1000, "USD")) }
    subject { cashbox.take(taker) }

    context 'bank' do
      let(:taker) { 'Bank' }
      it { expect{ subject }.to change(cashbox, :cash).from(Money.new(1000, "USD")).to(Money.new(0, "USD")) }
      it { expect{ subject }.to  output("Encashment was carried out\n").to_stdout}
    end

    context 'gansta' do
       let(:taker) { 'gangsta' }
       it { expect{ subject }.to  raise_error ArgumentError, 'We call the police!'}
       #it { expect{ subject }.not_to change(cashbox, :cash) }
    end

  end

end
