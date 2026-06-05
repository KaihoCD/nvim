local conditions = require('heirline.conditions')
local heirline_utils = require('heirline.utils')
local utils = require('plugins.ui.heirline.utils')
local git = require('plugins.ui.heirline.git')

local M = {}

local icons = G.icons

M.vi_mode = {
    flexible = 6,
    update = { 'ModeChanged', 'BufEnter' },
    {
        provider = function()
            return ' ' .. icons.ui.nvim .. ' ' .. utils.mode[vim.api.nvim_get_mode().mode][1] .. ' '
        end,
    },
    { provider = '' },
}

M.git = {
    condition = function()
        local is_repo, _ = git.get_status()
        return is_repo
    end,
    update = {
        'BufEnter',
        'DirChanged',
        'FocusGained',
        'InsertLeave',
        'BufWritePost',
        'CursorHold',
    },
    init = function(self)
        local _, branch = git.get_status()

        -- Always use global branch name for consistency across all buffers
        self.branch_name = branch

        -- Git changes are buffer-specific (only for tracked files)
        local b_status = vim.b.gitsigns_status_dict
        if b_status then
            self.status_dict = b_status
            self.has_changes = (b_status.added or 0) ~= 0
                or (b_status.removed or 0) ~= 0
                or (b_status.changed or 0) ~= 0
        else
            self.status_dict = { added = 0, removed = 0, changed = 0 }
            self.has_changes = false
        end
    end,
    {
        provider = function(self)
            return ' ' .. icons.ui.git .. ' ' .. self.branch_name
        end,
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        {
            provider = '[',
        },
        {
            provider = function(self)
                local count = self.status_dict.added or 0
                return count > 0 and ('+' .. count)
            end,
            hl = function()
                return { fg = 'green_bright' }
            end,
        },
        {
            provider = function(self)
                local count = self.status_dict.changed or 0
                return count > 0 and ('~' .. count)
            end,
            hl = function()
                return { fg = 'yellow_bright' }
            end,
        },
        {
            provider = function(self)
                local count = self.status_dict.removed or 0
                return count > 0 and ('-' .. count)
            end,
            hl = function()
                return { fg = 'red_bright' }
            end,
        },
        {
            provider = ']',
        },
    },
    { provider = ' ' },
}

M.diagnostic = {
    condition = conditions.has_diagnostics,
    init = function(self)
        local diag = vim.diagnostic.count(0)
        self.errors = diag[vim.diagnostic.severity.ERROR] or 0
        self.warnings = diag[vim.diagnostic.severity.WARN] or 0
        self.info = diag[vim.diagnostic.severity.INFO] or 0
        self.hints = diag[vim.diagnostic.severity.HINT] or 0
    end,
    update = { 'DiagnosticChanged', 'BufEnter' },
    {
        provider = function(self)
            return self.errors > 0 and (' ' .. icons.diag.error .. ' ' .. self.errors)
        end,
        hl = function()
            return { fg = 'red_bright' }
        end,
    },
    {
        provider = function(self)
            return self.warnings > 0 and (' ' .. icons.diag.warn .. ' ' .. self.warnings)
        end,
        hl = function()
            return { fg = 'yellow_bright' }
        end,
    },
    {
        provider = function(self)
            return self.info > 0 and (' ' .. icons.diag.info .. ' ' .. self.info)
        end,
        hl = function()
            return { fg = 'blue_bright' }
        end,
    },
    {
        provider = function(self)
            return self.hints > 0 and (' ' .. icons.diag.hint .. ' ' .. self.hints)
        end,
        hl = function()
            return { fg = 'cyan_bright' }
        end,
    },
}

M.record = {
    condition = function()
        return vim.fn.reg_recording() ~= ''
    end,
    update = { 'RecordingEnter', 'RecordingLeave' },
    { provider = string.format(' %s ', icons.ui.record), hl = { italic = false } },
    heirline_utils.surround({ '󰅁', '󰅂 ' }, nil, {
        provider = function()
            return vim.fn.reg_recording()
        end,
    }),
}

M.lsp = {
    condition = conditions.lsp_attached,
    update = { 'LspAttach', 'LspDetach' },
    { provider = ' ' .. icons.ui.lsp, hl = { italic = false } },
    {
        provider = function()
            local names = vim.iter(vim.lsp.get_clients({ bufnr = 0 }))
                :map(function(client)
                    return client.name
                end)
                :totable()
            return string.format(' %s', table.concat(names, ','))
        end,
    },
    { provider = ' ' },
}

M.indent = {
    condition = function()
        return vim.bo.buftype == ''
    end,
    update = { 'OptionSet', 'BufEnter' },
    provider = function()
        local indent_type = vim.bo.expandtab and 'Spaces' or 'Tab Size'
        local size = vim.bo.shiftwidth
        if size == 0 then
            size = vim.bo.tabstop
        end
        return string.format(' %s:%d ', indent_type, size)
    end,
}

M.ts = {
    condition = function()
        local ok, parser = pcall(vim.treesitter.get_parser, 0)
        return ok and parser
    end,
    init = function(self)
        local parser = vim.treesitter.get_parser(0)
        self.lang = parser and parser:lang()
    end,
    flexible = 4,
    {
        { provider = ' ' .. icons.ui.ts .. ' ', hl = { italic = false } },
        {
            provider = function(self)
                return self.lang
            end,
        },
        { provider = ' ' },
    },
    { provider = '' },
}

M.ruler = {
    flexible = 3,
    { provider = ' ' .. icons.ui.ruler .. ' %P ' },
    { provider = '' },
}

return {
    {
        M.vi_mode,
        M.git,
        M.diagnostic,
        { provider = ' %=' },
        M.record,
        M.indent,
        M.lsp,
        M.ts,
        M.ruler,
        hl = { bg = 'bg_sub' },
    },
}
