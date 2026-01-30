require "govuk_tech_docs"
require "lib/header_menu_fix_extension"
require "lib/package_contents"
require "lib/sassdocs_helpers"
require "lib/table_of_contents_helpers"

# Patch the GovukTechDocs cleanly
# https://www.justinweiss.com/articles/3-ways-to-monkey-patch-without-making-a-mess/
require "lib/ext/govuk_tech_docs/tech_docs_html_renderer/reset_unique_identifier_generator_preprocess"
GovukTechDocs::TechDocsHTMLRenderer.include Ext::GovukTechDocs::TechDocsHTMLRenderer::ResetUniqueIndentifierGeneratorPreprocess

GovukTechDocs.configure(self)

::Middleman::Extensions.register(:header_menu_fix, HeaderMenuFixExtension)
activate :header_menu_fix

# Load our own version of GOV.UK Frontend before the one registered by the
# tech_docs_gem otherwise we may be using styles and scripts
# from an outdated version the time for the tech_docs_gem to catch up
sprockets.prepend_path File.join(__dir__, "./node_modules/govuk-frontend/")

# Prevent pages from being indexed unless GitHub Actions is building the main branch
config[:tech_docs][:prevent_indexing] = (ENV["GITHUB_REF"] != "refs/heads/main")

helpers do
  include PackageContents
  include SassdocsHelpers
  include TableOfContentsHelpers

  def markdown(content = nil)
    concat Tilt["markdown"].new(context: @app) { content }.render
  end
end

page "v5/*", layout: :v5, data: { parent: "/v5/" }
page "v4/*", layout: :v4, data: { parent: "/v4/" }
page "*", data: { parent: "/" }
