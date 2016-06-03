class ResolveConfigAliases
  ALIASES = {
    "javascript" => "jshint",
    "java_script" => "jshint",
    "coffee_script" => "coffeescript",
  }.freeze

  def initialize(config)
    @config = config
  end

  def run
    @config.inject({}) do |config_without_aliases, (config_key, config_value)|
      if ALIASES.keys.include? config_key
        config_without_aliases[ALIASES[config_key]] = config_value
      else
        config_without_aliases[config_key] = config_value
      end
      config_without_aliases
    end
  end
end
