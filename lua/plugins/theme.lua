return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before all other start plugins
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      integrations = {
        barbar = true,
        blink_cmp = true,
        gitsigns = true,
        lsp_trouble = false,
        mason = true,
        treesitter = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
