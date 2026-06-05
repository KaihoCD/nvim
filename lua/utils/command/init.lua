local ensure = require('utils.command.ensure')
local installer = require('utils.command.installer')

local M = {}

M.ensure_command = ensure.ensure_command
M.exists = installer.exists
M.open_installer = installer.open
M.register_installer = installer.register

return M
