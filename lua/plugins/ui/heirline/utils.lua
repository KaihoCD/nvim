local M = {}

local devicons = require('nvim-web-devicons')

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
    ['t'] = { 'TERM', 'brightBlack' },
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
    ['r'] = { 'PROMPT', 'brightBlack' },
    ['rm'] = { 'MORE', 'brightBlack' },
    ['r?'] = { 'CONFIRM', 'brightBlack' },
    ['!'] = { 'SHELL', 'brightBlack' },
    ['null'] = { 'null', 'brightBlack' },
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

M.path_hl = {
    cwd = 'HeirlineTablinePathCwd',
    separator = 'HeirlineTablinePathSeparator',
    relative = 'HeirlineTablinePathRelative',
}

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

function M.set_tabline_path_highlights(ctx)
    vim.api.nvim_set_hl(0, M.path_hl.cwd, ctx.hl.cwd)
    vim.api.nvim_set_hl(0, M.path_hl.separator, ctx.hl.separator)
    vim.api.nvim_set_hl(0, M.path_hl.relative, ctx.hl.relative)
end

function M.paint(group, text)
    return '%#' .. group .. '#' .. text
end

-- Renders the path segments with appropriate highlights and separators.
function M.render_path_segments(segments, separator, group)
    local rendered = {}

    for i, segment in ipairs(segments) do
        if i > 1 then
            table.insert(rendered, M.paint(M.path_hl.separator, separator))
        end

        table.insert(rendered, M.paint(group, M.normalize_segment(segment)))
    end

    return table.concat(rendered)
end

return M
