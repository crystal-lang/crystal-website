require "./sponsors"

module BountySource
  class API
    def initialize(@team : String, @token : String)
      @client = HTTP::Client.new("api.bountysource.com", tls: true)
    end

    def support_levels
      headers = HTTP::Headers{
        "Accept"        => "application/vnd.bountysource+json; version=2",
        "Authorization" => "token #{@token}",
        "User-Agent"    => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36",
        "Referer"       => "https://salt.bountysource.com/teams/crystal-lang/admin/supporters",
        "Origin"        => "https://salt.bountysource.com",
      }
      response = @client.get("/support_levels?supporters_for_team=#{@team}", headers: headers).body
      begin
        Array(SupportLevel).from_json(response)
      rescue ex : JSON::ParseException
        puts "Error trying to parse BountySource JSON Response from /support_levels"
        puts response
        puts headers
        raise ex
      end
    end

    def supporters(page)
      headers = HTTP::Headers{
        "Accept"        => "application/vnd.bountysource+json; version=2",
        "Authorization" => "token #{@token}",
        "User-Agent"    => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36",
        "Referer"       => "https://salt.bountysource.com/teams/crystal-lang/admin/supporters",
        "Origin"        => "https://salt.bountysource.com",
      }
      response = @client.get("/supporters?order=monthly&page=#{page}&per_page=50&team_slug=#{@team}", headers: headers).body
      begin
        Array(Supporters).from_json(response)
      rescue ex : JSON::ParseException
        puts "Error trying to parse BountySource JSON Response from /supporters"
        puts response
        puts headers
        raise ex
      end
    end

    def user(slug)
      headers = HTTP::Headers{
        "Accept"     => "application/vnd.bountysource+json; version=1",
        "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36",
      }
      response = @client.get("/users/#{slug}?access_token=#{@token}", headers: headers).body
      begin
        User.from_json(response)
      rescue ex : JSON::ParseException
        puts "Error trying to parse BountySource JSON Response from /users/#{slug}"
        puts response
        puts headers
        raise ex
      end
    end

    def team(slug)
      headers = HTTP::Headers{
        "Accept"     => "application/vnd.bountysource+json; version=1",
        "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36",
      }
      response = @client.get("/teams/#{slug}?access_token=#{@token}", headers: headers).body
      begin
        Team.from_json(response)
      rescue ex : JSON::ParseException
        puts "Error trying to parse BountySource JSON Response from /teams/#{slug}"
        puts response
        puts headers
        raise ex
      end
    end
  end

  class Supporters
    JSON.mapping({
      type:            {type: String, nilable: true},
      id:              {type: Int64, nilable: true},
      slug:            {type: String, nilable: true},
      display_name:    String,
      image_url_large: String,
      monthly_amount:  Float64,
      alltime_amount:  Float64,
      created_at:      String,
    })

    def_equals_and_hash id
  end

  class SupportLevel
    JSON.mapping({
      id:         Int64,
      amount:     Float64,
      status:     String,
      created_at: {type: Time, converter: Time::Format.new("%FT%T.%LZ")},
      owner:      Owner,
      reward:     {type: Reward, nilable: true},
    })

    class Owner
      JSON.mapping({
        display_name: String,
        slug:         {type: String, nilable: true},
        type:         {type: String, nilable: true},
      })
    end

    class Reward
      JSON.mapping({
        id:          Int64,
        title:       String,
        description: String,
        amount:      Float64,
      })
    end
  end

  class User
    JSON.mapping({
      id:              Int64,
      slug:            String,
      display_name:    String,
      url:             {type: String, nilable: true},
      github_account:  {type: Account, nilable: true},
      twitter_account: {type: Account, nilable: true},
    })

    class Account
      JSON.mapping({
        display_name: String,
      })
    end
  end

  class Team
    JSON.mapping({
      id:   Int64,
      slug: String,
      name: String,
      url:  {type: String, nilable: true},
    })
  end
end

module GitHub
  class API
    def initialize
      @client = HTTP::Client.new("api.github.com", tls: true)
    end

    def user(username)
      response = @client.get("/users/#{username}").body
      begin
        User.from_json(response)
      rescue ex : JSON::ParseException
        puts "Error trying to parse GitHub JSON Response from /users/#{username}"
        puts response
        raise ex
      end
    end

    class User
      JSON.mapping({
        name: {type: String, nilable: true},
        blog: {type: String, nilable: true},
      })
    end
  end
end

token = ARGV[0]?
unless token
  puts <<-USAGE
  Usage: bountysource <token>

  To find out your <token> check the Network traffic in a browser when hitting
  BountySource and look for an Authorization header or access_token parameter
  in JSON requests.
  USAGE
  exit
end

team = "crystal-lang"
bountysource = BountySource::API.new(team, token)

github = GitHub::API.new

# paginate sponsors until repeat of empty page.
supporters = [] of BountySource::Supporters
page_index = 1
while (page = bountysource.supporters(page_index)) &&
      (new_supporters = page.select { |s| !supporters.includes?(s) }) &&
      new_supporters.size > 0
  supporters.concat(new_supporters)
  page_index += 1
end

support_levels = bountysource.support_levels
support_levels.select! { |s| s.status == "active" && s.owner.display_name != "Anonymous" }
support_levels.sort_by! &.amount

sponsors = SponsorsBuilder.new

support_levels.each do |support_level|
  name = nil
  url = nil
  if slug = support_level.owner.slug
    case support_level.owner.type
    when "Person"
      name = support_level.owner.display_name
      user = bountysource.user(slug)
      url = user.url.presence
      unless url
        if (github_account = user.github_account)
          github_user = github.user(github_account.display_name)
          name = github_user.name || name
          url = github_user.blog || "https://github.com/#{github_account.display_name}"
        elsif (twitter_account = user.twitter_account)
          url = "http://twitter.com/#{twitter_account.display_name}"
        end
      end
    when "Team"
      team = bountysource.team(slug)
      url = team.url.presence
      name = team.name
    else
      raise "unhandled owner type for #{support_level.owner}"
    end
  end

  if url && !url.blank? && !(url.starts_with?("http://") || url.starts_with?("https://"))
    url = "http://#{url}"
  end

  amount = support_level.amount
  url ||= ""

  raise "unable to determine name for #{support_level.owner}" unless name

  supporter = supporters.find { |s| s.display_name == support_level.owner.display_name }
  raise "unable to match: #{support_level.owner.display_name} in supporters" unless supporter

  logo = supporter.image_url_large
  all_time = supporter.alltime_amount
  since = Time.parse(supporter.created_at[0..10], "%F", location: Time::Location::UTC)

  sponsors.add Sponsor.new(name, url, logo, amount, all_time, nil, since)
end

File.open("#{__DIR__}/../_data/bountysource.json", "w") do |file|
  sponsors.save(file)
end
