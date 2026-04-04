local M = {}

M.default_clrs = {
    system = 'base24',
    name = 'Neovim Default Dark',
    author = 'Neovim',
    variant = 'dark',
    palette = {
        bg = '#14161b',
        bgAlt = '#2c2e33',
        bgSel = '#4f5258',
        comment = '#9b9ea4',
        fgMute = '#b7bcc4',
        fg = '#e0e2ea',
        fgAlt = '#d2d6de',
        fgMax = '#eef1f8',
        red = '#ff8f9a',
        orange = '#ffb26b',
        yellow = '#fce094',
        green = '#b3f6c0',
        cyan = '#8cf8f7',
        blue = '#a6dbff',
        purple = '#d5c5ff',
        accent = '#6b5300',
        bgDark = '#2c2e33',
        bgDeep = '#101216',
        redAlt = '#ffc0b9',
        yellowAlt = '#fce094',
        greenAlt = '#b3f6c0',
        cyanAlt = '#8cf8f7',
        blueAlt = '#a6dbff',
        purpleAlt = '#d5c5ff',
    },
    raw = {
        base00 = '#14161b',
        base01 = '#2c2e33',
        base02 = '#4f5258',
        base03 = '#9b9ea4',
        base04 = '#b7bcc4',
        base05 = '#e0e2ea',
        base06 = '#d2d6de',
        base07 = '#eef1f8',
        base08 = '#ff8f9a',
        base09 = '#ffb26b',
        base0A = '#fce094',
        base0B = '#b3f6c0',
        base0C = '#8cf8f7',
        base0D = '#a6dbff',
        base0E = '#d5c5ff',
        base0F = '#6b5300',
        base10 = '#2c2e33',
        base11 = '#101216',
        base12 = '#ffc0b9',
        base13 = '#fce094',
        base14 = '#b3f6c0',
        base15 = '#8cf8f7',
        base16 = '#a6dbff',
        base17 = '#d5c5ff',
    },
}

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
