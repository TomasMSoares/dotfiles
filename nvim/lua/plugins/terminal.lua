return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 20,
      direction = "horizontal",
      shade_terminals = true,
    })
  end
}
