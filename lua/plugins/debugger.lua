-- Single source of truth for the debug stack. nvim-dap used to be declared in
-- three places (twice here and once in lsp.lua), and this file mixed packer
-- keys (`opt`, `run`, `module`) with lazy.nvim ones, which silently dropped the
-- vscode-js-debug build step.
return {
	{
		"mfussenegger/nvim-dap",
		-- No event/cmd: the <F5>/<leader>d* mappings in config/keybindings.lua all
		-- go through require("dap"), which lazy.nvim's module loader picks up.
		lazy = true,
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
			{ "mfussenegger/nvim-dap-python", lazy = true },
			"jay-babu/mason-nvim-dap.nvim",
			"williamboman/mason.nvim",
			"mxsdev/nvim-dap-vscode-js",
			{
				"microsoft/vscode-js-debug",
				-- `build`, not packer's `run`: without it the adapter is never
				-- bundled and dap reports `js-debug-adapter` as not executable.
				build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
			},
			"nvim-telescope/telescope-dap.nvim",
		},
		config = function()
			require("config.dap_config").setup()
			-- Registered here rather than from Telescope's own config so that
			-- opening Telescope doesn't pull in the whole debug stack.
			pcall(function()
				require("telescope").load_extension("dap")
			end)
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = { "nvim-neotest/nvim-nio" },
		-- Deliberately no `opts`: letting lazy.nvim call dapui.setup() while
		-- resolving nvim-dap's dependencies makes dapui require("dap") mid-load,
		-- which loops back into this file's config. dap_config.setup() calls it.
	},
	-- nvim-dap-virtual-text is set up from lua/config/dap_config.lua, so no
	-- `opts` here on purpose (it would call setup() twice).
	{ "theHamsta/nvim-dap-virtual-text", lazy = true },
}
