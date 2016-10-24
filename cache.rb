class Cache

  attr_reader :cache

  def initialize(cache={})
    @cache = cache
  end

  def key?(key)
    @cache.has_key?(key)
  end

  def get(key)
    @cache[key]
  end

  def set(key, value)
    @cache[key] = value
  end

  def clear
    @cache = {}
  end
end
