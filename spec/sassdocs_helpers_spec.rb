require 'json'
require 'ostruct'

require_relative '../sassdocs_helpers.rb'

# Middleman helpers convert data to allow dot access, so we need to bring in data in a similar way.
def dothash(hash)
  JSON.parse(hash.to_json, object_class: OpenStruct)
end

RSpec.describe SassdocsHelpers do
  describe '#github_url' do
    it "should return a url" do
      fixture = dothash({
        context: {
          line: {
            start: 9,
            end: 15
          }
        },
        file: {
          path: "helpers/_clearfix.scss"
        }
      })
      url = SassdocsHelpers.github_url(fixture)

      expect(url).to eq('https://github.com/alphagov/govuk-frontend/tree/v3.6.0/src/govuk/helpers/_clearfix.scss#L9-L15')
    end
  end
end
