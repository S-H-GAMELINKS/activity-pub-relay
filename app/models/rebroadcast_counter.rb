class RebroadcastCounter
  def self.increment
    key = Time.current.strftime("%Y-%m-%d")

    if Rails.cache.exist?(key)
      Rails.cache.increment(key, 1)
    else
      Rails.cache.write(key, 1, expire_in: 7.days)
    end
  end
end
