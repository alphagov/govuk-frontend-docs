require "govuk_tech_docs"
require "lib/sassdocs_helpers"

# Patch the GovukTechDocs cleanly
# https://www.justinweiss.com/articles/3-ways-to-monkey-patch-without-making-a-mess/
require "lib/ext/govuk_tech_docs/tech_docs_html_renderer/reset_unique_identifier_generator_preprocess"
GovukTechDocs::TechDocsHTMLRenderer.include Ext::GovukTechDocs::TechDocsHTMLRenderer::ResetUniqueIndentifierGeneratorPreprocess

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
