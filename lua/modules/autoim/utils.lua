local M = {}

---@alias OsType 'mac' | 'win' | 'wsl' | 'linux'

---@param os_type? OsType
---@return OsType | boolean
function M.current_os(os_type)
    local os = (vim.uv or vim.loop).os_uname()
    local sysname = os.sysname
    local release = os.release

    local current
    if sysname == 'Windows_NT' then
        current = 'win'
    elseif sysname == 'Darwin' then
        current = 'mac'
    elseif sysname == 'Linux' and release:match('WSL') then
        current = 'wsl'
    else
        current = 'linux'
    end

    if os_type then
        return current == os_type
    end

    return current
end

---@param value string
---@return string
function M.shellescape(value)
    return vim.fn.shellescape(value)
end

---@param cmd string
---@return boolean, string
function M.run(cmd)
    local output = vim.fn.system(cmd)
    local ok = vim.v.shell_error == 0
    return ok, vim.trim(output)
end

---@param items string[]
---@param value string
---@return boolean
function M.contains(items, value)
    return vim.tbl_contains(items, value)
end

return M
