require "csv"
require "http/client"

# Syncs the sponsors data from crystal-sponsors:
#
#   1. downloads CSVs,
#   2. downloads every remote logo into assets/sponsors/ (reusing files that
#      are already there),
#   3. rewrites the `logo` column to the local path (`sponsors/<name>.<ext>`).
#
# Environment:
#   SPONSORS_REF       crystal-sponsors branch, tag or commit (default: master)
#   SPONSORS_DATA_URL  overrides the whole base URL (for testing)


SPONSORS_REF      = ENV["SPONSORS_REF"]?.presence || "master"
SPONSORS_DATA_URL = ENV["SPONSORS_DATA_URL"]?.presence ||
                    "https://raw.githubusercontent.com/crystal-lang/crystal-sponsors/#{SPONSORS_REF}/_data"

CSVS       = %w(sponsors sponsor_logos_corporate sponsor_logos_gold sponsor_logos_silver)
DATA_DIR   = "_data"
LOGOS_DIR  = "assets/sponsors"
LOGO_PATH  = "sponsors" # prefix of the `logo` column, relative to assets/
MAX_BYTES  = 1_000_000
MAX_REDIRS = 5

LOGO_COLUMN = 0
NAME_COLUMN = 1

# Returns the body of `url`, following redirects. Raises on any HTTP error or
# when the body is larger than MAX_BYTES.
def fetch(url : String, redirects = MAX_REDIRS) : Bytes
  HTTP::Client.get(url, headers: HTTP::Headers{"User-Agent" => "crystal-website-sync-sponsors"}) do |response|
    case response.status_code
    when 200
      io = IO::Memory.new
      IO.copy(response.body_io, io, MAX_BYTES + 1)
      raise "#{url} is larger than #{MAX_BYTES} bytes" if io.size > MAX_BYTES
      return io.to_slice
    when 301, 302, 303, 307, 308
      raise "Too many redirects fetching #{url}" if redirects == 0
      location = response.headers["Location"]? || raise "Redirect without Location from #{url}"
      return fetch(URI.parse(url).resolve(location).to_s, redirects - 1)
    else
      raise "Fetching #{url} failed with HTTP #{response.status_code}"
    end
  end
end

# The file type is decided by the first bytes of the file
def image_extension(data : Bytes) : String?
  return "png" if data.size >= 8 && data[0, 8] == Bytes[0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
  return "jpg" if data.size >= 3 && data[0, 3] == Bytes[0xFF, 0xD8, 0xFF]
  return "webp" if data.size >= 12 && String.new(data[0, 4]) == "RIFF" && String.new(data[8, 4]) == "WEBP"

  # SVG is text: look for an <svg element in the beginning of the file.
  head = String.new(data[0, Math.min(data.size, 1024)])
  "svg" if head.valid_encoding? && head.includes?("<svg")
end

def slug(name : String) : String
  name.downcase.gsub(/\W/, "_")
end

def local_logo(name : String, url : String) : String
  base = slug(name)

  if existing = Dir.glob("#{LOGOS_DIR}/#{base}.*").first?
    return "#{LOGO_PATH}/#{File.basename(existing)}"
  end

  data = fetch(url)
  extension = image_extension(data) || raise "Logo of '#{name}' (#{url}) is not a PNG, JPEG, WebP or SVG image"
  filename = "#{base}.#{extension}"
  File.write(File.join(LOGOS_DIR, filename), data)
  STDERR.puts "Downloaded logo for '#{name}' as #{filename}"
  "#{LOGO_PATH}/#{filename}"
end

Dir.mkdir_p(DATA_DIR)
Dir.mkdir_p(LOGOS_DIR)

# Several rows (and files) can point at the same logo.
resolved = Hash(String, String).new

CSVS.each do |csv_name|
  rows = CSV.parse(String.new(fetch("#{SPONSORS_DATA_URL}/#{csv_name}.csv")))

  rows.each_with_index do |row, index|
    next if index == 0

    logo = row[LOGO_COLUMN]
    next unless logo.starts_with?(%r{https?://})

    row[LOGO_COLUMN] = resolved[logo] ||= local_logo(row[NAME_COLUMN], logo)
  end

  File.open(File.join(DATA_DIR, "#{csv_name}.csv"), "w") do |file|
    CSV.build(file) do |csv|
      rows.each { |row| csv.row row }
    end
  end
end
