# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

This is a personal Neovim configuration (not an application). There is no build, no test suite, and nothing to run — changes are Lua plugin specs loaded by `lazy.nvim` at editor startup. Verification happens by starting Neovim and using it.

## Common commands

```bash
# Syntax-check a Lua file without starting nvim
luac -p lua/plugins/<file>.lua

# Headless smoke test (loads full config, exits cleanly if no errors)
nvim --headless -c "lua print('ok')" -c "qa"

# Open a fixture and check LSP attachment / treesitter highlight
nvim --headless /path/to/file.py -c "sleep 3" \
  -c "lua for _,c in ipairs(vim.lsp.get_clients({bufnr=0})) do print(c.name) end" \
  -c "qa"
```

From inside Neovim:

- `:Lazy sync` — fetch new plugins, remove uninstalled, update lockfile
- `:Lazy restore` — check out the exact commits pinned in `lazy-lock.json`
- `:Lazy update <plugin>` — pull latest for one plugin
- `:Mason` — manage LSPs / linters / formatters (installer UI)
- `:TSUpdate` / `:TSInstallSync <parser>` — update / install treesitter parsers synchronously
- `:checkhealth` — run health checks for `vim.lsp`, `mason`, `nvim-treesitter`, `blink.cmp`, `nvim-lint`, `conform`

## Architecture

```
init.lua
 ├─ config.options            core vim.opt values
 ├─ config.keybindings.setup  ALL keymaps live here (DAP, LSP, Snacks, Barbar, etc.)
 ├─ config.lazy               bootstraps lazy.nvim and imports lua/plugins/*
 ├─ config.dap_config.setup   DAP adapters + per-language launch configs
 └─ post-setup block          lualine, fidget, noice, barbar, diagram autocmd
```

`lua/plugins/*.lua` is auto-discovered by lazy.nvim via `{ import = "plugins" }`. **Every file in that directory must `return` a lazy plugin spec table**; otherwise lazy errors at startup. This is why deprecated plugins live in `disabled-plugins/` (outside the import glob) instead of being deleted or commented out.

### Neovim version baseline

Neovim **0.11+** is assumed. The config uses the modern LSP API: `vim.lsp.config(name, {...})` to declare settings and `vim.lsp.enable(name)` / mason-lspconfig's `automatic_enable` to start servers. Do **not** revert to the older `require('lspconfig').<server>.setup{...}` style — it is no longer present.

### Language support layer (`lsp.lua`, `treesitter.lua`, `linter.lua`, `formatter.lua`, `mason.lua`, `schemas.lua`, `ftdetect/ansible.lua`)

These files form a single cohesive layer. Adding a new language means touching several of them — follow the pattern, do not create per-language files:

1. **LSP** — add the server name to `ensure_installed` in `lsp.lua` and, if it needs non-default settings, register a `vim.lsp.config('<server>', {...})` block **before** the `require('mason-lspconfig').setup(...)` call. Capabilities are already extended for every server via `vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })` — do not add per-server capabilities.
2. **Treesitter** — add the parser name to the `ensure_installed` list in `treesitter.lua`. Parsers compile with `gcc` (master branch uses its own installer); no extra system binary required.
3. **Linter** — add the filetype to `lint.linters_by_ft` in `linter.lua`. The linter binary must be in `mason.lua`'s `ensure_installed` for mason-tool-installer, unless provided by the LSP itself (ESLint LSP handles its own linting, for example).
4. **Formatter** — add the filetype to `formatters_by_ft` in `formatter.lua`. The formatter binary goes in `mason.lua`.
5. **External tool auto-install** — any non-LSP CLI (shellcheck, shfmt, tflint, ansible-lint, prettier, stylua, ruff, markdownlint-cli2, markdown-toc) is owned by `mason-tool-installer` in `lua/plugins/mason.lua`. LSP servers are owned by `mason-lspconfig` in `lsp.lua`. Do not duplicate.

### Non-obvious choices worth knowing

- **`nvim-treesitter` tracks the `master` branch**, not `main`. The `main` branch requires the `tree-sitter` CLI binary on the system. Master uses its own gcc-based parser installer and is the ecosystem default. If you migrate to `main`, you must also install `cargo install tree-sitter-cli` (or npm equivalent) and rewrite `treesitter.lua` to use `require('nvim-treesitter').install({...})` + a `FileType` autocmd, since `configs.setup{}` is removed on `main`.
- **Completion is `blink.cmp`** (not `nvim-cmp`). LSP capability extension goes via `require('blink.cmp').get_lsp_capabilities()`, applied globally with `vim.lsp.config('*', { capabilities = ... })`. Do not reintroduce `cmp-nvim-lsp.default_capabilities()`.
- **Format-on-save lives exclusively in `conform.nvim`** (`formatter.lua`, `format_on_save = {...}`). There used to be a `BufWritePre` autocmd in `init.lua` that also called `conform.format`; it was removed because it double-formatted. Do not add it back.
- **Python is split**: `pyright` owns types/hover/completion, `ruff` (LSP) owns lint + organize-imports and is configured to disable its own hover provider so the hover from pyright wins. `pyright.disableOrganizeImports = true` cedes that responsibility to ruff. Keep the split — both servers are expected to attach simultaneously.
- **Ansible vs YAML**: `yamlls` handles plain YAML (with schemas from `SchemaStore.nvim`), `ansiblels` handles `yaml.ansible`. Filetype routing is done by `ftdetect/ansible.lua` via `vim.filetype.add({ pattern = ... })` — `playbooks/*.yml`, `roles/*/tasks/*.yml`, `*.ansible.yml`, and `site.yml` map to `yaml.ansible`. `yamlls.filetypes` is narrowed so the two servers do not collide.
- **DAP config is in `lua/config/dap_config.lua`, not in a plugin file.** The plugin specs in `lua/plugins/debugger.lua` only install adapters; per-language launch configurations (Python paths, JS runtime, etc.) live in the config module and are invoked from `init.lua`. DAP is only set up for Python, JS/TS, and C++ — by design, no debuggers for Bash / Terraform / Ansible.
- **`.claude/settings.local.json`** carries repo-scoped Claude Code permissions. It is tracked in git; edit with the `update-config` skill or through Claude's settings flow, not by hand.

### Disabled plugins

Files in `disabled-plugins/` are historical specs kept out of the lazy import path. Before adding a plugin that might already exist here (copilot, markdown-preview stack, diagrams, ollama, mcphub), check this directory — you may only need to move the file back into `lua/plugins/`.

### Plugin lockfile

`lazy-lock.json` pins every plugin to an exact commit. Commit it alongside any plugin spec change so the setup is reproducible. `:Lazy sync` updates it; do not hand-edit.

## Verification after config changes

1. `luac -p` on every changed Lua file.
2. `nvim --headless -c "qa"` — must exit without error output.
3. If LSP / treesitter / completion was touched: open a representative file for each affected language and confirm `vim.lsp.get_clients({bufnr=0})` and `vim.treesitter.highlighter.active[...]` are populated.
4. `:checkhealth` for the subsystems you touched.
