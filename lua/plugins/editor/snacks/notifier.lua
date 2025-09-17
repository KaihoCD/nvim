local notify = require('utils.notify')

local level_symbols = G.icons.levels
local margin = G.layout.margin

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
		if not client or type(value) ~= 'table' then
			return
		end
		local p = progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == ev.data.params.token then
				p[i] = {
					token = ev.data.params.token,
					msg = ('[%3d%%] %s%s'):format(
						value.kind == 'end' and 100 or value.percentage or 100,
						value.title or '',
						value.message and (' **%s**'):format(value.message) or ''
					),
					done = value.kind == 'end',
				}
				break
			end
		end

		local msg = {} ---@type string[]
		progress[client.id] = vim.tbl_filter(function(v)
			return table.insert(msg, v.msg) or not v.done
		end, p)

		local spinner = { '', '', '', '', '', '' }
		notify(table.concat(msg, '\n'), 'info', {
			id = 'lsp_progress',
			title = client.name,
			opts = function(notif)
				notif.icon = #progress[client.id] == 0 and ''
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

local M = {}

local function notifier_style()
	local last_buf

	---@param buf integer
	---@param notif snacks.notifier.Notif
	---@param ctx snacks.notifier.ctx
	return function(buf, notif, ctx)
		local render = ctx.notifier:get_render('compact')
		render(buf, notif, ctx)
		vim.schedule(function()
			if not notif.layout or buf == last_buf then
				notif.layout.top = 0
				return
			end

			notif.layout.top = (notif.layout.top or 0) + 1
			ctx.notifier:process()
			last_buf = buf
		end)
	end
end

M.opts = {
	style = notifier_style(),
	margin = { top = 1, right = margin.right, bottom = 0 },
	padding = true,
	icons = {
		error = level_symbols.error,
		warn = level_symbols.warn,
		info = level_symbols.info,
		debug = level_symbols.debug,
		trace = level_symbols.trace,
	},
}

return M
