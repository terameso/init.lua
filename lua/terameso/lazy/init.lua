return {
  {
    "nvim-lua/plenary.nvim",
    name = "plenary",
  },
  "sQVe/sort.nvim",
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      -- Accept full suggestion
      vim.keymap.set("i", "<C-y>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })

      -- Accept next word
      vim.keymap.set("i", "<C-w>", "copilot#AcceptWord()", { expr = true, replace_keycodes = false })

      -- Accept next line
      vim.keymap.set("i", "<C-l>", "copilot#AcceptLine()", { expr = true, replace_keycodes = false })

      -- Dismiss suggestion
      vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)")

      -- Cycle through suggestions
      vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)")
      vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)")

      vim.g.copilot_filetypes = {
        ["*"] = true,
        ["go"] = false,
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup({ n_lines = 500 })
      local statusline = require("mini.statusline")
      statusline.setup({
        use_icons = vim.g.have_nerd_font,
      })
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end,
  },
  { -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = "ibl",
    opts = {},
  },
}
