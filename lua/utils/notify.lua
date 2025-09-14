-- @param msg   string  消息内容
-- @param level number? 日志等级（默认 INFO）
-- @param opts  table?  传给 notify 的附加选项
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

return notify
