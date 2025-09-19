local kind_icons = G.icons.kind_icons
local diag_icons = G.icons.diag
local tree = G.icons.tree
local files = G.icons.files

local presets = require('plugins.editor.snacks.picker.presets')

local function resize(amount)
  return function(win)
    local edgy = require('edgy').get_win(win.opts.win)
    local dim = edgy:dim('width')
    if dim ~= edgy.width then
      edgy:resize('width')
    end
    edgy:resize('width', amount)
  end
end

-- [[ https://github.com/folke/snacks.nvim/blob/main/lua/snacks/explorer/actions.lua ]]
local actions = {
  -- action of keymap '.'
  explorer_focus = function(picker)
    vim.fn.chdir(picker:dir())
  end,
  -- action of keymap '<BS>'
  explorer_up = function(picker)
    vim.fn.chdir(vim.fs.dirname(picker:cwd()))
  end,
  explorer_add = function(picker)
    local Actions = require('snacks.explorer.actions')
    local Tree = require('snacks.explorer.tree')
    local uv = vim.uv or vim.loop

    Snacks.input({
      prompt = 'New file or directory',
    }, function(value)
      if not value or value:find('^%s$') then
        return
      end
      local path = svim.fs.normalize(picker:dir() .. '/' .. value)
      local is_file = value:sub(-1) ~= '/'
      local dir = is_file and vim.fs.dirname(path) or path
      if is_file and uv.fs_stat(path) then
        Snacks.notify.warn('File already exists:\n- `' .. path .. '`')
        return
      end
      vim.fn.mkdir(dir, 'p')
      if is_file then
        io.open(path, 'w'):close()
      end
      Tree:open(dir)
      Tree:refresh(dir)
      Actions.update(picker, { target = path })
    end)
  end,
}

return {
  icons = {
    tree = tree,
    files = {
      dir = files.dir,
      dir_open = files.dir_open,
      file = files.file,
    },
    diagnostics = {
      Error = diag_icons.error .. ' ',
      Warn = diag_icons.warn .. ' ',
      Info = diag_icons.info .. ' ',
      Hint = diag_icons.hint .. ' ',
    },
    git = {
      staged = '󰄵',
      modified = '󱗝',
      added = '✚',
      deleted = '✖',
      ignored = '󰘓',
      renamed = '󰁕',
      unmerged = '󰘭 ',
      commit = '󰜘 ',
      untracked = '',
    },
    lsp = {
      unavailable = '✘',
    },
    kinds = kind_icons,
  },
  layouts = {
    default = presets.default,
    vertical = presets.vertical,
    sidebar = presets.sidebar,
    select = presets.select,
  },
  sources = {
    explorer = {
      jump = { close = true },
      layout = {
        preview = { main = true, enabled = false },
      },
      win = {
        list = {
          keys = {
            ['L'] = { { 'pick_win', 'jump' }, mode = { 'n', 'i' } },
            ['<A-Left>'] = resize(-2),
            ['<A-Right>'] = resize(2),
          },
        },
      },
      actions = actions,
    },
    lines = { layout = { preset = 'vertical' } },
    icons = { layout = { preset = 'select' } },
    search_history = { layout = { preset = 'select' } },
    command_history = { layout = { preset = 'select' } },
  },
}
