return {
  "kwkarlwang/bufjump.nvim",
  config = function()
    require("bufjump").setup({
      forward_key = "<C-,>",
      backward_key = "<C-l>",
      on_success = nil
    })
  end,
}
