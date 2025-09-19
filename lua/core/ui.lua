G.layout = {
  margin = {
    top = 10,
    right = 2,
    bottom = 2,
  },
  size = {
    float_width = 0.8,
    float_height = 0.8,
    split_left = 35,
    split_right = 0.3,
    split_bottom = 0.35,
  },
}

G.icons = {
  tabline = {
    close = '',
    ellipsis = '…',
    -- stylua: ignore start
		tabnr = {
			{ '󰎥', '󰼏' }, { '󰎨', '󰼐' },
			{ '󰎫', '󰼑' }, { '󰎲', '󰼒' },
			{ '󰎯', '󰼓' }, { '󰎴', '󰼔' },
			{ '󰎷', '󰼕' }, { '󰎺', '󰼖' },
			{ '󰎽', '󰼗' }, { '󰿫', '󰿪' },
		},
    -- stylua: ignore end
    separator = { '', '' },
  },
  statusline = {
    nvim = '',
    git = '',
    home = '',
    lsp = '󰄹',
    ts = '󱏒',
    ruler = '󰉪',
    record = '󰻃',
    separator = { '', '', '', '', '', '' },
  },
  buf = {
    modified = '',
    readonly = '󰌾',
  },
  files = {
    dir = '󰉋 ',
    dir_open = '󰝰 ',
    file = '󰈤 ',
    lua = ' ',
  },
  markdown = {
    header = { '󰎥  ', '󰼐  ', '󰎫  ', '󰼒  ', '󰎯  ', '󰼔  ' },
    checkbox = {
      checked = '   ',
      unchecked = '   ',
      todo = '   ',
      important = '   ',
      question = '   ',
    },
  },
  fillchars = {
    foldopen = '',
    foldclose = '',
  },
  tree = {
    vertical = '│ ',
    middle = '│ ',
    last = '└╴',
  },
  diag = {
    error = '',
    warn = '',
    info = '',
    hint = '',
  },
  levels = {
    error = '',
    warn = '',
    info = '',
    debug = '',
    trace = '󰴽',
  },
  kind_icons = {
    Copilot = '',

    String = '',
    Number = '',
    Boolean = '',
    Array = '󰅨',
    Object = '󱃖',
    Package = '󰏖',
    Null = '󰟢',
    Unknown = '',
    Identifier = '',

    -- keys from lspkind
    Text = '󰉿',
    Method = '󰡱',
    Function = '󰡱',
    Constructor = '',

    Field = '',
    Variable = '',
    Property = '󰜢',

    Class = '󰙅',
    Interface = '',
    Struct = '󱡠',
    Namespace = '󰦮',
    Module = '',

    Unit = '󰑭',
    Value = '󱀍',
    Enum = '',
    EnumMember = '',

    Keyword = '󰌆',
    Constant = '󰐀',

    Snippet = '󱄽',
    Color = '󰏘',
    File = '󰈙',
    Reference = '󰬲',
    Folder = '󰝰',
    Event = '',
    Operator = '',
    TypeParameter = '󰬛',
  },
}

if G.setting.use_termicons then
  G.icons.files = {
    dir = '톀',
    dir_open = '톁',
    file = '큪',
    lua = '킺',
  }
end
