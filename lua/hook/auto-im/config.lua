local cur_os = require('utils.funcs').cur_os

local M = {
  -- Filetypes to restore last used input method
  text_filetypes = { 'markdown', 'text', 'tex', 'rst' },
  -- Treesitter nodes to restore last used input method
  treesitter_nodes = {
    comment = { 'comment', 'line_comment', 'block_comment' },
    string = { 'string', 'raw_string', 'string_literal' },
    docstring = { 'docstring', 'string_doc' },
  },
}

if cur_os('mac') then
  M.default_im = 'com.apple.keylayout.ABC'
  M.chinese_im = 'com.apple.inputmethod.SCIM.Generic'
  M.im_switch_command = 'im-select'
end

if cur_os('win') or cur_os('wsl') then
  M.default_im = '1033' -- English (US)
  M.chinese_im = '2052' -- Chinese (Simplified)
  M.im_switch_command = 'im-select.exe'
end

if cur_os('linux') then
  M.default_im = 'keyboard-us'
  M.chinese_im = 'pinyin'
  M.im_switch_command = 'fcitx5-remote'
end

return M
