return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "saghen/blink.cmp",
            "b0o/SchemaStore.nvim",
        },
        config = function()
            local servers = {
                "pyright",
                "ruff",
                "ts_ls",
                "eslint",
                "marksman",
                "bashls",
                "terraformls",
                "ansiblels",
                "yamlls",
            }

            -- Extend default capabilities with blink.cmp for every server
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            vim.lsp.config("*", { capabilities = capabilities })

            -- Python: pyright for types/hover, ruff for lint/format -> split responsibilities
            vim.lsp.config("pyright", {
                settings = {
                    pyright = {
                        -- let ruff handle import organization
                        disableOrganizeImports = true,
                    },
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "openFilesOnly",
                            -- let ruff own these
                            ignore = { "*" },
                        },
                    },
                },
            })

            vim.lsp.config("ruff", {
                init_options = {
                    settings = {
                        -- hover lives in pyright; ruff keeps lint/fix/format
                        logLevel = "info",
                    },
                },
                on_attach = function(client, _)
                    client.server_capabilities.hoverProvider = false
                end,
            })

            -- TypeScript / JavaScript
            vim.lsp.config("ts_ls", {
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "literal",
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = false,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "literal",
                            includeInlayFunctionParameterTypeHints = true,
                        },
                    },
                },
            })

            -- ESLint: auto-fix lint issues on save
            vim.lsp.config("eslint", {
                settings = {
                    workingDirectories = { mode = "auto" },
                },
                on_attach = function(_, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        command = "LspEslintFixAll",
                    })
                end,
            })

            -- Bash
            vim.lsp.config("bashls", {
                filetypes = { "sh", "bash" },
            })

            -- Terraform
            vim.lsp.config("terraformls", {
                filetypes = { "terraform", "terraform-vars", "tf" },
            })

            -- Ansible
            vim.lsp.config("ansiblels", {
                filetypes = { "yaml.ansible" },
                settings = {
                    ansible = {
                        python = { interpreterPath = "python3" },
                        ansible = { useFullyQualifiedCollectionNames = true },
                        validation = {
                            enabled = true,
                            lint = { enabled = true, path = "ansible-lint" },
                        },
                    },
                },
            })

            -- YAML with SchemaStore (GitHub Actions, k8s, etc.)
            vim.lsp.config("yamlls", {
                -- don't conflict with ansiblels
                filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
                settings = {
                    yaml = {
                        schemaStore = {
                            -- disable built-in schemaStore, use schemastore.nvim
                            enable = false,
                            url = "",
                        },
                        schemas = require("schemastore").yaml.schemas(),
                        validate = true,
                        format = { enable = false },
                    },
                },
            })

            -- Markdown
            vim.lsp.config("marksman", {})

            -- mason-lspconfig 2.x: ensure_installed + automatic_enable does the rest
            require("mason-lspconfig").setup({
                ensure_installed = servers,
                automatic_enable = true,
            })

            -- Diagnostics UI
            vim.diagnostic.config({
                virtual_text = { prefix = "●", spacing = 2 },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "jay-babu/mason-nvim-dap.nvim",
            "theHamsta/nvim-dap-virtual-text",
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = { "mfussenegger/nvim-dap" },
    },
    {
        "nvim-telescope/telescope-dap.nvim",
        event = "VeryLazy",
        dependencies = { "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
    },
    {
        "nvim-telescope/telescope-symbols.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
}
