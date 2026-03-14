local size = G.layout.size

---@alias TerminalPosition 'bottom' | 'right' | 'float'
---@alias CachedTerminal snacks.win

---@type table<integer, CachedTerminal | nil>
local terminal_cache = {}

---@type integer
local last_count_key = 1

---@param term CachedTerminal | nil
---@return boolean
local function is_terminal_valid(term)
  if not term then
    return false
  end

  if not term:buf_valid() or not term.buf then
    return false
  end

  return vim.bo[term.buf].buftype == 'terminal'
end

---@param position TerminalPosition
---@param width number
---@param height number
---@param count integer
---@return snacks.terminal.Opts
local function terminal_opts(position, width, height, count)
  return {
    count = count,
    win = {
      position = position,
      width = width,
      height = height,
    },
  }
end

---@param term CachedTerminal
---@param position TerminalPosition
---@param width number
---@param height number
local function update_terminal_layout(term, position, width, height)
  ---@type snacks.win.Config
  local opts = term.opts
  opts.position = position
  opts.width = width
  opts.height = height
end

---@param position TerminalPosition
---@param width number?
---@param height number?
---@return fun()
local function toggle_terminal(position, width, height)
  return function()
    local resolved_width = width or size.float_width
    local resolved_height = height or size.float_height

    for count, term in pairs(terminal_cache) do
      if not is_terminal_valid(term) then
        terminal_cache[count] = nil
      end
    end

    local count_key = vim.v.count == 0 and last_count_key or vim.v.count1
    local term = terminal_cache[count_key]

    if not term then
      terminal_cache[count_key] = Snacks.terminal.toggle(nil, terminal_opts(position, resolved_width, resolved_height, count_key))
      last_count_key = count_key
      return
    end

    update_terminal_layout(term, position, resolved_width, resolved_height)
    term:toggle()

    if is_terminal_valid(term) then
      terminal_cache[count_key] = term
    end

    last_count_key = count_key
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
