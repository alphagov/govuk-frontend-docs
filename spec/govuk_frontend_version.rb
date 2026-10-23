require "json"

require_relative "../lib/govuk_frontend_version"

RSpec.describe GOVUKFrontendVersion do

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
    Object.new.extend(GOVUKFrontendVersion)
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
end