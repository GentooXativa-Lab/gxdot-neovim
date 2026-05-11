return {
    {
        "olimorris/codecompanion.nvim",
        version = "^19.0.0",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "ravitemer/mcphub.nvim"
        },
        opts = {
            interactions = {
                inline = {
                    adapter = {
                        name = "ollama",
                        model = "starcoder2:15b",
                    },
                    keymaps = {
                        accept_change = {
                            modes = { n = "ga" },
                            description = "Accept the suggested change",
                        },
                        reject_change = {
                            modes = { n = "gr" },
                            opts = { nowait = true },
                            description = "Reject the suggested change",
                        },
                    },
                },
                cli = {
                    agent = "claude_code",
                    agents = {
                        claude_code = {
                            cmd = "claude",
                            args = {},
                            description = "Claude Code CLI",
                            provider = "terminal",
                        },
                    },
                },
                opts = {
                    log_level = "DEBUG",
                }
            },
        }
    }
}
