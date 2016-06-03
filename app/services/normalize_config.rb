class NormalizeConfig
  def initialize(config)
    @config = config
  end

  def run
    @config.reduce({}) do |normalized_config, (key, value)|
      normalized_key = normalize_key key
      if value.is_a? Hash
        normalized_config[normalized_key] = NormalizeConfig.new(value).run
      else
        normalized_config[normalized_key] = value
      end
      normalized_config
    end
  end

  private

  def normalize_key(key)
    key.downcase
  end
end
