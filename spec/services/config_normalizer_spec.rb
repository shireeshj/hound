require "app/services/config_normalizer"

describe ConfigNormalizer do
  context "given a hash with keys containing capital letters" do
    it "downcases the keys" do
      config = { "Ruby" => { "Enabled" => true} }

      normalized_config = ConfigNormalizer.new(config).run

      expect(normalized_config.keys).to eq ["ruby"]
      expect(normalized_config["ruby"].keys).to eq(["enabled"])
    end
  end
end
