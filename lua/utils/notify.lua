-- @param msg string  message content
-- @param level number? log levels
-- @param opts table?
local function _notify(msg, level, opts)
    level = level or vim.log.levels.INFO
    opts = opts or {}

    if Snacks and Snacks.notify then
        opts.level = level
        return Snacks.notify(msg, opts)
    else
        return vim.notify(msg, level, opts)
    end
end

local function with_defaults(defaults)
    defaults = defaults or {}

    local function merge(opts)
        return vim.tbl_extend('force', defaults, opts or {})
    end

    return setmetatable({}, {
        __call = function(_, msg, level, opts)
            return _notify(msg, level, merge(opts))
        end,
    })
end

local notify = setmetatable({}, {
    __call = function(_, msg, level, opts)
        return _notify(msg, level, opts)
    end,
})

notify.info = function(msg, opts)
    return _notify(msg, vim.log.levels.INFO, opts)
end
notify.warn = function(msg, opts)
    return _notify(msg, vim.log.levels.WARN, opts)
end
notify.error = function(msg, opts)
    return _notify(msg, vim.log.levels.ERROR, opts)
end
notify.debug = function(msg, opts)
    return _notify(msg, vim.log.levels.DEBUG, opts)
end
notify.trace = function(msg, opts)
    return _notify(msg, vim.log.levels.TRACE, opts)
end

---@param defaults table?
---@return {info: fun(msg: string, opts?: table), warn: fun(msg: string, opts?: table), error: fun(msg: string, opts?: table), debug: fun(msg: string, opts?: table), trace: fun(msg: string, opts?: table)}
---Create a scoped notifier that merges `defaults` into every notification call.
---The returned object can be called like `notify`, and also exposes level helpers
---such as `info`, `warn`, and `error`.
notify.with = function(defaults)
    local scoped = with_defaults(defaults)
    scoped.info = function(msg, opts)
        return notify.info(msg, vim.tbl_extend('force', defaults or {}, opts or {}))
    end
    scoped.warn = function(msg, opts)
        return notify.warn(msg, vim.tbl_extend('force', defaults or {}, opts or {}))
    end
    scoped.error = function(msg, opts)
        return notify.error(msg, vim.tbl_extend('force', defaults or {}, opts or {}))
    end
    scoped.debug = function(msg, opts)
        return notify.debug(msg, vim.tbl_extend('force', defaults or {}, opts or {}))
    end
    scoped.trace = function(msg, opts)
        return notify.trace(msg, vim.tbl_extend('force', defaults or {}, opts or {}))
    end
    return scoped
end

return notify
