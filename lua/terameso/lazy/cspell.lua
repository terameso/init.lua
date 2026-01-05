return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "davidmh/cspell.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local cspell = require("cspell")

    -- UPDATED: Logic to find config or fallback to global
    local function find_cspell_config_file()
      -- 1. Look for a project-specific config file first
      local config_files = { "cspell.json", ".cspell.json", "cSpell.json", "cspell.config.js" }
      local found = vim.fs.find(config_files, {
        upward = true,
        stop = vim.loop.os_homedir(),
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      })

      -- 2. If we found a project config, use it
      if found[1] then
        return found[1]
      end

      -- 3. FALLBACK: If no project config exists, force use of the global one
      -- This ensures "nvim", "lazyvim", etc. are always known
      return vim.fn.expand("~/.cspell.json")
    end

    local cspell_config = {
      find_json = find_cspell_config_file,
    }

    null_ls.setup({
      sources = {
        cspell.diagnostics.with({
          config = cspell_config,
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity.WARN
          end,
        }),
        cspell.code_actions.with({
          config = cspell_config,
        }),
      },
    })
  end,
}
