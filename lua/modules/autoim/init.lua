local configs = require('modules.autoim.config')
local command = require('utils.command')
local notify = require('utils.notify').with({
    icon = configs.notify_icon,
    title = configs.notify_title,
})

local M = {}

function M.setup()
    if
        not configs.im_switch_command
        or not command.ensure_available({
            command = configs.im_switch_command,
            install_command = configs.install_command,
            install_cmd_name = configs.install_cmd_name,
            missing_message = 'input method switch tool not found ('
                .. (configs.im_switch_command or 'unknown')
                .. '), module disabled!',
            notify = notify,
            schedule_notify = true,
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

return M
