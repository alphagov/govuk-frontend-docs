module PackageContents
  def components
    extract_from "components/_index.scss" do |line|
      # Match anything found between `@import "` and `/index";`
      line[/(?<=@import ")[a-z-]*(?=\/index";)/]
    end
  end

  def overrides
    extract_from "overrides/_index.scss" do |line|
      # Match anything found between `@import "` and `";`
      line[/(?<=@import ")[a-z-]*(?=";)/]
    end
  end

  def extract_from(file, &block)
    File.readlines("node_modules/govuk-frontend/dist/govuk/#{file}")
      .map(&block)
      .compact
      .tap { |list| raise "No matches found in #{file}" if list.empty? }
  end
end
