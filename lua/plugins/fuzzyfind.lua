return {
    {
        "nvim-telescope/telescope.nvim",
        -- Loaded through :Telescope alone. The `keys` block that used to live
        -- here duplicated lua/config/keybindings.lua, and two of its mappings
        -- pointed somewhere else entirely (<leader><space> at buffers instead
        -- of smart_files, <leader>sw at workspace symbols instead of
        -- grep_string), with keybindings.lua silently winning because it maps
        -- later. keybindings.lua is now the single source of truth.
        cmd = "Telescope",
        version = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- A dependency rather than a top-level spec: on its own it had no
            -- lazy trigger, so it loaded at startup and its config require()d
            -- Telescope, dragging it in and overriding `cmd` above.
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        opts = {
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                dap = {},
            },
        },
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            -- Registered here rather than from each provider's spec: the other
            -- way round forces Telescope to load at startup. The `dap`
            -- extension is registered from nvim-dap's config instead, so
            -- opening Telescope doesn't pull in the whole debug stack.
            for _, ext in ipairs({ "fzf", "fidget" }) do
                pcall(telescope.load_extension, ext)
            end
        end,
    },
}
