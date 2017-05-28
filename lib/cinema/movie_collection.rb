require_relative 'movie'

module Cinema
  class MovieCollection
    include Enumerable
    include ERB::Util
    # @return [Enumerable] collection of [Movie]
    attr_accessor :collection
    TIMEFORMAT = '%H:%M'.freeze
    SHOW_MSG = 'Now showing: %s %s - %s'.freeze

    # Initialize collection from file
    # @param filename [String] name of file with movies
    # @note each movie in file should be [String] in CSV format separeted with '|'
    def initialize(filename)
      unless File.exist?(filename)
        raise ArgumentError, "File #{filename} not found"
      end

      @collection = CSV.read(filename, col_sep: '|').map do |movie|
        Movie.create(movie, self)
      end
    end

    def each(&block)
      @collection.each(&block)
    end

    # All movies
    # @return [Enumerable] collection of [Movie]
    def all
      @collection
    end

    # Uniq genres list of collection
    # @return [Array] all genres
    def genres
      @collection.map(&:genre).flatten.uniq.sort
    end

    # Sort movies by any field of [Movie]
    # @param field [Symbol]
    # @return [Array] sorted movies list
    def sort_by(field)
      @collection.sort_by(&field)
    end

    # Filter movies collection
    # @param attrs_hash [Hash] hash with movie attribute {attribute: value}
    # @note Attributes checking is performed with ===, so you can pass ranges, regexps and other generic patterns
    # @return [Array] filtered movies list
    def filter(**attrs_hash)
      attrs_hash.reduce(@collection) do |memo, (key, value)|
        memo.select { |movie| movie.match?(key, value) }
      end
    end

    # Statistic for movies
    # @param key [Symbol] movie attribute name
    # @return [Hash] list with {attribute value => movies count}
    def stats(key)
      @collection.flat_map(&key)
                 .sort
                 .group_by { |v| v }
                 .map { |v, values| { v => values.count } }
    end

    # Show movie
    # @param movie [Movie]
    # @return [String] Now showing: movietitle time starts - time ends
    def show(movie)
      start_time = Time.now
      end_time = start_time + 60 * movie.length.to_i
      puts SHOW_MSG % [movie.title, start_time.strftime(TIMEFORMAT), end_time.strftime(TIMEFORMAT)]
    end

    # Load budgets for movies in collection
    # @param hash [Hash] {id: imdb_movie_id [String], budget: [String]$ }
    def load_budgets(hash)
      @collection.each do |movie|
        param = hash.select { |info| movie.id == info[:id] }.first
        movie.budget = param[:budget] unless param.nil?
      end
    end

    # Load title and poster path for movies in collection
    # @param info [Hash] info from tmdb
    def load_detail(info)
      @collection.each do |movie|
        detail = info.detect { |tmdb| movie.title == tmdb[:original_title] }
        unless detail.nil?
          movie.alt_title = detail[:title]
          movie.poster = detail[:poster_path]
        end
      end
    end

    # Save rendered list into file
    def save(file)
      File.open(file, "w+") do |f| f.write(render) end
    end

    private

    # Choose random popular movie by rating
    def most_popular_movie(collection)
      collection.sort_by { |movie| movie.rating * rand(0.0..1.5) }.last
    end

    # Render table of movies from ERB template
    def render
      ERB.new(File.open(File.join(File.dirname(File.expand_path(__FILE__)), '/templates/movie_collection.html.erb')).read).result(binding)
    end
  end
end
