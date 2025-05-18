return {

-- 	{
--     "jose-elias-alvarez/null-ls.nvim",
--     dependencies = {"nvim-lua/plenary.nvim"},
--     config = function()
--         local null_ls = require("null-ls")
--
--         null_ls.setup({
--             sources = {null_ls.builtins.diagnostics.ruff, null_ls.builtins.formatting.black}
--         })
--     end
-- },
{
  "nvimtools/none-ls.nvim",
  optional = true,
  opts = function(_, opts)
    local nls = require("null-ls")
    opts.sources = vim.list_extend(opts.sources or {}, {
      nls.builtins.diagnostics.markdownlint_cli2,
    })
  end,
},
{
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      markdown = { "markdownlint-cli2" },
    },
  },
}
}
