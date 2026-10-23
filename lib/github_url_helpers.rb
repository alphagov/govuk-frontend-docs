require_relative('govuk_frontend_version')

module GitHubUrlHelpers
  def github_source_code_url(path, version = :latest)
    GitHubUrl.new("/govuk/#{path}", version, root: :package, type: :blob).to_s
  end

  def github_package_root(version = :latest)
    GitHubUrl.new("/govuk", version, root: :package).to_s
  end

  def github_file_url(path, version = :latest)
    GitHubUrl.new(path, version).to_s
  end

  class GitHubUrl
    # Encapsulates the build of a GitHub URL
    extend GOVUKFrontendVersion

    REPO_ROOT = "https://github.com/alphagov/govuk-frontend".freeze

    def initialize(path, version, root: :repository, type: :tree)
      @path = path
      @version = version
      @root = root
      @type = type
    end

    def to_s
      url = "#{REPO_ROOT}/#{@type}"

      url += "/#{self.class.package_version(@version)}"

      if @root === :package
        url += self.class.package_path(@version)
      end

      url += @path
    end
  end
end
