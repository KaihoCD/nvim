local size = G.layout.size

local terminal_cache = {}

---@type snacks.win | nil
local last_terminal = nil

local function is_terminal_valid(term)
  if not term or not term.win then
    return false
  end

  -- 检查窗口是否有效
  if not term.win:is_valid() then
    return false
  end

  -- 获取窗口的buffer并检查是否是terminal类型
  local buf = term.win:buf()
  if not buf or not buf:is_valid() then
    return false
  end

  -- 检查buffer的filetype是否为terminal
  return vim.bo[buf.id].filetype == 'terminal'
end

local function toggle_terminal(position, width, height)
  return function()
    width = width or size.float_width
    height = height or size.float_height
    local opts = {
      win = {
        position = position,
        width = width,
        height = height,
      },
    }

    if not is_terminal_valid(last_terminal) then
      last_terminal = nil
    end

    for count, term in pairs(terminal_cache) do
      if not is_terminal_valid(term) then
        terminal_cache[count] = nil
      end
    end

    if vim.v.count == 0 then
      if not last_terminal then
        terminal_cache[vim.v.count1] = Snacks.terminal.toggle(nil, opts)
        last_terminal = terminal_cache[vim.v.count1]
      else
        last_terminal.opts.position = position
        last_terminal.opts.width = width
        last_terminal.opts.height = height
        last_terminal:toggle()
      end
      return
    end

    if not terminal_cache[vim.v.count1] or not is_terminal_valid(terminal_cache[vim.v.count1]) then
      terminal_cache[vim.v.count1] = Snacks.terminal.toggle(nil, opts)
      last_terminal = terminal_cache[vim.v.count1]
      return
    end

    last_terminal = terminal_cache[vim.v.count1]
    terminal_cache[vim.v.count1].opts = opts
    last_terminal:toggle()
  end
end

local M = {}

M.keys = {
  {
    '<c-\\>',
    toggle_terminal('bottom', 0, size.split_bottom),
    desc = 'Toggle Terminal',
    mode = { 'n', 't' },
  },
  {
    '|',
    toggle_terminal('right', size.split_right, 0),
    desc = 'Toggle Terminal',
    mode = { 'n', 't' },
  },
  {
    '<C-`>',
    toggle_terminal('float'),
    desc = 'Toggle Terminal',
    mode = { 'n', 't' },
  },
}

M.opts = {
  enabled = true,
  win = { wo = { winbar = '' } },
}

return M
