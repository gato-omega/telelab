namespace :db do
  desc 'Use database_cleaner to erase all data from the db, without dropping it'
  task :clean => :environment do
    puts "Cleaning...".green
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean
    puts "Cleaned!".light_green
  end
end
