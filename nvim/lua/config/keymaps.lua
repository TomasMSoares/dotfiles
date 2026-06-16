local keymap = vim.keymap

keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle nvim-tree" }) -- nvim-tree toggle

keymap.set("n", "<C-h>", "<C-w>h", { desc = "Switch to Left Window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Switch to Right Window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Switch to Top Window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Switch to Bottom Window" })

keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next Buffer" })
keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous Buffer" })
keymap.set("n", "<leader>x", function()
	require("bufdelete").bufdelete(0, false)
end, { desc = "Close Buffer" })

keymap.set("n", "<leader>h", ":ToggleTerm<CR>", { desc = "Toggle Terminal" })
keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear Search Highlights" })

-- LSP Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local function opts(desc)
			return { buffer = ev.buf, desc = desc }
		end

		vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts("Go to Definition (Telescope)"))
		vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts("Go to References (Telescope)"))

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Show Hover Documentation"))
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename Symbol"))
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code Actions"))
	end,
})
