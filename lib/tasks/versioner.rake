require 'sidekiq/api'

desc 'Run rails gem versioner'
task versioner: :environment do
  ValuconTest::RailsVersioner.sync_with_rubygems
end

task clear_all: :environment do
  Sidekiq::Queue.new.clear
  RailsGem.destroy_all
  `rm -f #{Rails.root.join('public', 'gems', '*.gem')}`
end
