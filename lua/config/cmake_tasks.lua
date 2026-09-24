-- Generic CMake+Ninja tasks for overseer. Nothing project-specific lives here;
-- a project that needs its own env or targets registers extra templates from
-- its `.nvim.lua` (`exrc` is on, so Neovim asks for `:trust` the first time).
local M = {}

-- GCC/Clang diagnostics plus CMake's own configure-time errors. The trailing
-- `%-G%.%#` drops every other line, which is what keeps ninja's `[12/48]`
-- progress spam out of the quickfix.
M.errorformat = table.concat({
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
    "%f:%l: %trror: %m",
    "%f:%l: %tarning: %m",
    "CMake Error at %f:%l (%*[^)]):%m",
    "CMake Warning at %f:%l (%*[^)]):%m",
    "%-G%.%#",
}, ",")

-- Compiler output must NOT go through a pty. overseer's default strategy writes
-- into a terminal buffer, and the pty hard-wraps every line at the window width
-- -- so a long GCC/Qt diagnostic reaches the errorformat parser already cut in
-- half and lands in the quickfix truncated. Measured, not theorised: an injected
-- error came out as `‘thisSymbolDoesNo` at 80 columns. A plain buffer keeps
-- lines intact, at the cost of ANSI colour in the task output.
M.plain_output = { "jobstart", use_terminal = false }

-- Shared quickfix component. `items_only` means only errorformat matches land in
-- the list; the full output stays in the task buffer.
function M.quickfix(opts)
    opts = opts or {}
    return {
        "on_output_quickfix",
        errorformat = M.errorformat,
        items_only = true,
        open_on_match = opts.open_on_match ~= false,
    }
end

function M.setup()
    local overseer = require("overseer")
    local TAG = require("overseer.constants").TAG

    overseer.register_template({
        name = "cmake",
        -- Registered as a PROVIDER, not as three plain templates, because
        -- `overseer.SearchCondition` only understands `filetype` and `dir` --
        -- "is this a CMake project?" cannot be written as a condition. The
        -- generator answers it per search, against the dir overseer hands us
        -- (absolute, no trailing slash) rather than a captured cwd, so the
        -- tasks follow you when you change projects mid-session.
        generator = function(opts)
            local dir = opts.dir
            if vim.fn.filereadable(dir .. "/CMakeLists.txt") == 0 then
                return {}
            end

            return {
                {
                    name = "cmake:configure",
                    desc = "cmake -B build -G Ninja (Debug, exports compile_commands.json)",
                    builder = function()
                        return {
                            cmd = { "cmake", "-B", "build", "-G", "Ninja", "-DCMAKE_BUILD_TYPE=Debug",
                                    "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
                            cwd = dir,
                            components = { M.quickfix(), "default" },
                            strategy = M.plain_output,
                        }
                    end,
                },
                {
                    name = "cmake:build",
                    desc = "cmake --build build -j",
                    tags = { TAG.BUILD },
                    builder = function()
                        return {
                            cmd = { "cmake", "--build", "build", "-j" },
                            cwd = dir,
                            components = { M.quickfix(), "default" },
                            strategy = M.plain_output,
                        }
                    end,
                },
                {
                    name = "cmake:ctest",
                    desc = "ctest --test-dir build --output-on-failure",
                    tags = { TAG.TEST },
                    builder = function()
                        return {
                            cmd = { "ctest", "--test-dir", "build", "--output-on-failure" },
                            cwd = dir,
                            -- Test failures are not errorformat matches, so opening
                            -- the quickfix here would pop an empty window.
                            components = { M.quickfix({ open_on_match = false }), "default" },
                        }
                    end,
                },
            }
        end,
    })
end

return M
