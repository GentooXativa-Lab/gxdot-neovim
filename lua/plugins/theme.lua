return {
    {
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
  end,
    },
{
  "navarasu/onedark.nvim",
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('onedark').setup {
      style = 'darker'
    }
    require('onedark').load()
    vim.cmd.colorscheme("onedark")
  end
}
}
