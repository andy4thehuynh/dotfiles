return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    opts.options = opts.options or {}
    opts.options.section_separators = { left = "", right = "" }
    opts.options.component_separators = { left = "", right = "" }
    opts.sections = opts.sections or {}
    opts.sections.lualine_a = {
      {
        "mode",
        fmt = function(str)
          return str:sub(1, 1):lower()
        end,
      },
    }
    opts.sections.lualine_b = {}
    opts.sections.lualine_c = {}
    opts.sections.lualine_x = {}
    opts.sections.lualine_y = {}
    opts.sections.lualine_z = { { "location", color = { bg = "NONE", fg = "#6c7086" } } }
    return opts
  end,
}
