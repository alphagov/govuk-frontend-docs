require 'json'
require 'ostruct'
require 'active_support/all'

require_relative '../sassdocs_helpers.rb'

# Middleman helpers convert data to allow dot access, so we need to bring in data in a similar way.
def dothash(hash)
  JSON.parse(hash.to_json, object_class: OpenStruct)
end

RSpec.describe SassdocsHelpers do
  describe '#inline_parameters' do
    it "should return single name with a dollar prefix" do
      fixture = dothash([
        {
          name: "colour"
        }
      ])
      inline_parameters = SassdocsHelpers.inline_parameters(fixture)

      expect(inline_parameters).to eq('$colour')
    end
    it "should return multiple names with a comma separator" do
      fixture = dothash([
        {
          name: "colour"
        },
        {
          name: "legacy"
        }
      ])
      inline_parameters = SassdocsHelpers.inline_parameters(fixture)

      expect(inline_parameters).to eq('$colour, $legacy')
    end
    it "should return defaults formatted based on their type" do
      fixture = dothash([
        {
          name: "colour",
          type: "String",
          default: "red"
        },
        {
          name: "legacy",
          type: "Boolean",
          default: "false"
        }
      ])
      inline_parameters = SassdocsHelpers.inline_parameters(fixture)

      expect(inline_parameters).to eq('$colour: "red", $legacy: false')
    end
  end
  describe '#parameters_table' do
    it "should return name with a dollar prefix and back ticks surrounding it" do
      fixture = dothash([
        {
          name: "param"
        }
      ])
      parameter = SassdocsHelpers.parameters_table(fixture)

      expect(parameter.first[:name]).to eq('`$param`')
    end
    it "should return description with whitespace and pipes encoded" do
      fixture = dothash([
        {
          name: "param",
          description: "Hello world\n\r Testing | Pipes"
        }
      ])
      parameter = SassdocsHelpers.parameters_table(fixture)

      expect(parameter.first[:description]).to eq('Hello world Testing &#124; Pipes')
    end
    it "should return no data if no description" do
      fixture = dothash([
        {
          name: "param"
        }
      ])
      parameter = SassdocsHelpers.parameters_table(fixture)

      expect(parameter.first[:description]).to eq("<span aria-hidden='true'>—</span>")
    end
    it "should return single type with back ticks surrounding it" do
      fixture = dothash([
        {
          name: "param",
          type: "Boolean"
        }
      ])
      parameter = SassdocsHelpers.parameters_table(fixture)

      expect(parameter.first[:type]).to eq('`Boolean`')
    end
    it "should return multiple types with or and back ticks surrounding it" do
      fixture = dothash([
        {
          name: "param",
          type: "Boolean | String"
        }
      ])
      parameter = SassdocsHelpers.parameters_table(fixture)

      expect(parameter.first[:type]).to eq('`Boolean` or `String`')
    end
    it "should return no data if no type" do
      fixture = dothash([
        {
          name: "param"
        }
      ])
      parameter = SassdocsHelpers.parameters_table(fixture)

      expect(parameter.first[:type]).to eq("<span aria-hidden='true'>—</span>")
    end
    it "should return default value with back ticks surrounding it" do
      fixture = dothash([
        {
          default: "value"
        }
      ])
      parameter = SassdocsHelpers.parameters_table(fixture)

      expect(parameter.first[:default_value]).to eq("`value`")
    end
    it "should return no data if no default" do
      fixture = dothash([
        {
          name: "param"
        }
      ])
      parameter = SassdocsHelpers.parameters_table(fixture)

      expect(parameter.first[:default_value]).to eq("<span aria-hidden='true'>—</span>")
    end
  end
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
