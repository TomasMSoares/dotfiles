return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20,
			direction = "horizontal",
			shade_terminals = true,
		})

		-- Local function for terminal mappings
		local function set_terminal_keymaps()
			local opts = { buffer = 0 }
			-- Exit terminal mode with double escape
			vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { buffer = 0, desc = "Exit Terminal Mode" })

			-- Navigation inside terminal (also crosses into tmux panes)
			vim.keymap.set("t", "<C-h>", [[<Cmd>TmuxNavigateLeft<CR>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>TmuxNavigateDown<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>TmuxNavigateUp<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>TmuxNavigateRight<CR>]], opts)
		end

		-- Define which terminals are "allowed" to have these mappings (Opt-in)
		local opt_in_patterns = {
			"zsh",
			"bash",
			"sh",
			"fish",
			"toggleterm",
			"tmux",
		}

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*",
			callback = function()
				local name = vim.api.nvim_buf_get_name(0):lower()
				for _, pattern in ipairs(opt_in_patterns) do
					if name:match(pattern) then
						set_terminal_keymaps()
						return
					end
				end
			end,
		})
	end,
}
