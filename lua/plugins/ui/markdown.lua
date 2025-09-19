local icons = G.icons.markdown
local checkbox = icons.checkbox

local M = {}

local function append_checkbox(raw, render_icon, highlight)
  return {
    raw = '[' .. raw .. ']',
    rendered = render_icon,
    highlight = highlight,
    scope_highlight = nil,
  }
end

M.opts = {
  overrides = {
    buftype = {
      nofile = {
        code = {
          left_pad = 0,
          right_pad = 0,
          border = 'hide',
          language_icon = false,
          language_name = false,
          highlight = 'MainNormalFloat',
        },
        bullet = {
          highlight = 'MainNormalFloat',
        },
      },
    },
  },
  render_modes = true,
  sign = { enabled = false },
  code = {
    width = 'block',
    border = 'thin',
    min_width = 80,
    left_pad = 1,
    right_pad = 1,
    position = 'right',
    language_border = '▄',
    language_left = '██',
    language_right = '██',
    highlight_inline = 'RenderMarkdownCodeInfo',
  },
  heading = {
    width = 'block',
    border = true,
    icons = icons.header,
    left_pad = 1,
    right_pad = 1,
  },
  checkbox = {
    right_pad = 0,
    checked = { icon = checkbox.checked },
    unchecked = { icon = checkbox.unchecked },
    custom = {
      todo = append_checkbox('-', checkbox.todo, 'RenderMarkdownTodo'),
      important = append_checkbox('!', checkbox.important, 'DiagnosticWarn'),
      question = append_checkbox('?', checkbox.question, 'DiagnosticInfo'),
    },
  },
  anti_conceal = {
    ignore = {
      head_border = true,
      head_background = true,
    },
  },
}

return M
