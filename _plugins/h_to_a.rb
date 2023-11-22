require 'jekyll'

module Jekyll
  module HToA
    def h_to_a(input, key = "id")
      input.map do |k, v|
        (v || {}).merge({
          key => k
        })
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::HToA)
