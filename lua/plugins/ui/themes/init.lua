---@param default_theme? Colorscheme | nil
local function setup_themes(theme_plugins_configs, default_theme)
	local processed_configs = {}
	local matched = false

	for name, config in pairs(theme_plugins_configs) do
		if default_theme and default_theme:match(name) then
			config.event = nil
			config.priority = nil
			config.config = function()
				vim.cmd.colorscheme(default_theme)
			end
			matched = true
		end
		table.insert(processed_configs, config)
	end

	if not matched then
		vim.cmd.colorscheme('default')
	end

	return processed_configs
end

return setup_themes(require('plugins.ui.themes.configs'), 'nightfox')
