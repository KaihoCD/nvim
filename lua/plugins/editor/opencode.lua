local map = require('utils').map
local M = {}

M.snacks_opts = {
    picker = {
        actions = {
            opencode_send = function(...)
                return require('opencode').snacks_picker_send(...)
            end,
        },
        win = {
            input = {
                keys = {
                    ['<C-o>s'] = { 'opencode_send', mode = { 'n', 'i' } },
                },
            },
        },
    },
}

function M.config()
    vim.o.autoread = true

    ---@type opencode.Opts
    vim.g.opencode_opts = {
        ask = {
            snacks = {
                icon = G.icons.kind_icons.Copilot .. ' ',
                win = {
                    title_pos = 'center',
                    footer_keys = false,
                },
            },
        },
    }

    local opencode = require('opencode')

    -- stylua: ignore start
    map('x', '<leader>oa', function() opencode.ask('@this: ',{ submit = true }) end, { desc = 'Ask opencode…' })
    map('n', '<leader>oa', function() opencode.ask('@buffer: ',{ submit = true }) end, { desc = 'Ask opencode…' })
    map('n', '<leader>os', function() opencode.select() end, { desc = 'Select opencode…' })
    -- stylua: ignore end
end

return M
