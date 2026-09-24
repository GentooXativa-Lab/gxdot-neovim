-- transparent.nvim: strips background colors so the terminal background shows through.
-- Toggle with <leader>ut (see config/keybindings.lua) or :TransparentToggle.
-- The plugin persists its enabled/disabled state between sessions, so no
-- auto-enable is needed here.
return {
    "xiyaowong/transparent.nvim",
    -- Upstream recommends NOT lazy-loading: the highlight-clearing logic must
    -- run right after the colorscheme is applied.
    lazy = false,
    priority = 900, -- after the colorschemes (priority 1000)
    opts = {
        -- Extra groups beyond the defaults so plugin UIs turn transparent too.
        extra_groups = {
            "NormalFloat", -- floating panels: Lazy, Mason, LspInfo
            "FloatBorder",
            "SnacksNormal", -- Snacks explorer / pickers
            "SnacksNormalNC",
        },
        exclude_groups = {},
    },
    config = function(_, opts)
        require("transparent").setup(opts)
        -- Statusline and buffer tabs define their highlights dynamically, so clear by prefix.
        require("transparent").clear_prefix("lualine")
        require("transparent").clear_prefix("Buffer")
    end,
}
