return {
    'skanehira/github-actions.nvim',
    -- Without a trigger this loads at startup and drags Telescope in with it,
    -- defeating telescope.nvim's own `cmd = "Telescope"`.
    cmd = {
        "GithubActionsDispatch",
        "GithubActionsHistory",
        "GithubActionsHistoryByPR",
        "GithubActionsWatch",
    },
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-telescope/telescope.nvim', -- Optional: for enhanced workflow selection
    },
    opts = {},
}
