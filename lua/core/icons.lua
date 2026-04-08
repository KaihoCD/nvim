local M = {}

M.ui = {
    nvim = '',
    git = '󰘬',
    home = '',
    lsp = '󰄹',
    ts = '󱏒',
    ruler = '󰉪',
    record = '󰻃',
    close = '',
    ellipsis = '…',
    separator = { '', '' },
    -- stylua: ignore start
    tabnr = {
        { '󰎥', '󰼏' }, { '󰎨', '󰼐' },
        { '󰎫', '󰼑' }, { '󰎲', '󰼒' },
        { '󰎯', '󰼓' }, { '󰎴', '󰼔' },
        { '󰎷', '󰼕' }, { '󰎺', '󰼖' },
        { '󰎽', '󰼗' }, { '󰿫', '󰿪' },
    },
    -- stylua: ignore end
}

M.diag = {
    error = '',
    warn = '',
    info = '',
    hint = '',
}

M.levels = {
    error = '',
    warn = '',
    info = '',
    debug = '',
    trace = '󰴽',
}

M.file = {
    default = '󰈤',
    modified = '',
    readonly = '󰌾',
    dir = '󰉋',
    dir_open = '󰝰',
}

M.markdown = {
    header = { '󰎥  ', '󰼐  ', '󰎫  ', '󰼒  ', '󰎯  ', '󰼔  ' },
    checkbox = {
        checked = '  ',
        unchecked = '  ',
        todo = '  ',
        important = '  ',
        question = '  ',
    },
}

M.kind_icons = {
    Copilot = '',

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
}

G.icons = M
