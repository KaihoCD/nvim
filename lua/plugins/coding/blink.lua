local M = {}

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
    keymap = {
        preset = 'super-tab',
        -- override the 'super-tab' preset
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
        ['<C-k>'] = { 'snippet_backward', 'fallback' },
        ['<C-j>'] = { 'snippet_forward', 'fallback' },
        ['<C-e>'] = { 'hide', 'hide_signature', 'fallback' },
    },
    completion = {
        list = {
            selection = { preselect = true, auto_insert = false },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
        menu = {
            auto_show = true,
        },
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
        providers = {
            lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                score_offset = 100,
            },
        },
    },
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true },
    cmdline = {
        sources = function()
            local cmd_type = vim.fn.getcmdtype()

            if cmd_type == '/' or cmd_type == '?' then
                return { 'buffer' }
            end

            if cmd_type == ':' or cmd_type == '@' then
                return { 'cmdline' }
            end

            return {}
        end,
        keymap = {
            preset = 'super-tab',
        },
        completion = {
            menu = {
                auto_show = true,
            },
        },
    },
}

return M
