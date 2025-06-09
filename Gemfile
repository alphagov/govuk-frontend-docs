# Hacky way to not have Netlify automatically install the gems and 
# ensure npm is installed when Bundler runs. Without this,  
# installing the tech_docs_gem from Git fails because
# the `.gemspec` file tries to run `npm install` but `npm`
# is not installed on Netlify's machine running the build
# https://answers.netlify.com/t/how-do-i-disable-rubygems-installation/90066/5
return true if ENV['NETLIFY'] and not ENV['INSTALL_GEMS']
# If you do not have OpenSSL installed, change
# the following line to use 'http://'
source "https://rubygems.org"

# For faster file watcher updates on Windows:
gem "wdm", "~> 0.1.0", platforms: %i[mswin mingw]

# Windows does not come with time zone data
gem "tzinfo-data", platforms: %i[mswin mingw jruby]

# Include the tech docs gem
gem "govuk_tech_docs", github: 'alphagov/tech-docs-gem', branch: 'apply-brand-refresh'

# Development
gem "json"
gem "ostruct"
gem "rake", "~> 13.2"
gem "rspec", "~> 3.13.0"
gem "rubocop-govuk", "~> 5.0.2"
