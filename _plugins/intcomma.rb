module IntComma
  def intcomma(value, delimiter=",")
    begin
      orig = value.to_s
      delimiter = delimiter.to_s
    rescue Exception => e
      puts "#{e.class} #{e}"
      return value
    end

    copy = orig.strip
    copy = orig.gsub(/^(-?\d+)(\d{3})/, "\\1#{delimiter}\\2")
    orig == copy ? copy : intcomma(copy, delimiter)
  end
end

Liquid::Template.register_filter(IntComma)
