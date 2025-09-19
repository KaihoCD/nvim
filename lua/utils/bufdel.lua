--- 关闭指定 buffer
---@param bufnr  number 要关闭的 buffer 号
---@param force? boolean 是否强制关闭（默认 false）
local function delbuffer(bufnr, force)
  force = force or false

  if Snacks and Snacks.bufdelete then
    Snacks.bufdelete({ buf = bufnr, force = force })
    return
  end

  local buftype = vim.bo[bufnr].buftype
  vim.cmd(
    ('silent! %s %d'):format(
      (force or buftype == 'terminal') and 'bdelete!' or 'confirm bdelete',
      bufnr
    )
  )
end

return delbuffer
