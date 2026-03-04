vim.opt.guicursor = table.concat({
  "n-v-c:block-Cursor-blinkon200-blinkoff150-blinkwait300",
  "i-ci-ve:ver25-Cursor-blinkon200-blinkoff150-blinkwait300",
  "r-cr-o:hor20-Cursor-blinkon200-blinkoff150-blinkwait300",
}, ",")
vim.o.cursorline = true
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"
