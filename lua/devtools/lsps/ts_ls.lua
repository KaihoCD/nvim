local ts_ls = {
  init_options = {
    preferences = {
      includeInlayVariableTypeHints = true,
      includeInlayParameterNameHints = 'all',
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    },
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
  },
}

return ts_ls
