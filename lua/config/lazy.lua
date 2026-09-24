-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({{"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out, "WarningMsg"},
                           {"\nPress any key to exit..."}}, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = { -- import your plugins
    {
        import = "plugins"
    }},
    -- colorscheme used while installing plugins; only list themes we have
    install = {
        colorscheme = {"catppuccin", "habamax"}
    },
    -- automatically check for plugin updates, but don't nag about them at startup
    checker = {
        enabled = true,
        notify = false
    },
    change_detection = {
        notify = false
    },
    -- No plugin needs luarocks any more (neorg was the only one), so don't let
    -- lazy.nvim bootstrap hererocks: it only leaves a broken luarocks behind in
    -- :checkhealth.
    rocks = {
        enabled = false
    }
    -- NOTE: `library` used to be set here. It is a lazydev.nvim option, not a
    -- lazy.setup() one, and was silently ignored.
})