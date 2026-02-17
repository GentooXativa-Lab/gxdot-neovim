-- Editing enhancements: autopairs, surround, comments
return {
    -- Auto-close brackets and quotes
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    -- Surround text with pairs (ys, ds, cs motions)
    -- ys{motion}{char} - add surround
    -- ds{char} - delete surround
    -- cs{old}{new} - change surround
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = true,
    },

    -- Comment with gc motion (gcc for line, gc{motion} for block)
    {
        "numToStr/Comment.nvim",
        opts = {},
        lazy = false,
    },
}
