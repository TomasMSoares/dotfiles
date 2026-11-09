return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"mfussenegger/nvim-jdtls",
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"ruff",
				"basedpyright",
				"ts_ls",
				"cssls",
				"html",
				"clangd",
				"jdtls",
				"sqls",
				"bashls",
				"dockerls",
				"docker_compose_language_service",
				"marksman",
				"jsonls",
				"yamlls",
				"taplo",
				"texlab",
			},
			-- jdtls is started by nvim-jdtls in ftplugin/java.lua; enabling it here too spawns a second server
			automatic_enable = { exclude = { "jdtls" } },
		})

		-- Formatters (conform, plugins/formatting.lua) and linters (nvim-lint, plugins/linting.lua).
		-- Kept in one call: a second setup() would replace this list instead of extending it.
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- formatters
				"stylua",
				"clang-format",
				"google-java-format",
				"prettier",
				"shfmt",
				"taplo",
				-- linters
				"eslint_d",
				"shellcheck",
				"hadolint",
				"markdownlint",
				-- both
				"sqlfluff",
			},
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}
		local lsp = vim.lsp

		-- Applies to every server; the per-server configs below are merged on top
		lsp.config("*", { capabilities = capabilities })

		-- vim.* globals and plugin types come from lazydev (plugins/lazydev.lua)
		lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
				},
			},
		})

		lsp.config("basedpyright", {
			settings = {
				basedpyright = {
					analysis = {
						typeCheckingMode = "standard",
					},
				},
			},
		})

		-- Hover comes from basedpyright; ruff only lints/formats
		lsp.config("ruff", {
			on_attach = function(client)
				client.server_capabilities.hoverProvider = false
			end,
		})

		-- Formatting is done by sqlfluff via conform
		lsp.config("sqls", {
			on_attach = function(client, _)
				client.server_capabilities.documentFormattingProvider = false
			end,
		})
	end,
}
