---@class state.Preferences
---@field format_on_save boolean

---@class state.Ui
---@field type 'borderless' | 'bordered'
---@field style 'single' | 'rounded'

---@class state.Colors: modules.colors.ColorsPalette

---@class state.LspConfigs
---@field vtsls 'default' | 'mason'
---@field ts_ls 'default' | 'mason'

---@alias state.Keys
---| 'preferences'
---| 'ui'
---| 'clrs'
---| 'lsp_config'
---| string

---@class state.Store
---@field get fun(key: 'preferences'): state.Preferences
---@field get fun(key: 'ui'): state.Ui
---@field get fun(key: 'clrs'): state.Colors
---@field get fun(key: 'lsp_config'): state.LspConfigs
---@field get fun(key: state.Keys): state.Ui | state.Ui | state.Colors | any
---@field set fun(key: 'preferences', value: state.Preferences)
---@field set fun(key: 'ui', value: state.Ui)
---@field set fun(key: 'clrs', value: state.Colors)
---@field set fun(key: 'lsp_config', value: state.LspConfigs)
---@field set fun(key: state.Keys, value: any)
---@field register fun(defaults: table, schemas?: table)
---@field get_schema fun(key: string): table | nil
---@field watch_file fun()
