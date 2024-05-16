require_relative "../lib/package_contents"

class Test
  include PackageContents
end

RSpec.describe PackageContents do
  before(:all) do
    @helper = Test.new
  end

  describe "#components" do
    it "extracts components from components/_index.scss" do
      allow(File).to receive(:readlines).and_return <<~FILE.split("\n")
        @import "../base";

        @import "first-component/index";
        @import "second-component/index";
        @import "third-component/index";
      FILE

      expect(@helper.components).to eq(%w[
        first-component
        second-component
        third-component
      ])
    end

    it "throws if no components are found in components/_index.scss" do
      allow(File).to receive(:readlines).and_return []

      expect { @helper.components }.to raise_error(
        "No matches found in components/_index.scss",
      )
    end
  end

  describe "#overrides" do
    it "extracts overrides from overrides/_index.scss" do
      allow(File).to receive(:readlines).and_return <<~FILE.split("\n")
        @import "../a-dependency";

        @import "one";
        @import "two";
        @import "th-ree";
      FILE

      expect(@helper.overrides).to eq(%w[
        one
        two
        th-ree
      ])
    end

    it "throws if no overrides are found in components/_index.scss" do
      allow(File).to receive(:readlines).and_return []

      expect { @helper.overrides }.to raise_error(
        "No matches found in overrides/_index.scss",
      )
    end
  end
end
