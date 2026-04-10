local FORMAT_TIMEOUT_MS = 3000
local NOTIFY_OPTS = { title = 'Formatter' }

local M = {}

local function build_formatter_display_name(formatters, uses_lsp)
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

local LSP_HOOKS = {
    eslint = function(bufnr, client)
        local group =
            vim.api.nvim_create_augroup('EslintFixAllAfterFormat_' .. bufnr, { clear = true })

        vim.api.nvim_create_autocmd('DiagnosticChanged', {
            group = group,
            buffer = bufnr,
            once = true,
            callback = function()
                if not client.server_capabilities.codeActionProvider then
                    return
                end

                vim.api.nvim_buf_call(bufnr, function()
                    vim.lsp.buf.code_action({
                        context = {
                            ---@diagnostic disable-next-line: assign-type-mismatch
                            only = { 'source.fixAll.eslint' },
                            diagnostics = {},
                        },
                        apply = true,
                    })
                end)
            end,
        })

        vim.defer_fn(function()
            pcall(vim.api.nvim_del_augroup_by_id, group)
        end, FORMAT_TIMEOUT_MS)
    end,
}

local function run_lsp_hooks(bufnr)
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local notify = require('utils.notify')

    for _, client in ipairs(clients) do
        local hook = LSP_HOOKS[client.name]
        if hook then
            local success, err = pcall(hook, bufnr, client)
            if not success then
                notify.warn(
                    string.format('LSP hook "%s" failed: %s', client.name, tostring(err)),
                    NOTIFY_OPTS
                )
            end
        end
    end
end

-- 格式化编排器：负责协调格式化流程
local function orchestrate_format(format_fn, opts)
    local conform = require('conform')
    local notify = require('utils.notify')

    local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

    local formatters, uses_lsp = conform.list_formatters_to_run(bufnr)
    local formatter_names = build_formatter_display_name(formatters, uses_lsp)

    format_fn(opts, function(err)
        if err then
            notify.error('Format failed: ' .. err, NOTIFY_OPTS)
            return
        end

        notify.info('Formatted with: ' .. formatter_names, NOTIFY_OPTS)

        run_lsp_hooks(bufnr)
    end)
end

-- 标准格式化
local function format_buffer(opts)
    local conform = require('conform')

    opts = opts or {}
    opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
    opts.timeout_ms = opts.timeout_ms or FORMAT_TIMEOUT_MS
    opts.async = vim.F.if_nil(opts.async, true)

    orchestrate_format(function(format_opts, callback)
        conform.format(format_opts, callback)
    end, opts)
end

local function toggle_format_on_save()
    local notify = require('utils.notify')
    local preferences = G.State.get('preferences')
    local enabled = preferences.format_on_save

    G.State.set(
        'preferences',
        vim.tbl_extend('force', preferences, { format_on_save = not enabled })
    )
    notify.info('Format on Save: ' .. (not enabled and 'Enabled' or 'Disabled'), NOTIFY_OPTS)
end

local function setup_format_on_save_autocmd()
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('ConformFormatOnSave', { clear = true }),
        callback = function(args)
            local preferences = G.State.get('preferences')
            if not preferences.format_on_save then
                return
            end

            format_buffer({
                bufnr = args.buf,
                timeout_ms = FORMAT_TIMEOUT_MS,
                async = false,
            })
        end,
    })
end

local function setup_keymaps()
    local map = require('utils').map

    map('n', '<leader>tf', toggle_format_on_save, { desc = 'Toggle [F]ormat on Save' })
    map({ 'n', 'v' }, '<leader>lf', format_buffer, { desc = '[F]ormat buffer' })
end

function M.config()
    require('conform').setup({
        notify_no_formatters = true,
        notify_on_error = true,
        formatters_by_ft = {
            javascript = { 'biome' },
            typescript = { 'biome' },
            javascriptreact = { 'biome' },
            typescriptreact = { 'biome' },
            json = { 'biome' },
            vue = { 'prettierd' },
            css = { 'prettierd' },
            less = { 'prettierd' },
            html = { 'prettierd' },
            yaml = { 'prettierd' },
            markdown = { 'prettierd' },
            lua = { 'stylua' },
            zsh = { 'shfmt' },
            bash = { 'shfmt' },
        },
        formatters = require('devtools').get_formatters(),
    })
    setup_keymaps()
    setup_format_on_save_autocmd()
end

return M
