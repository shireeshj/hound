class ConfigAliasResolver
  ALIASES = {
    "javascript" => "jshint",
    "java_script" => "jshint",
    "coffee_script" => "coffeescript"
  }.freeze

  def initialize(config)
    @config = config
  end

  def run
    config_with_aliases_resolved = {}

    @config.each_pair do |config_key, config_value|
      if ALIASES.keys.include? config_key
        config_with_aliases_resolved[ALIASES[config_key]] = config_value
      else
        config_with_aliases_resolved[config_key] = config_value
      end
    end

    config_with_aliases_resolved
  end
end
