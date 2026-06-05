vim.api.nvim_create_autocmd('LspProgress', {
    group = vim.api.nvim_create_augroup('LspProgress', { clear = true }),
    callback = function(ev)
        local value = ev.data.params.value
        local message = value.message and { value.message } or { ' ', 'OkMsg' }
        vim.api.nvim_echo({ message }, false, {
            id = 'lsp.' .. ev.data.client_id,
            kind = 'progress',
            source = 'vim.lsp',
            title = value.title,
            status = value.kind ~= 'end' and 'running' or 'success',
            percent = value.percentage,
        })
    end,
})
