require "app/services/resolve_config_aliases"

describe ResolveConfigAliases do
  context "when the content contains configured aliases" do
    it "renames them to the appropriate linter" do
      config = {
        "javascript" => { "enabled" => false },
        "ruby" => { "enabled" => false },
      }

      config_with_resolved_aliases = ResolveConfigAliases.new(config).run

      expect(config_with_resolved_aliases.keys).to eq(["jshint", "ruby"])
    end
  end
end
