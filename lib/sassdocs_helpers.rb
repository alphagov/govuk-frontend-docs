require "json"

module SassdocsHelpers
  ORDER = %w[settings tools helpers].freeze

  def format_sassdoc_data(data)
    raise "No data in data/sassdocs.json, run `npm install` to generate." if data.nil?

    # Remove private API entries
    public_entries = data.select { |item| item.access == "public" }
    # Remove vendored files, for example SassMQ
    public_entries = public_entries.reject { |item| item.file.path.start_with?("vendor") }
    # Group the items by their 'group', for example 'Settings' or 'Helpers'
    public_entries
      .group_by { |item| item.group.first }
      .group_by { |group_name, _| group_name.split("/").first }
      .sort_by { |group| ORDER.index(group.first) || Float::INFINITY }
  end

  def mixin_trailing_code(code)
    # Some mixins can have content passed inside.
    # For example the `govuk-media-query` function:
    # @include govuk-media-query($from: tablet) {
    #  //..
    # }
    accepts_content = code.include?("@content")
    if accepts_content
      " {\n  //..\n}"
    else
      ";"
    end
  end

  def inline_parameters(parameters)
    return "" unless parameters

    # Generate the possible parameters that could be passed into a function or mixin.
    # For example with the `govuk-colour` function: `$colour, $legacy`
    # If the function / mixin has default values output them too, for example `$important: true`
    # TODO Replace concatenation with interpolation
    # rubocop:disable Style/StringConcatenation
    "(" + parameters.map { |param|
      output = "$#{param.name}"
      if param["default"]
        output << ": "
        output << if param.type == "String"
                    '"' + param["default"] + '"'
                  else
                    param["default"]
                  end
      end
      output
    }.join(", ") + ")"
    # rubocop:enable Style/StringConcatenation
  end

  def parameters_table(parameters)
    # Clone the parameters so we don't overwrite the original data when we map over it.
    parameters.deep_dup.map do |param|
      # If cell contains no data hide dash from assistive technology
      no_data = "<span aria-hidden='true'>—</span>"

      param.name = "`$#{param.name}`"

      # Pipes in Markdown indicate tables, we need to encode them here so they don't render as table syntax
      if param.description
        encoded_description = param.description.gsub("|", "&#124;")
        ## Remove unnecessary line breaks
        description_without_linebreaks = encoded_description.gsub(/\n/m, "").sub(/\r/m, "")
        param.description = description_without_linebreaks
      else
        param.description = no_data
      end

      # Multiple types can be separated by pipe characters e.g. "String | Boolean".
      # We can check for them and then rejoin them with 'or' instead.
      param.type = if param.type
                     param.type.split(" | ").map { |char| "`#{char}`" }.join(" or ")
                   else
                     no_data
                   end
      param.default_value = param["default"] ? "`#{param['default']}`" : no_data
      param
    end
  end

  def item_heading(item)
    # For variables add a dollar to distinguish them from similar mixin/function names
    if item.context.type == "variable"
      "$#{item.context.name}"
    else
      item.context.name
    end
  end

  def group_heading(heading)
    # If the title is not defined, we can give it a generic one.
    if heading != "undefined"
      # Format the group heading
      heading.gsub("/", " / ").titlecase
    else
      "General"
    end
  end

  def subgroup_heading(heading)
    if heading == "undefined"
      "General"
    elsif heading.include?("/")
      slug = heading.split("/").last
      slug.gsub("-", " ").capitalize
    else
      "General #{heading}"
    end
  end

  def github_url(item)
    # Maintain backwards compatibility with GOV.UK Frontend v4
    github_package_path = govuk_frontend_version.start_with?("4") ? "/src" : "/packages/govuk-frontend/src"

    # Construct GitHub link
    "https://github.com/alphagov/govuk-frontend/tree/v#{govuk_frontend_version}#{github_package_path}/govuk/#{item.file.path}#L#{item.context.line.start}-L#{item.context.line.end}"
  end

  def govuk_frontend_version
    # Since this accesses the file system,
    # store an instance variable so we only need to do this once.
    return @govuk_frontend_version unless @govuk_frontend_version.nil?

    # Get the current version of GOV.UK Frontend from the package.
    package_lock_file = File.read("./package-lock.json")
    package_lock = JSON.parse(package_lock_file)
    @govuk_frontend_version = package_lock["packages"]["node_modules/govuk-frontend"]["version"]
    @govuk_frontend_version
  end
end
