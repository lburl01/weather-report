require 'httparty'
require_relative 'cache'

@cache = Cache.new

city_state = ARGV

def get_json(url)
  return @cache.get(url) if @cache.key?(url)

  data = HTTParty.get(url).parsed_response

  data = @cache.set(url, data)
  return data
end

data = get_json("http://api.wunderground.com/api/7d88bd8046a20136/conditions/q/#{city_state[1]}/#{city_state[0]}.json")

puts "The weather for #{city_state[0]} #{city_state[1]}: "
puts "It's " + data['current_observation']['weather'] + " and feels like: " + data['current_observation']['feelslike_string'] + "."
