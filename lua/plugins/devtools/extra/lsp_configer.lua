local devtools = require('devtools')
local lsp_definitions = require('devtools.lsps')
local notify = require('utils.notify').with({ title = 'LspConfig' })

local STATE_KEY = 'lsp_configs'
local DEFAULT_VARIANT = 'default'

local function get_state()
    return G.State.get(STATE_KEY) or {}
end

local function set_variant(name, variant)
    G.State.set(STATE_KEY, vim.tbl_extend('force', get_state(), { [name] = variant }))
end

local function list_variants(name)
    local lsp_configs = lsp_definitions[name]
    if type(lsp_configs) ~= 'table' then
        return {}
    end

    local variants = vim.tbl_keys(lsp_configs)
    table.sort(variants)

    return variants
end

local function has_variant(name, variant)
    return vim.tbl_contains(list_variants(name), variant)
end

local function current_variant(name)
    local variant = get_state()[name]
    return has_variant(name, variant) and variant or DEFAULT_VARIANT
end

local function switchable_lsp_names()
    local names = {}

    for name in pairs(lsp_definitions) do
        if #list_variants(name) > 1 then
            table.insert(names, name)
        end
    end

    table.sort(names)

    return names
end

local function reload_lsp(name)
    local config = devtools.get_lsps()[name]
    if not config then
        notify.error('Failed to resolve LSP config: ' .. name)
        return false
    end

    vim.lsp.enable(name, false)
    vim.lsp.config(name, config)
    vim.lsp.enable(name, true)
    vim.cmd('doautoall nvim.lsp.enable FileType')

    return true
end

local function apply_variant(name, variant)
    if #list_variants(name) == 0 then
        notify.error('Unknown LSP: ' .. name)
        return
    end

    if not has_variant(name, variant) then
        notify.error('Unknown variant for ' .. name .. ': ' .. variant)
        return
    end

    set_variant(name, variant)

    if reload_lsp(name) then
        notify('LSP config switched: ' .. name .. ' -> ' .. variant)
    end
end

local function pick_variant(name)
    local variants = list_variants(name)
    if #variants == 0 then
        notify.error('Unknown LSP: ' .. name)
        return
    end

    vim.ui.select(variants, {
        prompt = 'Select LSP config for ' .. name,
        format_item = function(variant)
            return variant == current_variant(name) and (variant .. ' (current)') or variant
        end,
    }, function(choice)
        if choice then
            apply_variant(name, choice)
        end
    end)
end

local function handle_command(args)
    if #args == 0 then
        vim.ui.select(switchable_lsp_names(), {
            prompt = 'Select LSP',
        }, function(name)
            if name then
                pick_variant(name)
            end
        end)
        return
    end

    if #args == 1 then
        pick_variant(args[1])
        return
    end

    if #args == 2 then
        apply_variant(args[1], args[2])
        return
    end

    notify.error('Usage: :LspConfig [name] [variant]')
end

local function complete(_, line)
    local args = vim.split(vim.trim(line), '%s+', { trimempty = true })

    if #args <= 1 then
        return switchable_lsp_names()
    end

    if #args == 2 then
        return list_variants(args[1])
    end

    return {}
end

local commands = vim.api.nvim_get_commands({ builtin = false })
if not commands.LspConfig then
    vim.api.nvim_create_user_command('LspConfig', function(opts)
        handle_command(vim.split(vim.trim(opts.args), '%s+', { trimempty = true }))
    end, {
        nargs = '*',
        complete = complete,
        desc = 'Switch LSP config variant',
    })
end

return {}
