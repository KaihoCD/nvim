local merge_if = require('utils.funcs').merge_if

---@param colors ThemeColors
---@param borderless boolean
return function(colors, borderless)
  local main_bg = colors.bg.main
  local sub_color = colors.theme.sub
  local main_color = colors.theme.main
  local fix_bg = colors.bg.fix

  return merge_if(
    {
      -- picker explorer
      SnacksPickerExplorerNormal = { bg = main_bg },
      SnacksPickerExplorerBorder = { bg = main_bg, fg = sub_color },
      SnacksPickerExplorerTitle = { bg = main_bg, fg = sub_color },
      SnacksPickerExplorerPrompt = { bg = main_bg, fg = main_color },
      -- picker box
      SnacksPickerBoxBorder = { bg = main_bg, fg = colors.fg.separator },
      -- picker input
      SnacksPickerInput = { 'SubNormalFloat' },
      SnacksPickerInputBorder = { 'SubFloatBorder' },
      SnacksPickerInputTitle = { 'SubFloatTitle' },
      -- picker list
      SnacksPickerListCursorLine = { 'CursorLine' },
    },
    borderless,
    {
      -- picker explorer
      SnacksPickerExplorerNormal = { bg = fix_bg },
      SnacksPickerExplorerBorder = { bg = fix_bg, fg = sub_color },
      SnacksPickerExplorerTitle = { bg = fix_bg, fg = sub_color },
      SnacksPickerExplorerPrompt = { bg = fix_bg, fg = main_color },
      -- picker box
      SnacksPickerBoxBorder = { bg = fix_bg, fg = fix_bg },
    }
  )
end
