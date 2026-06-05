local map = require('utils').map

local M = {}

M.opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    picker = {
        win = {
            input = {
                keys = {
                    ['<C-j>'] = { 'confirm', mode = { 'n', 'i' } },
                    ['<C-k>'] = false,
                },
            },
        },
    },
}

function M.config(opts)
    vim.g.snacks_animate = false

    require('snacks').setup(opts)

    local markdown = require('snacks.picker.util.markdown')

    ---@diagnostic disable-next-line: duplicate-set-field
    markdown.render = function(buf)
        markdown.render_fallback(buf)
    end

    --stylua: ignore start
    map('n', '<leader><space>', function() Snacks.picker.smart() end, { desc = 'Smart Find' })
    map('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'Grep' })
    map('n', '<leader>,', function() Snacks.picker.buffers() end, { desc = 'Buffers' })

    map('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Definition' })
    map('n', 'grr', function() Snacks.picker.lsp_references() end, { desc = 'References', nowait = true })
    map('n', 'gri', function() Snacks.picker.lsp_implementations() end, { desc = 'Implementations' })
    map('n', 'gO', function() Snacks.picker.lsp_symbols() end, { desc = 'Document Symbols' })

    map('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'LazyGit' })

    map('n', '<leader>sf', function() Snacks.picker.files() end, { desc = 'Find Files' })
    map('n', '<leader>sr', function() Snacks.picker.recent() end, { desc = 'Recent Files' })
    map('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = 'Resume Search' })
    map('n', '<leader>sp', function() Snacks.picker() end, { desc = 'Search Picker' })
    --stylua: ignore end
end

return M
