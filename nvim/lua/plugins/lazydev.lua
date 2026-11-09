-- Gives lua_ls the Neovim API (vim.*) and plugin types when editing this config.
-- Only libraries you actually require() in the current file get loaded.
return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			-- vim.uv types, only when vim.uv is used
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}
