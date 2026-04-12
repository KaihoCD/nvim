G.State = require('state.core')

G.State.register({
    preferences = {
        format_on_save = false,
    },
    ui = {
        type = 'borderless',
        style = 'single',
    },
    lsp_configs = {
        vtsls = 'mason',
    },
    clrs = require('modules.colors.constant').palette,
}, {
    preferences = {
        format_on_save = 'boolean',
    },
    ui = {
        type = 'enum:borderless|bordered',
        style = 'enum:single|rounded',
    },
    lsp_configs = {
        vtsls = 'enum:default|mason',
    },
    clrs = {
        name = 'string',
        ['*'] = 'pattern:^#%x%x%x%x%x%x$',
    },
})

-- Enable file watching
G.State.watch_file()
