local M = {}

-- Easier map
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  opts.noremap = opts.noremap ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

--- Merge tables if condition is true
---@generic B,O
---@param base B # Base table
---@param cond boolean # Condition to check
---@param override O # Table to merge into base if cond is true
---@return (B|O) # Resulting table after merging (or base if cond is false)
function M.merge_if(base, cond, override)
  if cond then
    return vim.tbl_deep_extend('force', base, override)
  end
  return base
end

---@param funcs table<number, fun(arg: any): any>
---@return fun(value:any):any
function M.pipe(funcs)
  return function(value)
    local result = value
    for _, fn in ipairs(funcs) do
      result = fn(result)
    end
    return result
  end
end

---@alias OsType 'mac' | 'win' | 'wsl' | 'linux'
---@param os_type OsType | nil
---@return OsType | boolean
function M.cur_os(os_type)
  local os = (vim.uv or vim.loop).os_uname()
  local sysname = os.sysname
  local release = os.release

  local cur_os
  if sysname == 'Windows_NT' then
    cur_os = 'win'
  elseif sysname == 'Darwin' then
    cur_os = 'mac'
  elseif sysname == 'Linux' and release:match('WSL') then
    cur_os = 'wsl'
  else
    cur_os = 'linux'
  end

  if os_type then
    return cur_os == os_type
  end

  return cur_os
end

function M.debounce(ms, fn)
  local timer = vim.uv.new_timer()
  return function(...)
    if not timer then
      return
    end
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

return M
