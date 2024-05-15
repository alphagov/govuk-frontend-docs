module PackageContents
  def components
    File.readlines("node_modules/govuk-frontend/dist/govuk/components/_index.scss")
      .map { |line| /@import "(?<component>[a-z-]*)\/index";/.match(line)&.[](:component) }
      .compact
  end

  def overrides
    File.readlines("node_modules/govuk-frontend/dist/govuk/overrides/_index.scss")
      .map { |line| /@import "(?<override>[a-z-]*)";/.match(line)&.[](:override) }
      .compact
  end
end
