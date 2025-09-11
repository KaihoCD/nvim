local checkbox = G.md.checkbos

local M = {}

local function add_checkbox_type(raw, render_icon, highlight)
	return {
		raw = '[' .. raw .. ']',
		rendered = render_icon,
		highlight = highlight,
		scope_highlight = nil,
	}
end

M.opts = {
	overrides = {
		buftype = {
			nofile = {
				code = {
					left_pad = 0,
					right_pad = 0,
					border = 'hide',
					language_icon = false,
					language_name = false,
					highlight = 'FloatBg',
				},
			},
		},
	},
	render_modes = true,
	sign = { enabled = false },
	code = {
		width = 'block',
		min_width = '80',
		border = 'thin',
		left_pad = 1,
		right_pad = 1,
		highlight_inline = 'RenderMarkdownCodeInfo',
	},
	heading = {
		icons = G.md.header,
		width = 'block',
		left_pad = 1,
		right_pad = 1,
	},
	checkbox = {
		right_pad = 0,
		checked = { icon = checkbox.checked },
		unchecked = { icon = checkbox.unchecked },
		custom = {
			todo = add_checkbox_type('-', checkbox.todo, 'RenderMarkdownTodo'),
			important = add_checkbox_type('!', checkbox.important, 'DiagnosticWarn'),
			question = add_checkbox_type('?', checkbox.question, 'DiagnosticInfo'),
		},
	},
	anti_conceal = {
		ignore = {
			head_border = true,
			head_background = true,
		},
	},
}

return M
