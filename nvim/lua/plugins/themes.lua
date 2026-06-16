return {
	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,
		config = function()
			vim.o.termguicolors = true

			vim.g.everforest_background = "medium"
			vim.g.everforest_better_performance = 1

			vim.cmd.colorscheme("everforest")
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
	},

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
	},

	{
		"EdenEast/nightfox.nvim",
		lazy = false,
	},

	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
	},
}
