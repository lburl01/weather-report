require 'httparty'
require_relative 'cache'
require 'json'
require_relative 'file_system_cache'
require 'pry'

@cache = Cache.new
@file_cache = FileSystemCache.new

unless File.file?("memory.json")
  @json_file = File.new("memory.json", "w+")
end

city_state = ARGV

def get_json(url)
  file = File.read("memory.json")
  parsed_file = JSON.parse(file)
  if parsed_file.key?(url)
    # binding.pry
    file_data = parsed_file[url]
  else
    data = HTTParty.get(url)
    data_body = data.body
    parsed_data = data.parsed_response

    json_obj = {url => data_body}.to_json

    File.open("memory.json", 'w+') { |file| file.write(json_obj) }

    return parsed_data
  end
end

data = get_json("http://api.wunderground.com/api/7d88bd8046a20136/conditions/alerts/astronomy/forecast10day/currenthurricane/q/#{city_state[1]}/#{city_state[0]}.json")

if data['alerts'] == []
  data['alerts'] = 0
end


puts "All about weather for #{city_state[0]} #{city_state[1]}: "
puts "It's #{data['current_observation']['weather']} and feels like: #{data['current_observation']['feelslike_string']}."
print "Sunrise is at " + data['sun_phase']['sunrise']['hour'] + ":" + data['sun_phase']['sunrise']['minute'] + "AM."
puts " Sunset is at " + data['sun_phase']['sunset']['hour'] + ":" + data['sun_phase']['sunset']['minute'] + "PM."
puts "Current weather alerts: #{data['alerts']}"
puts "Ten Day Forecast:"
puts data['forecast']['txt_forecast']['forecastday'][0]['title'] + ": " + data['forecast']['txt_forecast']['forecastday'][0]['fcttext']
puts data['forecast']['txt_forecast']['forecastday'][2]['title'] + ": " + data['forecast']['txt_forecast']['forecastday'][2]['fcttext']
puts data['forecast']['txt_forecast']['forecastday'][4]['title'] + ": " + data['forecast']['txt_forecast']['forecastday'][4]['fcttext']
puts data['forecast']['txt_forecast']['forecastday'][6]['title'] + ": " + data['forecast']['txt_forecast']['forecastday'][6]['fcttext']
puts data['forecast']['txt_forecast']['forecastday'][8]['title'] + ": " + data['forecast']['txt_forecast']['forecastday'][8]['fcttext']
puts "Current Hurricanes:"
puts data['currenthurricane'][0]['stormInfo']['stormName'] + " is a category " + "#{data['currenthurricane'][0]['Current']['SaffirSimpsonCategory']}"

# filename = "memory.json"
# filename.truncate(0)
