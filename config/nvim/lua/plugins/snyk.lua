return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      snyk_ls = {
        filetypes={"ruby", "lua"},
      }
    }
  }
}
