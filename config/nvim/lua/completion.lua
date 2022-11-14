vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Displays hover information about the symbol under the cursor
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

    -- Jumps to the definition of the type symbol
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

    -- Lists all the references 
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

    -- Displays a function's signature information
    bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

    -- Show diagnostics in a floating window
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

    -- Move to the previous diagnostic
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

    -- Move to the next diagnostic
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },


  window = {
    -- completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },


  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },


  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),
  },


  sources = {
    { name = 'path' },
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'buffer', keyword_length = 3 },
    { name = 'luasnip', keyword_length = 2 },
  },
})






-- local lspkind = require("lspkind")
-- local cmp = require("cmp")


-- cmp.setup({
--   formatting = {
--     format = lspkind.cmp_format({
--       mode = "symbol",
--       maxwidth = 50,
--
--       before = function(_, vim_item)
--         return vim_item
--       end
--     })
--   },
--
--
--   snippet = {
--     expand = function(args)
--       require("luasnip").lsp_expand(args.body)
--     end,
--   },
--
--
--   window = {
--     completion = cmp.config.window.bordered(),
--     documentation = cmp.config.window.bordered(),
--   },
--
--
--   mapping = cmp.mapping.preset.insert({
--     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete({}),
--     ['<C-e>'] = cmp.mapping.abort(),
--     ['<CR>'] = cmp.mapping.confirm({ select = true }),
--     ['<TAB>'] = cmp.mapping.confirm({ select = false }),
--   }),
--
--
--   sources = cmp.config.sources({
--     { name = "nvim_lsp" },
--     { name = "luasnip" },
--     { name = "buffer" },
--     { name = "path" },
--   }),
--
--
--   experimental = {
--     ghost_text = true
--   },
-- })
--
--
-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline("/", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = "buffer" }
--     -- { name = 'nvim_lsp_document_symbol' },
--   }
-- })
--
--
-- -- -- `:` cmdline setup.
-- cmp.setup.cmdline(":", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = "path" }
--   }, {
--     { name = "cmdline" }
--   })
-- })
--
