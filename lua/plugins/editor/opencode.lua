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
                    ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
                },
            },
        },
    },
}

function M.config()
    vim.o.autoread = true

    ---@type opencode.Opts
    vim.g.opencode_opts = {}

    local opencode = require('opencode')

    -- stylua: ignore start
    map('x', '<leader>oa', function() opencode.ask('@this: ',{ submit = true }) end, { desc = 'Ask opencode…' })
    map('n', '<leader>oa', function() opencode.ask('@buffer: ',{ submit = true }) end, { desc = 'Ask opencode…' })

    map('n', '<leader>ou', function() opencode.command('session.half.page.up') end, { desc = 'Scroll opencode up' })
    map('n', '<leader>od', function() opencode.command('session.half.page.down') end, { desc = 'Scroll opencode down' })
    -- stylua: ignore end
end

return M
