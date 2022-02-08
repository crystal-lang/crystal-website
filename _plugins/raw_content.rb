module Jekyll
  class RawContent < Generator
    def generate(site)
      site.collections.each do |_, collection|
        collection.docs.each do |post|
          post.data['raw_content'] = post.content
        end
      end
    end
  end
end
