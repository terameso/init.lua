return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "davidmh/cspell.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local cspell = require("cspell")

    -- Logic to find the cspell.json config file in your project
    local function find_cspell_config_file()
      local config_files = { "cspell.json", ".cspell.json", "cSpell.json", "cspell.config.js" }
      local found = vim.fs.find(config_files, {
        upward = true,
        stop = vim.loop.os_homedir(),
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      })
      return found[1]
    end

    null_ls.setup({
      sources = {
        -- CSpell Source
        cspell.diagnostics.with({
          -- Optional: Only run if a config file is found
          -- condition = function(utils)
          --   return utils.root_has_file({ "cspell.json", ".cspell.json" })
          -- end,
          config = {
            find_json = find_cspell_config_file,
          },
          -- Make the errors appear as Hints (blue/grey) instead of Errors (red)
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity.WARN
          end,
        }),

        -- Code Actions (Apply suggestions)
        cspell.code_actions.with({
          config = {
            find_json = find_cspell_config_file,
          },
        }),
      },
    })
  end,
}
