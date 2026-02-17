return {{
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup()
        vim.cmd("TSInstall! c lua vim vimdoc query python javascript")
    end
}}
