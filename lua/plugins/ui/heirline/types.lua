---@class GitColors
---@field git_add string
---@field git_change string
---@field git_delete string

---@class DiagColors
---@field diag_error string
---@field diag_error_inactive string
---@field diag_warn string
---@field diag_warn_inactive string
---@field diag_info string
---@field diag_info_inactive string
---@field diag_hint string
---@field diag_hint_inactive string

---@class ModeColors
---@field normal string
---@field normal_light string
---@field normal_lighter string
---@field insert string
---@field insert_light string
---@field insert_lighter string
---@field visual string
---@field visual_light string
---@field visual_lighter string
---@field command string
---@field command_light string
---@field command_lighter string
---@field terminal string
---@field terminal_light string
---@field terminal_lighter string
---@field select string
---@field select_light string
---@field select_lighter string
---@field replace string
---@field replace_light string
---@field replace_lighter string

---@class StatusColors
---@field active_fg string
---@field active_bg string
---@field inactive_fg string
---@field inactive_bg string

---@class HeirlineColors: GitColors, DiagColors, ModeColors, StatusColors
---@field fg string
---@field bg string

---@alias ThemeName string
