require "csv"
require "./sponsors"

LEVELS = [5000, 2000, 1000, 500, 250, 150, 75, 25, 10, 5, 1]

def level(sponsor : Sponsor)
  LEVELS.find { |amount| amount <= sponsor.this_month.to_i }.not_nil!
end

all_sponsors = Array(Sponsor).new

%w(opencollective.json bountysource.json others.json).each do |filename|
  File.open("#{__DIR__}/../_data/#{filename}") do |file|
    all_sponsors.concat Array(Sponsor).from_json(file)
  end
end

all_sponsors.sort_by! { |s| {-level(s), -s.all_time, s.since, s.name} }

File.open("#{__DIR__}/../_data/sponsors.csv", "w") do |file|
  CSV.build(file) do |csv|
    csv.row "logo", "name", "url", "this_month", "all_time", "since", "level"

    all_sponsors.each do |sponsor|
      currency = sponsor.currency || "$"

      csv.row sponsor.logo,
        sponsor.name,
        sponsor.url,
        "#{currency}#{sponsor.this_month.to_i}",
        "#{currency}#{sponsor.all_time.to_i}",
        sponsor.since.to_s("%b %-d, %Y"),
        level(sponsor)
    end
  end
end
