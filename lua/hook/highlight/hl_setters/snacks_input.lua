local merge_if = require('utils.funcs').merge_if

---@param _ ThemeColors
---@param borderless boolean
return function(_, borderless)
  return merge_if({
    SnacksInputNormal = { 'SubNormalFloat' },
    SnacksInputBorder = { 'SubFloatBorder' },
    SnacksInputTitle = { 'SubFloatTitle' },
  }, borderless, {})
end
