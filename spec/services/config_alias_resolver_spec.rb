require "app/services/config_alias_resolver"

describe ConfigAliasResolver do
  context "when the content contains configured aliases" do
    it "renames them to the appropriate linter" do
      config = {
        javascript: { enabled: false },
        ruby: { enabled: false },
      }

      config_with_resolved_aliases = ConfigAliasResolver.new(config).run

      expect(config_with_resolved_aliases.keys).to eq([:jshint, :ruby])
    end
  end
end
