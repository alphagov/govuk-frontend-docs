require_relative "../lib/package_contents"

class Test
  include PackageContents
end

RSpec.describe PackageContents do
  before(:all) do
    @helper = Test.new
  end

  shared_examples "a sass index parser" do |method, file|
    it "extracts names via @import" do
      allow(File).to receive(:readlines).and_return <<~FILE.split("\n")
        @import "../base";

        @import "first";
        @import "second/index";
        @import "th-ird/_index";
        @import "fourth/index.scss";
        @import 'fifth/_index.scss';
        // @import "false-match/index";
        @import "";
      FILE

      expect(@helper.send(method)).to eq(%w[
        first
        second
        th-ird
        fourth
        fifth
      ])
    end

    it "extracts names via @use" do
      allow(File).to receive(:readlines).and_return <<~FILE.split("\n")
        @use "../base";

        @use "first";
        @use "second/index";
        @use "th-ird/_index";
        @use "fourth/index.scss";
        @use 'fifth/_index.scss';
        @use "sixth" with ($config: true);
        // @use "false-match/index";
        @use "";
      FILE

      expect(@helper.send(method)).to eq(%w[
        first
        second
        th-ird
        fourth
        fifth
        sixth
      ])
    end

    it "throws if no matches are found" do
      allow(File).to receive(:readlines).and_return []

      expect { @helper.send(method) }.to raise_error(
        "No matches found in #{file}",
      )
    end
  end

  describe "#components" do
    it_behaves_like "a sass index parser", :components, "components/_index.scss"
  end

  describe "#overrides" do
    it_behaves_like "a sass index parser", :overrides, "overrides/_index.scss"
  end
end
