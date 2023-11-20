##
# Middleman extension fixing the menu button in the header
#
# The element is missing a `hidden` attribute, which the extension
# adds using Nokogiri when rendering the `layouts/_header.erb` partial
#
# @see https://middlemanapp.com/advanced/custom-extensions/
class HeaderMenuFixExtension < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    super
    
    # @see https://github.com/middleman/middleman/blob/ad0e0ee9ba5e017e4f3f1cc861f4fa2a4c04f198/middleman-core/lib/middleman-core/extension.rb#L63
    app.after_render do |content, path, locals, renderer|
      # The `after_render` hook will trigger for each renderer (eg. md, erb)
      # and each partial/layout being rendered. We only care about the one
      # containing the menu button, which is `layouts/_header.erb`
      next unless path == 'layouts/_header.erb'
      
      html = Nokogiri::HTML5.fragment(content)
      
      menu_button = html.search('.govuk-header__menu-button').first
      next unless menu_button

      menu_button['hidden'] = ''

      html.serialize
    end
  end
end
