namespace :gateway do
  desc 'Starts the gateway service'
  task :start => :environment do
    puts "Litening on #{GATEWAY_SERVER_URL}".light_green
  end
end
