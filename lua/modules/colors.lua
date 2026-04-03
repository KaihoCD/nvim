local M = {}

local COLOR_SCRIPT = vim.fn.expand('~/.config/colors/colors')

---@return string[]?
local function export_command()
    if vim.fn.executable('clrs') == 1 then
        return { 'clrs', 'export', 'lua' }
    end

    if vim.fn.executable(COLOR_SCRIPT) == 1 then
        return { COLOR_SCRIPT, 'export', 'lua' }
    end

    return nil
end

---@param chunk string
---@return table?
local function decode_theme(chunk)
    if type(chunk) ~= 'string' or chunk == '' then
        return nil
    end

    local loader, err = load(chunk, 'clrs.export.lua', 't', {})
    if not loader then
        vim.schedule(function()
            vim.notify('Failed to load exported colors: ' .. err, vim.log.levels.WARN)
        end)
        return nil
    end

    local ok, theme = pcall(loader)
    if not ok then
        vim.schedule(function()
            vim.notify('Failed to evaluate exported colors: ' .. theme, vim.log.levels.WARN)
        end)
        return nil
    end

    if type(theme) ~= 'table' or type(theme.palette) ~= 'table' then
        return nil
    end

    if theme.system == 'base16' and type(theme.raw) ~= 'table' then
        return nil
    end

    return theme
end

---@return table? clrs
local function load_palette()
    local cmd = export_command()
    if not cmd then
        return nil
    end

    local result = vim.system(cmd, { text = true }):wait()
    if result.code ~= 0 then
        local stderr = vim.trim(result.stderr or '')
        if stderr ~= '' then
            vim.schedule(function()
                vim.notify('Failed to export colors: ' .. stderr, vim.log.levels.WARN)
            end)
        end
        return nil
    end

    local theme = decode_theme(result.stdout)
    if type(theme) ~= 'table' then
        return nil
    end

    local palette = type(theme.palette) == 'table' and theme.palette or nil
    if not palette or vim.tbl_isempty(palette) then
        return nil
    end

    theme.palette = palette
    return theme
end

function M.apply()
    local clrs = load_palette()
    if clrs then
        G.State.set('clrs', clrs)
    end
end

return M
