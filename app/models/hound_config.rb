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
    @merged_config ||= merge(DEFAULT_CONFIG, resolved_aliases_config)
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
    ResolveConfigAliases.new(normalized_config).run
  end

  def normalized_config
    NormalizeConfig.new(parsed_config).run
  end

  def parsed_config
    parse(commit.file_content(CONFIG_FILE))
  end

  def merge(base_hash, derived_hash)
    result = base_hash.merge(derived_hash)
    keys_appearing_in_both = base_hash.keys & derived_hash.keys
    keys_appearing_in_both.each do |key|
      next unless base_hash[key].is_a?(Hash)
      result[key] = merge(base_hash[key], derived_hash[key])
    end
    result
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
