module PageFragments
  module PageFragmentHelper
    def render_page_fragment *keys
      pf = keys.first.is_a?(PageFragments::PageFragment) ? keys.first : PageFragments::PageFragment.get(keys.flatten)
      pf && pf.content.to_s.html_safe
    end
  end
end