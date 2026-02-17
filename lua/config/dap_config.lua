local M = {}

M.setup = function()
    local dap = require("dap")
    local mason_dap = require("mason-nvim-dap")
    local dap_virtual_text = require("nvim-dap-virtual-text")
    local ui = require("dapui")

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
  node_path = "/home/jvginer/.nvm/versions/node/v22.16.0/bin/node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  debugger_path = "/home/jvginer/.local/share/nvim/lazy/vscode-js-debug",
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
            runtimeExecutable = "/home/jvginer/.nvm/versions/node/v22.16.0/bin/node",
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

    -- DAP UI integration
    local dapui = require("dapui")
    dap.listeners.before.attach.dapui_config = function()
        dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
        dapui.open()
    end

require("dap").adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "js-debug-adapter", -- As I'm using mason, this will be in the path
    args = {"${port}"},
  }
}

    -- Uncomment these if you want DAP UI to close automatically
    -- dap.listeners.before.event_terminated.dapui_config = function()
    --     dapui.close()
    -- end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --     dapui.close()
    -- end
end

return M
