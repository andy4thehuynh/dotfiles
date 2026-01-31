return {
  "nvim-neotest/neotest",
  dependencies = {
    "olimorris/neotest-rspec",
    "nvim-neotest/neotest-jest",
    "nvim-neotest/neotest-python",
  },

  opts = {
    adapters = {
      -- Ruby/Rails
      ["neotest-rspec"] = {
        rspec_cmd = function()
          return { "bundle", "exec", "rspec" }
        end,
      },
      -- JavaScript (auto-detects jest.config.js)
      ["neotest-jest"] = {
        jestCommand = "npm test --",
      },
      -- Python (auto-detects pytest)
      ["neotest-python"] = {
        runner = "pytest",
      },
    },
  },
}
