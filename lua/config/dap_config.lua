local M = {}

M.setup = function()
    local dap = require("dap")
    local mason_dap = require("mason-nvim-dap")

    -- Setup dap-python
    require("dap-python").setup("uv")
    require("dap-python").test_runner = "pytest"

    -- nvim-dap-virtual-text is set up from its own spec in
    -- lua/plugins/debugger.lua; calling setup() here too ran it twice.

    -- Mason-DAP setup
    -- `js-debug-adapter` is the Mason package; `vscode-js-debug` is the source repo
    -- (Microsoft) and is NOT a Mason package — it was silently ignored before.
    mason_dap.setup({
        -- DAP ADAPTER names only. `ruff` and `copilot-language-server` used to be
        -- listed here and were silently ignored: they are LSP/lint tools, not
        -- debug adapters. `ruff` is installed by mason-tool-installer instead.
        -- `cppdbg` is mason-nvim-dap's alias for the `cpptools` package.
        ensure_installed = {"cppdbg", "python", "js-debug-adapter"},
        automatic_installation = true,
        handlers = {
            function(config)
                require("mason-nvim-dap").default_setup(config)
            end
        }
    })

    require("dap-vscode-js").setup({
        -- Use the Node binary from $PATH so nvm/asdf-managed projects pick the right
        -- version. Override per-project in `.nvim.lua` if a specific node is required.
        node_path = "node",
        -- Mason owns the debugger now; the legacy lazy clone is no longer used.
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        -- debugger_cmd = { "js-debug-adapter" }, -- takes precedence over node_path/debugger_path
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
        -- log_file_path = "(stdpath cache)/dap_vscode_js.log"
        -- log_file_level = false
        -- log_console_level = vim.log.levels.ERROR
    })

    -- JS/TS adapter configuration
    -- Note: a project's `.nvim.lua` may push more configs into these tables.
    dap.configurations.javascript = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch Node.js",
            program = "${workspaceFolder}/server.js",
            cwd = vim.fn.getcwd(),
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            -- Use the node binary from $PATH (respects nvm/asdf). Override per-project
            -- in `.nvim.lua` when a specific runtime is required.
            runtimeExecutable = "node",
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

    -- IMPORTANT: copy the table so JS and TS get independent arrays. A direct
    -- assignment (`dap.configurations.typescript = dap.configurations.javascript`)
    -- aliases the table by reference and causes downstream `table.insert`s
    -- (e.g. from project-local `.nvim.lua`) to duplicate configs across both filetypes.
    dap.configurations.typescript = vim.deepcopy(dap.configurations.javascript)
    dap.configurations.typescriptreact = vim.deepcopy(dap.configurations.javascript)

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

    -- DAP UI integration
    -- require()d inside the callbacks so nvim-dap-ui only loads when a debug
    -- session actually starts, and never while nvim-dap itself is still
    -- loading (which would deadlock the two modules).
    dap.listeners.before.attach.dapui_config = function()
        require("dapui").open()
    end
    dap.listeners.before.launch.dapui_config = function()
        require("dapui").open()
    end

    -- pwa-node adapter — js-debug-adapter is in $PATH thanks to Mason
    require("dap").adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "js-debug-adapter",
            args = {"${port}"},
        }
    }

    -- C/C++ (cppdbg + gdb). Registered LAST on purpose: mason-nvim-dap's
    -- `default_setup` also installs a `cppdbg` adapter and a default
    -- `configurations.cpp`, and this overwrites both so the <F5> menu shows one
    -- set of entries instead of two.
    require("config.dap_cpp").setup()

    -- Uncomment these if you want DAP UI to close automatically when the session ends
    -- dap.listeners.before.event_terminated.dapui_config = function()
    --     dapui.close()
    -- end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --     dapui.close()
    -- end
end

return M
