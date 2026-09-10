-- LSP only. The debug stack lives in lua/plugins/debugger.lua.
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- `opts` (even empty) is what makes lazy.nvim call mason.setup().
			-- Without it mason-lspconfig warns that mason was never set up and
			-- refuses every entry in ensure_installed.
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = { "pyright", "ts_ls", "marksman" },
			})

			-- Neovim 0.11+ native LSP configuration
			-- Python
			vim.lsp.config("pyright", {
				capabilities = capabilities,
			})
			vim.lsp.enable("pyright")

			-- TypeScript/JavaScript
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("ts_ls")

			-- Markdown
			vim.lsp.config("marksman", {
				capabilities = capabilities,
			})
			vim.lsp.enable("marksman")
		end,
	},
}
