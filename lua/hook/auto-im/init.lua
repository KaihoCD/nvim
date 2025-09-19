local configs = require('hook.auto-im.config')
local notify = require('utils.notify')

local function im_notify(msg, level)
  notify(msg, level, { icon = '󱅄 ', title = ' Auto-IM ' })
end

local has_im_command, _ = pcall(vim.fn.system, configs.im_switch_command .. '--version')
if not has_im_command then
  im_notify(
    'input method switch tool not found (' .. configs.im_switch_command .. '), module disabled!',
    vim.log.levels.WARN
  )
  return
end

local AutoIM = {}
AutoIM.prev_im = nil -- Save previous im

--- Switch to a specific input method
function AutoIM.switch_to(im_name)
  local ok, current_im = pcall(vim.fn.system, configs.im_switch_command)
  if not ok then
    im_notify('Failed to get current input method', vim.log.levels.ERROR)
    return
  end

  AutoIM.prev_im = vim.trim(current_im) -- always update before switching
  if current_im == im_name then
    return
  end

  local switch_done = pcall(vim.fn.system, configs.im_switch_command .. ' ' .. im_name)
  if not switch_done then
    im_notify('Failed to switch to' .. im_name, vim.log.levels.ERROR)
  end
end

--- Return treesitter nodes to restore input method
local cached_nodes
function AutoIM.treesitter_nodes()
  if cached_nodes then
    return cached_nodes
  end
  local nodes = {}
  for _, node_list in pairs(configs.treesitter_nodes) do
    for _, node in ipairs(node_list) do
      table.insert(nodes, node)
    end
  end
  cached_nodes = nodes
  return nodes
end

--- Check if cursor is in a special syntax node
function AutoIM.in_special_syntax()
  if not vim.treesitter then
    im_notify(
      'nvim-treesitter not available, falling back to default input method',
      vim.log.levels.WARN
    )
    return false
  end

  local filetype = vim.bo.filetype
  local lang = vim.treesitter.language.get_lang(filetype) or filetype
  local ok, parser = pcall(vim.treesitter.get_parser, 0, lang)
  if not ok or not parser then
    return false
  end

  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local node = vim.treesitter.get_node({ pos = { line - 1, col } })
  if not node then
    return false
  end

  local valid_nodes = AutoIM.treesitter_nodes()
  while node do
    for _, valid_node in ipairs(valid_nodes) do
      if node:type() == valid_node then
        return true
      end
    end
    node = node:parent()
  end

  return false
end

--- Check if string contains Chinese characters
function AutoIM.contains_chinese()
  local line = vim.api.nvim_get_current_line()
  -- 中文 Unicode 范围: U+4E00 ~ U+9FFF
  -- UTF-8 编码模式: [\228-\233][\128-\191][\128-\191]
  return line:find('[\228-\233][\128-\191][\128-\191]') ~= nil
end

local function switch_to_default()
  AutoIM.switch_to(configs.default_im)
end

local function switch_to_prev()
  local filetype = vim.bo.filetype
  local target_im

  if vim.tbl_contains(configs.text_filetypes, filetype) then
    target_im = AutoIM.prev_im or configs.default_im
  elseif AutoIM.in_special_syntax() or AutoIM.contains_chinese() then
    target_im = AutoIM.prev_im or configs.default_im
  else
    target_im = configs.default_im
  end

  AutoIM.switch_to(target_im)
end

local group = vim.api.nvim_create_augroup('InputMethodSelect', { clear = true })

vim.api.nvim_create_autocmd('InsertEnter', {
  group = group,
  callback = function()
    vim.schedule(switch_to_prev)
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'FocusGained' }, {
  group = group,
  callback = function()
    vim.schedule(switch_to_default)
  end,
})
