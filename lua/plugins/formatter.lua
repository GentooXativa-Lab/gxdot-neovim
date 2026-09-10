return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile", "BufWritePre" },
	-- `:Format` is only a recipe in conform's docs, not a real command, so it is
	-- registered below; without that, `cmd = "Format"` was a phantom trigger.
	cmd = { "ConformInfo", "Format" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				-- Plain "ruff" is deprecated in conform (it is an alias of
				-- ruff_fix, which lints but does not format). Fix, then format.
				python = { "ruff_fix", "ruff_format" },
				markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
				["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			},
		})

		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			conform.format({ async = true, lsp_format = "fallback", range = range })
		end, { range = true, desc = "Format buffer or range" })
	end,
}
