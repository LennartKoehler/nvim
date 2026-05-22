vim.opt.guicursor = table.concat({
  "n-v-c:block-Cursor-blinkon200-blinkoff150-blinkwait300",
  "i-ci-ve:ver25-Cursor-blinkon200-blinkoff150-blinkwait300",
  "r-cr-o:hor20-Cursor-blinkon200-blinkoff150-blinkwait300",
}, ",")

-- set number # (optional - will help to visually verify that it's working)
-- set textwidth=0
-- set wrapmargin=0
-- set wrap
-- set linebreak # (optional - breaks by word rather than character)
vim.o.textwidth = 0
vim.o.wrapmargin = 0
vim.o.wrap = true

vim.o.cursorline = true
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true


vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.diffopt:remove("inline")


vim.opt.fillchars:append { eob = " " }
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"

-- remove line/col and Bot/Top from statusline
vim.opt.statusline = "%f"
