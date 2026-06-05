local installer = require('utils.command.installer')
local shared = require('utils.command.shared')

local M = {}

---@param checks (utils.command.EnsureCheck|utils.command.EnsureCheckFn)[]?
---@param context utils.command.InstallerContext
---@param notify utils.command.Notify
---@param schedule_notify boolean?
---@return boolean
local function run_checks(checks, context, notify, schedule_notify)
    if type(checks) ~= 'table' then
        return true
    end

    for index, check in ipairs(checks) do
        local run = type(check) == 'function' and check or check.run
        if type(run) ~= 'function' then
            shared.dispatch_notification(
                schedule_notify,
                notify.error,
                'Command availability check #' .. index .. ' is missing a runnable function.'
            )
            return false
        end

        local ok, passed, message = pcall(run, context)
        if not ok then
            local name = type(check) == 'table' and check.name or nil
            local label = name and ('"' .. name .. '" ') or ''
            shared.dispatch_notification(
                schedule_notify,
                notify.error,
                'Command availability check ' .. label .. 'failed: ' .. passed
            )
            return false
        end

        if not passed then
            local fallback = type(check) == 'table' and check.message or nil
            shared.dispatch_notification(
                schedule_notify,
                notify.warn,
                message or fallback or ('Command is not ready: ' .. context.command .. '.')
            )
            return false
        end
    end

    return true
end

---@param opts utils.command.EnsureRequirement
---@return boolean
local function ensure_one(opts)
    opts = shared.normalize_ensure_opts(opts)
    local notify = shared.get_notify(opts)
    local context = shared.make_context(opts)
    local command = context.command
    local installer_opts = opts.installer or {}

    installer.register(installer_opts)

    if installer.exists(command) then
        return run_checks(opts.checks, context, notify, opts.schedule_notify)
    end

    local function warn()
        notify.warn(opts.missing_message or ('Required command not found (' .. command .. ').'))

        if type(installer_opts.install_command) == 'string' and installer_opts.install_command ~= '' then
            if type(installer_opts.install_cmd_name) == 'string' and installer_opts.install_cmd_name ~= '' then
                notify.warn(
                    'Use `:'
                        .. installer_opts.install_cmd_name
                        .. '` to review/run: '
                        .. installer_opts.install_command
                )
            else
                notify.warn('Install it with: ' .. installer_opts.install_command)
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

---@param opts utils.command.EnsureRequirement|utils.command.EnsureRequirement[]
---@return boolean
function M.ensure_command(opts)
    if shared.is_requirement_list(opts) then
        for _, requirement in ipairs(opts) do
            if not ensure_one(requirement) then
                return false
            end
        end
        return true
    end

    return ensure_one(opts)
end

return M
