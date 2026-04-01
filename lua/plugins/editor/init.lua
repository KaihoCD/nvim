local snacks = require('plugins.editor.snacks')
local opencode = require('plugins.editor.opencode')

return {
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        event = 'VimEnter',
        config = function()
            require('plugins.editor.treesitter').config()
        end,
    },
    {
        src = 'https://github.com/folke/snacks.nvim',
        event = 'VimEnter',
        opts = snacks.opts,
        config = snacks.config,
    },
    {
        src = 'https://github.com/lewis6991/gitsigns.nvim',
        event = 'VimEnter',
        opts = require('plugins.editor.gitsigns').opts,
    },
    {
        src = 'https://github.com/stevearc/oil.nvim',
        event = 'VimEnter',
        ---@module 'oil'
        ---@type oil.SetupOpts
        deps = {
            { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
        },
        opts = {
            keymaps = {
                ['<C-h>'] = false,
                ['<C-l>'] = false,
                ['<C-j>'] = false,
                ['<C-k>'] = false,
                ['<bs>'] = { 'actions.parent', mode = 'n' },
                ['gh'] = { 'actions.toggle_hidden', mode = 'n' },
                ['<C-r>'] = 'actions.refresh',
                ['-'] = { 'actions.close', mode = 'n' },
                ['q'] = { 'actions.close', mode = 'n' },
            },
        },
        config = function(opts)
            require('oil').setup(opts)
            require('utils').map('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
        end,
    },
    {
        src = 'https://github.com/nickjvandyke/opencode.nvim',
        event = 'VimEnter',
        deps = {
            {
                src = 'https://github.com/folke/snacks.nvim',
                opts = opencode.snacks_opts,
            },
        },
        config = opencode.config,
    },
    -- folding
    {
        src = 'https://github.com/chrisgrieser/nvim-origami',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {
            foldtext = {
                lineCount = {
                    template = ' 󰘕 %d lines ',
                    hlgroup = 'Function',
                },
            },
            autoFold = { enabled = false },
            foldKeymaps = { setup = false },
        },
        config = function(opts)
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
            require('origami').setup(opts)
        end,
    },
    {
        src = 'https://github.com/folke/todo-comments.nvim',
        event = 'VimEnter',
        config = function()
            local todo_comments = require('todo-comments')
            local map = require('utils').map
            todo_comments.setup({})
            -- stylua: ignore start
            map('n', ']t', function() todo_comments.jump_next() end, { desc = 'Next Todo Comment' })
            map('n', '[t', function() todo_comments.jump_prev() end, { desc = 'Previous Todo Comment' })
            map('n', '<leader>st', function() Snacks.picker['todo_comments']() end, { desc = 'Search Todo Comment' })
            -- stylua: ignore end
        end,
    },
    {
        src = 'https://github.com/NMAC427/guess-indent.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
    },
}
