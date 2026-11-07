-- Ctrl-h/j/k/l moves across nvim splits and tmux panes alike (tmux half lives in tmux.conf)
return {
	"christoomey/vim-tmux-navigator",
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
	},
	keys = {
		{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Window/Pane Left" },
		{ "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Window/Pane Down" },
		{ "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Window/Pane Up" },
		{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Window/Pane Right" },
	},
}
