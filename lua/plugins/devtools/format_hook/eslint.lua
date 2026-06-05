local M = {}

local RETRY_COUNT = 1
local RETRY_DELAY_MS = 1000

local function request_fix_all(bufnr)
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
end

local function retry_fix_all(bufnr, attempts_left)
    local group = vim.api.nvim_create_augroup('EslintFixAllAfterFormat_' .. bufnr, { clear = true })
    local finished = false

    local function cleanup()
        finished = true
        pcall(vim.api.nvim_del_augroup_by_id, group)
    end

    vim.api.nvim_create_autocmd('DiagnosticChanged', {
        group = group,
        buffer = bufnr,
        callback = function()
            if finished or not vim.api.nvim_buf_is_valid(bufnr) then
                cleanup()
                return
            end

            request_fix_all(bufnr)
            cleanup()
        end,
    })

    for attempt = 1, attempts_left do
        vim.defer_fn(function()
            if finished or not vim.api.nvim_buf_is_valid(bufnr) then
                cleanup()
                return
            end

            if attempt == attempts_left then
                request_fix_all(bufnr)
                cleanup()
            end
        end, attempt * RETRY_DELAY_MS)
    end
end

function M.run(bufnr, client)
    if not client.server_capabilities.codeActionProvider then
        return
    end

    vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end

        local has_diagnostics = not vim.tbl_isempty(vim.diagnostic.get(bufnr))
        if has_diagnostics then
            request_fix_all(bufnr)
            return
        end

        retry_fix_all(bufnr, RETRY_COUNT)
    end)
end

return M
