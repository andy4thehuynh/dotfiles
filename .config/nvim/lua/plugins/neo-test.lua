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
      -- JavaScript
      ["neotest-jest"] = {
        jestCommand = "npm test --",
      },
      -- Python
      ["neotest-python"] = {
        runner = "pytest",
      },
    },
  },
}
