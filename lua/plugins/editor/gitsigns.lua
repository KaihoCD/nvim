local map = require('utils').map

local M = {}

M.opts = {
    signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '┃' },
        untracked = { text = '┆' },
    },

    signs_staged = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '┃' },
        untracked = { text = '┆' },
    },
    current_line_blame = false,
    on_attach = function()
        local gs = require('gitsigns')

        map('n', ']h', function()
            gs.nav_hunk('next')
        end, { desc = 'Next Hunk' })
        map('n', '[h', function()
            gs.nav_hunk('prev')
        end, { desc = 'Prev Hunk' })

        map('n', '<leader>hp', gs.preview_hunk_inline, { desc = 'Preview Hunk' })

        map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset Hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset Buffer' })
        map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage Hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage Buffer' })

        map('n', '<leader>hb', gs.blame_line, { desc = 'Blame Inline' })
        map('n', '<leader>gB', gs.blame, { desc = 'Buffer Blame' })

        Snacks.toggle({
            name = 'Git Signs',
            get = function()
                return require('gitsigns.config').config.signcolumn
            end,
            set = function()
                gs.toggle_signs()
            end,
        }):map('<leader>tgs')
        Snacks.toggle({
            name = 'Git Blame line',
            get = function()
                return require('gitsigns.config').config.current_line_blame
            end,
            set = function()
                gs.toggle_current_line_blame()
            end,
        }):map('<leader>tgb')

        vim.api.nvim_create_user_command('GitsignsPreviewHunkInline', function()
            local ok, markdown = pcall(require, 'render-markdown')

            if ok then
                markdown.disable()
            end

            gs.preview_hunk_inline()

            if not ok then
                return
            end

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
                buffer = vim.api.nvim_get_current_buf(),
                once = true,
                callback = function()
                    markdown.enable()
                end,
            })
        end, {})
    end,
}

return M
