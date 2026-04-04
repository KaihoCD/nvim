---@class ModulePreferencesState
---@field auto_lint boolean
---@field format_on_save boolean

---@class ModuleUiState
---@field type string

---@class ModuleColorsState
---@field system string
---@field name string
---@field author string
---@field variant string
---@field palette table<string, string>
---@field raw? table<string, string>

---@alias ModuleLspConfigsState table<string, string>

---@class ModuleStateSchema
---@field preferences ModulePreferencesState
---@field ui ModuleUiState
---@field clrs ModuleColorsState
---@field lsp_configs? ModuleLspConfigsState

---@alias ModuleStateGet
---| fun(key: 'preferences'): ModulePreferencesState
---| fun(key: 'ui'): ModuleUiState
---| fun(key: 'clrs'): ModuleColorsState
---| fun(key: 'lsp_configs'): ModuleLspConfigsState | nil
---| fun(key: string): any

---@alias ModuleStateSet
---| fun(key: 'preferences', value: ModulePreferencesState)
---| fun(key: 'ui', value: ModuleUiState)
---| fun(key: 'clrs', value: ModuleColorsState)
---| fun(key: 'lsp_configs', value: ModuleLspConfigsState)
---| fun(key: string, value: any)

---@alias ModuleStateRegister fun(defaults: ModuleStateSchema)

---@class ModuleStateStore
---@field get ModuleStateGet
---@field set ModuleStateSet
---@field register ModuleStateRegister
