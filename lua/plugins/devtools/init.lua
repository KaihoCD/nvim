local lsp = require('plugins.devtools.lsp')

return {
    {
        src = 'https://github.com/neovim/nvim-lspconfig',
        event = 'VimEnter',
        deps = {
            { src = 'https://github.com/mason-org/mason.nvim' },
            {
                src = 'https://github.com/mason-org/mason-lspconfig.nvim',
                opts = lsp.mason_lspconfig_opts,
            },
            {
                src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
                config = lsp.mason_tool_installer_config,
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
    {
        src = 'https://github.com/mfussenegger/nvim-lint',
        event = { 'BufReadPre', 'BufNewFile' },
        config = require('plugins.devtools.lint').config,
    },
}
