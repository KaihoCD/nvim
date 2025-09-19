---@param colors ThemeColors
return function(colors)
  return {
    WhichKeyNormal = { 'MainNormalFloat' },
    WhichKeyBorder = { 'MainFloatBorder' },
    WhichKeyTitle = { 'MainFloatTitle' },
    WhichKeyIcon = { fg = colors.theme.preproc },
  }
end
