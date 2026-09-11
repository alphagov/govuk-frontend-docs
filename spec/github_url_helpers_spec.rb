require "json"

require_relative "../lib/github_url_helpers"

RSpec.describe GitHubUrlHelpers do
  let :package_content do
    {
      packages: {
        "node_modules/govuk-frontend": { version: "10.10.10" },
        "node_modules/govuk-frontend-v5": { version: "5.5.5" },
        "node_modules/govuk-frontend-v4": { version: "4.4.4" },
      },
    }.to_json
  end

  before(:each) do
    allow(File).to receive(:read).and_return(package_content)
    # Include mixin into a test class to allow us to mock File
    # TODO Move constant definition
    # rubocop:disable Lint/ConstantDefinitionInBlock
    class Test
      include GitHubUrlHelpers
    end
    @helper = Test.new
    # rubocop:enable Lint/ConstantDefinitionInBlock
  end

  describe "#installed_versions" do
    it "returns a hash of installed versions" do
      expect(@helper.installed_govuk_frontend_versions).to eq({
        v5: "5.5.5",
        v4: "4.4.4",
        v10: "10.10.10",
      })
    end
  end

  describe "#govuk_frontend_version" do
    it "returns the latest version by default" do
      expect(@helper.govuk_frontend_version).to eq "10.10.10"
    end
  end

  describe :github_file_url do
    it "returns a url" do
      url = @helper.github_file_url("foo")
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/blob/v10.10.10/packages/govuk-frontend/src/govuk/foo")
    end

    it "uses the appropriate version" do
      url = @helper.github_file_url("foo", :v5)
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/blob/v5.5.5/packages/govuk-frontend/src/govuk/foo")
    end

    it "adapts the path for v4 links" do
      url = @helper.github_file_url("foo", :v4)
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/blob/v4.4.4/src/govuk/foo")
    end
  end

  describe :github_directory_url do
    it "returns a url" do
      url = @helper.github_directory_url("foo")
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/tree/v10.10.10/packages/govuk-frontend/src/govuk/foo")
    end

    it "uses the appropriate version" do
      url = @helper.github_directory_url("foo", :v5)
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/tree/v5.5.5/packages/govuk-frontend/src/govuk/foo")
    end

    it "adapts the path for v4 links" do
      url = @helper.github_directory_url("foo", :v4)
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/tree/v4.4.4/src/govuk/foo")
    end
  end
end
