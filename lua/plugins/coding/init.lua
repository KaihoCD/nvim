local copilot = require('plugins.coding.copilot')
local blink = require('plugins.coding.blink')

local nop_func = function()
    --[[nop func]]
end

return {
    { src = 'https://github.com/echasnovski/mini.pairs', event = 'InsertEnter' },
    { src = 'https://github.com/echasnovski/mini.surround', event = 'VimEnter' },
    { src = 'https://github.com/echasnovski/mini.ai', event = 'VimEnter' },
    { src = 'https://github.com/folke/ts-comments.nvim', event = 'VimEnter' },
    {
        src = 'https://github.com/windwp/nvim-ts-autotag',
        ft = { 'html', 'xml', 'javascriptreact', 'typescriptreact', 'vue', 'svelte' },
    },
    {
        src = 'https://github.com/saghen/blink.cmp',
        event = 'VimEnter',
        deps = {
            { src = 'https://github.com/saghen/blink.lib', config = nop_func },
            { src = 'https://github.com/folke/lazydev.nvim' },
            { src = 'https://github.com/xzbdmw/colorful-menu.nvim' },
            { src = 'https://github.com/brenoprata10/nvim-highlight-colors' },
            {
                src = 'https://github.com/rafamadriz/friendly-snippets',
                config = nop_func,
            },
        },
        opts = blink.opts,
        config = blink.config,
    },
    {
        src = 'https://github.com/zbirenbaum/copilot.lua',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = copilot.opts,
        config = copilot.config,
    },
}
