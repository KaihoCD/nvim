local M = {}

--- Apply highlight groups from a group definition table.
--- @param groups table<string, table> group definitions
local function apply_groups(groups)
    for group, def in pairs(groups) do
        local hl = {
            bg = def.bg or 'NONE',
            fg = def.fg or 'NONE',
        }
        if def.bold then
            hl.bold = true
        end
        if def.italic then
            hl.italic = true
        end
        if def.underline then
            hl.underline = true
        end
        vim.api.nvim_set_hl(0, group, hl)
    end
end

function M.apply()
    local clrs = G.State.get('clrs')
    if not clrs then
        return
    end

    local groups_dir = vim.fn.stdpath('config') .. '/lua/modules/highlight/groups'
    local handle = vim.loop.fs_scandir(groups_dir)
    if not handle then
        return
    end

    local name = vim.loop.fs_scandir_next(handle)
    while name do
        local mod_name = 'modules.highlight.groups.' .. name:gsub('%.lua$', '')
        local ok, mod = pcall(require, mod_name)
        if ok and type(mod) == 'function' then
            apply_groups(mod(clrs))
        end
        name = vim.loop.fs_scandir_next(handle)
    end
end

vim.api.nvim_create_autocmd('UiEnter', {
    callback = function()
        vim.opt.winborder = G.State.get('ui').style

        require('modules.colors').apply()
        M.apply()
    end,
})

return M
