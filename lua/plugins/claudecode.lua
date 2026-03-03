return {
    "coder/claudecode.nvim",
    config = function()
        require("claudecode").setup({
            auto_start = true,
            terminal_cmd = "claude",

            -- Selection tracking (sends editor context to Claude via WebSocket)
            track_selection = true,

            -- Terminal configuration
            terminal = {
                split_side = "right",
                split_width_percentage = 0.50,
                provider = "snacks",
                auto_close = true,
                git_repo_cwd = true,
            },

            -- Diff integration
            diff_opts = {
                layout = "horizontal",
                open_in_new_tab = false,
                keep_terminal_focus = false,
            },
        })
    end,
    keys = {
        -- Preserved keybindings (same as before)
        { "<leader>cc", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude Code" },
        { "<C-,>",      "<cmd>ClaudeCode<cr>",            mode = "t",                    desc = "Toggle Claude Code (terminal)" },
        { "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude Code: Continue" },
        { "<leader>cV", "<cmd>ClaudeCode --verbose<cr>",  desc = "Claude Code: Verbose" },

        -- New keybindings
        { "<leader>cr", "<cmd>ClaudeCode --resume<cr>",   desc = "Claude Code: Resume" },
        { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude Code" },
        { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "Accept Claude Diff" },
        { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "Deny Claude Diff" },
        { "<leader>cs", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                    desc = "Send selection to Claude" },
        { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add buffer to Claude" },
        { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
        {
            "<leader>cs",
            "<cmd>ClaudeCodeTreeAdd<cr>",
            ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
            desc = "Add file from tree to Claude",
        },
    },
}
