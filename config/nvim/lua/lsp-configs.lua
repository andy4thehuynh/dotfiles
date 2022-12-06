local cmp = require('cmp')
local lsp = require('lsp-zero')
local cmp_config = { behavior = cmp.SelectBehavior.Select }

lsp.preset('recommended')

lsp.ensure_installed({
  'gopls',
  'solargraph',
  'sumneko_lua',
  'tsserver',
})

lsp.setup_nvim_cmp({
  source = {
    { name = 'nvim_lsp_signature_help' }
  },
  mapping = lsp.defaults.cmp_mappings({
    ['<Up>'] = cmp.mapping.select_prev_item(cmp_config),
    ['<Down>'] = cmp.mapping.select_next_item(cmp_config),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  })
})

vim.opt.signcolumn = "yes" -- otherwise it bounces in and out, not strictly needed though
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = vim.api.nvim_create_augroup("RubyLSP", { clear = true }), -- also this is not /needed/ but it's good practice
  callback = function()
    vim.lsp.start {
      name = "standard",
      cmd = { "/Users/andyhuynh/.config/asdf/shims/standardrb", "--lsp" },
    }
  end,
})


-- see the log at :LspLog
vim.lsp.set_log_level("debug")

lsp.nvim_workspace() -- adds a completion source and setup sumneko_lua
lsp.setup()
