local FORMAT_TIMEOUT_MS = 3000
local NOTIFY_OPTS = { title = 'Formatter' }

local M = {}

local function build_opts()
    return {
        notify_no_formatters = true,
        notify_on_error = true,
        formatters_by_ft = {
            javascript = { 'prettierd', 'eslint_d' },
            typescript = { 'prettierd', 'eslint_d' },
            javascriptreact = { 'prettierd', 'eslint_d' },
            typescriptreact = { 'prettierd', 'eslint_d' },
            vue = { 'prettierd', 'eslint_d' },
            css = { 'prettierd' },
            less = { 'prettierd' },
            html = { 'prettierd' },
            json = { 'prettierd' },
            yaml = { 'prettierd' },
            markdown = { 'prettierd' },
            lua = { 'stylua' },
            zsh = { 'shfmt' },
            bash = { 'shfmt' },
        },
        formatters = require('devtools').get_formatters(),
        format_on_save = function()
            local preferences = G.State.get('preferences')

            if not preferences.format_on_save then
                return nil
            end

            return {
                timeout_ms = FORMAT_TIMEOUT_MS,
                lsp_format = 'fallback',
            }
        end,
    }
end

local function formatters_to_string(formatters, uses_lsp)
    local names = vim.tbl_map(function(formatter)
        return formatter.name
    end, formatters or {})

    if uses_lsp then
        table.insert(names, 'lsp')
    end

    if #names == 0 then
        return 'none'
    end

    return table.concat(names, ', ')
end

local function toggle_format_on_save()
    local notify = require('utils.notify')
    local preferences = G.State.get('preferences')
    local enabled = preferences.format_on_save

    G.State.set('preferences', vim.tbl_extend('force', preferences, { format_on_save = not enabled }))
    notify.info('Format on Save: ' .. (not enabled and 'Enabled' or 'Disabled'), NOTIFY_OPTS)
end

local function format_current_buffer()
    local conform = require('conform')
    local notify = require('utils.notify')
    local bufnr = vim.api.nvim_get_current_buf()
    local formatters, uses_lsp = conform.list_formatters_to_run(bufnr)

    conform.format({ bufnr = bufnr, timeout_ms = FORMAT_TIMEOUT_MS }, function(err)
        if err then
            notify.error('Format failed: ' .. err, NOTIFY_OPTS)
            return
        end

        notify.info('Formatted with: ' .. formatters_to_string(formatters, uses_lsp), NOTIFY_OPTS)
    end)
end

local function setup_keymaps()
    local map = require('utils').map

    map('n', '<leader>tf', toggle_format_on_save, { desc = 'Toggle [F]ormat on Save' })
    map({ 'n', 'v' }, '<leader>lf', format_current_buffer, { desc = '[F]ormat buffer' })
end

function M.config()
    require('conform').setup(build_opts())
    setup_keymaps()
end

return M
