require "csv"
require "log"
require "./sponsors"

LEVELS = [5000, 2000, 1000, 500, 250, 150, 75, 25, 10, 5, 1, 0]

def level(sponsor : Sponsor)
  LEVELS.find { |amount| amount <= sponsor.last_payment.to_i }.not_nil!
end

all_sponsors = Array(Sponsor).new
overrides = Array(Sponsor).new

%w(opencollective.json bountysource.json others.json).each do |filename|
  File.open("#{__DIR__}/../_data/#{filename}") do |file|
    sponsors = Array(Sponsor).from_json(file)
    sponsors, overrides = sponsors.partition(&.overrides.nil?) if filename == "others.json"
    all_sponsors.concat sponsors
  end
end

overrides.each do |sponsor|
  name_to_override = sponsor.overrides.not_nil!
  if index = all_sponsors.index { |s| s.name == name_to_override }
    to_override = all_sponsors[index]
    to_override.name = sponsor.name # name is mandatory
    to_override.url = sponsor.url if sponsor.url
    to_override.logo = sponsor.logo if sponsor.logo
    to_override.last_payment = sponsor.last_payment if sponsor.last_payment > 0
    to_override.all_time += sponsor.all_time if sponsor.all_time > 0
    to_override.currency = sponsor.currency if sponsor.currency
    to_override.since = sponsor.since if sponsor.since < to_override.since
    all_sponsors[index] = to_override
  else
    Log.warn { "Can't find a sponsor named '#{name_to_override}'" }
  end
end

all_sponsors.sort_by! { |s| {-level(s), -s.all_time, s.since, s.name} }

File.open("#{__DIR__}/../_data/sponsors.csv", "w") do |file|
  CSV.build(file) do |csv|
    csv.row "logo", "name", "url", "last_payment", "all_time", "since", "level"

    all_sponsors.each do |sponsor|
      currency = sponsor.currency || "$"

      csv.row sponsor.logo,
        sponsor.name,
        sponsor.url,
        "#{currency}#{sponsor.last_payment.to_i}",
        "#{currency}#{sponsor.all_time.to_i}",
        sponsor.since.to_s("%b %-d, %Y"),
        level(sponsor)
    end
  end
end
