require "json"

module GitHubUrlHelpers
  REPO_ROOT = "https://github.com/alphagov/govuk-frontend".freeze

  def github_source_code_url(path, version = :latest)
    github_url "blob/v%{version}%{package_path}/govuk/#{path}", version
  end

  def github_package_root(version = :latest)
    github_url "tree/v%{version}%{package_path}/govuk", version
  end

  def github_file_url(path, version = :latest)
    github_url "tree/v%{version}/#{path}", version
  end

  def github_url(template, version = :latest)
    sprintf "#{REPO_ROOT}/#{template}", {
      version: govuk_frontend_version(version),
      package_path: version == :v4 ? "/src" : "/packages/govuk-frontend/src",
    }
  end

  def govuk_frontend_version(version = :latest)
    version = latest_installed_govuk_frontend_version if version == :latest

    installed_govuk_frontend_versions[version]
  end

  def latest_installed_govuk_frontend_version
    installed_govuk_frontend_versions.keys.max_by do |v|
      v.to_s[/\d+/].to_i
    end
  end

  def installed_govuk_frontend_versions
    # Creates a map of installed versions, with the major versions as keys and
    # the full version as the value.
    # e.g. { :v4 => "4.4.4", :v5 => "5.5.5", :v6 => "6.6.6" }
    @installed_govuk_frontend_versions ||= begin
      package_lock_file = File.read("./package-lock.json")
      JSON.parse(package_lock_file)["packages"]
        .select { |path| path.include?("govuk-frontend") }
        .values
        .map { |package| ["v#{package['version'].split('.').first}".to_sym, package["version"]] }
        .to_h
    end
  end
end
