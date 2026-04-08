local M = {}

M.mason_lspconfig_opts = {
    automatic_enable = false,
}

local function augroup(name)
    return vim.api.nvim_create_augroup('LSP' .. name, { clear = true })
end

local function setup_diagnostic()
    local severity = vim.diagnostic.severity

    vim.diagnostic.config({
        severity_sort = true,
        virtual_text = {
            spacing = 2,
            source = 'if_many',
            format = function(diag)
                local by_severity = {
                    [severity.ERROR] = diag.message,
                    [severity.WARN] = diag.message,
                    [severity.INFO] = diag.message,
                    [severity.HINT] = diag.message,
                }
                return by_severity[diag.severity]
            end,
        },
        float = {
            source = 'if_many',
        },
    })
end

---@return table
local function build_capabilities()
    local base = {
        workspace = {
            fileOperations = {
                didRename = true,
                willRename = true,
            },
        },
    }

    local ok, blink = pcall(require, 'blink.cmp')
    if not ok then
        return base
    end

    return vim.tbl_deep_extend('force', base, blink.get_lsp_capabilities())
end

local function attach_document_highlight(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local method = vim.lsp.protocol.Methods.textDocument_documentHighlight
    if not client or not client:supports_method(method, event.buf) then
        return
    end

    local buf = event.buf
    local highlight_group = vim.api.nvim_create_augroup('LSPHighlight:' .. buf, { clear = true })

    vim.api.nvim_create_autocmd('CursorHold', {
        buffer = buf,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = buf,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
        group = augroup('Detach'),
        buffer = buf,
        callback = function(detach_event)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({
                group = highlight_group,
                buffer = detach_event.buf,
            })
        end,
    })
end

local function attach_lsp_keymaps(event)
    local set_keymap = require('utils').map

    local map = function(mode, lhs, rhs, desc)
        set_keymap(mode, lhs, rhs, { buffer = event.buf, desc = desc })
    end

    local file_code_action = function()
        vim.lsp.buf.code_action({
            context = {
                only = { 'source' },
                diagnostics = {},
            },
        })
    end

    map('n', 'grA', file_code_action, 'Code Action (Source)')
    map('n', 'grD', vim.lsp.buf.declaration, 'Goto Declaration')
    map('n', '<leader>lF', vim.lsp.buf.format, 'Format by Lsp')
end

local function setup_lsp_attach_autocmd()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = augroup('Attach'),
        callback = function(event)
            attach_document_highlight(event)
            attach_lsp_keymaps(event)
        end,
    })
end

---@param capabilities table
local function configure_lsps(capabilities)
    local names = {}

    for lsp_name, lsp_config in pairs(require('devtools').get_lsps()) do
        local config = vim.deepcopy(lsp_config)
        config.capabilities = vim.tbl_deep_extend('force', capabilities, config.capabilities or {})

        vim.lsp.config(lsp_name, config)
        table.insert(names, lsp_name)
    end

    if #names > 0 then
        vim.lsp.enable(names)
    end
end

function M.mason_tool_installer_config()
    require('mason-tool-installer').setup({
        ensure_installed = require('devtools').get_installed(),
    })
end

local function configure_lsp()
    local capabilities = build_capabilities()
    configure_lsps(capabilities)
    setup_diagnostic()
    setup_lsp_attach_autocmd()
    require('plugins.devtools.extra.lsp_configer')

    -- Preferences
    vim.lsp.document_color.enable(false)
end

function M.config()
    vim.schedule(configure_lsp)
end

return M
