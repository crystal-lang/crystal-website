# https://github.com/albrow/liquid_time_ago_in_words
module Jekyll
  module TimeFilter
		def time_ago_in_words(input)
			one_minute = 60
			one_hour = 60 * one_minute
			one_day = 24 * one_hour
			one_week = 7 * one_day
			one_month = one_day * 3652425 / 120000
			one_year = one_day * 3652425 / 10000

			return "" if input.nil?

			words = ""

			unless (input.is_a? Date) || (input.is_a? Time)
				raise "Can't convert that to a Time!"
			end

			now = Time.now
			seconds_ago = now - input

			if seconds_ago < 0
				words = "in the future"

			elsif seconds_ago < 10
				words = "just now"

			elsif seconds_ago < one_minute
				words = seconds_ago.round.to_s + " seconds ago"


			elsif seconds_ago < 2 * one_minute
				words = "about a minute ago"

			elsif seconds_ago < one_hour
				words = (seconds_ago/one_minute).round.to_s + " minutes ago"


			elsif seconds_ago < 2 * one_hour
				words = "about an hour ago"

			elsif seconds_ago < one_day
				words = (seconds_ago/one_hour).round.to_s + " hours ago"


			elsif seconds_ago < 2 * one_day
				words = "about a day ago"

			elsif seconds_ago < one_week
				words = (seconds_ago/one_day).round.to_s + " days ago"


			elsif seconds_ago < 2 * one_week
				words = "about a week ago"

			elsif seconds_ago < one_month
				words = (seconds_ago/one_week).round.to_s + " weeks ago"


			elsif seconds_ago < 2 * one_month
				words = "about a month ago"

			elsif seconds_ago < one_year
				words = (seconds_ago/one_month).round.to_s + " months ago"


			elsif seconds_ago < 2 * one_year
				words = "about a year ago"
			else
				words = (seconds_ago/one_year).round.to_s + " years ago"
			end

			# # a javascript call to update the time ago client-side
			# script = "<script>
			# 					document.addEventListener('DOMContentLoaded',function(){
			# 						if (typeof(update_time_ago) == typeof(Function)) {
			# 							update_time_ago(#{input.tv_sec});
			# 						}
			# 					});
			# 					</script>"
      #
			# output = "<span class='time-ago' id='#{input.tv_sec}' data-seconds='#{input.tv_sec}'>
			# 					#{words}
			# 					</span>
			# 					#{script}"

			return words
		end
	end
end

Liquid::Template.register_filter(Jekyll::TimeFilter)
