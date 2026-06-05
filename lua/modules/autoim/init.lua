local configs = require('modules.autoim.config')
local command = require('utils.command')
local Notify = require('utils.notify')
local notify = Notify.new({
    icon = configs.notify_icon,
    title = configs.notify_title,
})

local M = {}

local function load_auto_im()
    if
        not configs.im_switch_command
        or not command.ensure_command({
            command = configs.im_switch_command,
            missing_message = 'input method switch tool not found ('
                .. (configs.im_switch_command or 'unknown')
                .. '), module disabled!',
            notify = notify,
            schedule_notify = true,
            installer = {
                install_command = configs.install_command,
                install_cmd_name = configs.install_cmd_name,
            },
        })
    then
        return false
    end

    local core = require('modules.autoim.core')
    local state = core.state
    local pure = core.pure
    local actions = core.actions

    local group = vim.api.nvim_create_augroup(configs.augroup_name, { clear = true })

    vim.api.nvim_create_autocmd('VimEnter', {
        group = group,
        once = true,
        callback = function()
            state.ready = true
        end,
    })

    vim.api.nvim_create_autocmd(configs.restore_events, {
        group = group,
        callback = actions.switch_to_prev,
    })

    vim.api.nvim_create_autocmd(configs.default_events, {
        group = group,
        callback = function(args)
            if not pure.should_handle_default_event(args) then
                return
            end
            actions.switch_to_default()
        end,
    })

    return true
end

function M.setup()
    vim.api.nvim_create_autocmd('VimEnter', {
        once = true,
        callback = function()
            load_auto_im()
        end,
    })
end

return M
