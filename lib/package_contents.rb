module PackageContents
  def components
    extract_from "components/_index.scss" do |line|
      # Match sass index file patterns: folder, folder/index, folder/_index,
      # folder/index.scss, folder/_index.scss
      line[/^\s*@import\s+["']([a-z-]+)(?:\/(?:_?index)(?:\.scss)?)?["']\s*;/, 1]
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
