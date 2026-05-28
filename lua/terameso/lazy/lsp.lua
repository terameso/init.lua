return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },
  config = function()
    -- 1. Setup basics
    require("fidget").setup({})
    require("mason").setup()

    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local lspconfig = require("lspconfig")

    local capabilities =
      vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

    -- 2. Define Custom TSGO Config
    -- We must do this BEFORE mason-lspconfig tries to set it up
    local configs = require("lspconfig.configs")
    if not configs.tsgo then
      configs.tsgo = {
        default_config = {
          cmd = { "tsgo", "--lsp", "--stdio" },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
        },
      }
    end

    -- 3. Mason LSP Config Setup
    -- Ensure you use 'mason-lspconfig' here, NOT 'lspconfig'
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "lemminx",
        "tsgo", -- Ensure tsgo is managed by Mason
      },
      handlers = {
        -- Default handler: Setup any server installed by Mason
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,

        -- Specific handler for Lua
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                },
              },
            },
          })
        end,
      },
    })

    -- 4. Autocompletion Setup
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        -- { name = 'codeium' }, -- Uncomment if you have codeium installed
      }, {
        { name = "buffer" },
      }),
    })

    -- 5. Diagnostics UI
    vim.diagnostic.config({
      virtual_text = false,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    })

    -- 6. Keymaps (KickStart style)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("terameso-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- Wrap these in pcall just in case telescope isn't loaded yet
        local telescope_builtin = require("telescope.builtin")
        map("gr", telescope_builtin.lsp_references, "[G]oto [R]eferences")
        map("<leader>D", telescope_builtin.lsp_type_definitions, "Type [D]efinition")
        map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
      end,
    })
  end,
}
