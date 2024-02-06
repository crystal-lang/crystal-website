Jekyll::Hooks.register :documents, :post_convert do |doc|
  timestamp = doc.date.strftime("%Y%m%d%H%M%S")
  doc.content = doc.content.gsub(%r{<del><a href="([^"]*)">(.*)</a></del>}, <<~HTML)
    <del><a href="\\1" title="This link appears to be broken" data-dead-link data-proofer-ignore>\\2</a></del><ins>(<a href="https://web.archive.org/web/#{timestamp}/\\1">archive</a>)</ins>
    HTML
end
