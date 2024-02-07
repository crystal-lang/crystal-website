Jekyll::Hooks.register :documents, :post_convert do |doc|
  timestamp = doc.date.strftime("%Y%m%d%H%M%S")
  doc.content = doc.content.gsub(%r{<del><a href="([^"]*)">(.*)</a></del>}, <<~HTML)
    <a href="https://web.archive.org/web/#{timestamp}/\\1" title="This link leads to an archived version of the target page which appears to be no longer available" data-dead-link>\\2</a>
    HTML
end
