local omarchy_theme_file = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")
local omarchy_colorscheme
local omarchy_theme_plugin

if vim.fn.filereadable(omarchy_theme_file) == 1 then
  local ok, specs = pcall(dofile, omarchy_theme_file)
  if ok and type(specs) == "table" then
    for _, spec in ipairs(specs) do
      if spec[1] == "LazyVim/LazyVim" then
        omarchy_colorscheme = spec.opts and spec.opts.colorscheme
      elseif type(spec[1]) == "string" and not omarchy_theme_plugin then
        -- Keep only the plugin identity needed to provide Omarchy's colorscheme.
        omarchy_theme_plugin = {
          spec[1],
          name = spec.name,
          branch = spec.branch,
          lazy = false,
          priority = 1001,
        }
      end
    end
  end
end

local plugins = {}
if omarchy_theme_plugin then
  table.insert(plugins, omarchy_theme_plugin)
end

table.insert(plugins, {
  "projekt0n/github-nvim-theme",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    local colorscheme = omarchy_colorscheme or "github_dark_default"
    local ok = pcall(vim.cmd.colorscheme, colorscheme)
    if not ok then
      vim.cmd.colorscheme("github_dark_default")
    end

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
})

return plugins
