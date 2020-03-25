require 'json'
require 'ostruct'
require 'active_support/all'

require_relative '../sassdocs_helpers.rb'

# Middleman helpers convert data to allow dot access, so we need to bring in data in a similar way.
def dothash(hash)
  JSON.parse(hash.to_json, object_class: OpenStruct)
end

RSpec.describe SassdocsHelpers do
  describe '#doc_heading' do
    it "should return with a dollar prefix if variable" do
      fixture = dothash({
        context: {
          type: 'variable',
          name: 'govuk-assets-path'
        }
      })
      heading = SassdocsHelpers.doc_heading(fixture)

      expect(heading).to eq('$govuk-assets-path')
    end
    it "should heading if not variable" do
      fixture = dothash({
        context: {
          type: 'function',
          name: 'govuk-colour'
        }
      })
      heading = SassdocsHelpers.doc_heading(fixture)

      expect(heading).to eq('govuk-colour')
    end
  end
  describe '#group_heading' do
    it "should return General if undefined" do
      heading = SassdocsHelpers.group_heading('undefined')

      expect(heading).to eq('General')
    end
    it "should format heading to titlecase" do
      heading = SassdocsHelpers.group_heading('helpers')

      expect(heading).to eq('Helpers')
    end
    it "should format heading with forwards slashes to titlecase" do
      heading = SassdocsHelpers.group_heading('settings/colours')

      expect(heading).to eq('Settings / Colours')
    end
  end
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
