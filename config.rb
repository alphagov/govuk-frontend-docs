require 'govuk_tech_docs'

GovukTechDocs.configure(self)

helpers do
    def format_mixin_trailing_code(code)
        acceptsContent = code.include?('@content')
        if acceptsContent
            " {\n  //..\n}"
        else
            ";"
        end
    end
    def format_parameters(parameters)
        parameters.map.with_index { |param, index|
            output = "$#{param.name}"
            if param['default']
                output << ": "
                if param.type == 'String'
                    output << '"'
                end
                output << param['default']
                if param.type == 'String'
                    output << '"'
                end
            end
            if index != parameters.size - 1
                output << ", "
            end
            output
        }.join
    end
    def sassdoc
        data.sassdoc
            .select { |doc|
                # Remove private API entries
                doc.access == 'public'
            }
            .select { |doc|
                # Remove vendored files, for example SassMQ
                !doc.file.path.start_with?('vendor')
            }
            .map { |doc|
                # Format headings
                heading = doc.context.name
                # For variables add a dollar to distinguish them from similar mixin/function names
                if doc.context.type == 'variable'
                    heading = '$' + heading
                end
                doc.heading = heading
                doc
            }
            .map { |doc|
                # Construct GitHub link
                # TODO: dynamically get version number
                version = '3.5.0'
                url = "https://github.com/alphagov/govuk-frontend/tree/v#{version}/src/govuk/#{doc.file.path}#L#{doc.context.line.start}-L#{doc.context.line.end}"
                doc.github_url = url
                doc
            }
            .map { |doc|
                # Format the group heading
                originalHeading = doc.group.first
                # If the title is not defined, we can give it a generic one.
                if originalHeading != 'undefined'
                    heading = originalHeading
                else
                    heading = 'General'
                end
                # Format the heading
                heading = heading.gsub('/', ' / ').titlecase
                doc.group_heading = heading
                doc
            }
            .group_by {
                # Group the docs by their 'group', for example 'Settings' or 'Helpers'
                |doc| doc.group_heading
            }
    end

    def markdown(text=nil, &block)
        content = text
        if block_given?
            content = capture_html(&block)
        end
        concat Tilt['markdown'].new(context: @app) { content }.render
    end
end
