local heirline_utils = require('plugins.ui.heirline.utils')
local utils = require('heirline.utils')

local M = {}
local sep = package.config:sub(1, 1)

M.ctx = {
    separator = ' ',
    bg = 'bg_sub',
    hl = {
        cwd = { fg = 'fg_low' },
        separator = { fg = 'fg_low' },
        relative = { fg = 'fg_high' },
        filename = { fg = 'blue' },
        file_icon = nil,
        modified = { fg = 'green', italic = false },
        readonly = { fg = 'yellow', italic = false },
    },
}

-- Configuration for long segment truncation
M.truncate_config = {
    max_length = 30, -- Maximum length before truncation
    keep_prefix = 15, -- Characters to keep at start
    keep_suffix = 10, -- Characters to keep at end
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
                M.ctx.hl[hl_key],
                M.ctx.hl.separator,
                M.ctx.bg
            )
        end,
    }
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
        -- Return a copy of segments
        local dirs = {}
        for i, seg in ipairs(segments) do
            dirs[i] = seg
        end
        return dirs, nil
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

--- Calculate the display width of TabPages component
---@return number
local function calculate_tabpages_width()
    local count = vim.fn.tabpagenr('$')
    if count <= 1 then
        return 0
    end
    -- Each tab format: ' N ' = 3 chars per tab
    return count * 3
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

--- Truncate a long segment intelligently
---@param segment string
---@return string
local function truncate_segment(segment)
    local max_len = M.truncate_config.max_length
    local width = vim.fn.strdisplaywidth(segment)

    if width <= max_len then
        return segment
    end

    -- For very long segments, keep prefix and suffix with ellipsis in middle
    local keep_prefix = M.truncate_config.keep_prefix
    local keep_suffix = M.truncate_config.keep_suffix

    -- Extract prefix and suffix
    local chars = vim.fn.split(segment, '\\zs') -- Split into characters
    if #chars <= keep_prefix + keep_suffix then
        return segment
    end

    local prefix_chars = {}
    for i = 1, keep_prefix do
        table.insert(prefix_chars, chars[i])
    end

    local suffix_chars = {}
    for i = #chars - keep_suffix + 1, #chars do
        table.insert(suffix_chars, chars[i])
    end

    return table.concat(prefix_chars) .. '…' .. table.concat(suffix_chars)
end

--- Truncate and prepare path segments
---@param segments string[]
---@return table[] array of {text: string}
local function prepare_segments(segments)
    local result = {}
    for _, seg in ipairs(segments) do
        -- Skip empty segments and apply truncation
        if seg and seg ~= '' then
            table.insert(result, {
                text = truncate_segment(seg),
            })
        end
    end
    return result
end

--- Calculate total display width of rendered segments
---@param segments string[]
---@param separator string
---@return number
local function calculate_segments_width(segments, separator)
    if #segments == 0 then
        return 0
    end

    local total = 0
    for i, seg in ipairs(segments) do
        total = total + vim.fn.strdisplaywidth(seg)
        if i < #segments then
            total = total + vim.fn.strdisplaywidth(separator)
        end
    end
    return total
end

--- Fit path segments to available width dynamically
---@param display_info table
---@param available_width number
---@return string[] cwd_segments, string[] path_segments, string|nil filename
local function fit_path_to_width(display_info, available_width)
    local separator = M.ctx.separator

    -- Extract basic info
    local cwd_segments = display_info.cwd_segments or {}
    local is_file = display_info.is_file
    local base_segments = display_info.mode == 'cwd' and display_info.child_segments
        or display_info.full_segments
        or {}

    -- Split dirs and filename
    local all_dirs, filename = split_dirs_and_filename(base_segments, is_file)

    -- Prepare segments (truncate long names and filter empty)
    local dir_infos = prepare_segments(all_dirs)

    -- Get cwd anchor
    local cwd_anchor = nil
    local has_cwd = display_info.mode == 'cwd' and #cwd_segments > 0
    if has_cwd then
        cwd_anchor = cwd_segments[#cwd_segments]
    end

    -- Build result from end to start, checking width each time
    local selected_dirs = {}

    for i = #dir_infos, 1, -1 do
        local seg_info = dir_infos[i]

        -- Try adding this segment
        local test_dirs = vim.deepcopy(selected_dirs)
        table.insert(test_dirs, 1, seg_info.text)

        -- Calculate total width if we include this segment
        local cwd_width = has_cwd
                and cwd_anchor
                and (vim.fn.strdisplaywidth(cwd_anchor) + vim.fn.strdisplaywidth(separator))
            or 0
        local dirs_width = calculate_segments_width(test_dirs, separator)
        local filename_width = filename
                and (vim.fn.strdisplaywidth(separator) + vim.fn.strdisplaywidth(filename) + 3)
            or 0 -- +3 for icon

        local total_width = cwd_width + dirs_width + filename_width

        if total_width <= available_width then
            -- Fits! Add this segment
            table.insert(selected_dirs, 1, seg_info.text)
        else
            -- Doesn't fit, add ellipsis if we have some segments
            if #selected_dirs > 0 then
                table.insert(selected_dirs, 1, '…')
            end
            break
        end
    end

    -- Filter empty strings
    local result_dirs = {}
    for _, seg in ipairs(selected_dirs) do
        if seg and seg ~= '' then
            table.insert(result_dirs, seg)
        end
    end

    -- Return results
    if has_cwd and cwd_anchor then
        return { cwd_anchor }, result_dirs, filename
    else
        return {}, result_dirs, filename
    end
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

local function make_dynamic_path_component()
    return {
        init = function(self)
            -- Calculate available width
            local total_width = vim.o.columns
            local tabpages_width = calculate_tabpages_width()
            local padding = 2 -- left and right padding (1 space each)
            local file_status_reserve = 4 -- Reserve space for file status icons (● + )

            -- Add some safety margin to prevent overflow
            local safety_margin = 5
            local available_width = total_width
                - tabpages_width
                - padding
                - file_status_reserve
                - safety_margin

            -- Ensure available_width is positive
            if available_width < 10 then
                available_width = 10
            end

            -- Fit path to available width
            local cwd_segments, path_segments, filename =
                fit_path_to_width(self.display_info, available_width)

            self.separator = M.ctx.separator
            self.cwd_segments = cwd_segments
            self.dirs = path_segments
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
    update = { 'BufEnter', 'BufLeave', 'TermLeave', 'BufModifiedSet', 'DirChanged', 'WinResized' },
    init = function(self)
        local cwd = vim.fn.getcwd()
        local buffer = heirline_utils.get_buffer_identity(0)
        local icon, icon_color = heirline_utils.get_file_info()

        self.display_info = build_display_info(cwd, buffer.path)
        self.fallback_name = buffer.fallback_name
        self.allow_file_status = self.display_info.is_file or buffer.is_unnamed
        self.file_icon = self.display_info.is_file and icon or ''
        self.file_icon_hl = self.display_info.is_file and icon_color ~= '' and { fg = icon_color }
            or nil
    end,
    make_dynamic_path_component(),
}

M.TabPages = {
    utils.make_tablist({
        provider = function(self)
            return '%' .. self.tabnr .. 'T ' .. self.tabnr .. ' %T'
        end,
        hl = function(self)
            if self.is_active then
                return { fg = 'blue', bold = true }
            else
                return { fg = 'fg_ghost' }
            end
        end,
    }),
}

return {
    {
        { provider = ' ' },
        M.WorkDir,
        { provider = '%=' },
        M.TabPages,
        { provider = ' ' },
        hl = { bg = 'bg_sub' },
    },
}
