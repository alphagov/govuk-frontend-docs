require "json"

module GOVUKFrontendVersion
    def package_version(version)
        version = latest_installed_govuk_frontend_version if version == :latest

        installed_govuk_frontend_versions[version]
    end

    def package_path(version)
        version == :v4 ? "/src" : "/packages/govuk-frontend/src"
    end

    def latest_installed_govuk_frontend_version
        installed_govuk_frontend_versions.keys.max_by do |v|
        v.to_s[/\d+/].to_i
        end
    end

    def installed_govuk_frontend_versions
        # Creates a map of installed versions, with the major versions as keys and
        # the full version as the value.
        # e.g. { :v4 => "v4.4.4", :v5 => "v5.5.5", :v6 => "v6.6.6" }
        @installed_govuk_frontend_versions ||= begin
        package_lock_file = File.read("./package-lock.json")
        JSON.parse(package_lock_file)["packages"]
            .select { |path| path.include?("govuk-frontend") }
            .values
            .map { |package| ["v#{package['version'].split('.').first}".to_sym, "v#{package['version']}"] }
            .to_h
        end
    end
end