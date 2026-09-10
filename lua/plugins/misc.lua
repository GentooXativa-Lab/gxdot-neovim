return { -- terminal
    {
        "akinsho/toggleterm.nvim",
        event = "VeryLazy",
        version = "*",
        opts = {
            size = 25,
            open_mapping = "<c-s>",
        },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            -- options
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- catppuccin ships catppuccin-nvim (which follows the active flavour),
        -- not a plain "catppuccin" lualine theme; that name made lualine warn
        -- and fall back to "auto" on every startup.
        opts = {
            options = { theme = "catppuccin-nvim" },
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                -- override markdown rendering so that completion and other
                -- plugins use Treesitter
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
            presets = {
                bottom_search = true, -- classic bottom cmdline for search
                command_palette = true, -- cmdline and popupmenu together
                long_message_to_split = true, -- long messages go to a split
                inc_rename = false, -- input dialog for inc-rename.nvim
                lsp_doc_border = false, -- border on hover docs and signature help
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
    },
    { "lambdalisue/vim-suda" },
    {
        "andrewferrier/wrapping.nvim",
        config = function()
            require("wrapping").setup()
        end
    },
}
