local status = require('nvim-spotify').status
status:start()

require("lualine").setup({
  options = {
    theme = "nord",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "filename" },
    lualine_c = { "" },
    lualine_x = { "" },
    lualine_y = {  status.listen },
    lualine_z = { "location" }
  },
})
