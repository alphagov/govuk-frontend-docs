require 'json'
require 'ostruct'
require 'active_support/all'

require_relative '../sassdocs_helpers.rb'

# Middleman helpers convert data to allow dot access, so we need to bring in data in a similar way.
def dothash(hash)
  JSON.parse(hash.to_json, object_class: OpenStruct)
end

RSpec.describe SassdocsHelpers do
  before(:each) do
    allow(File).to receive(:read).and_return('{ "dependencies": { "govuk-frontend": { "version": "1.0.0" } } }')
    # Include mixin into a test class to allow us to mock File
    class Test
      include SassdocsHelpers
    end
    @helper = Test.new
  end

  describe '#format_sassdoc_data' do
    it "should raise an error if there is no data" do
      expect {
        fixture = dothash({})
        @helper.format_sassdoc_data(fixture)
      }.to raise_error("No data in data/sassdocs.json, run `npm install` to generate.")
    end
    it "should remove private entries" do
      fixture = dothash({
        sassdoc: [
          {
            access: "public",
            group: [ "public" ],
            file: {
              path: "public.scss"
            }
          },
          {
            access: "private",
            group: [ "private" ],
            file: {
              path: "private.scss"
            }
          }
        ]
      })
      groups = @helper.format_sassdoc_data(fixture)
      first_group = groups.first
      group_heading = first_group.first
      expect(groups.length).to eq(1)
      expect(group_heading).to eq("public")
    end
    it "should remove vendored entries" do
      fixture = dothash({
        sassdoc: [
          {
            access: "public",
            group: [ "public" ],
            file: {
              path: "public.scss"
            }
          },
          {
            access: "public",
            group: [ "vendored" ],
            file: {
              path: "vendored.scss"
            }
          }
        ]
      })
      groups = @helper.format_sassdoc_data(fixture)
      first_group = groups.first
      group_heading = first_group.first
      expect(groups.length).to eq(1)
      expect(group_heading).to eq("public")
    end
    it "should group entries by their group" do
      fixture = dothash({
        sassdoc: [
          {
            access: "public",
            group: [ "mixins" ],
            file: {
              path: "first.scss"
            }
          },
          {
            access: "public",
            group: [ "mixins" ],
            file: {
              path: "second.scss"
            }
          },
          {
            access: "public",
            group: [ "helpers" ],
            file: {
              path: "third.scss"
            }
          }
        ]
      })
      groups = @helper.format_sassdoc_data(fixture)
      expect(groups['mixins'].length).to eq(2)
      expect(groups['mixins'].first.file.path).to eq('first.scss')
      expect(groups['mixins'].second.file.path).to eq('second.scss')

      expect(groups['helpers'].length).to eq(1)
      expect(groups['helpers'].first.file.path).to eq('third.scss')
    end
  end
  describe '#mixin_trailing_code' do
    it "should return trailing semi-colon by default" do
      trailing = @helper.mixin_trailing_code(".test { color: red; }")

      expect(trailing).to eq(';')
    end
    it "should return block syntax if mixin accepts content" do
      trailing = @helper.mixin_trailing_code("@if true { @content; }")

      expect(trailing).to eq(" {\n  //..\n}")
    end
  end
  describe '#inline_parameters' do
    it "should return single name with a dollar prefix" do
      fixture = dothash([
        {
          name: "colour"
        }
      ])
      inline_parameters = @helper.inline_parameters(fixture)

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
      inline_parameters = @helper.inline_parameters(fixture)

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
      inline_parameters = @helper.inline_parameters(fixture)

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
      parameter = @helper.parameters_table(fixture)

      expect(parameter.first[:name]).to eq('`$param`')
    end
    it "should return description with whitespace and pipes encoded" do
      fixture = dothash([
        {
          name: "param",
          description: "Hello world\n\r Testing | Pipes"
        }
      ])
      parameter = @helper.parameters_table(fixture)

      expect(parameter.first[:description]).to eq('Hello world Testing &#124; Pipes')
    end
    it "should return no data if no description" do
      fixture = dothash([
        {
          name: "param"
        }
      ])
      parameter = @helper.parameters_table(fixture)

      expect(parameter.first[:description]).to eq("<span aria-hidden='true'>—</span>")
    end
    it "should return single type with back ticks surrounding it" do
      fixture = dothash([
        {
          name: "param",
          type: "Boolean"
        }
      ])
      parameter = @helper.parameters_table(fixture)

      expect(parameter.first[:type]).to eq('`Boolean`')
    end
    it "should return multiple types with or and back ticks surrounding it" do
      fixture = dothash([
        {
          name: "param",
          type: "Boolean | String"
        }
      ])
      parameter = @helper.parameters_table(fixture)

      expect(parameter.first[:type]).to eq('`Boolean` or `String`')
    end
    it "should return no data if no type" do
      fixture = dothash([
        {
          name: "param"
        }
      ])
      parameter = @helper.parameters_table(fixture)

      expect(parameter.first[:type]).to eq("<span aria-hidden='true'>—</span>")
    end
    it "should return default value with back ticks surrounding it" do
      fixture = dothash([
        {
          default: "value"
        }
      ])
      parameter = @helper.parameters_table(fixture)

      expect(parameter.first[:default_value]).to eq("`value`")
    end
    it "should return no data if no default" do
      fixture = dothash([
        {
          name: "param"
        }
      ])
      parameter = @helper.parameters_table(fixture)

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
      heading = @helper.doc_heading(fixture)

      expect(heading).to eq('$govuk-assets-path')
    end
    it "should heading if not variable" do
      fixture = dothash({
        context: {
          type: 'function',
          name: 'govuk-colour'
        }
      })
      heading = @helper.doc_heading(fixture)

      expect(heading).to eq('govuk-colour')
    end
  end
  describe '#group_heading' do
    it "should return General if undefined" do
      heading = @helper.group_heading('undefined')

      expect(heading).to eq('General')
    end
    it "should format heading to titlecase" do
      heading = @helper.group_heading('helpers')

      expect(heading).to eq('Helpers')
    end
    it "should format heading with forwards slashes to titlecase" do
      heading = @helper.group_heading('settings/colours')

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
      url = @helper.github_url(fixture)

      expect(url).to eq('https://github.com/alphagov/govuk-frontend/tree/v1.0.0/src/govuk/helpers/_clearfix.scss#L9-L15')
    end
  end
  describe '#govuk_frontend_version' do
    it "should return version" do
      version = @helper.govuk_frontend_version

      expect(version).to eq('1.0.0')
    end
  end
end
