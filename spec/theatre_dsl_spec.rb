require 'rspec'
require 'rspec/its'
require_relative '../lib/theatre'

describe Cinema::Theatre do
  let(:theatre) do
    Cinema::Theatre.new('movies.txt') do
      hall :red, title: 'Красный зал', places: 100
      hall :blue, title: 'Синий зал', places: 50
      hall :green, title: 'Зелёный зал (deluxe)', places: 12

      period '09:00'..'11:00' do
        description 'Утренний сеанс'
        filters genre: 'Comedy', year: 1900..1980
        price 10
        hall :red, :blue
      end

      period '11:00'..'16:00' do
        description 'Спецпоказ'
        title 'The Terminator'
        price 50
        hall :green
      end

      period '16:00'..'20:00' do
        description 'Вечерний сеанс'
        filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
        price 20
        hall :red, :blue
      end

      period '19:00'..'22:00' do
        description 'Вечерний сеанс для киноманов'
        filters year: 1900..1945, exclude_country: 'USA'
        price 30
        hall :green
      end
    end
  end

  describe 'halls' do
    subject { theatre.halls }
    it { is_expected.to be_a(Hash) }
    it { expect(subject.count).to eq(3) }

    context 'red hall' do
      subject { theatre.halls[:red] }
      it do
        is_expected.to be_a(Cinema::Hall)
          .and have_attributes(title: 'Красный зал', places: 100)
      end
    end
  end

  describe 'periods' do
    subject { theatre.periods }
    it { is_expected.to be_a(Hash) }
    it { expect(subject.count).to eq(4) }

    context 'period 09:00..11:00' do
      subject { theatre.periods['09:00'..'11:00'] }
      it { is_expected.to be_a(Cinema::Period) }
      its(:description) { is_expected.to eq('Утренний сеанс') }
      its(:price) { is_expected.to eq(10) }
      its(:filters) { is_expected.to eq({genre: 'Comedy', year: 1900..1980}) }
      its(:hall) { is_expected.to eq([:red, :blue]) }
    end
  end

end
