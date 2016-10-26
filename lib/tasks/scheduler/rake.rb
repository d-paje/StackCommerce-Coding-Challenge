# This is used by the Heroku Scheduler but I don't have my credit card info in Heroku so I can't use it
desc 'Cleanup Rails cache'
task :update_feed => :environment do
  puts 'Clearing Rails cache...'
  Rails.cache.cleanup
  puts "done."
end
