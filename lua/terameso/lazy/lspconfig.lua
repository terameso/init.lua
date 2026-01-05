return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      cspell = {
        cmd = { "cspell-lsp", "--stdio" },
        filetypes = {
          "markdown",
          "text",
          "typescript",
          "javascript",
          "lua",
          "python",
          "json",
          "yaml",
        },
        settings = {
          cspell = {
            configFile = vim.fn.expand("~/.config/cspell/cspell.json"),
          },
        },
      },
    },
  },
}

