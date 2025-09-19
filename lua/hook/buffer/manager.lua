local bufdel = require('utils.bufdel')

-- [[ https://github.com/AstroNvim/astrocore/blob/main/lua/astrocore/buffer.lua ]]
local M = {}

M.current_buf, M.last_buf = nil, nil

--- Check if a buffer is valid
---@param bufnr? integer The buffer to check, default to current buffer
---@return boolean # Whether the buffer is valid or not
function M.is_valid(bufnr)
  if not bufnr then
    bufnr = 0
  end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

--- Navigate left and right by n places in the bufferline
---@param n integer The number of tabs to navigate to (positive = right, negative = left)
function M.nav(n)
  local current = vim.api.nvim_get_current_buf()
  local bufs = vim.t.bufs or {}
  local count = #bufs
  if count < 1 then
    return
  end

  for i, v in ipairs(bufs) do
    if v == current then
      local new_i = i + n
      if new_i < 1 then
        new_i = count + new_i
      end
      if new_i > count then
        new_i = ((new_i - 1) % count) + 1
      end

      local new_buf = bufs[new_i]
      if new_buf and new_buf ~= current then
        vim.api.nvim_set_current_buf(new_buf)
      end
      break
    end
  end
end

--- Move the current buffer tab n places in the bufferline
---@param n integer The number of tabs to move the current buffer over by (positive = right, negative = left)
function M.move(n)
  if n == 0 or not vim.t.bufs then
    return
  end

  local bufs = vim.t.bufs
  local count = #bufs
  if count < 2 then
    return
  end

  local current = vim.api.nvim_get_current_buf()

  for i, bufnr in ipairs(bufs) do
    if bufnr == current then
      local new_i = ((i - 1 + n) % count) + 1
      if new_i == i then
        return
      end

      table.remove(bufs, i)
      table.insert(bufs, new_i, bufnr)

      break
    end
  end

  vim.t.bufs = bufs
  vim.cmd.redrawtabline()
end

--- Close all buffers
---@param keep_current? boolean Whether or not to keep the current buffer (default: false)
---@param force? boolean Whether or not to foce close the buffers or confirm changes (default: false)
function M.close_all(keep_current, force)
  local current = vim.api.nvim_get_current_buf()
  local bufs_to_close = {}

  for _, bufnr in ipairs(vim.t.bufs or {}) do
    if not keep_current or bufnr ~= current then
      table.insert(bufs_to_close, bufnr)
    end
  end

  vim.schedule(function()
    for _, bufnr in ipairs(bufs_to_close) do
      bufdel(bufnr, force)
    end
  end)
end

return M
