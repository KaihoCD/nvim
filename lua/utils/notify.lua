local Notify = {}
Notify.__index = Notify

local HL_LEVEL_MAP = {
    [vim.log.levels.TRACE] = 'Macro',
    [vim.log.levels.DEBUG] = 'Comment',
    [vim.log.levels.INFO] = 'DiagnosticInfo',
    [vim.log.levels.WARN] = 'DiagnosticWarn',
    [vim.log.levels.ERROR] = 'DiagnosticError',
}

local function emit(msg, level, opts)
    level = level or vim.log.levels.INFO
    opts = opts or {}

    local prefix = ''
    local icon = opts.icon and type(opts.icon) == 'string' and opts.icon ~= '' and opts.icon or nil
    local title = opts.title and type(opts.title) == 'string' and opts.title ~= '' and opts.title
        or nil

    if icon and title then
        prefix = ('[%s %s] '):format(icon, title)
    elseif title then
        prefix = ('[%s] '):format(title)
    elseif icon then
        prefix = ('[%s] '):format(icon)
    end

    local chunks = {}
    local content_hl = level ~= vim.log.levels.INFO and (HL_LEVEL_MAP[level] or 'Normal') or nil
    if prefix ~= '' then
        chunks[#chunks + 1] = { prefix, HL_LEVEL_MAP[level] or 'Normal' }
    end
    chunks[#chunks + 1] = content_hl and { msg, content_hl } or { msg }

    return vim.api.nvim_echo(chunks, true, {})
end

---@class utils.notify.Instance
---@field defaults table
---@field notify fun(msg: string, level?: number, opts?: table)
---@field info fun(msg: string, opts?: table)
---@field warn fun(msg: string, opts?: table)
---@field error fun(msg: string, opts?: table)
---@field debug fun(msg: string, opts?: table)
---@field trace fun(msg: string, opts?: table)

---@param defaults table?
---@return utils.notify.Instance
function Notify.new(defaults)
    local instance = { defaults = defaults or {} }

    local function merge(opts)
        return vim.tbl_extend('force', instance.defaults or {}, opts or {})
    end

    instance.notify = function(msg, level, opts)
        return emit(msg, level, merge(opts))
    end
    instance.info = function(msg, opts)
        return instance.notify(msg, vim.log.levels.INFO, opts)
    end
    instance.warn = function(msg, opts)
        return instance.notify(msg, vim.log.levels.WARN, opts)
    end
    instance.error = function(msg, opts)
        return instance.notify(msg, vim.log.levels.ERROR, opts)
    end
    instance.debug = function(msg, opts)
        return instance.notify(msg, vim.log.levels.DEBUG, opts)
    end
    instance.trace = function(msg, opts)
        return instance.notify(msg, vim.log.levels.TRACE, opts)
    end

    return setmetatable(instance, Notify)
end

Notify.default = Notify.new()

-- 向后兼容：旧调用方 require('utils.notify').info(msg) 转发到 Notify.default
return setmetatable(Notify, {
    __index = function(_, key)
        local default = rawget(Notify, 'default')
        if default and type(default[key]) == 'function' then
            return default[key]
        end
    end,
    __call = function(_, msg, level, opts)
        return Notify.default.notify(msg, level, opts)
    end,
})
