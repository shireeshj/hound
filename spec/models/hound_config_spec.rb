require "spec_helper"
require "app/models/config/parser"
require "app/services/config_normalizer"
require "app/services/config_alias_resolver"
require "app/models/hound_config"

describe HoundConfig do
  describe "#content" do
    it "returns the contents of the .hound.yml file merged with the defaults" do
      commit = stubbed_commit(
        ".hound.yml" => <<-EOS.strip_heredoc
          ruby:
            config_file: config/rubocop.yml
        EOS
      )
      hound_config = HoundConfig.new(commit)

      expect(hound_config.content["ruby"]).to eq(
        {
          "enabled" => true,
          "config_file" => "config/rubocop.yml",
        },
      )
    end
  end


  describe "#enabled_for?" do
    context "given a language that isn't in the config file" do
      context "given the language is a default" do
        it "return true" do
          commit = stubbed_commit(
            ".hound.yml" => ""
          )
          hound_config = HoundConfig.new(commit)

          expect(hound_config).to be_enabled_for("ruby")
        end
      end

      context "given the language is not a default" do
        it "return false" do
          commit = stubbed_commit(
            ".hound.yml" => ""
          )
          hound_config = HoundConfig.new(commit)

          expect(hound_config).not_to be_enabled_for("remark")
        end
      end
    end

    context "given a language that is disabled in the config file" do
      it "returns false" do
        commit = stubbed_commit(
          ".hound.yml" => <<-EOS.strip_heredoc
            ruby:
              enabled: false
          EOS
        )
        hound_config = HoundConfig.new(commit)

        expect(hound_config).not_to be_enabled_for("ruby")
      end
    end

    context "given a language that is enabled in the config file" do
      it "returns true" do
        commit = stubbed_commit(
          ".hound.yml" => <<-EOS.strip_heredoc
            remark:
              enabled: true
          EOS
        )
        hound_config = HoundConfig.new(commit)

        expect(hound_config).to be_enabled_for("remark")
      end
    end

    context "given an unsupported language" do
      it "returns false" do
        commit = stubbed_commit(".hound.yml" => "")
        hound_config = HoundConfig.new(commit)
        unsupported_linter = "some_random_linter"

        expect(hound_config).not_to be_enabled_for(unsupported_linter)
      end
    end

    context "when the enabled key is capitalized" do
      it "returns true" do
        commit = stubbed_commit(
          ".hound.yml" => <<-EOS.strip_heredoc
            python:
              Enabled: true
          EOS
        )
        hound_config = HoundConfig.new(commit)

        expect(hound_config).to be_enabled_for("python")
      end
    end

    context "when the given language has underscores in it" do
      it "converts them and returns true" do
        commit = stubbed_commit(
          ".hound.yml" => <<-EOS.strip_heredoc
            coffeescript:
              enabled: true
          EOS
        )
        hound_config = HoundConfig.new(commit)

        expect(hound_config).to be_enabled_for("coffee_script")
      end
    end
  end

  describe "#fail_on_violations?" do
    context "when the setting is turned on" do
      it "returns true" do
        commit = stubbed_commit(
          ".hound.yml" => <<-EOS.strip_heredoc
            fail_on_violations: true
          EOS
        )
        hound_config = HoundConfig.new(commit)

        expect(hound_config.fail_on_violations?).to eq true
      end
    end

    context "when the setting is turned off" do
      it "returns false" do
        commit = stubbed_commit(
          ".hound.yml" => <<-EOS.strip_heredoc
            fail_on_violations: false
          EOS
        )
        hound_config = HoundConfig.new(commit)

        expect(hound_config.fail_on_violations?).to eq false
      end
    end

    context "when the setting is unconfigured" do
      it "returns false" do
        commit = stubbed_commit(".hound.yml" => "")
        hound_config = HoundConfig.new(commit)

        expect(hound_config.fail_on_violations?).to eq false
      end
    end
  end

  def be_enabled_for(linter_name)
    be_linter_enabled(linter_name)
  end
end
