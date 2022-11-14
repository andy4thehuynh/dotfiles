-- https://github.com/lukas-reineke/indent-blankline.nvim#with-custom-listchars-and-gindent_blankline_space_char_blankline
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " ",
}
