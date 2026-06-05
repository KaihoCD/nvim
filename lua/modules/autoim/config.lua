local utils = require('modules.autoim.utils')

local M = {
    text_filetypes = { 'markdown', 'text', 'tex', 'rst' },
    treesitter_nodes = {
        comment = { 'comment', 'line_comment', 'block_comment' },
        string = { 'string', 'raw_string', 'string_literal' },
        docstring = { 'docstring', 'string_doc' },
    },
}

M.notify_title = 'Auto-IM'

if utils.current_os('mac') then
    M.default_im = 'com.apple.keylayout.ABC'
    M.chinese_im = 'com.apple.inputmethod.SCIM.Generic'
    M.im_switch_command = 'im-select'
    M.install_command = 'brew tap daipeihust/tap && brew install im-select'
elseif utils.current_os('win') or utils.current_os('wsl') then
    M.default_im = '1033'
    M.chinese_im = '2052'
    M.im_switch_command = 'im-select.exe'
elseif utils.current_os('linux') then
    M.default_im = 'keyboard-us'
    M.chinese_im = 'pinyin'
    M.im_switch_command = 'fcitx5-remote'
end

M.install_cmd_name = 'InstallIm'
M.augroup_name = 'InputMethodSelect'
M.restore_events = { 'InsertEnter' }
M.default_events = { 'BufEnter', 'InsertLeave', 'FocusGained' }

return M
