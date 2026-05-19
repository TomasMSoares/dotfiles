return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("venv-selector").setup({
      settings = {
        options = {
          notify_user_on_activate = true,
        },
      },
    })
  end,
  keys = {
    { "<leader>py", "<cmd>VenvSelect<cr>", desc = "Select Virtual Env" },
  },
}
