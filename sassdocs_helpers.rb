module SassdocsHelpers
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
            .group_by {
                # Group the docs by their 'group', for example 'Settings' or 'Helpers'
                |doc| doc.group.first
            }
    end
    def mixin_trailing_code(code)
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
    def inline_parameters(parameters)
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
    def parameters_table(parameters)
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
    def doc_heading(doc)
        # For variables add a dollar to distinguish them from similar mixin/function names
        if doc.context.type == 'variable'
            '$' + doc.context.name
        else
            doc.context.name
        end
    end
    def group_heading(heading)
        # If the title is not defined, we can give it a generic one.
        if heading != 'undefined'
            # Format the group heading
            heading.gsub('/', ' / ').titlecase
        else
            'General'
        end
    end
    def github_url(doc)
        # Construct GitHub link
        "https://github.com/alphagov/govuk-frontend/tree/v#{govuk_frontend_version}/src/govuk/#{doc.file.path}#L#{doc.context.line.start}-L#{doc.context.line.end}"
    end
    def govuk_frontend_version
        # Since this accesses the file system,
        # store an instance variable so we only need to do this once.
        return @govuk_frontend_version unless @govuk_frontend_version.nil?
        # Get the current version of GOV.UK Frontend from the package.
        package_lock_file = File.read('./package-lock.json')
        package_lock = JSON.parse(package_lock_file)
        @govuk_frontend_version = package_lock["dependencies"]["govuk-frontend"]["version"]
        @govuk_frontend_version
    end
end
