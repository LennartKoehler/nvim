require("theprimeagen.set")
require("theprimeagen.remap")
require("theprimeagen.lazy_init")

-- DO.not
-- DO NOT INCLUDE THIS

-- If i want to keep doing lsp debugging
-- function restart_htmx_lsp()
--     require("lsp-debug-tools").restart({ expected = {}, name = "htmx-lsp", cmd = { "htmx-lsp", "--level", "DEBUG" }, root_dir = vim.loop.cwd(), });
-- end

-- DO NOT INCLUDE THIS
-- DO.not

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('BufEnter', {
    group = ThePrimeagenGroup,
    callback = function()
        if vim.bo.filetype == "zig" then
            pcall(vim.cmd.colorscheme, "tokyonight-night")
        else
            pcall(vim.cmd.colorscheme, "rose-pine-moon")
        end
    end
})




autocmd('LspAttach', {
    group = ThePrimeagenGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25


vim.api.nvim_create_autocmd("FileType", {
    pattern = "codecompanion",
    callback = function()
        vim.schedule(function()
            -- Go to normal mode, append a new line, and start insert mode
            vim.cmd("normal! Go")
            vim.cmd("startinsert")
        end)
    end,
})
-- disable autocomplete on codecompanion buffer
local cmp = require("cmp")
cmp.setup.filetype("codecompanion", {
  sources = {}  -- no sources = no completion
})


vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')


-- vim.opt.conceallevel = 2
vim.highlight.priorities.semantic_tokens = 95

local function toggle_connected_comments()
  local cs = vim.bo.commentstring:gsub("%%s", ""):gsub("%s+$", "")
  if cs == "" then return end  -- skip if no commentstring

  local line_num = vim.fn.line('.')  -- current line
  local start_line = line_num

  local current_line = vim.fn.getline(line_num)
    if not current_line:match("^%s*" .. vim.pesc(cs)) then
    vim.api.nvim_feedkeys("gcip", "mx", false)  -- "mx" sets mark x and returns
        return
    end


 -- find start of consecutive commented block
  while start_line > 1 do
    local prev = vim.fn.getline(start_line - 1)
    if prev:match("^%s*" .. vim.pesc(cs)) then
      start_line = start_line - 1
    else
      break
    end
  end


  local i = start_line
  while i < vim.fn.line('$') do
    local line = vim.fn.getline(i)
    if line:match("^%s*" .. vim.pesc(cs)) then
      -- uncomment
      line = line:gsub("^%s*" .. vim.pesc(cs) .. " ?(%s*.*)$", "%1", 1)
      vim.fn.setline(i, line)
      i = i + 1
    else
        break
    end

  end
end

vim.keymap.set('n', '<leader>gcb', toggle_connected_comments, { noremap = true, silent = true })

-- local function any_dapui_active()
--     for _, win in ipairs(vim.api.nvim_list_wins()) do
--         local buf = vim.api.nvim_win_get_buf(win)
--         local ft = vim.bo[buf].filetype
--         if ft:match("^dapui_") then
--             return true
--         end
--     end
--     return false
-- end

-- local shade = require("shade")
-- vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "BufEnter", "WinClosed" }, {
--     callback = function()
--         if any_dapui_active() then
--             shade.toggle(false) -- disable shading
--         else
--             shade.toggle(true)  -- enable shading
--         end
--     end,
-- })



-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "codecompanion",
--         local buf = args.buf,
--         local chat = require("codecompanion").buf_get_chat(buf),
--
--         chat:add_callback("on_completed", function(chat, cb_args, c, info)
--
--                 print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG")
--                 vim.api.nvim_exec_autocmds({
--                     event = "CursorMoved",
--                     buffer = buf,
--                 })
--                 vim.api.nvim_exec_autocmds({
--                     event = "CursorMovedI",
--                     buffer = buf,
--                 })
--
--                 print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG")
--             -- local render_md = require("render-markdown")
--             -- render_md.disable()
--             -- render_md.enable()
--             -- print("triggered")
--             -- vim.api.command("checktime")
--
--         --     -- Force Tree-sitter to parse buffer
--         --     local parser = vim.treesitter.get_parser(buf, "markdown")
--         --     if parser then parser:parse() end
--         --     print("rendering buffer", args.buf)
--         --     render_md.buf_enable()
--         --     -- Make sure window is valid
--         --     local wins = vim.fn.win_findbuf(buf)
--         --     local win = wins[1] or vim.api.nvim_get_current_win()
--         --
--         --     -- Ensure conceallevel if using conceal
--         --     vim.api.nvim_win_set_option(win, "conceallevel", 2)
--         --     vim.api.nvim_win_set_option(win, "concealcursor", "nc")
--         --
--         -- local log = require('render-markdown.core.log')
--         --     render_md.render({buf = buf, event = "testevent123"})
--         --     log.buf('info', 'Update', buf, "testevent")
--         --
--         end)
-- })
--
--
