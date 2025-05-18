-- vim: ts=2 sts=2 sw=2 et
--
-- Load keybindings first
require("config.keybindings").setup()

-- Bootstrap lazy.nvim
require("config.lazy")

require("coq_3p")({{
    src = "builtin/ada"
}, {
    src = "builtin/c"
}, {
    src = "builtin/clojure"
}, {
    src = "builtin/css"
}, {
    src = "builtin/haskell"
}, {
    src = "builtin/html"
}, {
    src = "builtin/js"
}, {
    src = "builtin/php"
}, {
    src = "builtin/syntax"
}, {
    src = "builtin/xml"
}, {
    src = "cow",
    trigger = "!cow"
}, {
    src = "figlet",
    short_name = "BIG"
}, {
    src = "orgmode",
    short_name = "ORG"
}})

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

-- ANTHROPIC SETUP for codecompanion
-- require("codecompanion").setup({
--     strategies = {
--         chat = {
--             adapter = "anthropic"
--         },
--         inline = {
--             adapter = "anthropic"
--         }
--     },
--     adapters = {
--         anthropic = function()
--             return require("codecompanion.adapters").extend("anthropic", {
--                 env = {
--                     api_key = "cmd:age -d -i ~/.ssh/id_rsa ~/.config/gentooxativa/neovim.enc"
--                 }
--             })
--         end
--     }
-- })

require("codecompanion").setup({
    strategies = {
        chat = {
            adapter = "ollama"
        },
        inline = {
            adapter = "ollama"
        }
    },
    adapters = {
        ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
                -- env = {
                --     url = "url",
                --     api_key = "example-api-key"
                -- },
                -- headers = {
                --     ["Content-Type"] = "application/json",
                --     ["Authorization"] = "Basic ${api_key}"
                -- },
                env = {
                    url = "cmd:age -d -i ~/.ssh/id_rsa ~/.config/gentooxativa/ollama_host.enc",
                },
                headers = {
                    ["Content-Type"] = "application/json",
                },

                parameters = {
                    sync = true
                }
            })
        end
    },
    opts = {
        log_level = "TRACE", -- or "TRACE"
    }
})

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