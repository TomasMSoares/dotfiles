return {
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local gs = require('gitsigns')
      gs.setup({
        signs = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true,
        current_line_blame = true,
        on_attach = function(bufnr)
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']h', function()
            if vim.wo.diff then return ']h' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = "Next Hunk" })

          map('n', '[h', function()
            if vim.wo.diff then return '[h' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = "Prev Hunk" })

          -- Actions (Moved to <leader>g prefix to avoid collision with <leader>h terminal)
          map('n', '<leader>gs', gs.stage_hunk, { desc = "Stage Hunk" })
          map('n', '<leader>gp', gs.preview_hunk, { desc = "Preview Hunk" })
          map('n', '<leader>gr', gs.reset_hunk, { desc = "Reset Hunk" })
        end
      })
    end
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { 
        "<leader>gg", 
        function()
          -- If we are currently in a lazygit buffer, close it
          if vim.bo.filetype == "lazygit" then
            vim.cmd("close")
          else
            vim.cmd("LazyGit")
          end
        end, 
        desc = "Toggle LazyGit",
        mode = { "n", "t" } -- Allow toggling from both Normal and Terminal mode
      },
    },
  },
}
