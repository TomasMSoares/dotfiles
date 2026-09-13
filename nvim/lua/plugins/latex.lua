return {
	{
		"lervag/vimtex",
		lazy = false, -- VimTeX handles its own ftplugin lazy loading
		init = function()
			-- Use Zathura as the PDF viewer
			vim.g.vimtex_view_method = "zathura"

			-- Configure latexmk continuous compilation
			vim.g.vimtex_compiler_latexmk = {
				aux_dir = "",
				out_dir = "",
				callback = 1,
				continuous = 1,
				executable = "latexmk",
				hooks = {},
				options = {
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}

			-- Quickfix window behavior (2 = open automatically only on errors)
			vim.g.vimtex_quickfix_mode = 2
		end,
	},
	{
		"micangl/cmp-vimtex",
		ft = { "tex", "bib", "plaintex" },
	},
}
