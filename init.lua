-- vim: ts=4 sts=4 sw=4 et
--
-- Neovim entry point.
--
-- Everything plugin-related lives in its own spec under lua/plugins/, so that
-- lazy.nvim owns the load order. Calling require() on a plugin from here would
-- force it to load eagerly and silently break the lazy-loading declared in the
-- specs, so don't add plugin setup calls to this file.

-- Core options (must run before anything reads them)
require("config.options")

-- Keybindings (sets <leader> before lazy.nvim builds its keymaps)
require("config.keybindings").setup()

-- Bootstrap lazy.nvim and load lua/plugins/*
require("config.lazy")
