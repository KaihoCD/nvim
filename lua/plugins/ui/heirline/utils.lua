local M = {}

local devicons = require('nvim-web-devicons')
local highlights = require('heirline.highlights')

M.mode = {
    ['n'] = { 'NORMAL', 'blue' },
    ['no'] = { 'OP', 'blue' },
    ['nov'] = { 'OP', 'blue' },
    ['noV'] = { 'OP', 'blue' },
    ['no'] = { 'OP', 'blue' },
    ['niI'] = { 'NORMAL', 'blue' },
    ['niR'] = { 'NORMAL', 'blue' },
    ['niV'] = { 'NORMAL', 'blue' },
    ['i'] = { 'INSERT', 'green' },
    ['ic'] = { 'INSERT', 'green' },
    ['ix'] = { 'INSERT', 'green' },
    ['t'] = { 'TERM', 'comment' },
    ['nt'] = { 'N-TERM', 'blue' },
    ['v'] = { 'VISUAL', 'purple' },
    ['vs'] = { 'V-CHAR', 'purple' },
    ['V'] = { 'V-LINES', 'purple' },
    ['Vs'] = { 'V-LINES', 'purple' },
    [''] = { 'V-BLOCK', 'purple' },
    ['s'] = { 'V-BLOCK', 'purple' },
    ['R'] = { 'REPLACE', 'red' },
    ['Rc'] = { 'REPLACE', 'red' },
    ['Rx'] = { 'REPLACE', 'red' },
    ['Rv'] = { 'V-REPLACE', 'red' },
    ['s'] = { 'SELECT', 'purple' },
    ['S'] = { 'S-LINE', 'purple' },
    [''] = { 'S-BLOCK', 'purple' },
    ['c'] = { 'COMMAND', 'yellow' },
    ['cv'] = { 'COMMAND', 'yellow' },
    ['ce'] = { 'COMMAND', 'yellow' },
    ['r'] = { 'PROMPT', 'comment' },
    ['rm'] = { 'MORE', 'comment' },
    ['r?'] = { 'CONFIRM', 'comment' },
    ['!'] = { 'SHELL', 'comment' },
    ['null'] = { 'null', 'comment' },
}

---@return string icon The file icon
---@return string color The icon color
---@return string filename The file name
function M.get_file_info()
    local bufpath = vim.api.nvim_buf_get_name(0)

    if bufpath == '' then
        return G.icons.file.default, '', '[No Name]'
    end

    local filename = vim.fn.fnamemodify(bufpath, ':t')
    if filename == '' then
        filename = '[No Name]'
    end

    local extension = vim.fn.fnamemodify(bufpath, ':e')
    local icon, color = devicons.get_icon_color(bufpath, extension, { default = false })

    return icon or G.icons.file.default, color or '', filename
end

-- Normalizes buffer paths by removing URI schemes and handling special cases.
function M.normalize_buf_path(buf_path)
    if buf_path == '' then
        return ''
    end

    if buf_path:match('^oil://') then
        return buf_path:gsub('^oil://', '')
    end

    if buf_path:match('^file://') then
        return vim.uri_to_fname(buf_path)
    end

    if buf_path:match('^[%w.+-]+://') then
        return nil
    end

    return buf_path
end

function M.get_buffer_identity(bufnr)
    local raw_name = vim.api.nvim_buf_get_name(bufnr or 0)
    local is_oil = raw_name:match('^oil://') ~= nil
    local is_unnamed = raw_name == ''

    return {
        raw_name = raw_name,
        path = M.normalize_buf_path(raw_name),
        is_oil = is_oil,
        is_unnamed = is_unnamed,
        fallback_name = is_unnamed and '[No Name]' or is_oil and '[Oil]' or nil,
    }
end

function M.normalize_segment(segment)
    return (segment:gsub('^~', G.icons.ui.home .. ' '))
end

---@param text string
---@param hl table
---@return string
local function paint(text, hl)
    local open, close = highlights.eval_hl(hl)
    return open .. text .. close
end

---@param segments string[]
---@param separator string
---@param segment_hl table
---@param separator_hl table
---@return string
function M.render_path_segments(segments, separator, segment_hl, separator_hl)
    local rendered = {}

    for i, segment in ipairs(segments) do
        if i > 1 then
            table.insert(rendered, paint(separator, separator_hl))
        end

        table.insert(rendered, paint(M.normalize_segment(segment), segment_hl))
    end

    return table.concat(rendered)
end

return M
