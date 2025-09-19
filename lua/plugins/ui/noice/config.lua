return function(_, opts)
  -- Override defaultl level function
  ---@diagnostic disable-next-line: duplicate-set-field
  require('noice.text.format.formatters').level = function(message, options)
    if message.level then
      local icon = ''
      if options.icons and options.icons[message.level] then
        icon = options.icons[message.level]
      end
      message:append(' ' .. icon .. ' ', options.hl_group[message.level])
    end
  end

  require('noice').setup(opts)
end
