module Config
  class GoLint < Base
    DEFAULT_CONFIG = "".freeze

    def linter_names
      [
        "go",
        "golint",
      ]
    end

    def content
      DEFAULT_CONFIG
    end
  end
end
