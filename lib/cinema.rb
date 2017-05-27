# Module contains some functional with which you can play.
#
# Cinema emulates the behavior of two types of cinemas:
# * Netflix (online theater)
# * Theatre (movie house)
#
# Both use module Cashbox. You also can include this module in other classes.
# Cashbox has simple functionality:
# * put_money in box
# * see how money is in box now
# * take('Bank') will take all money from box
#
# Movie represents film with all attributes like movie in IMDb
# MovieCollection is enumerable collection of movies
#
# Theatre has schedule: standart and custom.
#
# MovieScraper help you to get information about movies from IMDb
#
# Please read more (http://github.com/natali-maximenko/ruby-basics)
module Cinema
end

# gems
require 'money'
require 'timecop'
require 'virtus'
require 'nokogiri'
require 'themoviedb-api'

# std lib
require 'open-uri'
require 'csv'
require 'date'
require 'erb'
require 'yaml'
require 'set'

# lib
require 'cinema/movie_collection'
require 'cinema/netflix'
require 'cinema/theatre'
require 'cinema/movie_scraper'
