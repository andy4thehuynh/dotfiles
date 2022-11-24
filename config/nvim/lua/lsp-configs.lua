local cmp = require('cmp')
local lsp = require('lsp-zero')
local cmp_config = { behavior = cmp.SelectBehavior.Select }

lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
  'gopls',
  'solargraph',
  'sumneko_lua',
})

lsp.nvim_workspace() -- adds a completion source and setup sumneko_lua 

lsp.setup_nvim_cmp({
  mapping = lsp.defaults.cmp_mappings({
    ['<Up>'] = cmp.mapping.select_prev_item(cmp_config),
    ['<Down>'] = cmp.mapping.select_next_item(cmp_config),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  })
})

lsp.setup()
