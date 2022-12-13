module Jekyll
  class CalloutsConverter < Jekyll::Generator
    priority :low

    def initialize(config)
      callout_names = config["callouts"]
      if callout_names && !callout_names.empty?
        @regex = /(^ {0,3}>\s*)\*\*(#{callout_names.join("|") {|n| Regexp.escape(n)}}):\*\*((?:[\t ]+[^\n]*)?)(\n(?:^ {0,3}>[^\n]*)*)/m
      else
        @regex = nil
      end
    end

    def generate(site)
      return unless @regex
      @site = site
      site.collections.each do |_, collection|
        collection.docs.each do |post|
          convert_callouts(post) if post.extname == '.md'
        end
      end
    end

    private

    FOLLOW_LINE_REGEX = /\n {0,3}>/

    def convert_callouts(post)
      post.content = post.content.gsub(@regex) {
        match = $~
        render_include(match[2], match[3].lstrip, match[4].gsub(FOLLOW_LINE_REGEX, "\n").lstrip)
      }
    end

    def render_markdown(source)
      @site.find_converter_instance(
        Jekyll::Converters::Markdown
      ).convert(source)
    end

    DEFAULT_INCLUDE_PATH = "callout.html"

    def render_include(callout, title, content)
      template = callout.downcase
      template.tr!("- ", "__")
      file = "callouts/#{template}.html"

      unless locate_include_file(file)
        file = DEFAULT_INCLUDE_PATH
      end

      %({% include #{file} callout="#{template}" title=#{title.inspect} content=#{content.inspect} %})
    end

    def locate_include_file(file)
      @site.includes_load_paths.each do |dir|
        path = Jekyll::PathManager.join(dir, file)
        return path if File.file?(path)
      end
      nil
    end
  end
end
