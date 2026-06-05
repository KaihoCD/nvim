local lsp = require('plugins.devtools.lsp')

return {
    {
        src = 'https://github.com/neovim/nvim-lspconfig',
        event = 'VimEnter',
        deps = {
            {
                src = 'https://github.com/mason-org/mason.nvim',
                config = function()
                    local ui = G.State.get('ui')
                    local border = ui.type == 'bordered' and ui.style or nil
                    require('mason').setup({
                        ui = {
                            border = border,
                            backdrop = 100,
                            height = 0.8,
                        },
                    })
                end,
            },
            {
                src = 'https://github.com/mason-org/mason-lspconfig.nvim',
                opts = {
                    automatic_enable = false,
                },
            },
            {
                src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
                config = function()
                    require('mason-tool-installer').setup({
                        ensure_installed = require('devtools').get_installed(),
                    })
                end,
            },
            { src = 'https://github.com/saghen/blink.cmp' },
        },
        config = lsp.config,
    },
    {
        src = 'https://github.com/stevearc/conform.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = require('plugins.devtools.format').config,
    },
}
