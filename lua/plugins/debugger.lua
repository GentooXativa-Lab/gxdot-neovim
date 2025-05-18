return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope-dap.nvim",
            "mfussenegger/nvim-dap-python",
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
        },
        config = function()
            -- DAP configuration is now in a separate file
            -- See lua/config/dap_config.lua
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
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
        config = function()
            require("nvim-dap-virtual-text").setup()
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
    },
}