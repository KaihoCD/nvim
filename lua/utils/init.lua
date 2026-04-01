local M = {}

M.map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false -- defaults true
    opts.noremap = opts.noremap ~= false -- defaults true
    vim.keymap.set(mode, lhs, rhs, opts)
end

---@generic T
---@param value T|T[]|nil
---@return T[]
M.to_list = function(value)
    if not value then
        return {}
    end
    if type(value) ~= 'table' then
        return { value }
    end
    if vim.islist(value) then
        return value
    end
    return { value }
end

---@generic F: function
---@param ms integer Delay in milliseconds after the most recent call.
---@param fn F Function to invoke after the debounce window expires.
---@return F
function M.debounce(ms, fn)
    local timer = vim.uv.new_timer()
    local argv = nil
    local argc = 0

    return function(...)
        if not timer or timer:is_closing() then
            return
        end

        argv = { ... }
        argc = select('#', ...)
        timer:stop()

        timer:start(ms, 0, function()
            local call_argv = argv
            local call_argc = argc
            timer:stop()
            vim.schedule(function()
                fn(unpack(call_argv, 1, call_argc))
            end)
        end)
    end
end

return M
