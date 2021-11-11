require "govuk_tech_docs"
require "sassdocs_helpers"

config[:build_dir] = "deploy/public"

GovukTechDocs.configure(self)

# Prevent pages from being indexed unless GitHub Actions is building the main branch
config[:tech_docs][:prevent_indexing] = (ENV["GITHUB_REF"] != "refs/heads/main")

helpers do
  include SassdocsHelpers
  def markdown(content = nil)
    concat Tilt["markdown"].new(context: @app) { content }.render
  end
end
