return {
    {
        "mason-org/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" },
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "",
                    package_pending = "",
                    package_uninstalled = "",
                },
            },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VeryLazy",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "shellcheck",
                "shfmt",
                "tflint",
                "ansible-lint",
                "markdownlint-cli2",
                "markdown-toc",
                "prettier",
                "stylua",
                "ruff",
            },
            auto_update = false,
            run_on_start = true,
            start_delay = 3000,
        },
    },
}
