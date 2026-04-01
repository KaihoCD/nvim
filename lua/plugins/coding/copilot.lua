local M = {}

M.opts = {
    suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
            accept = '<tab>',
            next = '<C-j>',
            prev = '<C-k>',
        },
        debounce = 50,
    },
}

function M.config(opts)
    require('copilot').setup(opts)

    vim.g.copilot_nes_debounce = 500

    vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
            vim.b.copilot_suggestion_hidden = true
        end,
    })

    vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function()
            vim.b.copilot_suggestion_hidden = false
            vim.schedule(function()
                if vim.api.nvim_get_mode().mode:match('i') then
                    require('copilot.suggestion').update_preview()
                end
            end)
        end,
    })
end

return M
