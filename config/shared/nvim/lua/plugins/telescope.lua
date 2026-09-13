return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      file_ignore_patterns = {
        "^.git/",
        "node_modules/",
        "%.pyc$",
        "__pycache__/",
        "%.egg%-info/",
        "dist/",
        "build/",
        "vendor/",
        "%.gem$",
        "%.so$",
        "%.dylib$",
        "06%-System/00%-Archive/", -- re: obsidian.nvim
        ".obsidian/", -- re: obsidian.nvim
      },
    },
  },
  keys = {
    {
      "<leader><space>",
      function()
        require("telescope.builtin").find_files({ hidden = true })
      end,
      desc = "Find Files (Root Dir)",
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({ hidden = true, cwd = vim.uv.cwd() })
      end,
      desc = "Find Files (cwd)",
    },
  },
}
