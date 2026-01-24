-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- disable markdownlint diagnostics for Markdown files
    vim.diagnostic.enable(false, { bufnr = vim.api.nvim_get_current_buf() })
  end,
})

-- Disable marksman LSP for obsidian vault (times out with large vaults)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "marksman" then
      local bufname = vim.api.nvim_buf_get_name(args.buf)
      -- Detach marksman from obsidian vault files
      if bufname:match("iCloud~md~obsidian") then
        vim.lsp.buf_detach_client(args.buf, args.data.client_id)
      end
    end
  end,
})
