RSpec.describe ValuconTest::RailsVersioner do
  def inlined_jobs
    Sidekiq::Worker.clear_all
    result = yield Sidekiq::Worker
    Sidekiq::Worker.drain_all
    result
  end

  describe '.sync_with_rubygems' do
    it 'downloads new gem when unknown version provided' do
      json_stub = <<-JSON
[
  {
    "number":"5.0.1",
    "sha":"3f9acd2c489c9eed11ff200a37cb32784cf15ddc5e561657d50b847ced3c361d"
  }
]
      JSON
      stub_request(:any, 'https://rubygems.org/api/v1/versions/rails.json').to_return(body: json_stub)

      expect do
        inlined_jobs do
          ValuconTest::RailsVersioner.sync_with_rubygems
        end
      end.not_to raise_error

      gem = RailsGem.find_by_version('5.0.1')
      expect(gem).not_to be_nil
      expect(File.exist?("#{Dir.pwd}/public/gems/rails-5.0.1.gem")).to be_truthy
      expect do
        ValuconTest::RailsVersioner.verify_sha("#{Dir.pwd}/public/gems/rails-5.0.1.gem", gem.sha)
      end.not_to raise_error
    end

    it 'raises when version is known but file not found' do
      RailsGem.create!(version: '0.0.0-valucontest', sha: '123', gem_copy: "#{Dir.pwd}/public/gems/rails-XXX.gem")

      json_stub = <<-JSON
[
  {
    "number":"0.0.0-valucontest",
    "sha":"12345"
  }
]
      JSON
      stub_request(:any, 'https://rubygems.org/api/v1/versions/rails.json').to_return(body: json_stub)

      expect do
        inlined_jobs do
          ValuconTest::RailsVersioner.sync_with_rubygems
        end
      end.to raise_error ValuconTest::RailsVersioner::RubygemIsMissing
    end

    it 'raises when version is known but sha is wrong' do
      RailsGem.create!(
        version:  '0.0.0-valucontest',
        sha:      'not used here',
        gem_copy: "#{Dir.pwd}/public/gems/rails-XXX.gem"
      )

      json_stub = <<-JSON
[
  {
    "number":"0.0.0-valucontest",
    "sha":"123456"
  }
]
      JSON
      stub_request(:any, 'https://rubygems.org/api/v1/versions/rails.json').to_return(body: json_stub)
      File.open("#{Dir.pwd}/public/gems/rails-XXX.gem", 'w') {}

      expect do
        inlined_jobs do
          ValuconTest::RailsVersioner.sync_with_rubygems
        end
      end.to raise_error ValuconTest::RailsVersioner::WrongSHAHash
      File.delete("#{Dir.pwd}/public/gems/rails-XXX.gem")
    end

    it "doesn't raise when version is known and everything is ok" do
      RailsGem.create!(
        version:  '0.0.0-valucontest',
        sha:      'not used here',
        gem_copy: "#{Dir.pwd}/public/gems/rails-XXX.gem"
      )

      json_stub = <<-JSON
[
  {
    "number":"0.0.0-valucontest",
    "sha":"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  }
]
      JSON
      stub_request(:any, 'https://rubygems.org/api/v1/versions/rails.json').to_return(body: json_stub)
      File.open("#{Dir.pwd}/public/gems/rails-XXX.gem", 'w') {}

      expect do
        inlined_jobs do
          ValuconTest::RailsVersioner.sync_with_rubygems
        end
      end.not_to raise_error
      File.delete("#{Dir.pwd}/public/gems/rails-XXX.gem")
    end
  end
end
