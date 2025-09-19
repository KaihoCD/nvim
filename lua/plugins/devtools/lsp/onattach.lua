local map = require('utils.funcs').map
local border_style = G.context.lsp_border_style

local function augroup(name)
  return vim.api.nvim_create_augroup('LSP' .. name, { clear = true })
end

local function attach_hl(event)
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  local method = vim.lsp.protocol.Methods.textDocument_documentHighlight

  if client and client:supports_method(method, event.buf) then
    local highlight_augroup = augroup('Highlight')

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = augroup('Detach'),
      callback = function(_event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({
          group = highlight_augroup,
          buffer = _event.buf,
        })
      end,
    })
  end
end

local function _float_style()
  return {
    max_width = math.ceil(vim.o.columns * 0.6),
    max_height = math.ceil(vim.o.lines * 0.4),
    border = border_style,
  }
end

local function attach_keymaps(event)
  local function hover()
    return vim.lsp.buf.hover(_float_style())
  end

  local function signature_help()
    return vim.lsp.buf.signature_help(_float_style())
  end

  local function open_float()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1

    local diags = vim.diagnostic.get(event.buf, { lnum = line })

    if #diags == 0 then
      return vim.diagnostic.goto_next()
    end

    return vim.diagnostic.open_float(event.buf, _float_style())
  end

  -- stylua: ignore start
  map('n', 'K', hover, { buffer = event.buf, desc = 'Hover' })
  map('n', 'gK', signature_help, { buffer = event.buf, desc = 'Signature Help Hover' })
  map('i', '<C-s>', signature_help, { buffer = event.buf, desc = 'Signature Help Hover' })
  map('n', '<leader>lr', function() vim.lsp.buf.rename() end, { buffer = event.buf, desc = '[r]ename' })
  map('n', '<leader>ld', open_float, { buffer = event.buf, desc = '[d]ianostic' })
  map('n', '<leader>lF', function() vim.lsp.buf.format() end, { buffer = event.buf, desc = '[f]ormat by LSP' })
  map({ 'n', 'x' }, '<leader>la', function() vim.lsp.buf.code_action() end, { buffer = event.buf, desc = 'code [a]ction' })
  -- stylua: ignore end
end

return function()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup('AttachHiglight'),
    callback = function(event)
      attach_hl(event)
      attach_keymaps(event)
    end,
  })
end
