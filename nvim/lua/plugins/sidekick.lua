return {
	"folke/sidekick.nvim",
	opts = {
		cli = {
			mux = {
				backend = "tmux",
				enabled = true,
			},
			tools = {
				antigravity = {
					cmd = { "agy" },
				},
			},
		},
	},
	config = function(_, opts)
		require("sidekick").setup(opts)
		local config = require("sidekick.config")
		for tool, _ in pairs(config.cli.tools) do
			if tool ~= "antigravity" and tool ~= "claude" and tool ~= "pi" then
				config.cli.tools[tool] = nil
			end
		end
	end,
	keys = {
		-- {
		--   "<tab>",
		--   function()
		--     -- if there is a next edit, jump to it, otherwise apply it if any
		--     if not require("sidekick").nes_jump_or_apply() then
		--       return "<Tab>" -- fallback to normal tab
		--     end
		--   end,
		--   expr = true,
		--   desc = "Goto/Apply Next Edit Suggestion",
		-- },
		{
			"<c-.>",
			function()
				require("sidekick.cli").focus()
			end,
			desc = "Sidekick Focus",
			mode = { "n", "t", "i", "x" },
		},
		{
			"<leader>aa",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>as",
			function()
				require("sidekick.cli").select()
			end,
			-- To select only installed tools:
			-- require("sidekick.cli").select({ filter = { installed = true } })
			desc = "Select CLI",
		},
		{
			"<leader>ad",
			function()
				require("sidekick.cli").close()
			end,
			desc = "Detach a CLI Session",
		},
		{
			"<leader>at",
			function()
				require("sidekick.cli").send({ msg = "{this}" })
			end,
			mode = { "x", "n" },
			desc = "Send This",
		},
		{
			"<leader>af",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Send File",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},

		-- Keybinds to open models directly
		{
			"<leader>ag",
			function()
				require("sidekick.cli").toggle({ name = "gemini", focus = true })
			end,
			desc = "Sidekick Toggle Gemini",
		},
	},
}
