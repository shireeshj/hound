class HoundConfig
  CONFIG_FILE = ".hound.yml"
  DEFAULT_CONFIG = {
    "coffeescript" => { "enabled" => true },
    "eslint" => { "enabled" => false },
    "go" => { "enabled" => true },
    "haml" => { "enabled" => true },
    "jscs" => { "enabled" => false },
    "jshint" => { "enabled" => true },
    "remark" => { "enabled" => false },
    "python" => { "enabled" => false },
    "ruby" => { "enabled" => true },
    "scss" => { "enabled" => true },
    "swift" => { "enabled" => true },
  }

  attr_reader_initialize :commit

  def content
    merged_config
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
    @resolved_aliases_config ||= ConfigAliasResolver.new(normalized_config).run
  end

  def normalized_config
    @normalized_config ||= ConfigNormalizer.new(parsed_config).run
  end

  def parsed_config
    @parsed_config ||= parse(commit.file_content(CONFIG_FILE))
  end

  def merged_config
    @merged_config ||= merge(DEFAULT_CONFIG, resolved_aliases_config)
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
