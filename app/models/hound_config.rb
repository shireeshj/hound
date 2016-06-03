class HoundConfig
  BETA_LINTERS = [
    "eslint",
    "jscs",
    "pyton",
    "remark",
  ].freeze
  CONFIG_FILE = ".hound.yml"
  DEFAULT_CONFIG = Linter::Collection::LINTER_NAMES.inject({}) do |config, name|
    config[name] = { "enabled" => !BETA_LINTERS.include?(name) }
    config
  end.freeze

  attr_reader_initialize :commit

  def content
    @merged_config ||= DEFAULT_CONFIG.deep_merge(resolved_aliases_config)
  end

  def linter_enabled?(name)
    key = normalize_key(name)
    config = options_for(key)

    !!config["enabled"]
  end

  def fail_on_violations?
    !!(content["fail_on_violations"])
  end

  private

  def resolved_aliases_config
    ResolveConfigAliases.run(normalized_config)
  end

  def normalized_config
    NormalizeConfig.run(parsed_config)
  end

  def parsed_config
    parse(commit.file_content(CONFIG_FILE))
  end

  def parse(file_content)
    Config::Parser.yaml(file_content) || {}
  end

  def options_for(name)
    content.fetch(name, {})
  end

  def normalize_key(key)
    key.downcase.sub("_", "")
  end
end
