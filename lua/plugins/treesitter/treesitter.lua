local M = {}

-- [[ https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua ]]
M.init = function(plugin)
  require('lazy.core.loader').add_to_rtp(plugin)
  require('nvim-treesitter.query_predicates')
end

M.opts = {
  ensure_installed = {
    'bash',
    'c',
    'diff',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'regex',
    'bash',
    'python',
    'toml',
    'gitignore',

    'javascript',
    'typescript',
    'tsx',
    'vue',

    'html',
    'css',
    'scss',

    'json',
    'jsonc',
  },
  sync_install = true,
  ignore_install = {},
  -- Autoinstall languages that are not installed
  auto_install = true,
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby' } },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<M-=>',
      node_incremental = '<M-=>',
      node_decremental = '<M-->',
      scope_incremental = false,
    },
  },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = {
        [']f'] = '@function.outer',
        [']c'] = '@class.outer',
        [']a'] = '@parameter.inner',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']C'] = '@class.outer',
        [']A'] = '@parameter.inner',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[c'] = '@class.outer',
        ['[a'] = '@parameter.inner',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[C'] = '@class.outer',
        ['[A'] = '@parameter.inner',
      },
    },
  },
}

return M
