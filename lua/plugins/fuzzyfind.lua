return {
    {
        "nvim-telescope/telescope.nvim",
        -- Loaded through :Telescope alone. The `keys` block that used to live
        -- here duplicated lua/config/keybindings.lua, and two of its mappings
        -- pointed somewhere else entirely (<leader><space> -> buffers vs
        -- smart_files, <leader>sw -> workspace symbols vs grep_string), with
        -- keybindings.lua silently winning because it maps later on VeryLazy.
        cmd = "Telescope",
        version = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Declared as a dependency (not a top-level spec) so it doesn't load
            -- at startup and drag Telescope in with it.
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-symbols.nvim",
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
            -- Extensions are loaded here rather than from each provider's spec:
            -- doing it the other way round forces Telescope to load at startup.
            -- The `dap` extension is loaded from nvim-dap's config instead, so
            -- opening Telescope doesn't pull in the whole debug stack.
            for _, ext in ipairs({ "fzf", "fidget" }) do
                pcall(telescope.load_extension, ext)
            end
        end,
    },
}
