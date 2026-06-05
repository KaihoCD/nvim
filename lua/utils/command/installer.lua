local shared = require('utils.command.shared')

local M = {}

---@param command string?
---@return boolean
function M.exists(command)
    return type(command) == 'string' and command ~= '' and vim.fn.executable(command) == 1
end

---@param opts utils.command.InstallerOpts
function M.open(opts)
    local notify = shared.get_notify(opts)
    local context = shared.make_context(opts)
    local install_command = context.install_command
    local command = context.command

    if type(install_command) ~= 'string' or install_command == '' then
        notify.warn('No install command configured for ' .. command .. '.')
        return
    end

    shared.run_hook(opts.before_install, context)

    vim.cmd('botright split')
    vim.cmd('terminal')

    local buf = vim.api.nvim_get_current_buf()
    local job_id = vim.b[buf].terminal_job_id

    vim.api.nvim_create_autocmd('TermClose', {
        buffer = buf,
        once = true,
        callback = function()
            context.exit_code = vim.v.event.status
            shared.run_hook(opts.after_install, context)
        end,
    })

    if type(job_id) ~= 'number' or job_id <= 0 then
        notify.error('Failed to open installer terminal for ' .. command .. '.')
        return
    end

    vim.bo[buf].buflisted = false

    vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then
            return
        end

        vim.cmd('startinsert')
        vim.fn.chansend(job_id, install_command)
        notify.info(
            'Installer ready for '
                .. command
                .. '. Review it, press Enter to run, then exit the shell when done.'
        )
    end)
end

---@param opts utils.command.InstallerOpts
function M.register(opts)
    local install_cmd_name = opts.install_cmd_name
    local install_command = opts.install_command

    if type(install_cmd_name) ~= 'string' or install_cmd_name == '' then
        return
    end

    if type(install_command) ~= 'string' or install_command == '' then
        return
    end

    local commands = vim.api.nvim_get_commands({ builtin = false })
    if commands[install_cmd_name] then
        return
    end

    vim.api.nvim_create_user_command(install_cmd_name, function()
        M.open(opts)
    end, {
        desc = 'Open installer for ' .. (opts.command or 'command'),
    })
end

return M
