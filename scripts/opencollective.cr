require "./sponsors"

module OpenCollective
  class API
    def initialize(@team : String)
      @client = HTTP::Client.new("opencollective.com", tls: true)
    end

    def members
      response = @client.get("/#{@team}/members/all.json").body

      begin
        # JSON.parse(response)
        Array(Member).from_json(response)
      rescue ex : JSON::ParseException
        puts "Error trying to parse OpenCollective JSON Response from /#{@team}/members/all.json"
        puts response
        raise ex
      end
    end
  end

  class Member
    include JSON::Serializable

    property name : String
    property type : String
    property role : String
    property isActive : Bool
    property totalAmountDonated : Float64
    property lastTransactionAmount : Float64
    property twitter : String?
    property github : String?
    property website : String?
    property image : String?

    @[JSON::Field(converter: Time::Format.new("%Y-%m-%d %H:%M"))]
    property createdAt : Time

    @[JSON::Field(converter: Time::Format.new("%Y-%m-%d %H:%M"))]
    property lastTransactionAt : Time
  end
end

team = "crystal-lang"
opencollective = OpenCollective::API.new(team)
sponsors = SponsorsBuilder.new

dateOfGrace = Time.utc - 3.months
opencollective.members.each do |member|
  next unless member.role == "BACKER"

  next if member.totalAmountDonated == 0 # The only ones I see with 0 are not BACKERs, but just in case

  downcase_name = member.name.downcase
  next if downcase_name == "incognito" || downcase_name == "guest"

  url = member.website || member.twitter || member.github
  logo = member.image

  # We consider a member as not paying anything if it's inactive or it haven't sponsored in the last 3 months
  if member.isActive && member.lastTransactionAt > dateOfGrace
    amount = member.lastTransactionAmount
  else
    amount = 0.0
  end

  all_time = member.totalAmountDonated
  sponsors.add Sponsor.new(member.name, url, logo, amount, all_time, nil, member.createdAt, nil)
end

File.open("#{__DIR__}/../_data/opencollective.json", "w") do |file|
  sponsors.save(file)
end
