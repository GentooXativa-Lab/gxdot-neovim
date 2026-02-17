-- vim: ts=2 sts=2 sw=2 et
--
-- Load core options
require("config.options")

-- Load keybindings
require("config.keybindings").setup()

-- Bootstrap lazy.nvim
require("config.lazy")

-- Initialize DAP configuration
require("config.dap_config").setup()

-- DapUI is now configured in lua/plugins/debugger.lua

require("telescope").load_extension("dap")
require("telescope").load_extension("fidget")

require("lualine").setup()
require("fidget").setup()

require("noice").setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true -- requires hrsh7th/nvim-cmp
        }
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false -- add a border to hover docs and signature help
    }
})

-- DAP UI listeners are now configured in config/dap_config.lua

vim.g.barbar_auto_setup = false -- disable auto-setup

require("barbar").setup({})

--- Diagrams
---
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        pcall(function()
            require("diagram").setup({
                integrations = {require("diagram.integrations.markdown"), require("diagram.integrations.neorg")},
                renderer_options = {
                    mermaid = {
                        theme = "forest"
                    },
                    plantuml = {
                        charset = "utf-8"
                    },
                    d2 = {
                        theme_id = 1
                    },
                    gnuplot = {
                        theme = "dark",
                        size = "800,600"
                    }
                }
            })
        end)
    end
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({
            bufnr = args.buf
        })
    end
})
