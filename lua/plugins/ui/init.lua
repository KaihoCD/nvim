local snacks = require('plugins.ui.snacks')

return {
    {
        src = 'https://github.com/rebelot/heirline.nvim',
        event = 'UiEnter',
        deps = {
            {
                src = 'https://github.com/nvim-treesitter/nvim-treesitter',
            },
        },
        config = require('plugins.ui.heirline').config,
    },
    {
        src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
        event = 'VimEnter',
        deps = {
            { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
        },
        opts = require('plugins.ui.markdown').opts,
    },
    {
        src = 'https://github.com/brenoprata10/nvim-highlight-colors',
        event = 'VimEnter',
        opts = {
            render = 'virtual',
            virtual_symbol = '',
        },
    },
    {
        src = 'https://github.com/folke/snacks.nvim',
        event = 'VimEnter',
        opts = snacks.opts,
    },
}
