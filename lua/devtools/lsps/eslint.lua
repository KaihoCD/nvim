local eslint = {
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
  },
  settings = {
    workingDirectory = { mode = 'auto' },
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = 'separateLine',
      },
      showDocumentation = {
        enable = true,
      },
    },
    format = false,
  },
}

return eslint
