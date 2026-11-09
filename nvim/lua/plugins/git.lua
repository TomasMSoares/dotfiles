return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			local gs = require("gitsigns")
			gs.setup({
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
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
					local function next_hunk()
						gs.nav_hunk("next")
					end
					local function prev_hunk()
						gs.nav_hunk("prev")
					end
					map("n", "<leader>gj", next_hunk, { desc = "Next Hunk" })
					map("n", "<leader>gk", prev_hunk, { desc = "Prev Hunk" })

					map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage Hunk" })
					map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
					map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset Hunk" })
				end,
			})
		end,
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
					vim.cmd("LazyGit")
				end,
				desc = "Toggle LazyGit",
				mode = { "n" },
			},
		},
	},
}
