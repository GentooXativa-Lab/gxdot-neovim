-- Keeps the CLI tools conform expects installed and up to date. mason.nvim on
-- its own has no `ensure_installed` option (v2.x), so declaring the tools in
-- its `opts` was silently ignored.
return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { { "williamboman/mason.nvim", opts = {} } },
		opts = {
			ensure_installed = {
				"markdown-toc",
				"markdownlint-cli2",
				"prettier",
				"ruff",
				"stylua",
			},
			run_on_start = true,
			-- Delay so the check never competes with startup, and only re-check
			-- once a day instead of on every launch.
			start_delay = 3000,
			debounce_hours = 24,
		},
	},
}
