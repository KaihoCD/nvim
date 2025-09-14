local M = {}

local border_style = G.status.border_style
local menu_border = G.status.blink_menu_border
local kind_icons = G.kind_icons

M.opts = {
	fuzzy = { implementation = 'prefer_rust_with_warning' },
	appearance = { kind_icons = kind_icons },
	completion = {
		list = {
			selection = { preselect = true, auto_insert = false },
		},
		documentation = {
			window = { border = border_style },
			auto_show = true,
		},
		ghost_text = { enabled = true },
		menu = {
			border = menu_border,
			auto_show = true,
			draw = {
				columns = { { 'kind_icon' }, { 'label', gap = 1 } },
				components = {
					label = {
						text = function(ctx)
							return require('colorful-menu').blink_components_text(ctx)
						end,
						highlight = function(ctx)
							return require('colorful-menu').blink_components_highlight(ctx)
						end,
					},
					-- [[ https://github.com/brenoprata10/nvim-highlight-colors#blinkcmp-integration ]]
					kind_icon = {
						text = function(ctx)
							-- default kind icon
							local icon = ctx.kind_icon
							-- if LSP source, check for color derived from documentation
							if ctx.item.source_name == 'LSP' then
								local color_item = require('nvim-highlight-colors').format(
									ctx.item.documentation,
									{ kind = ctx.kind }
								)
								if color_item and color_item.abbr ~= '' then
									icon = color_item.abbr
								end
							end
							return icon .. ctx.icon_gap
						end,
						highlight = function(ctx)
							-- default highlight group
							local highlight = 'BlinkCmpKind' .. ctx.kind
							-- if LSP source, check for color derived from documentation
							if ctx.item.source_name == 'LSP' then
								local color_item = require('nvim-highlight-colors').format(
									ctx.item.documentation,
									{ kind = ctx.kind }
								)
								if color_item and color_item.abbr_hl_group then
									highlight = color_item.abbr_hl_group
								end
							end
							return highlight
						end,
					},
				},
			},
		},
	},
	signature = { window = { border = border_style } },
	keymap = {
		preset = 'super-tab',
		-- override the 'super-tab' preset
		['<Tab>'] = { 'select_and_accept', 'fallback' },
		['<C-h>'] = { 'snippet_backward', 'fallback' },
		['<C-l>'] = { 'snippet_forward', 'fallback' },
	},
	sources = {
		default = { 'lsp', 'snippets', 'path', 'buffer', 'lazydev' },
		providers = {
			lazydev = {
				name = 'LazyDev',
				module = 'lazydev.integrations.blink',
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
	},
	cmdline = {
		sources = function()
			local cmd_type = vim.fn.getcmdtype()
			if cmd_type == '/' then
				return { 'buffer' }
			end
			if cmd_type == ':' then
				return { 'cmdline' }
			end
			return {}
		end,
		keymap = {
			preset = 'super-tab',
		},
		completion = {
			menu = {
				auto_show = true,
			},
		},
	},
}

return M
