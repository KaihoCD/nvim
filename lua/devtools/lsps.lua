local build_lsp_configs = require('devtools.utils').build_lsp_configs

local vtsls = build_lsp_configs({
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
    },
    settings = {
        complete_function_calls = true,
        vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
                maxInlayHintLength = 30,
                completion = {
                    enableServerSideFuzzyMatch = true,
                },
            },
        },
        typescript = {
            updateImportsOnFileMove = { enabled = 'always' },
            suggest = {
                completeFunctionCalls = true,
            },
            inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = 'literals' },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
            },
        },
    },
}, {
    mason = function(config)
        return vim.tbl_deep_extend('force', config, {
            settings = {
                vtsls = {
                    autoUseWorkspaceTsdk = false,
                },
                typescript = {
                    tsdk = vim.fs.joinpath(
                        vim.fn.stdpath('data'),
                        'mason',
                        'packages',
                        'vtsls',
                        'node_modules',
                        '@vtsls',
                        'language-server',
                        'node_modules',
                        'typescript',
                        'lib'
                    ),
                },
            },
        })
    end,
})

local jsonls = build_lsp_configs({
    settings = {
        json = {
            -- Find more schemas here: https://www.schemastore.org/json/
            schemas = {
                {
                    description = 'TypeScript compiler configuration file',
                    fileMatch = { 'tsconfig.json', 'tsconfig.*.json' },
                    url = 'https://json.schemastore.org/tsconfig.json',
                },
                {
                    description = 'Babel configuration',
                    fileMatch = { '.babelrc.json', '.babelrc', 'babel.config.json' },
                    url = 'https://json.schemastore.org/babelrc.json',
                },
                {
                    description = 'ESLint config',
                    fileMatch = { '.eslintrc.json', '.eslintrc' },
                    url = 'https://json.schemastore.org/eslintrc.json',
                },
                {
                    description = 'Prettier config',
                    fileMatch = { '.prettierrc', '.prettierrc.json', 'prettier.config.json' },
                    url = 'https://json.schemastore.org/prettierrc',
                },
                {
                    description = 'Stylelint config',
                    fileMatch = { '.stylelintrc', '.stylelintrc.json', 'stylelint.config.json' },
                    url = 'https://json.schemastore.org/stylelintrc',
                },
                {
                    description = 'Json schema for properties json file for a GitHub Workflow template',
                    fileMatch = { '.github/workflow-templates/**.properties.json' },
                    url = 'https://json.schemastore.org/github-workflow-template-properties.json',
                },
                {
                    description = 'NPM configuration file',
                    fileMatch = { 'package.json' },
                    url = 'https://json.schemastore.org/package.json',
                },
                {
                    description = 'JSON schema for Visual Studio component configuration files',
                    fileMatch = { '*.vsconfig' },
                    url = 'https://json.schemastore.org/vsconfig.json',
                },
            },
        },
    },
    setup = {
        commands = {
            Format = {
                function()
                    vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
                end,
            },
        },
    },
})

local lua_ls = build_lsp_configs({
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            completion = {
                callSnippet = 'Replace',
            },
            diagnostics = {
                disable = { 'unused-function' },
            },
            codeLens = {
                enable = false,
            },
            hint = {
                enable = false,
                setType = true,
                paramType = true,
                paramName = 'Disable',
                semicolon = 'Disable',
                arrayIndex = 'Disable',
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

local M = {
    ['html'] = build_lsp_configs({}),
    ['cssls'] = build_lsp_configs({}),
    ['marksman'] = build_lsp_configs({}),
    ['eslint'] = build_lsp_configs({}),
    ['vtsls'] = vtsls,
    ['jsonls'] = jsonls,
    ['lua_ls'] = lua_ls,
}

return M
