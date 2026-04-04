require('modules.state')
require('modules.pack')
require('modules.autoim')

local colors = require('modules.colors')

-- Register global state keys and defaults.
-- Type annotations for the state store are defined in 'modules/state/type.lua'.
G.State.register({
    ['preferences'] = {
        auto_lint = false,
        format_on_save = false,
    },
    ['ui'] = {
        type = 'borderless',
    },
    ['clrs'] = colors.default_clrs,
})

-- Use Plugins
G.Pack.use('plugins')
