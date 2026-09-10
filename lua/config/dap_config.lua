local M = {}

M.setup = function()
    -- Resolved at runtime: hardcoding an nvm version breaks on every Node upgrade.
    local node_path = vim.fn.exepath("node")
    local js_debug_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"

    local dap = require("dap")
    local mason_dap = require("mason-nvim-dap")
    local dap_virtual_text = require("nvim-dap-virtual-text")

    -- Setup dap-python
    require("dap-python").setup("uv")
    require("dap-python").test_runner = "pytest"

    -- Dap Virtual Text
    dap_virtual_text.setup()

    -- Mason-DAP setup
    mason_dap.setup({
        ensure_installed = {"cppdbg", "python", "ruff", "copilot-language-server", "vscode-js-debug", "js-debug-adapter"},
        automatic_installation = true,
        handlers = {
            function(config)
                require("mason-nvim-dap").default_setup(config)
            end
        }
    })

    require("dap-vscode-js").setup({
  node_path = node_path, -- resolved from $PATH
  debugger_path = js_debug_path,
 -- Path to vscode-js-debug installation.
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

    -- JS/TS adapter configuration
    dap.configurations.javascript = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch Node.js",
            program = "${workspaceFolder}/server.js",
            cwd = vim.fn.getcwd(),
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            runtimeExecutable = node_path,
            envFile = "${workspaceFolder}/.env",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Node.js process",
            processId = require("dap.utils").pick_process,
            cwd = vim.fn.getcwd(),
        }
    }

    dap.configurations.typescript = dap.configurations.javascript

    -- Python adapter configuration
    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Launch (mediahub)",
            program = "${workspaceFolder}/mediahub/__main__.py",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            args = {"-S", "-w", "/tmp/mediahub", "-d"},
            purpose = {"debug-in-terminal"},
            env_file = "${workspaceFolder}/.env",
            env = {
                MEDIAHUB_NO_CACHE = "1",
            },
            pythonPath = function()
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                    return cwd .. "/venv/bin/python"
                elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                    return cwd .. "/.venv/bin/python"
                else
                    return "/usr/bin/python"
                end
            end
        },
        {
            type = "python",
            request = "launch",
            name = "Launch current file",
            program = "${file}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            pythonPath = function()
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                    return cwd .. "/venv/bin/python"
                elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                    return cwd .. "/.venv/bin/python"
                else
                    return "/usr/bin/python"
                end
            end
        }
    }

    -- DAP UI. Set up from here rather than from the plugin spec: if lazy.nvim
    -- calls dapui.setup() while resolving nvim-dap's dependencies, dapui
    -- require()s dap mid-load and the two loop.
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

    dap.listeners.before.attach.dapui_config = function()
        require("dapui").open()
    end
    dap.listeners.before.launch.dapui_config = function()
        require("dapui").open()
    end

    -- NOTE: do not override dap.adapters["pwa-node"] here. dap-vscode-js
    -- already registers it using node_path/debugger_path above; overriding it
    -- with `command = "js-debug-adapter"` points at a binary that isn't
    -- installed and makes `:checkhealth dap` fail.

    -- Uncomment these if you want DAP UI to close automatically
    -- dap.listeners.before.event_terminated.dapui_config = function()
    --     dapui.close()
    -- end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --     dapui.close()
    -- end
end

return M
