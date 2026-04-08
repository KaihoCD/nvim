---@class ModulePreferencesState
---@field auto_lint boolean
---@field format_on_save boolean

---@class ModuleUiState
---@field type 'borderless' | 'bordered'
---@field style 'single' | 'rounded'

---@alias ModuleColorsState ColorsPalette

---@alias ModuleLspConfigsState table<string, string>

---@class ModuleStateSchema
---@field preferences ModulePreferencesState
---@field ui ModuleUiState
---@field clrs ModuleColorsState
---@field lsp_configs? ModuleLspConfigsState

---@class ModuleStateStore
---@field get fun(key: 'preferences'): ModulePreferencesState
---@field get fun(key: 'ui'): ModuleUiState
---@field get fun(key: 'clrs'): ModuleColorsState
---@field get fun(key: 'lsp_configs'): ModuleLspConfigsState | nil
---@field get fun(key: string): any
---@field register fun(defaults: ModuleStateSchema)
---@field set fun(key: 'preferences', value: ModulePreferencesState)
---@field set fun(key: 'ui', value: ModuleUiState)
---@field set fun(key: 'clrs', value: ModuleColorsState)
---@field set fun(key: 'lsp_configs', value: ModuleLspConfigsState)
---@field set fun(key: string, value: any)
