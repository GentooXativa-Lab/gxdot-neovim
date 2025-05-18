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
        ensure_installed = {"cppdbg", "python", "ruff", "copilot-language-server"},
        automatic_installation = true,
        handlers = {
            function(config)
                require("mason-nvim-dap").default_setup(config)
            end
        }
    })

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
    
    -- Uncomment these if you want DAP UI to close automatically
    -- dap.listeners.before.event_terminated.dapui_config = function()
    --     dapui.close()
    -- end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --     dapui.close()
    -- end
end

return M
