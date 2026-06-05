local notify = require('utils.notify').default

local M = {}

---@alias utils.command.Notify utils.notify.Instance

---@class utils.command.InstallerContext
---@field command string
---@field install_command string?
---@field install_cmd_name string?
---@field exit_code integer|boolean?

---@class utils.command.InstallerOpts
---@field command? string
---@field install_command? string
---@field install_cmd_name? string
---@field notify? utils.command.Notify
---@field before_install? fun(context: utils.command.InstallerContext)
---@field after_install? fun(context: utils.command.InstallerContext)

---@alias utils.command.EnsureCheckFn fun(context: utils.command.InstallerContext): boolean, string?

---@class utils.command.EnsureCheck
---@field name? string
---@field run utils.command.EnsureCheckFn
---@field message? string

---@class utils.command.EnsureOpts
---@field command? string
---@field missing_message? string
---@field notify? utils.command.Notify
---@field schedule_notify? boolean
---@field checks? (utils.command.EnsureCheck|utils.command.EnsureCheckFn)[]
---@field installer? utils.command.InstallerOpts

---@alias utils.command.EnsureRequirement utils.command.EnsureOpts

---@param opts utils.command.EnsureRequirement|utils.command.EnsureRequirement[]
---@return boolean
function M.is_requirement_list(opts)
    return type(opts) == 'table' and opts.command == nil
end

---@param opts { notify?: utils.command.Notify }
---@return utils.command.Notify
function M.get_notify(opts)
    return opts.notify or notify
end

---@param schedule boolean?
---@param fn fun(message: string)
---@param message string
function M.dispatch_notification(schedule, fn, message)
    if schedule then
        vim.schedule(function()
            fn(message)
        end)
    else
        fn(message)
    end
end

---@param opts utils.command.EnsureRequirement|utils.command.InstallerOpts
---@return utils.command.EnsureRequirement
function M.normalize_ensure_opts(opts)
    local installer = vim.tbl_deep_extend('force', {}, opts.installer or {})
    installer.command = opts.command
    installer.notify = opts.notify or installer.notify

    return vim.tbl_deep_extend('force', {}, opts, { installer = installer })
end

---@param opts utils.command.InstallerOpts|utils.command.EnsureRequirement
---@return utils.command.InstallerContext
function M.make_context(opts)
    local installer = opts.installer or opts
    return {
        command = installer.command or 'unknown',
        install_command = installer.install_command,
        install_cmd_name = installer.install_cmd_name,
    }
end

---@param hook fun(context: utils.command.InstallerContext)?
---@param context utils.command.InstallerContext
function M.run_hook(hook, context)
    if type(hook) ~= 'function' then
        return
    end

    local ok, err = pcall(hook, context)
    if not ok then
        notify.error('Command installer hook failed: ' .. err)
    end
end

return M
