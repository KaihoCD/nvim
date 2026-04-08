require('modules.state')
require('modules.pack')
require('modules.autoim')

require('modules.colors')
require('modules.highlight')

-- Register global state keys and defaults.
-- Type annotations for the state store are defined in 'modules/state/type.lua'.
G.State.register({
    ['preferences'] = {
        auto_lint = false,
        format_on_save = false,
    },
    ['ui'] = {
        type = 'borderless',
        style = 'single',
    },
    ['clrs'] = require('modules.colors.constant').palette,
})

-- Use Plugins
G.Pack.use('plugins')
