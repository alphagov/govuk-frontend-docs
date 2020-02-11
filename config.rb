require 'govuk_tech_docs'

GovukTechDocs.configure(self)

# Get the current version of GOV.UK Frontend from the package.
package_lock_file = File.read('./package-lock.json')
package_lock = JSON.parse(package_lock_file)
GOVUK_FRONTEND_VERSION = package_lock["dependencies"]["govuk-frontend"]["version"]

helpers do
    def format_mixin_trailing_code(code)
        # Some mixins can have content passed inside.
        # For example the `govuk-if-ie8` function:
        # @include govuk-if-ie8 {
        #  //..
        # }
        acceptsContent = code.include?('@content')
        if acceptsContent
            " {\n  //..\n}"
        else
            ";"
        end
    end
    def format_inline_parameters(parameters)
        # Generate the possible paramters that could be passed into a function or mixin.
        # For example with the `govuk-colour` function: `$colour, $legacy`
        # If the function / mixin has default values output them too, for example `$important: true`
        parameters.map.with_index { |param, index|
            output = "$#{param.name}"
            if param['default']
                output << ": "
                if param.type == 'String'
                    output << '"' + param['default'] + '"'
                else
                    output << param['default']
                end
            end
            output
        }.join(', ')
    end
    def format_parameters_table(parameters)
        # Clone the parameters so we don't overwrite the original data when we map over it.
        parameters.deep_dup.map { |param|
            # If cell contains no data hide dash from assistive technology
            no_data = "<span aria-hidden='true'>—</span>"

            param.name = "`$#{param.name}`"

            # Pipes in Markdown indicate tables, we need to encode them here so they don't render as table syntax
            encoded_description = param.description.gsub('|', '&#124;')
            ## Remove unnecessary line breaks
            description_without_linebreaks = encoded_description.gsub(/\n/m, '').sub(/\r/m, '')
            param.description = description_without_linebreaks || no_data

            if param.type
                # Mutliple types can be seperated by pipe characters e.g. "String | Boolean".
                # We can check for them and then rejoin them with 'or' instead.
                param.type = param.type.split(' | ').map{|char| "`#{char}`" }.join(' or ')
            else
                param.type = no_data
            end
            param.default_value = param['default'] ? "`#{param['default']}`" : no_data
            param
        }
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
                url = "https://github.com/alphagov/govuk-frontend/tree/v#{GOVUK_FRONTEND_VERSION}/src/govuk/#{doc.file.path}#L#{doc.context.line.start}-L#{doc.context.line.end}"
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
