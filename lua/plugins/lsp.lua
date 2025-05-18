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
			{
				"ms-jpq/coq_nvim",
				branch = "coq",
			}, -- 9000+ Snippets
			{
				"ms-jpq/coq.artifacts",
				branch = "artifacts",
			}, -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
			-- Need to **configure separately**
			{
				"ms-jpq/coq.thirdparty",
				branch = "3p",
			},
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			require("mason").setup()
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = { "pyright" },
			})
			require("lspconfig").pyright.setup({
				capabilities = capabilities,
			})
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
