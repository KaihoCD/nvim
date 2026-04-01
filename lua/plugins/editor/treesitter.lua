local notify = require('utils.notify')
local command = require('utils.command')

local M = {}

function M.config()
    local parsers = {
        'bash',
        'c',
        'diff',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'regex',
        'python',
        'toml',
        'gitignore',
        'javascript',
        'typescript',
        'tsx',
        'vue',
        'html',
        'css',
        'scss',
        'json',
    }

    local ok = command.ensure_available({
        command = 'tree-sitter',
        install_command = 'brew install tree-sitter-cli',
        install_cmd_name = 'InstallTreeSitter',
        missing_message = 'nvim-treesitter requires tree-sitter CLI in PATH.',
        notify = notify,
    })

    if not ok then
        return
    end

    require('nvim-treesitter').install(parsers)

    vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
            local buf, filetype = args.buf, args.match
            local lang = vim.treesitter.language.get_lang(filetype)

            if not lang then
                return
            end

            if not vim.treesitter.language.add(lang) then
                return
            end

            vim.treesitter.start(buf, lang)
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
    })
end

return M
