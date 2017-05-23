module Cinema
  class CollectionByGenre
    def initialize(collection)
      collection.genres.each do |name|
        define_singleton_method "#{name.downcase}" do collection.filter(genre: name) end
      end
    end
  end
end

