local merge_if = require('utils.funcs').merge_if

---@param colors ThemeColors
---@param borderless boolean
return function(colors, borderless)
  return merge_if(
    {
      BlinkCmpMenu = { 'MainNormalFloat' },
      BlinkCmpMenuBorder = { 'MainFloatBorder' },
      BlinkCmpDoc = { 'MainNormalFloat' },
      BlinkCmpDocBorder = { 'MainFloatBorder' },
      BlinkCmpScrollBarThumb = { bg = colors.fg.separator },
      BlinkCmpScrollBarGutter = { 'MainFloatBorder' },
      BlinkCmpKind = { 'MainNormalFloat' },
      BlinkCmpMenuSelection = { 'CursorLine' },
    },
    borderless,
    {
      BlinkCmpDoc = { 'SubNormalFloat' },
      BlinkCmpDocBorder = { 'SubFloatBorder' },
      BlinkCmpDocSeparator = { 'SubNormalFloat' },
    }
  )
end
