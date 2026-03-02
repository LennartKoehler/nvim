return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,

  config = function()
    vim.o.background = "dark"

    local c = require("vscode.colors").get_colors()

    require("vscode").setup({
      transparent = true, -- keep background transparent
      italic_comments = true,
      italic_inlayhints = true,
      underline_links = true,
      disable_nvimtree_bg = true,
      terminal_colors = true,

    })

    require("vscode").load()
vim.api.nvim_set_hl(0, "LineNr", { fg = "#AAAAAA", bg = c.vscBG })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFFFFF", bg = c.vscBG})
  vim.api.nvim_set_hl(0, "Cursor", { fg = c.vscLightBlue, bg = c.vscLightBlue })
vim.api.nvim_set_hl(0, "lCursor", { fg = c.vscLightBlue, bg = c.vscLightBlue })
  end,
}
