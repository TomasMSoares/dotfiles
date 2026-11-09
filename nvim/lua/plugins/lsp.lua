return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		"folke/lazydev.nvim",
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

		lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},

					diagnostics = {
						globals = { "vim" },
					},

					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},

					telemetry = {
						enable = false,
					},
				},
			},
		})

		lsp.config("ts_ls", { capabilities = capabilities })
		lsp.config("clangd", { capabilities = capabilities })

		lsp.config("basedpyright", {
			capabilities = capabilities,
			settings = {
				basedpyright = {
					analysis = {
						typeCheckingMode = "standard",
					},
				},
			},
		})

		lsp.config("ruff", {
			capabilities = capabilities,
			on_attach = function(client)
				client.server_capabilities.hoverProvider = false
			end,
		})

		lsp.config("sqls", {
			capabilities = capabilities,
			on_attach = function(client, _)
				client.server_capabilities.documentFormattingProvider = false
			end,
		})

		lsp.config("dockerls", { capabilities = capabilities })
		lsp.config("docker_compose_language_service", { capabilities = capabilities })
		lsp.config("marksman", { capabilities = capabilities })
		lsp.config("bashls", { capabilities = capabilities })
		lsp.config("jsonls", { capabilities = capabilities })
		lsp.config("yamlls", { capabilities = capabilities })
		lsp.config("taplo", { capabilities = capabilities })
		lsp.config("texlab", { capabilities = capabilities })
	end,
}
