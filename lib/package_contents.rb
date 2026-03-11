module PackageContents
  SASS_IMPORT_PATTERN = %r{
    ^\s*                       # leading whitespace
    @(?:import|use)\s+         # @import or @use
    ["']                       # opening quote
      ([a-z-]+)                # capture the name
      (?:/(?:_?index)          # optional /index or /_index
        (?:\.scss)?            # optional .scss extension
      )?
    ["']                       # closing quote
    (?:\s+with\s+\(.*?\))?    # optional 'with ()' config
    \s*;                       # trailing whitespace and ;
  }x

  def components
    extract_from "components/_index.scss" do |line|
      line[SASS_IMPORT_PATTERN, 1]
    end
  end

  def overrides
    extract_from "overrides/_index.scss" do |line|
      line[SASS_IMPORT_PATTERN, 1]
    end
  end

  def extract_from(file, &block)
    File.readlines("node_modules/govuk-frontend/dist/govuk/#{file}")
      .map(&block)
      .compact
      .tap { |list| raise "No matches found in #{file}" if list.empty? }
  end
end
