local nop_fun = function()
    --[[nop func]]
end

return {
    tokyonight = {
        src = 'https://github.com/folke/tokyonight.nvim',
        name = 'theme-tokyonight',
        event = 'VimEnter',
        config = nop_fun,
    },
    catppuccin = {
        src = 'https://github.com/catppuccin/nvim',
        name = 'theme-catppuccin',
        event = 'VimEnter',
        config = nop_fun,
    },
    fox = {
        src = 'https://github.com/EdenEast/nightfox.nvim',
        name = 'theme-fox',
        event = 'VimEnter',
        config = nop_fun,
    },
    everforest = {
        src = 'https://github.com/sainnhe/everforest',
        name = 'theme-everforest',
        event = 'VimEnter',
        config = nop_fun,
    },
}
