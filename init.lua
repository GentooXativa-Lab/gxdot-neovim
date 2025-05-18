-- vim: ts=2 sts=2 sw=2 et
--
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = {
    noremap = true,
    silent = true
}

--- Keybindings
local map = vim.api.nvim_set_keymap

map("n", "<leader>tf", "<cmd>:Telescope find_files<CR>", opt)
map("n", "<leader>tC", "<cmd>:Telescope dap configurations<CR>", opt)
map("n", "<leader>tc", "<cmd>:Telescope commands<CR>", opt)
map("n", "<leader>tv", "<cmd>:Telescope dap variables<CR>", opt)
map("n", "<leader>pp", "<cmd>:VenvSelect<CR>", opt)

--- Debug related keybindings
map("n", "<F5>", '<cmd>lua require("dap").continue()<CR>', opt)
map("i", "<F5>", '<cmd>lua require("dap").continue()<CR>', opt)
map("n", "<F6>", '<cmd>lua require("dap").step_over()<CR>', opt)
map("i", "<F6>", '<cmd>lua require("dap").step_over()<CR>', opt)
map("n", "<F7>", '<cmd>lua require("dap").step_into()<CR>', opt)
map("i", "<F7>", '<cmd>lua require("dap").step_into()<CR>', opt)
map("n", "<F8>", '<cmd>lua require("dap").step_out()<CR>', opt)
map("i", "<F8>", '<cmd>lua require("dap").step_out()<CR>', opt)

map("n", "<leader>Vc", ':source $MYVIMRC<CR>', opt)

map("n", "<leader>Di", '<cmd>lua require("dapui").float_element()<CR>', opt)
map("n", "<A-d>", '<cmd>lua require("dapui").toggle()<CR>', opt)
map("i", "<A-d>", '<cmd>lua require("dapui").toggle()<CR>', opt)
map("n", "<leader>De", '<cmd>lua require("dapui").eval()<CR>', opt)
map("n", "<leader>dc", '<cmd>lua require("dap").continue()<CR>', opt)
map("n", "<leader>db", '<cmd>lua require("dap").toggle_breakpoint()<CR>', opt)
map("n", "<leader>dn", '<cmd>lua require("dap").step_over()<CR>', opt)
map("n", "<leader>di", '<cmd>lua require("dap").step_into()<CR>', opt)
map("n", "<leader>do", '<cmd>lua require("dap").step_out()<CR>', opt)
map("n", "<leader>ds", '<cmd>lua require("dap").close()<CR>', opt)
map("n", "<leader>dl", '<cmd>lua require("dap").run_last()<CR>', opt)
map("n", "<leader>dp", '<cmd>lua require("dap").pause()<CR>', opt)
map("n", "<leader>da", '<cmd>lua require("dap").attach()<CR>', opt)
map("n", "<leader>dpy", '<cmd>lua require("dap-python").test_method()<CR>', opt)
map("v", "<leader>dw", '<cmd>lua require("dapui").elements.watches.add(vim.fn.expand("<cexpr>"))<CR>', opt)
map("n", "<leader>dw", '<cmd>lua require("dapui").elements.watches.add(vim.fn.expand("<cword>"))<CR>', opt)
map("n", "<leader>dpc", '<cmd>lua require("dap-python").test_class()<CR>', opt)
map("n", "<leader>dps", '<cmd>lua require("dap-python").debug_selection()<CR>', opt)

vim.keymap.set("i", "<A-c>", 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

vim.keymap.set('i', '<A-d>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<A-a>', '<Plug>(copilot-previous)')
vim.keymap.set('i', '<A-s>', '<cmd>Copilot panel<CR>')

vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.format()<CR>', opt)
vim.keymap.set('i', '<F4>', '<cmd>lua vim.lsp.buf.format()<CR>', opt)

-- barbar keybindings
-- Move to previous/next
map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opt)
map("n", "<A-.>", "<Cmd>BufferNext<CR>", opt)

-- Re-order to previous/next
map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opt)
map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opt)

-- Goto buffer in position...
map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opt)
map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opt)
map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opt)
map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opt)
map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opt)
map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opt)
map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opt)
map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opt)
map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opt)
map("n", "<A-0>", "<Cmd>BufferLast<CR>", opt)

-- Pin/unpin buffer
map("n", "<A-p>", "<Cmd>BufferPin<CR>", opt)

-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned

-- Close buffer
map("n", "<A-c>", "<Cmd>BufferClose<CR>", opt)

-- Wipeout buffer
--                 :BufferWipeout

-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

-- Magic buffer-picking mode
map("n", "<C-p>", "<Cmd>BufferPick<CR>", opt)
map("n", "<C-s-p>", "<Cmd>BufferPickDelete<CR>", opt)

-- Sort automatically by...
map("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", opt)
map("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>", opt)
map("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", opt)
map("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", opt)
map("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", opt)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
--

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

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({
            bufnr = args.buf
        })
    end
})
