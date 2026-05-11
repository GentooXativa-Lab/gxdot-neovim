return {
    {
        "milanglacier/minuet-ai.nvim",
        event = "InsertEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("minuet").setup({
                provider = "openai_fim_compatible",

                -- Lower context_window keeps latency acceptable on a 12-16 GB
                -- GPU running qwen2.5-coder:7b. Raise to 1024 if suggestions
                -- feel under-informed.
                debounce = 400,
                throttle = 1000,
                context_window = 512,
                n_completions = 1,
                notify = "warn",

                -- Ghost-text frontend (Copilot-style). Keymaps reuse the old
                -- Copilot bindings the user is already trained on.
                virtualtext = {
                    auto_trigger_ft = { "*" },
                    keymap = {
                        accept      = "<A-c>",
                        accept_line = "<A-s>",
                        next        = "<A-d>",
                        prev        = "<A-a>",
                        dismiss     = "<A-e>",
                    },
                },

                provider_options = {
                    openai_fim_compatible = {
                        -- llama-server does not validate the key, but minuet
                        -- requires the option. "TERM" is read from $TERM.
                        api_key   = "TERM",
                        name      = "Llama.cpp",
                        -- llama-server's /v1/completions accepts `prompt` +
                        -- `suffix` and applies the GGUF's FIM template
                        -- automatically, so no body reshape or custom
                        -- get_text_fn is needed (response is OpenAI-shaped).
                        end_point = "http://localhost:8080/v1/completions",
                        -- llama-server ignores `model` unless launched with
                        -- --alias; kept descriptive for logs.
                        model     = "qwen2.5-coder",
                        stream    = true,
                        optional = {
                            max_tokens = 56,
                            top_p      = 0.9,
                            stop = {
                                "<|endoftext|>",
                                "<|fim_prefix|>",
                                "<|fim_suffix|>",
                                "<|fim_middle|>",
                                "<|fim_pad|>",
                                "<|repo_name|>",
                                "<|file_sep|>",
                            },
                        },
                    },
                },
            })

            -- Manual trigger in insert mode. action.next falls through to
            -- trigger() when no suggestion is active, so it doubles as
            -- "invoke ghost text now".
            vim.keymap.set("i", "<A-i>", function()
                require("minuet.virtualtext").action.next()
            end, { desc = "Minuet: invoke ghost text", noremap = true, silent = true })
        end,
    },
}
