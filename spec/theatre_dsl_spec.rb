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
    subject { theatre.schedule.halls }
    it { is_expected.to be_a(Hash) }
    it { expect(subject.count).to eq(3) }

    context 'red hall' do
      subject { theatre.schedule.halls[:red] }
      it do
        is_expected.to be_a(Cinema::Hall)
          .and have_attributes(title: 'Красный зал', places: 100)
      end
    end
  end

  describe 'periods' do
    subject { theatre.schedule.periods }
    it { is_expected.to be_a(Hash) }
    it { expect(subject.count).to eq(4) }

    context 'period 09:00..11:00' do
      subject { theatre.schedule.periods[9..11] }
      it { is_expected.to be_a(Cinema::Period) }
      its(:time) { is_expected.to eq(9..11) }
      its(:description) { is_expected.to eq('Утренний сеанс') }
      its(:price) { is_expected.to eq(10) }
      its(:filters) { is_expected.to eq({genre: 'Comedy', year: 1900..1980}) }
      its(:hall) { is_expected.to eq([:red, :blue]) }
    end
  end

  describe 'choose by timetable' do
    let(:time) { '17:00' }
    before do
      date = Date.today
      time = Time.local(date.year, date.month, date.day, 17, 0, 0)
      Timecop.freeze(time)
    end

    describe '#buy_ticket' do
      subject { theatre.buy_ticket(movie) }
      let(:movie) { theatre.filter({genre: ['Action', 'Drama'], year: 2007..Time.now.year}).first }
      it { expect{ subject }.to output("You bought a ticket for The Dark Knight, costs 20.00 USD\n").to_stdout }
    end

    describe '#show' do
      subject { theatre.show(time) }
      let(:time) { '18:00' }
      before do
        date = Date.today
        time = Time.local(date.year, date.month, date.day, 18, 0, 0)
        Timecop.freeze(time)
      end
      it "filter, get most popular" do
        films = double
        allow(theatre).to receive(:filter).with({genre: ['Action','Drama'], year: 2007..2017}) { films }
        expect(theatre).to receive(:most_popular_movie).with(films).and_return(double(length: 120, title: 'Modern Times'))

        theatre.show(time)
      end
    end
  end

  describe '#show' do
    subject { theatre.show(time) }
    let(:time) { '19:00' }
    before do
      date = Date.today
      time = Time.local(date.year, date.month, date.day, 19, 0, 0)
      Timecop.freeze(time)
    end
    it "filter, get most popular" do
      films = double
      allow(theatre).to receive(:filter).with({genre: ['Action','Drama'], year: 2007..2017}) { films }
      expect(theatre).to receive(:most_popular_movie).with(films).and_return(double(length: 120, title: 'Modern Times'))

      theatre.show(time)
    end
  end

  describe '#when?' do
    subject { theatre.when?(movie_title) }

    context 'when film not found' do
      let(:movie_title) { 'Mortal Combat' }
      it 'fails' do
        expect { subject }.to raise_error ArgumentError, "Movie 'Mortal Combat' not found"
      end
    end

    context 'when film is shown' do
      let(:movie_title) { 'American History X' }
      it { is_expected.to eq('From 16:00 to 20:00') }
    end
  end

  describe '#valid?' do
    subject { theatre.schedule.valid? }
    it { is_expected.to be_truthy }
  end

end
