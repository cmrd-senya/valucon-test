require 'English'

# docs
class DownloadGemWorker
  include Sidekiq::Worker
  def perform(version, sha_from_api)
    output = `cd #{gems_directory} && gem fetch rails -v #{version}`
    raise GemFetchFailure, output unless $CHILD_STATUS == 0 # rubocop:disable Style/NumericPredicate

    ValuconTest::RailsVersioner.verify_sha("#{gems_directory}/rails-#{version}.gem", sha_from_api)

    RailsGem.create!(
      version:  version,
      gem_copy: "#{gems_directory}/rails-#{version}.gem",
      sha:      sha_from_api
    )
  end

  class GemFetchFailure < RuntimeError
  end

  private

  def gems_directory
    Rails.root.join('public', 'gems')
  end
end
