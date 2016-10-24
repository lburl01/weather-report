require 'httparty'
require_relative 'cache'

@cache = Cache.new

def get_json(url)
  return @cache.get(url) if @cache.key?(url)

  data = HTTParty.get(url).parsed_response

  data = @cache.set(url, data)
  return data
end

data = get_json('http://api.wunderground.com/api/7d88bd8046a20136/conditions/q/NC/Raleigh.json')

p data
