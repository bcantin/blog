require 'Wordpress'

#Usage:rake rebirth:wordpress["/export/path/wordpress.xml"]
namespace :rebirth do
  desc "So my Apprentice, you seek to leave the realm of wordpress?"
  task :wordpress, :scroll, :needs => :environment do |t, args|
    args.with_defaults(:scroll => 'wordpress.xml')
    puts "--->Here are my wordly posessions my Liege: #{args[:scroll]}"
    puts "--->The gates of Wordpress open and the faithful enter."
    puts "--->Enter my apprentice."
    puts "--->Wordpress casts' forth your posessions."
    puts "--->Hand me your scroll."
    wp = Wordpress.new(args[:scroll])
    wp.renounce
    puts "--->God created Rails to train the faithful."
    puts "--->Rise Acolyte. Rise and bath in deliverance."
  end
end