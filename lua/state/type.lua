---@class ModulePreferencesState
---@field format_on_save boolean

---@class ModuleUiState
---@field type 'borderless' | 'bordered'
---@field style 'single' | 'rounded'

---@alias ModuleColorsState ColorsPalette

---@class ModuleStateStore
---@field get fun(key: 'preferences'): ModulePreferencesState
---@field get fun(key: 'ui'): ModuleUiState
---@field get fun(key: 'clrs'): ModuleColorsState
---@field get fun(key: string): any
---@field set fun(key: 'preferences', value: ModulePreferencesState)
---@field set fun(key: 'ui', value: ModuleUiState)
---@field set fun(key: 'clrs', value: ModuleColorsState)
---@field set fun(key: string, value: any)
---@field register fun(defaults: table, schemas?: table)
---@field get_schema fun(key: string): table | nil
