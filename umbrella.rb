# Write your soltuion here!
require "http"
require "json"
require "dotenv/load"

puts "Where are you?"
user_location = gets.chomp

puts "Checking the weather at " + user_location.to_s + "...."

gmaps_api_key = ENV.fetch("GMAPS_KEY")

# Assemble the full URL string by adding the first part, the API token, and the last part together
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location.gsub(" ", "%20") + "&key=" + gmaps_api_key

# Place a GET request to the URL
raw_gmaps_response = HTTP.get(gmaps_url)
parsed_gmaps_response = JSON.parse(raw_gmaps_response)
results_hash = parsed_gmaps_response.fetch("results")
first_result = results_hash.at(0)
geometry_hash = first_result.fetch("geometry")
location_hash = geometry_hash.fetch("location")
lat = location_hash.fetch("lat")
lng = location_hash.fetch("lng")

puts "Your coordinates are " + lat.to_s + ", " + lng.to_s + "."

# Hidden variables
pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_api_key + "/" + lat.to_s + "," + lng.to_s

# Place a GET request to the URL
raw_response = HTTP.get(pirate_weather_url)
parsed_response = JSON.parse(raw_response)

currently_hash = parsed_response.fetch("currently")
current_temp = currently_hash.fetch("temperature")

hourly_hash = parsed_response.fetch("hourly")
hourly_summary = hourly_hash.fetch("summary")

puts "The current temperature is " + current_temp.to_s + "F. "
puts "Next hour: " + hourly_summary.to_s


hourly_data_array = hourly_hash.fetch("data")
next_twelve_hours = hourly_data_array[1..12]

any_precipitation = false

next_twelve_hours.each do |hour_hash|
  precip_probability = hour_hash.fetch("precipProbability")

  if precip_probability > 0.10
    any_precipitation = true

    precip_time = Time.at(hour_hash.fetch("time"))

    seconds_from_now = precip_time - Time.now

    hours_from_now = seconds_from_now / 60 / 60

    puts "In #{hours_from_now.round} hours, there is a #{(precip_probability * 100).round}% chance of precipitation."
  end
end

if any_precipitation == true
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
