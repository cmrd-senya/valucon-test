# docs
class VerifyGemWorker
  include Sidekiq::Worker
  def perform(gem_id, sha_from_api)
    gem = RailsGem.find(gem_id)
    raise ValuconTest::RailsVersioner::RubygemIsMissing unless File.exist?(gem.gem_copy)
    ValuconTest::RailsVersioner.verify_sha(gem.gem_copy, sha_from_api)
  end
end
