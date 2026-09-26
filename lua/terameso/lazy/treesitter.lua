return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local parsers = {
      "vimdoc",
      "javascript",
      "typescript",
      "tsx",
      "c",
      "lua",
      "jsdoc",
      "bash",
      "markdown",
      "markdown_inline",
    }

    require("nvim-treesitter").setup()
    require("nvim-treesitter").install(parsers)

    local parser_by_filetype = {
      help = "vimdoc",
      javascript = "javascript",
      javascriptreact = "javascript",
      typescript = "typescript",
      typescriptreact = "tsx",
      c = "c",
      lua = "lua",
      bash = "bash",
      sh = "bash",
      markdown = "markdown",
    }

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("terameso_treesitter", { clear = true }),
      callback = function(event)
        local parser = parser_by_filetype[vim.bo[event.buf].filetype]
        if not parser then
          return
        end

        pcall(vim.treesitter.start, event.buf, parser)
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
