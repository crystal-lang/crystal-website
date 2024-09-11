require "csv"
require "log"
require "./sponsors"

LEVELS = [5000, 2000, 750, 350, 75, 25, 10, 5, 1, 0]

def level(sponsor : Sponsor)
  level = LEVELS.find { |amount| amount <= sponsor.last_payment.to_i }
  return level if level

  # Refunds appear as negative payments. Unfortunately the level is lost.
  Log.warn { "Can't find level for '#{sponsor.name}' paying '#{sponsor.last_payment}'" }
  0
end

all_sponsors_map = Hash(UInt64, Sponsor).new
overrides = Array(Sponsor).new

update_other_sponsor_totals = ENV["UPDATE_OTHER_SPONSOR_TOTALS"]? == "1" || Time.utc.day == 1 # only do this on the first day of the month

SPONSOR_DATA = begin
  csv = CSV.new(File.read("#{__DIR__}/../_data/sponsors.csv"), headers: true)
  hash = Hash(UInt64, Int32).new
  csv.each do |row|
    hash[Sponsor.id(row["name"], row["url"])] = row["all_time"].lchop("$").lchop("€").gsub(",", nil).to_i
  end
  hash
end

%w(opencollective.json bountysource.json others.json).each do |filename|
  File.open("#{__DIR__}/../_data/#{filename}") do |file|
    sponsors = Array(Sponsor).from_json(file)

    if filename == "others.json"
      sponsors, overrides = sponsors.partition(&.overrides.nil?)
      if update_other_sponsor_totals
        sponsors.map! do |sponsor|
          prev_value = SPONSOR_DATA[sponsor.id]?
          if !prev_value
            Log.warn { "Can't find sponsor '#{sponsor.name}' in sponsors.csv" }
            prev_value = 0
          end
          sponsor.all_time = prev_value + sponsor.last_payment
          sponsor
        end
      end
    end

    sponsors.each do |sponsor|
      prev_sponsor = all_sponsors_map[sponsor.id]?
      all_sponsors_map[sponsor.id] = prev_sponsor ? sponsor.merge(prev_sponsor) : sponsor
    end
  end
end

all_sponsors = all_sponsors_map.values # select all sponsors now that they've been merged

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

all_sponsors.sort_by! { |s| {-s.last_payment, -s.all_time, s.since, s.name} }

write_csv("sponsors.csv", all_sponsors.select(&.listed?))
write_csv("sponsor_logos_l.csv", all_sponsors.select { |sponsor| sponsor.last_payment.to_i >= 750 })
# NOTE: It should be 350, but we kept 250 to include PlaceOS
write_csv("sponsor_logos_s.csv", all_sponsors.select { |sponsor| sponsor.last_payment.to_i.in?(250...750) })

def write_csv(filename, sponsors)
  open_csv(filename) do |csv|
    csv.row "logo", "name", "url", "last_payment", "all_time", "since", "level"

    sponsors.each do |sponsor|
      currency = sponsor.currency || "$"

      last_payment = sponsor.last_payment.to_i

      csv.row sponsor.logo,
        sponsor.name,
        sponsor.url,
        "#{currency}#{last_payment.clamp(0..).format}",
        "#{currency}#{sponsor.all_time.to_i.format}",
        sponsor.since.to_s("%b %-d, %Y"),
        level(sponsor)
    end
  end
end

def open_csv(filename, datadir = Path[__DIR__, "..", "_data"])
  File.open(datadir.join(filename), "w") do |file|
    CSV.build(file) do |csv|
      yield csv
    end
  end
end
