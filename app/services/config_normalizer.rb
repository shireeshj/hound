class ConfigNormalizer
  def initialize(config)
    @config = config
  end

  def run
    normalized_config = {}

    @config.each_pair do |key, value|
      normalized_key = normalize_key key

      if value.is_a? Hash
        normalized_config[normalized_key] = ConfigNormalizer.new(value).run
      else
        normalized_config[normalized_key] = value
      end
    end

    normalized_config
  end

  private

  def normalize_key(key)
    key.downcase
  end
end
