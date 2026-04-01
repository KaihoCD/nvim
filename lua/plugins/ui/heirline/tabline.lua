local heirline_utils = require('plugins.ui.heirline.utils')
local utils = require('heirline.utils')
local colors = G.State.get('colors')

local M = {}
local sep = package.config:sub(1, 1)

M.ctx = {
    separator = ' ',
    hl = {
        cwd = { fg = colors.brightBlack },
        separator = { fg = colors.brightBlack },
        relative = { fg = colors.foreground },
        filename = { fg = colors.blue },
        file_icon = nil,
        modified = { fg = colors.green, italic = false },
        readonly = { fg = colors.yellow, italic = false },
    },
}

local function make_segments_component(source_key, hl_key)
    return {
        condition = function(self)
            return #self[source_key] > 0
        end,
        provider = function(self)
            return heirline_utils.render_path_segments(
                self[source_key],
                self.separator,
                heirline_utils.path_hl[hl_key]
            )
        end,
    }
end

local function tail(list, count)
    local start = math.max(#list - count + 1, 1)
    local items = {}

    for i = start, #list do
        table.insert(items, list[i])
    end

    return items
end

local function copy(list)
    local items = {}

    for i, item in ipairs(list) do
        items[i] = item
    end

    return items
end

local function split_path(path_str)
    if not path_str or path_str == '' then
        return {}
    end

    return vim.split(path_str, sep, { trimempty = true })
end

local function split_dirs_and_filename(segments, is_file)
    if #segments == 0 then
        return {}, nil
    end

    if not is_file then
        return copy(segments), nil
    end

    local dirs = {}

    for i = 1, #segments - 1 do
        dirs[i] = segments[i]
    end

    return dirs, segments[#segments]
end

local function is_subpath(root, path_str)
    if root == '' or path_str == '' then
        return false
    end

    if root == path_str then
        return true
    end

    local root_prefix = root:sub(-1) == sep and root or root .. sep
    return path_str:sub(1, #root_prefix) == root_prefix
end

local function build_display_info(cwd, buf_path)
    local cwd_short = vim.fn.fnamemodify(cwd, ':~')
    local cwd_segments = split_path(cwd_short)
    local is_file = buf_path and buf_path ~= '' and vim.fn.isdirectory(buf_path) == 0

    if not buf_path or buf_path == '' then
        return {
            mode = 'cwd',
            is_file = false,
            cwd_segments = cwd_segments,
            child_segments = {},
        }
    end

    if not is_subpath(cwd, buf_path) then
        return {
            mode = 'external',
            is_file = is_file,
            full_segments = split_path(vim.fn.fnamemodify(buf_path, ':~')),
        }
    end

    local cwd_prefix = cwd:sub(-1) == sep and cwd or cwd .. sep
    local relative = buf_path:sub(#cwd_prefix + 1)

    return {
        mode = 'cwd',
        is_file = is_file,
        cwd_segments = cwd_segments,
        child_segments = split_path(relative),
    }
end

local function compact_cwd_segments(info)
    local cwd_anchor = info.cwd_segments[#info.cwd_segments] or info.cwd_segments[1]

    if not cwd_anchor then
        return {}, {}
    end

    if #info.child_segments <= 3 then
        return { cwd_anchor }, copy(info.child_segments)
    end

    return { cwd_anchor }, vim.list_extend({ '…' }, tail(info.child_segments, 3))
end

local function compact_external_segments(info)
    if #info.full_segments <= 4 then
        return copy(info.full_segments)
    end

    local anchor = info.full_segments[1] == '~' and (info.full_segments[2] or info.full_segments[1])
        or info.full_segments[1]

    return vim.list_extend({ anchor, '…' }, tail(info.full_segments, 3))
end

local function build_variant(info, variant)
    if variant == 'full' then
        if info.mode == 'cwd' then
            return info.cwd_segments, info.child_segments, info.is_file
        end

        return {}, info.full_segments, info.is_file
    end

    if variant == 'compact' then
        if info.mode == 'cwd' then
            local cwd_segments, path_segments = compact_cwd_segments(info)
            return cwd_segments, path_segments, info.is_file
        end

        return {}, compact_external_segments(info), info.is_file
    end

    local segments = info.mode == 'cwd' and info.child_segments or info.full_segments

    if #segments == 0 then
        segments = info.mode == 'cwd' and info.cwd_segments or {}
    end

    if #segments > 2 then
        segments = vim.list_extend({ '…' }, tail(segments, 2))
    else
        segments = copy(segments)
    end

    if info.mode == 'cwd' and #info.child_segments == 0 then
        return segments, {}, false
    end

    return {}, segments, info.is_file
end

local function make_separator_component(left_key, right_dirs_key, right_filename_key)
    return {
        condition = function(self)
            return #self[left_key] > 0
                and (#self[right_dirs_key] > 0 or self[right_filename_key] ~= nil)
        end,
        provider = function(self)
            return self.separator
        end,
        hl = function()
            return M.ctx.hl.separator
        end,
    }
end

local function make_filename_separator_component()
    return {
        condition = function(self)
            return #self.dirs > 0 and self.filename ~= nil
        end,
        provider = function(self)
            return self.separator
        end,
        hl = function()
            return M.ctx.hl.separator
        end,
    }
end

local function make_icon_component()
    return {
        condition = function(self)
            return self.filename ~= nil and self.file_icon ~= ''
        end,
        provider = function(self)
            return self.file_icon .. ' '
        end,
        hl = function(self)
            return self.file_icon_hl or M.ctx.hl.file_icon or M.ctx.hl.filename
        end,
    }
end

local function make_filename_component()
    return {
        condition = function(self)
            return self.filename ~= nil
        end,
        provider = function(self)
            return heirline_utils.normalize_segment(self.filename)
        end,
        hl = function()
            return M.ctx.hl.filename
        end,
    }
end

local function make_modified_component()
    return {
        update = { 'BufModifiedSet', 'BufWritePost' },
        condition = function(self)
            return self.show_file_status and self.filename ~= nil and vim.bo.modified
        end,
        provider = function()
            return ' ' .. G.icons.file.modified
        end,
        hl = function()
            return M.ctx.hl.modified
        end,
    }
end

local function make_readonly_component()
    return {
        update = { 'OptionSet', 'BufEnter' },
        condition = function(self)
            return self.show_file_status
                and self.filename ~= nil
                and (not vim.bo.modifiable or vim.bo.readonly)
        end,
        provider = function()
            return ' ' .. G.icons.file.readonly
        end,
        hl = function()
            return M.ctx.hl.readonly
        end,
    }
end

local function make_path_component(variant)
    return {
        init = function(self)
            local cwd_segments, path_segments, is_file = build_variant(self.display_info, variant)
            local dirs, filename = split_dirs_and_filename(path_segments, is_file)

            self.separator = M.ctx.separator
            self.cwd_segments = cwd_segments
            self.dirs = dirs
            self.filename = filename or self.fallback_name
            self.show_file_status = self.allow_file_status
        end,
        make_segments_component('cwd_segments', 'cwd'),
        make_separator_component('cwd_segments', 'dirs', 'filename'),
        make_segments_component('dirs', 'relative'),
        make_filename_separator_component(),
        make_icon_component(),
        make_filename_component(),
        make_modified_component(),
        make_readonly_component(),
    }
end

M.WorkDir = {
    flexible = 1,
    update = { 'BufEnter', 'BufModifiedSet', 'DirChanged', 'WinResized' },
    init = function(self)
        local cwd = vim.fn.getcwd()
        local buffer = heirline_utils.get_buffer_identity(0)
        local icon, icon_color = heirline_utils.get_file_info()

        heirline_utils.set_tabline_path_highlights(M.ctx)
        self.display_info = build_display_info(cwd, buffer.path)
        self.fallback_name = buffer.fallback_name
        self.allow_file_status = self.display_info.is_file or buffer.is_unnamed
        self.file_icon = self.display_info.is_file and icon or ''
        self.file_icon_hl = self.display_info.is_file and icon_color ~= '' and { fg = icon_color }
            or nil
    end,
    make_path_component('full'),
    make_path_component('compact'),
    make_path_component('minimal'),
}

M.TabPages = {
    utils.make_tablist({
        provider = function(self)
            return '%' .. self.tabnr .. 'T ' .. self.tabnr .. ' %T'
        end,
        hl = function(self)
            if self.is_active then
                return { fg = colors.blue, bold = true }
            else
                return { fg = colors.brightBlack }
            end
        end,
    }),
}

return {
    { provider = ' ' },
    M.WorkDir,
    { provider = '%=', hl = { bg = colors.black } },
    M.TabPages,
    { provider = ' ' },
}
