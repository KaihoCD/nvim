local default_notify = require('utils.notify')

local M = {}

local function get_notify(opts)
    return opts.notify or default_notify
end

local function run_hook(hook, context)
    if type(hook) ~= 'function' then
        return
    end

    local ok, err = pcall(hook, context)
    if not ok then
        default_notify.error('Command installer hook failed: ' .. err)
    end
end

---@param command string?
---@return boolean
function M.exists(command)
    return type(command) == 'string' and command ~= '' and vim.fn.executable(command) == 1
end

---@param opts table
function M.open_installer(opts)
    local notify = get_notify(opts)
    local install_command = opts.install_command
    local command = opts.command or 'unknown'

    if type(install_command) ~= 'string' or install_command == '' then
        notify.warn('No install command configured for ' .. command .. '.')
        return
    end

    local context = {
        command = command,
        install_command = install_command,
        install_cmd_name = opts.install_cmd_name,
    }

    run_hook(opts.before_install, context)

    vim.cmd('botright split')
    vim.cmd('terminal')

    local buf = vim.api.nvim_get_current_buf()
    local job_id = vim.b[buf].terminal_job_id

    vim.api.nvim_create_autocmd('TermClose', {
        buffer = buf,
        once = true,
        callback = function()
            context.exit_code = vim.v.event.status
            run_hook(opts.after_install, context)
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

---@param opts table
function M.register_installer(opts)
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
        M.open_installer(opts)
    end, {
        desc = 'Open installer for ' .. (opts.command or 'command'),
    })
end

---@param opts table
---@return boolean
function M.ensure_available(opts)
    local notify = get_notify(opts)
    local command = opts.command or 'unknown'

    M.register_installer(opts)

    if M.exists(command) then
        return true
    end

    local function warn()
        notify.warn(opts.missing_message or ('Required command not found (' .. command .. ').'))

        if type(opts.install_command) == 'string' and opts.install_command ~= '' then
            if type(opts.install_cmd_name) == 'string' and opts.install_cmd_name ~= '' then
                notify.warn(
                    'Use `:' .. opts.install_cmd_name .. '` to review/run: ' .. opts.install_command
                )
            else
                notify.warn('Install it with: ' .. opts.install_command)
            end
        end
    end

    if opts.schedule_notify then
        vim.schedule(warn)
    else
        warn()
    end

    return false
end

return M
