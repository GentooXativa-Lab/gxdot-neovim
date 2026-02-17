return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				marksman = {},
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc" } },
			},
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			require("mason").setup()
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = { "pyright", "ts_ls" },
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
		end,
	},
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"theHamsta/nvim-dap-virtual-text",
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap" },
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
	},
}
