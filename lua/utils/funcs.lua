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

--- Uset left or right
function M.use_or(left, cond, right)
	if cond then
		return right
	end
	return left
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

return M
