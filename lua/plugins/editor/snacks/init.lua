vim.schedule(function()
  if not Snacks then
    return
  end

  -- Create some toggle mappings
  Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>uS')
  Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uW')
  Snacks.toggle.option('conceallevel', { off = 0, on = 2 }):map('<leader>uc')
  Snacks.toggle.option('relativenumber', { name = 'relative Number' }):map('<leader>ur')
  Snacks.toggle.diagnostics({ name = 'Diagnostics' }):map('<leader>ud')
  Snacks.toggle.line_number():map('<leader>ul')
  Snacks.toggle.treesitter():map('<leader>uT')
  Snacks.toggle.inlay_hints():map('<leader>uh')
  Snacks.toggle.indent():map('<leader>ug')
  Snacks.toggle.dim():map('<leader>uD')
  Snacks.toggle.animate():map('<leader>uA')
end)

vim.schedule(function()
  local input = require('snacks.picker.core.input')
  input.statuscolumn = function()
    return '%#SnacksPickerPrompt#   %*'
  end
end)

return {
  explorer = require('plugins.editor.snacks.explorer'),
  picker = require('plugins.editor.snacks.picker'),
  terminal = require('plugins.editor.snacks.terminal'),
  lazygit = require('plugins.editor.snacks.lazygit'),
  notifier = require('plugins.editor.snacks.notifier'),
}
