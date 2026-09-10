return {
    {
        "mfussenegger/nvim-dap",
        -- No event/cmd: the <F5>/<leader>d* mappings in config/keybindings.lua
        -- all go through require("dap"), which lazy.nvim's module loader picks
        -- up. Previously dap_config.setup() ran straight from init.lua, which
        -- pulled the whole debug stack in at startup.
        lazy = true,
        dependencies = {
            -- nvim-dap-ui is deliberately NOT listed here. As a dependency its
            -- config runs first and calls dapui.setup(), which require()s dap
            -- mid-load and loops back into this config
            -- ("loop or previous error loading module 'dapui'"). It loads on
            -- its own when dap_config's listeners require it.
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope-dap.nvim",
            "mfussenegger/nvim-dap-python",
            "mason-org/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
            "mxsdev/nvim-dap-vscode-js",
        },
        config = function()
            require("config.dap_config").setup()
            -- Registered here rather than from Telescope's config so that
            -- opening Telescope doesn't pull in the whole debug stack.
            pcall(function()
                require("telescope").load_extension("dap")
            end)
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        config = function()
            require("dapui").setup({
                controls = {
                    element = "repl",
                    enabled = true,
                    icons = {
                        disconnect = "",
                        pause = "",
                        play = "",
                        run_last = "",
                        step_back = "",
                        step_into = "",
                        step_out = "",
                        step_over = "",
                        terminate = ""
                    }
                },
                element_mappings = {},
                expand_lines = true,
                floating = {
                    border = "single",
                    mappings = {
                        close = {"q", "<Esc>"}
                    }
                },
                force_buffers = true,
                icons = {
                    collapsed = "",
                    current_frame = "",
                    expanded = ""
                },
                layouts = {{
                    elements = {{
                        id = "scopes",
                        size = 0.5
                    }, {
                        id = "breakpoints",
                        size = 0.15
                    }, {
                        id = "stacks",
                        size = 0.15
                    }, {
                        id = "watches",
                        size = 0.15
                    }, {
                        id = "repl",
                        size = 0.05
                    }},
                    position = "right",
                    size = 40
                }, {
                    elements = {{
                        id = "console",
                        size = 1
                    }},
                    position = "bottom",
                    size = 20
                }},
                mappings = {
                    edit = "e",
                    expand = {"<CR>", "<2-LeftMouse>"},
                    open = "o",
                    remove = "d",
                    repl = "r",
                    toggle = "t"
                },
                render = {
                    indent = 1,
                    max_value_lines = 100
                }
            })
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = true,
        config = function()
            require("nvim-dap-virtual-text").setup()
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        lazy = true,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        lazy = true,
        dependencies = {
            "mason-org/mason.nvim",
        },
    },
}
