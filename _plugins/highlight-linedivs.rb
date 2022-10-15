require "rouge"

module Rouge
  module Formatters
    # Transforms a token stream into HTML output.
    class HTMLLegacy < Formatter
      tag 'html_legacy'

      # @option opts [String] :css_class ('highlight')
      # @option opts [true/false] :line_numbers (false)
      # @option opts [true/false] :linewise (false)
      # @option opts [RougeLines::CSSTheme] :inline_theme (nil)
      # @option opts [true/false] :wrap (true)
      #
      # Initialize with options.
      #
      # If `:inline_theme` is given, then instead of rendering the
      # tokens as <span> tags with CSS classes, the styles according to
      # the given theme will be inlined in "style" attributes.  This is
      # useful for formats in which stylesheets are not available.
      #
      # Content will be wrapped in a tag (`div` if tableized, `pre` if
      # not) with the given `:css_class` unless `:wrap` is set to `false`.
      def initialize(opts={})
        @formatter = opts[:inline_theme] ? HTMLInline.new(opts[:inline_theme])
                     : HTML.new

        @formatter = HTMLLinewise.new(@formatter, opts) if opts[:linewise]

        @formatter = HTMLTable.new(@formatter, opts) if opts[:line_numbers]

        if opts.fetch(:wrap, true)
          @formatter = HTMLPygments.new(@formatter, opts.fetch(:css_class, 'codehilite'))
        end
      end
    end
  end
end

module Jekyll
  module Tags
    class HighlightBlock < Liquid::Block
      include Liquid::StandardFilters

      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
          @lang = Regexp.last_match(1).downcase
          @highlight_options = parse_options(Regexp.last_match(2))
        else
          raise SyntaxError, <<-MSG
Syntax Error in tag 'highlight' while parsing the following markup:

  #{markup}

Valid syntax: highlight <lang> [linenos] [linedivs]
MSG
        end
      end

      def render(context)
        prefix = context["highlighter_prefix"] || ""
        suffix = context["highlighter_suffix"] || ""
        code = super.to_s.gsub(%r!\A(\n|\r)+|(\n|\r)+\z!, "")

        is_safe = !!context.registers[:site].safe

        output =
          case context.registers[:site].highlighter
          when "pygments"
            render_pygments(code, is_safe)
          when "rouge"
            render_rouge(code)
          else
            render_codehighlighter(code)
          end

        rendered_output = add_code_tag(output)
        prefix + rendered_output + suffix
      end

      def sanitized_opts(opts, is_safe)
        if is_safe
          Hash[[
                 [:startinline, opts.fetch(:startinline, nil)],
                 [:hl_lines,    opts.fetch(:hl_lines, nil)],
                 [:linenos,     opts.fetch(:linenos, nil)],
                 [:linedivs,    opts.fetch(:linedivs, nil)],
                 [:encoding,    opts.fetch(:encoding, "utf-8")],
                 [:cssclass,    opts.fetch(:cssclass, nil)],
               ].reject { |f| f.last.nil? }]
        else
          opts
        end
      end

      private

      OPTIONS_REGEX = %r!(?:\w="[^"]*"|\w=\w|\w)+!

      def parse_options(input)
        options = {}
        return options if input.empty?

        # Split along 3 possible forms -- key="<quoted list>", key=value, or key
        input.scan(OPTIONS_REGEX) do |opt|
          key, value = opt.split("=")
          # If a quoted list, convert to array
          if value && value.include?('"')
            value.delete!('"')
            value = value.split
          end
          options[key.to_sym] = value || true
        end

        options[:linenos] = "inline" if options[:linenos] == true
        options
      end

      def render_rouge(code)
        formatter = ::Rouge::Formatters::HTMLLegacy.new(
          :line_numbers => @highlight_options[:linenos],
          :linewise     => @highlight_options[:linedivs],
          :wrap         => false,
          :css_class    => "highlight",
          :gutter_class => "gutter",
          :code_class   => "code"
        )
        lexer = ::Rouge::Lexer.find_fancy(@lang, code) || Rouge::Lexers::PlainText
        formatter.format(lexer.lex(code))
      end
    end
  end
end

Liquid::Template.register_tag("highlight", Jekyll::Tags::HighlightBlock)
