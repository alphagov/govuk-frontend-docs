require "govuk_tech_docs"
require "sassdocs_helpers"

config[:build_dir] = 'deploy/public'

GovukTechDocs.configure(self)

helpers do
  include SassdocsHelpers
  def markdown(content = nil)
    concat Tilt["markdown"].new(context: @app) { content }.render
  end
end
