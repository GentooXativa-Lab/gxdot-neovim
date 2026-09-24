-- Task runner: build / configure / test, with results in the quickfix.
--
-- `dap = true` patches nvim-dap so that a debug configuration's `preLaunchTask`
-- and `postDebugTask` are honoured. That patch is the whole build-then-debug
-- wiring — but it is only installed once overseer LOADS. Lazy-loading this on
-- `cmd` alone would make the first <F5> of a session silently skip the build,
-- so the plugin is loaded at VeryLazy on purpose.
return {
    {
        "stevearc/overseer.nvim",
        dependencies = { "mfussenegger/nvim-dap" },
        event = "VeryLazy",
        cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction", "OverseerRunCmd", "OverseerOpen",
                "OverseerClose", "OverseerInfo", "OverseerBuild", "OverseerLoadBundle" },
        config = function()
            require("overseer").setup({
                dap = true,
                task_list = {
                    direction = "bottom",
                    min_height = 12,
                },
            })

            require("config.cmake_tasks").setup()
        end,
    },
}
