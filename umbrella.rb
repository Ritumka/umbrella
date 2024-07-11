pp "Where are you located?"
user_location = gets.chomp
puts "Checking the weather at " + user_location + "..."

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location.gsub(" ", "%20") + "&key=" + ENV.fetch("GMAPS_KEY")

require "http"

resp = HTTP.get(maps_url)

raw_response = resp.to_s

require "json"

parsed_response = JSON.parse(raw_response)

results = parsed_response.fetch("results")

first_result = results.at(0)

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

puts "Your coordinates are " + latitude.to_s + ", " + longitude.to_s

pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

pp pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_api_key + "/" + latitude.to_s + "," + longitude.to_s

raw_response_weather = HTTP.get(pirate_weather_url)

parsed_response_weather = JSON.parse(raw_response_weather)

currently_hash = parsed_response_weather.fetch("currently")

current_temp = currently_hash.fetch("temperature")
current_summary = currently_hash.fetch("summary")

puts "It is currently " + current_temp.to_s + "."
puts "Next hour: " + current_summary.to_s + "."
