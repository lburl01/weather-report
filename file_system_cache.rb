class FileSystemCache

  attr_reader :file_cache

  def initialize(file_cache={})
    @file_cache = file_cache
  end

  def key?(key)
    @file_cache.has_key?(key)
  end

  def get(key)
    @file_cache[key]
  end

  def set(key, value)
    @file_cache[key] = value
  end

  def clear
    @file_cache = {}
  end
end
