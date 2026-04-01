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

    return theme
end

---@return table?
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
    return theme and theme.palette or nil
end

function M.apply()
    local palette = load_palette()
    if palette then
        G.State.set('colors', palette)
    end
end

M.apply()

return M
