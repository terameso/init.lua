return {
  "kwkarlwang/bufjump.nvim",
  config = function()
    require("bufjump").setup({
      forward_key = "<C-h>",
      backward_key = "<C-l>",
      on_success = nil
    })
  end,
}
