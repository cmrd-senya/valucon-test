module ValuconTest
  # docs
  module RailsVersioner
    def self.sync_with_rubygems
      rubygems_query.each do |version_hash|
        gem = RailsGem.find_by(version: version_hash['number'])
        if gem
          VerifyGemWorker.perform_async(gem.id, version_hash['sha'])
        else
          DownloadGemWorker.perform_async(version_hash['number'], version_hash['sha'])
        end
      end
    end

    def self.verify_sha(path, expected_sha)
      raise WrongSHAHash unless Digest::SHA256.file(path).hexdigest == expected_sha
    end

    class WrongSHAHash < RuntimeError
    end

    class RubygemIsMissing < RuntimeError
    end

    private_class_method def self.rubygems_query
      url = 'https://rubygems.org/api/v1/versions/rails.json'
      response = Net::HTTP.get(URI(url))
      JSON.parse(response)
    end
  end
end
