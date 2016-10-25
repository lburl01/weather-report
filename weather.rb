require 'httparty'
require_relative 'cache'
require 'json'
require_relative 'file_system_cache'
require 'pry'

@cache = Cache.new

city_state = ARGV

def get_json(url)
  parsed_file = {}

  if File.exists?("memory.json")
    parsed_file = JSON.parse(File.read("memory.json"))
    if parsed_file.key?(url)
      file_data = parsed_file[url]
      puts "found file"
      return file_data
    end
  end
  puts "out of if"
  data = HTTParty.get(url).parsed_response

  parsed_file[url] = data
  File.write('memory.json', JSON.dump(parsed_file))

  return data

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
