return {
    {
        "saghen/blink.cmp",
        event = "InsertEnter",
        version = "1.*",
        dependencies = {
            { "L3MON4D3/LuaSnip", version = "v2.*" },
            "rafamadriz/friendly-snippets",
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- Keymap preset:
            --   'default'    -> <C-y> accept, <C-n>/<C-p> navigate, <C-Space> open/docs, <C-e> hide, Tab/S-Tab jump snippets
            --   'super-tab'  -> Tab to accept (vscode style)
            --   'enter'      -> <CR> to accept
            keymap = { preset = "default" },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {
                -- Auto-show menu while typing (user had autocomplete=false before; we enable auto-popup now)
                menu = { auto_show = true },
                -- Only show docs popup on manual trigger (C-Space) to keep UI quiet
                documentation = { auto_show = true, auto_show_delay_ms = 300 },
                -- Pre-select first item so <C-y> / <CR> picks it
                list = { selection = { preselect = true, auto_insert = false } },
                ghost_text = { enabled = false },
            },

            signature = { enabled = true },

            snippets = { preset = "luasnip" },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
}
