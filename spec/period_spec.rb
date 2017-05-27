describe Cinema::Period do
  describe '#initialize' do
    subject { Cinema::Period.new('11:00'..'13:00') }
    it { expect{ subject }.to raise_error ArgumentError, 'You need a block to build!' }
  end

  describe '#intersect?' do
    subject { period1.intersect?(period2) }
    let(:period1) do
      Cinema::Period.new('09:00'..'11:00') do
        description 'Утренний сеанс'
        filters genre: 'Comedy', year: 1900..1980
        price 10
        hall :red, :blue
      end
    end

    context 'with object' do
      let(:period2) { Struct.new(:first_name, :last_name) }
      it { expect{ subject }.to raise_error ArgumentError, 'value must be a period' }
    end

    context 'when another hall another time' do
      let(:period2) do
        Cinema::Period.new('19:00'..'20:00') do
          description 'вечерний сеанс'
          price 20
          hall :green
        end
      end
      it { is_expected.to be_falsey }
    end

    context 'when same hall another time' do
      let(:period2) do
        Cinema::Period.new('19:00'..'20:00') do
          description 'вечерний сеанс'
          price 20
          hall :red
        end
      end
      it { is_expected.to be_falsey }
    end

    context 'when another hall same time' do
      let(:period2) do
        Cinema::Period.new('09:00'..'11:00') do
          description 'Утренний сеанс'
          price 10
          hall :green
        end
      end
      it { is_expected.to be_falsey }
    end

    context 'when same hall part time end' do
      let(:period2) do
        Cinema::Period.new('10:00'..'12:00') do
          description 'вечерний сеанс'
          price 20
          hall :red
        end
      end
      it { is_expected.to be_truthy }
    end

    context 'when same hall part time begin' do
      let(:period2) do
        Cinema::Period.new('08:00'..'11:00') do
          description 'для ранних пташек'
          price 7
          hall :red
        end
      end
      it { is_expected.to be_truthy }
    end

    context 'when same hall part time end' do
      let(:period2) do
        Cinema::Period.new('11:00'..'15:00') do
          description 'дневной сеанс'
          price 13
          hall :red
        end
      end
      it { is_expected.to be_truthy }
    end
  end
end

