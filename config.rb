require 'govuk_tech_docs'

GovukTechDocs.configure(self)

helpers do
    def markdown(text=nil, &block)
        content = text
        if block_given?
            content = capture_html(&block)
        end
        concat Tilt['markdown'].new(context: @app) { content }.render
    end
end