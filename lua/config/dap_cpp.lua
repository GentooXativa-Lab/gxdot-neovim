-- C/C++ debugging through cpptools (`cppdbg`) driving the system gdb.
-- Nothing project-specific here: a project adds its own configurations from its
-- `.nvim.lua`, which is why `M.pick_binary` is exported.
local M = {}

-- Mason installs cpptools' adapter as `OpenDebugAD7`. Prefer whatever is on
-- $PATH so a system-wide install works too.
local function opendebugad7()
    local exe = vim.fn.exepath("OpenDebugAD7")
    if exe ~= "" then
        return exe
    end
    return vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7"
end

-- Two separate things, and `-enable-pretty-printing` alone is NOT enough for a
-- Qt app: it turns on GDB's Python printers, which cover the `std::` types, but
-- Qt's own types need Qt-specific printers. Without them every QString renders
-- as `{...}` -- measured, not assumed. KDevelop's printers fill that gap and are
-- sourced explicitly here because cpptools' gdb is not guaranteed to read
-- ~/.config/gdb/gdbinit.
local qt_printers = vim.fn.expand("~/.config/gdb/kdevelop-printers/register.gdb")

M.setup_commands = {
    {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
    },
}

if vim.fn.filereadable(qt_printers) == 1 then
    table.insert(M.setup_commands, {
        text = "source " .. qt_printers,
        description = "Qt/KDE pretty-printers",
        -- Tolerated: a gdb built without Python still debugs fine, just opaquely.
        ignoreFailures = true,
    })
end

---Pick an executable out of `<root>/build/bin`.
---@param pattern string|nil Lua pattern the basename must match (nil = any)
---@param root string|nil Project root (defaults to the cwd at launch time)
---@return function A `program` value for a dap configuration
function M.pick_binary(pattern, root)
    return function()
        local dap = require("dap")
        local base = (root or vim.fn.getcwd()) .. "/build/bin"
        if vim.fn.isdirectory(base) == 0 then
            vim.notify("No " .. base .. " -- run cmake:configure and cmake:build first", vim.log.levels.WARN)
            return dap.ABORT
        end
        return require("dap.utils").pick_file({
            executables = true,
            path = base,
            -- `pick_file` walks subdirectories, and build/bin also holds the
            -- generated QML module tree, so pin the match to direct children.
            filter = function(filepath)
                if vim.fn.fnamemodify(filepath, ":h") ~= base then
                    return false
                end
                return pattern == nil or vim.fn.fnamemodify(filepath, ":t"):match(pattern) ~= nil
            end,
        })
    end
end

function M.setup()
    local dap = require("dap")

    -- `id = "cppdbg"` is MANDATORY for this adapter. Without it OpenDebugAD7
    -- starts fine and then simply never answers the launch request -- a hang
    -- with no error message.
    dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = opendebugad7(),
    }

    dap.configurations.cpp = {
        {
            name = "Debug binary from build/bin (pick)",
            type = "cppdbg",
            request = "launch",
            program = M.pick_binary(),
            cwd = "${workspaceFolder}",
            stopAtEntry = false,
            MIMode = "gdb",
            setupCommands = M.setup_commands,
        },
        {
            -- cpptools requires `program` on attach too, not just the pid.
            name = "Attach to running process",
            type = "cppdbg",
            request = "attach",
            processId = require("dap.utils").pick_process,
            program = M.pick_binary(),
            MIMode = "gdb",
            setupCommands = M.setup_commands,
        },
    }

    -- Independent copy: sharing the table would make a project-local
    -- `table.insert` show up under both filetypes. Same trap as JS/TS in
    -- dap_config.lua.
    dap.configurations.c = vim.deepcopy(dap.configurations.cpp)
end

return M
