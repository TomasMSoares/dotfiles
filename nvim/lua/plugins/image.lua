return {
  "3rd/image.nvim",
  dependencies = { "vhyrro/luarocks.nvim" },
  config = function()
    require("image").setup({
      backend = "kitty",
      integrations = {
        markdown = { enabled = true },
      },
    })
  end
}
