_G.G = {}

--- Core static settings, usually read from vim.g
--- These are fundamental options that rarely change at runtime
G.setting = {
  ---@type boolean
  use_borderless = vim.g.setting.use_borderless,

  ---@type boolean
  use_termicons = vim.g.setting.use_termicons,

  ---@type BorderType
  border_style = vim.g.setting.border_style,
}

--- Runtime configurable options
--- These can be modified at runtime according to user preference
G.config = {
  ---@type boolean
  -- Whether to auto-format files when saving
  format_on_save = true,

  ---@type boolean
  -- Whether to lint files when text changed
  lint_when_text_changed = true,

  ---@type number
  -- Default indentation size for new files or formatting
  indent_size = vim.g.setting.default_indent_size,
}

--- Context / derived configuration
--- These values are derived from 'setting' and meant for convenient use in business logic or UI modules.
G.context = {
  ---@type string
  -- Border style for blinking menu
  blink_menu_border = G.setting.use_borderless and 'none' or G.setting.border_style,

  ---@type string
  -- Border style for LSP floating windows
  lsp_border_style = G.setting.use_borderless and 'solid' or G.setting.border_style,

  ---@type string
  -- Position of which-key titles: 'center' if borderless, otherwise 'left'
  whichkey_title_pos = G.setting.use_borderless and 'center' or 'left',

  ---@type string
  -- Suffix for icons
  icon_suffix = G.setting.use_termicons and '' or ' ',
}
