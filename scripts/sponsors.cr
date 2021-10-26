require "http/client"
require "json"

record Sponsor, name : String, url : String?, logo : String?, this_month : Float64, all_time : Float64, currency : String?, since : Time, overrides : String? do
  include JSON::Serializable

  property name : String
  property url : String?
  property logo : String?
  property this_month : Float64
  property all_time : Float64
  property currency : String?
  @[JSON::Field(converter: Time::Format.new("%b %-d, %Y"))]
  property since : Time
  property overrides : String?
end

class SponsorsBuilder
  SHOW_LOGO_FROM = 75
  SHOW_URL_FROM  =  5

  def initialize
    @sponsors = [] of Sponsor
  end

  def add(sponsor : Sponsor)
    if index = @sponsors.index { |s| s.name == sponsor.name }
      prev_sponsor = @sponsors[index]
      # We merge them if any of the two doesn't have url, or the url is the same
      if prev_sponsor.url.nil? || sponsor.url.nil? || prev_sponsor.url == sponsor.url
        sponsor.all_time += prev_sponsor.all_time
        @sponsors.delete_at index
        puts "WARNING: Merging duplicate sponsor with name #{sponsor.name}."
      else
        puts "WARNING: Duplicate sponsor with name #{sponsor.name}."
      end
    end

    sponsor.logo = download_logo(sponsor)
    sponsor.url = nil if sponsor.this_month < SHOW_URL_FROM
    @sponsors << sponsor
  end

  def save(io : IO)
    @sponsors.sort_by!(&.since).reverse!

    JSON.build(io, indent: 2) do |json|
      @sponsors.to_json(json)
    end
  end

  private def download_logo(sponsor)
    logo = sponsor.logo
    return nil unless logo
    return nil if logo.blank?

    # skip logo if below threshold
    return nil if sponsor.this_month < SHOW_LOGO_FROM

    # resuse logo if one with name exist
    logo_prefix = "sponsors/#{sponsor.name.downcase.gsub(/\W/, "_")}"
    logos_dir = "#{__DIR__}/../_assets/img/"

    Dir["#{logos_dir}#{logo_prefix}.*"].each do |match|
      return "#{logo_prefix}#{File.extname(match)}"
    end

    # download logo and keep extension from the content_type
    HTTP::Client.get(logo) do |request|
      puts "Downloading #{sponsor.name} logo: #{logo}"

      ext = case request.content_type
            when "image/jpeg"
              "jpg"
            when "image/png"
              "png"
            when "image/svg+xml"
              "svg"
            else
              puts "  WARNING: not implemented image type #{request.content_type}"
              return nil
            end

      sponsor_logo = "#{logo_prefix}.#{ext}"
      File.open("#{logos_dir}#{sponsor_logo}", "w") do |f|
        IO.copy request.body_io, f
      end
      return sponsor_logo
    end
  end
end
