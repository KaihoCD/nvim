local NOTIFY_OPTS = { title = 'Linter' }

local M = {}

local function build_opts()
    return {
        linters_by_ft = {
            javascript = { 'eslint_d' },
            javascriptreact = { 'eslint_d' },
            typescript = { 'eslint_d' },
            typescriptreact = { 'eslint_d' },
            json = { 'jsonlint' },
        },
    }
end

local function linters_to_string(names)
    if not names or #names == 0 then
        return 'none'
    end

    return table.concat(names, ', ')
end

local function toggle_auto_lint()
    local notify = require('utils.notify')
    local preferences = G.State.get('preferences')
    local enabled = not preferences.auto_lint

    G.State.set('preferences', vim.tbl_extend('force', preferences, { auto_lint = enabled }))
    notify.info('Auto Lint: ' .. (enabled and 'Enabled' or 'Disabled'), NOTIFY_OPTS)
end

local function lint_buffer_and_notify()
    local lint = require('lint')
    local notify = require('utils.notify')
    local names = lint._resolve_linter_by_ft(vim.bo.filetype)

    lint.try_lint()

    vim.schedule(function()
        local running = lint.get_running(0)
        local active = #running > 0 and running or names
        notify.info('Lint with: ' .. linters_to_string(active), NOTIFY_OPTS)
    end)
end

local function setup_autocmds()
    local debounce = require('utils').debounce
    local lint_group = vim.api.nvim_create_augroup('Lint', { clear = true })

    vim.api.nvim_create_autocmd(
        { 'BufEnter', 'InsertLeave', 'TextChanged', 'TextChangedI', 'BufWritePost' },
        {
            group = lint_group,
            callback = debounce(200, function(args)
                if not vim.api.nvim_buf_is_valid(args.buf) then
                    return
                end

                local bo = vim.bo[args.buf]
                ---@type ModulePreferencesState
                local preferences = G.State.get('preferences')
                    or {
                        auto_lint = false,
                        format_on_save = false,
                    }

                if preferences.auto_lint and bo.modifiable and bo.buftype == '' then
                    vim.api.nvim_buf_call(args.buf, function()
                        require('lint').try_lint()
                    end)
                end
            end),
        }
    )
end

local function setup_keymaps()
    local map = require('utils').map

    map('n', '<leader>tl', toggle_auto_lint, { desc = 'Toggle [L]int' })
    map('n', '<leader>ll', lint_buffer_and_notify, { desc = '[L]int buffer' })
end

function M.config()
    require('lint').linters_by_ft = build_opts().linters_by_ft
    setup_autocmds()
    setup_keymaps()
end

return M
