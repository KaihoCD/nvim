local map = require('utils').map

local function map_nav(dir)
    return function()
        local cfg = vim.api.nvim_win_get_config(0)
        if cfg.relative == '' then
            vim.cmd.wincmd(dir)
            local bufnr = vim.api.nvim_get_current_buf()
            local buftype = vim.bo[bufnr].buftype
            if buftype == 'terminal' then
                vim.cmd.startinsert()
            end
        end
    end
end

local function toggle_netrw()
    if vim.bo.filetype == 'netrw' then
        vim.cmd.bdelete()
        return
    end
    vim.cmd.edit(vim.fn.expand('%:p:h'))
end

map('n', '<Esc>', '<CMD>nohlsearch<CR>', { desc = 'Clear highlights' })
map('t', '<C-n>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('n', '-', toggle_netrw, { desc = 'Toggle Netrw' })

map('n', '<A-h>', '<CMD>vertical resize -2<CR>', { desc = 'Decrease pane width' })
map('n', '<A-l>', '<CMD>vertical resize +2<CR>', { desc = 'Increase pane width' })
map('n', '<A-j>', '<CMD>resize -2<CR>', { desc = 'Decrease pane height' })
map('n', '<A-k>', '<CMD>resize +2<CR>', { desc = 'Increase pane height' })

map({ 'n', 't' }, '<C-h>', map_nav('h'), { desc = 'Move focus left' })
map({ 'n', 't' }, '<C-l>', map_nav('l'), { desc = 'Move focus right' })
map({ 'n', 't' }, '<C-j>', map_nav('j'), { desc = 'Move focus down' })
map({ 'n', 't' }, '<C-k>', map_nav('k'), { desc = 'Move focus up' })

map('n', '<leader><tab>C', '<CMD>tabonly<CR>', { desc = '[C]lose Other Tabs' })
map('n', '<leader><tab><tab>', '<CMD>tabnew %<CR>', { desc = 'New Tab(<tab>) with cur buf' })
map('n', '<leader><tab>n', '<CMD>tabnew<CR>', { desc = '[n]ew Tab' })
map('n', '<leader><tab>c', '<CMD>tabclose<CR>', { desc = '[c]lose Tab' })
map('n', '<leader><tab>l', '<CMD>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<leader><tab>h', '<CMD>tabprevious<CR>', { desc = 'Prev Tab' })

map('n', '<C-d>', '<C-d>zz', { desc = 'Page down and center cursor' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Page up and center cursor' })
map('n', '#', '#zz', { desc = 'Jump to previous occurrence of word' })
map('n', '*', '*zz', { desc = 'Jump to next occurrence of word' })
map('n', '{', '{zz', { desc = 'Jump to prev paragraph' })
map('n', '}', '}zz', { desc = 'Jump to next paragraph' })
map('n', 'n', 'nzzzv', { desc = 'Next search match, center & unfold' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search match, center & unfold' })
map('v', '<', '<gv', { desc = 'Indent left and keep visual selection' })
map('v', '>', '>gv', { desc = 'Indent right and keep visual selection' })
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected line(s) down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected line(s) up' })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Move down' })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Move up' })
map('n', 'yA', '<CMD>%y<CR>', { desc = 'Yank all' })
map('n', 'yc', 'yygccp', { remap = true, desc = 'Yank to a comment above' })
map('n', '<C-n>', '*Ncgn', { desc = 'Change word with . repeat down' })
map('n', '<C-p>', '#Ncgn', { desc = 'Change word with . repeat up' })
-- stylua: ignore start
map( 'v', '<C-n>', [[y/\V\C<C-r>=substitute(escape(@",'/\'),'\n','\\n','g')<CR><CR>Ncgn]], { desc = 'Change selected with . repeat down (Case-sensitive)' })
map( 'v', '<C-p>', [[y?\V\C<C-r>=substitute(escape(@",'?\'),'\n','\\n','g')<CR><CR>Ncgn]], { desc = 'Change selected with . repeat up (Case-sensitive)' })
-- stylua: ignore end
