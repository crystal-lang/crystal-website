require "http/client"
require "json"

record Sponsor, name : String, url : String?, logo : String?, last_payment : Float64, all_time : Float64, currency : String?, since : Time, overrides : String?, time_last_payment : Time? do
  include JSON::Serializable

  property name : String
  property url : String?
  property logo : String?
  property last_payment : Float64
  property all_time : Float64
  property currency : String?
  @[JSON::Field(converter: Time::Format.new("%b %-d, %Y"))]
  property since : Time
  property overrides : String?
  @[JSON::Field(converter: Time::Format.new("%b %-d, %Y"))]
  property time_last_payment : Time?

  def id : UInt64
    name.hash ^ (url || "").hash
  end

  # Merge this sponsor with the given sponsor. Requires that the name is the same
  def merge(other : Sponsor) : Sponsor
    raise "Can't merge #{self} with #{other}" if name != other.name

    url = merge_url other
    last_payment, time_last_payment = merge_last_payment other
    copy_with(
      url: url,
      last_payment: last_payment,
      time_last_payment: time_last_payment,
      all_time: (all_time - other.all_time).abs < Float64::EPSILON ? all_time : all_time + other.all_time,
      since: Math.min(since, other.since),
    )
  end

  # If any is nil, then the other is used. Otherwise, the most recent one is used.
  def merge_url(other : Sponsor) : String?
    return url if other.url.nil?
    return other.url if url.nil? || since < other.since
    url
  end

  # Returns the last payment and the time of the last payment according to which is the last one
  def merge_last_payment(other : Sponsor) : {Float64, Time?}
    return {last_payment, time_last_payment} if other.time_last_payment.nil?
    return {other.last_payment, other.time_last_payment} if time_last_payment.nil? || time_last_payment.not_nil! < other.time_last_payment.not_nil!
    {last_payment, time_last_payment}
  end
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
      sponsor = sponsor.merge prev_sponsor
      @sponsors.delete_at index
      Log.warn { "WARNING: Duplicate sponsor with name #{sponsor.name}." }
    end

    sponsor.logo = download_logo(sponsor)
    sponsor.url = nil if sponsor.last_payment < SHOW_URL_FROM
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
    return nil if sponsor.last_payment < SHOW_LOGO_FROM

    # resuse logo if one with name exist
    logo_prefix = "sponsors/#{sponsor.name.downcase.gsub(/\W/, "_")}"
    logos_dir = "#{__DIR__}/../assets/"

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
