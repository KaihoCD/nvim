if G.status.icon_type == 'termicons' then
	return {
		'mskelton/termicons.nvim', -- Need font "termicons"
		event = 'VeryLazy',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		build = false,
		opts = {},
	}
end

return {
	'nvim-tree/nvim-web-devicons',
	event = 'VeryLazy',
	opts = {},
}
