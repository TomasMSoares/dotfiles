return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local builtin = require("telescope.builtin")
    local keymap = vim.keymap

    keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
    keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Grep in Project" })
    keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })
    keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help Tags" })

    keymap.set('n', '<leader>ft', function ()
      builtin.colorscheme({
        enable_preview = true,
      })
    end, { desc = "Find Theme" })
  end
}
