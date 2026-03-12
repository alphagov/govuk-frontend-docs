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
  }x

  def components
    extract_from "components/_index.scss"
  end

  def overrides
    extract_from "overrides/_index.scss"
  end

  def extract_from(file, pattern: SASS_IMPORT_PATTERN)
    File.readlines("node_modules/govuk-frontend/dist/govuk/#{file}")
      .filter_map { |line| line[pattern, 1] }
      .tap { |list| raise "No matches found in #{file}" if list.empty? }
  end
end
