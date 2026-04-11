local M = {}

local COLOR_MAP = require('modules.colors.colors-map')
local utils = require('modules.colors.utils')

-- Local cache for the color palette
local cached_palette = nil

---@return string[]?
local function export_command()
    local clrs_path = vim.fn.expand('~/.config/clrs/clrs')

    if vim.fn.executable(clrs_path) == 1 then
        return { clrs_path, 'export', 'lua' }
    end

    -- Fall back to system clrs if available
    if vim.fn.executable('clrs') == 1 then
        return { 'clrs', 'export', 'lua' }
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

    if type(theme) ~= 'table' or not theme.name or not theme.base00 or not theme.base17 then
        return nil
    end

    return theme
end

---@return table? theme
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

    return decode_theme(result.stdout)
end

--- Get the cached color palette
---@return table? palette The cached color palette, or nil if not loaded
function M.get()
    if cached_palette then
        return cached_palette
    end

    -- If not cached locally, try to get from State
    cached_palette = G.State.get('clrs')
    return cached_palette
end

function M.setup()
    local theme = load_palette()
    if not theme then
        -- Try to populate cache from State even if load fails
        cached_palette = G.State.get('clrs')
        return
    end

    local current = G.State.get('clrs')
    if current and current.name == theme.name then
        -- Cache the current palette
        cached_palette = current
        return
    end

    local palette = utils.build_palette(theme, COLOR_MAP)

    G.State.set('clrs', palette)
    -- Update local cache
    cached_palette = palette
end

return M
