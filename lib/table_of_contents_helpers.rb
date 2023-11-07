##
# Extra helpers for customising the rendering of the table of contents in the sidebar
# so it accomodates a separate table of contents for the `v4` section of the site
module TableOfContentsHelpers
  ##
  # Override `render_page_tree` so it can be bypassed when rendering the children
  # of a specific given page (stored in `@parent_page`) (see `without_child_pages_for` bellow).
  # This enables not rendering the child pages of the `index`, as they'll be rendered
  # individually as well.
  # This is due to the lack of abstraction for the test checking whether to render a resource
  # as a single item or an item the tree of its children
  # See: https://github.com/alphagov/tech-docs-gem/blob/207bcb8593197f3aad8983018ca0a91db7783410/lib/govuk_tech_docs/table_of_contents/helpers.rb#L74
  def render_page_tree(resources, *args)
    return "" if resources == @parent_page&.children

    super(resources, *args)
  end

  ##
  # Temporarily excludes the children of the given page
  # from being rendered by `render_page_tree` while it runs
  # in the block passed to this method
  #
  # @example
  #
  #  without_child_pages_for(a_page) do
  #    render_page_tree(some_pages_including_a_page,...)
  #  end
  def without_child_pages_for(parent_page)
    @parent_page = parent_page

    yield
  ensure
    @parent_page = nil
  end
end
