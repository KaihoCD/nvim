local comps = require('plugins.ui.heirline.statusline.comps')
local conditions = require('heirline.conditions')
local pubulic_comps = require('plugins.ui.heirline.comps')
local utils = require('heirline.utils')
local blend = require('plugins.ui.heirline.colors').blend

local edges = G.icons.statusline.separator

return {
	init = function(self)
		local vimode = pubulic_comps.get_vimode()
		self.vicolors = { vimode.color, vimode.color .. '_light', vimode.color .. '_lighter' }
	end,
	-- left part
	{
		utils.surround({ '', edges[1] }, function(self)
			return self.vicolors[1]
		end, {
			comps.Vimode,
		}),
		hl = function(self)
			return { fg = 'bg', bg = self.vicolors[2], bold = true }
		end,
	},
	{
		utils.surround({ '', edges[2] }, function(self)
			return self.vicolors[2]
		end, {
			comps.Git,
		}),
		hl = function(self)
			return { fg = 'fg', bg = self.vicolors[3] }
		end,
	},
	{
		utils.surround({ '', edges[3] }, function(self)
			return self.vicolors[3]
		end, {
			comps.BufferName,
		}),
		hl = function(self)
			return {
				fg = blend('fg', self.vicolors[2]),
				bg = 'bg',
				italic = true,
			}
		end,
	},
	{
		condition = conditions.is_active,
		comps.Diagnostics,
		hl = function()
			return { bg = 'bg' }
		end,
	},
	-- mid part
	{
		{ provider = ' %=' },
		{
			condition = conditions.is_active,
			comps.WorkDir,
		},
		{ provider = '%= ' },
		hl = function()
			return { fg = 'fg', bg = 'bg' }
		end,
	},
	-- right part
	{
		condition = conditions.is_active,
		flexible = 5,
		comps.Lsp,
		{ provider = '' },
		hl = function()
			return { fg = 'normal', bg = 'bg' }
		end,
	},
	{
		utils.surround({ edges[4], '' }, function(self)
			return self.vicolors[3]
		end, {
			comps.Ts,
		}),
		hl = function(self)
			return {
				fg = blend('fg', self.vicolors[2]),
				bg = 'bg',
				italic = true,
			}
		end,
	},
	{
		utils.surround({ edges[5], '' }, function(self)
			return self.vicolors[2]
		end, {
			comps.Record,
		}),
		hl = function(self)
			return { fg = 'fg', bg = self.vicolors[3] }
		end,
	},
	{
		utils.surround({ edges[6], '' }, function(self)
			return self.vicolors[1]
		end, {
			comps.Ruler,
		}),
		hl = function(self)
			return { fg = 'bg', bg = self.vicolors[2], bold = true }
		end,
	},
}
