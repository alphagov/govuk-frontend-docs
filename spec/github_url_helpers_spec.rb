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

  subject do
    Object.new.extend(GitHubUrlHelpers)
  end

  before(:each) do
    allow(File).to receive(:read).and_return(package_content)
  end

  describe "#installed_versions" do
    it "returns a hash of installed versions" do
      expect(subject.installed_govuk_frontend_versions).to eq({
        v5: "v5.5.5",
        v4: "v4.4.4",
        v10: "v10.10.10",
      })
    end
  end

  describe "#govuk_frontend_version" do
    it "returns the latest version by default" do
      expect(subject.govuk_frontend_version).to eq "v10.10.10"
    end
  end

  describe :github_source_code_url do
    it "returns a url" do
      url = subject.github_source_code_url("foo")
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/blob/v10.10.10/packages/govuk-frontend/src/govuk/foo")
    end

    it "uses the appropriate version" do
      url = subject.github_source_code_url("foo", :v5)
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/blob/v5.5.5/packages/govuk-frontend/src/govuk/foo")
    end

    it "adapts the path for v4 links" do
      url = subject.github_source_code_url("foo", :v4)
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/blob/v4.4.4/src/govuk/foo")
    end
  end

  describe "#github_package_root" do
    it "returns a url" do
      url = subject.github_package_root
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/tree/v10.10.10/packages/govuk-frontend/src/govuk")
    end

    it "uses the appropriate version" do
      url = subject.github_package_root(:v5)
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/tree/v5.5.5/packages/govuk-frontend/src/govuk")
    end

    it "adapts the path for v4 links" do
      url = subject.github_package_root(:v4)
      expect(url).to eq("https://github.com/alphagov/govuk-frontend/tree/v4.4.4/src/govuk")
    end
  end
end
