return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- The `main` branch (the rewrite) requires Neovim >= 0.12; this config
		-- targets 0.11.x, so stay on `master`.
		branch = "master",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
			auto_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		},
	},
}
