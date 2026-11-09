-- nvim-treesitter `main` branch: setup() only takes install_dir, so parsers are
-- installed via install() and highlighting/indent are enabled per buffer below.
-- Requires the `tree-sitter` CLI (pacman -S tree-sitter-cli) and a C compiler.
local parsers = {
	"lua",
	"python",
	"c",
	"cpp",
	"javascript",
	"typescript",
	"tsx",
	"java",
	"sql",
	"bash",
	"dockerfile",
	"markdown",
	"markdown_inline",
	"json",
	"yaml",
	"toml",
	"html",
	"css",
	"vim",
	"vimdoc",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- main branch does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.install(parsers) -- no-op for parsers already installed

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", {}),
				callback = function(ev)
					-- vimtex relies on its own syntax highlighting (math detection, conceal)
					if ev.match == "tex" or ev.match == "plaintex" then
						return
					end
					local lang = vim.treesitter.language.get_lang(ev.match)
					if not lang then
						return
					end
					-- auto_install equivalent: fetch parsers that exist but aren't installed yet
					if not vim.treesitter.language.add(lang) then
						if vim.tbl_contains(ts.get_available(), lang) then
							ts.install(lang)
						end
						return
					end
					vim.treesitter.start(ev.buf, lang)
					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			enable = true,
			max_lines = 3,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
		},
	},
}
