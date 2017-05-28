# Cinema
This module was created to learn Ruby and contains some functional with which you can play.
Cinema emulates the behavior of two types of cinemas: Netflix (online theater) and Theatre (movie house).

## Netflix

### An Introduction

You can create netflix from file. Sample you find in root folder of module. This file contains info about top 250 movies from IMDb.

```ruby
require 'cinema'

netflix = Cinema::Netflix.new('movies.txt')
```

Before choosing which movie to watch, you need to pay.

```ruby
netflix.pay(30)
```
After payment, the money will go to your personal account and you will be able to use them later.

### Filtering movies to show
An easy way to choose movies is to provide a hash of values to match to `show`:

```ruby
netflix.show(genre: 'Drama', period: :modern)
# Now showing: The Godfather: Part II 13:27 - 16:47
```

You can also specify filter by block:

```ruby
netflix.show { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003 }
# Now showing: The Avengers 13:28 - 15:51
```

And create and use your own filters:

```ruby
# specify your filter
netflix.define_filter(:sci_fi) { |movie| movie.genre.include?('Sci-Fi') && movie.country != 'UK' }
# and use
netflix.show(sci_fi: true)
# use with other filters
netflix.show(sci_fi: true, director: 'Christopher Nolan')
```

Easy to use, but what happens if you want specify params to your filter?

```ruby
netflix.define_filter(:new_sci_fi) { |movie, year| movie.year > year && movie.genre.include?('Sci-Fi') && movie.country != 'UK' }
netflix.show(new_sci_fi: 2010)
```
Cinema will understand you)) Moreover, you can create filters based on existing ones!

```ruby
# use filter created in last example
netflix.define_filter(:newest_sci_fi, arg: 2014, from: :new_sci_fi)
netflix.show(newest_sci_fi: true)
```

### About prices

The prices for films depend on the selected period. We have 4 periods:
* ancient (filmed before 1945) - 1$
* classic (filmed between 1945 and 1967) - 1.5$
* modern (filmed between 1967 and 1999) - 3$
* new (filmed after 1999) - 5$

Sometimes money ends... Method `show` tell if you "Need more money".
But you can always ask netflix `how_much?` costs movie

```ruby
puts netflix.how_much?('The Terminator')
# 3.00
```

## Theatre

### An Introduction

Also need file with movies to be created. Sample you find in root folder of module.

```ruby
theatre = Cinema::Theatre.new('movies.txt')
```

Good news - you don't need to pay! Theatre shows different films according to his schedule.
You need only choose time.

```ruby
theatre.show('13:30')
# You bought a ticket for Indiana Jones and the Last Crusade, costs 5.00 USD
# Now showing: Indiana Jones and the Last Crusade 13:55 - 16:02
```

You can ask theatre 'when?' some will be shown.

```ruby
puts theatre.when?('American History X')
# From 17:00 to 23:00
```

### Custom schedule

Theatre provide you to set custom schedule rules by DSL.

```ruby
Cinema::Theatre.new('movies.txt') do
  hall :red, title: 'Red hall', places: 100
  hall :blue, title: 'Blue hall', places: 50
  hall :green, title: 'Green hall (deluxe)', places: 12

  period '09:00'..'11:00' do
    description 'Morning'
    filters genre: 'Comedy', year: 1900..1980
    price 10
    hall :red, :blue
  end

  period '11:00'..'16:00' do
    description 'Special'
    title 'The Terminator'
    price 50
    hall :green
  end

  period '16:00'..'20:00' do
    description 'Evening'
    filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
    price 20
    hall :red, :blue
  end

  period '19:00'..'22:00' do
    description 'Night show for fanats'
    filters year: 1900..1945, exclude_country: 'USA'
    price 30
    hall :green
  end
end
```





