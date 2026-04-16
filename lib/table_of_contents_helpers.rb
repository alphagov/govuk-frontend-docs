##
# Extra helpers for customising the rendering of the table of contents in the sidebar
# so it accomodates a separate table of contents for the `v4` section of the site
module TableOfContentsHelpers
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

  ##
  # Forces a page configured hidden from the navigation with
  # `hide_in_navigation: true` to be rendered in the navigation when
  # `render_page_tree` runs in the block this method receives
  #
  # @example
  #
  #  with_page_in_navigation(a_page) do
  #    render_page_tree(some_pages_including_a_page,...)
  #  end
  def with_page_in_navigation(page)
    original = page.data.hide_in_navigation
    page.data.hide_in_navigation = false

    yield
  ensure
    page.data.hide_in_navigation = original
  end
end
