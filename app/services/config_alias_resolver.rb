class ConfigAliasResolver
  ALIASES = {
    jshint: [:javascript, :java_script],
    coffeescript: [:coffee_script],
  }.freeze

  def initialize(config)
    @config = config
  end

  def run
    config_with_aliases_resolved = {}

    @config.each_pair do |config_key, config_value|
      config_merged = false

      ALIASES.each_pair do |linter, aliases|
        if !config_merged && aliases.include?(config_key)
          config_with_aliases_resolved[linter] = config_value
          config_merged = true
        end
      end

      if !config_merged
        config_with_aliases_resolved[config_key] = config_value
      end
    end

    config_with_aliases_resolved
  end
end
