require "app/services/normalize_config"

describe NormalizeConfig do
  describe "#run" do
    context "given a hash with keys containing capital letters" do
      it "downcases the keys" do
        config = { "Ruby" => { "Enabled" => true } }

        expect(NormalizeConfig.run(config).keys).to eq ["ruby"]
        expect(NormalizeConfig.run(config)["ruby"].keys).to eq(["enabled"])
      end
    end
  end
end
