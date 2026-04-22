return {
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile", "BufWritePost" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                markdown = { "markdownlint-cli2" },
                sh = { "shellcheck" },
                bash = { "shellcheck" },
                terraform = { "tflint" },
                ["yaml.ansible"] = { "ansible_lint" },
            }

            local lint_group = vim.api.nvim_create_augroup("UserLint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
                group = lint_group,
                callback = function()
                    -- skip if no linter for this ft
                    if lint.linters_by_ft[vim.bo.filetype] then
                        lint.try_lint()
                    end
                end,
            })
        end,
    },
}
