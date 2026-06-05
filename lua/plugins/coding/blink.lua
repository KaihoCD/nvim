local M = {}

--- 应用项目中 .vscode/* 的补全片段
--- - 扫描项目 .vscode/*.code-snippets，在缓存目录生成 package.json + 硬链接
---@return string|nil cache_dir
local function prepare_vscode_snippets_cache()
    local root = vim.fn.getcwd()
    local vscode_dir = root .. '/.vscode'
    if vim.fn.isdirectory(vscode_dir) ~= 1 then return nil end

    local files = vim.fn.glob(vscode_dir .. '/*.code-snippets', false, true)
    if #files == 0 then return nil end

    local cache_root = vim.fn.stdpath('cache') .. '/blink_vscode_snippets'
    local project_hash = vim.fn.sha256(root):sub(1, 12)
    local cache_dir = cache_root .. '/' .. project_hash

    vim.fn.delete(cache_dir, 'rf')
    vim.fn.mkdir(cache_dir, 'p')

    local snippets_contribs = {} ---@type {language:string,path:string}[]

    for _, filepath in ipairs(files) do
        local content = table.concat(vim.fn.readfile(filepath), '\n')
        local ok, data = pcall(vim.json.decode, content)
        if not ok or type(data) ~= 'table' then goto continue end

        local filename = vim.fn.fnamemodify(filepath, ':t')
        local basename = filename:gsub('%.code%-snippets$', '')

        -- 从 snippet 的 scope 字段收集 filetype，没有 scope 则用文件名约定
        local filetypes = {} ---@type string[]
        for _, snippet in pairs(data) do
            if type(snippet) == 'table' and snippet.scope then
                for scope in snippet.scope:gmatch('[^,]+') do
                    scope = vim.trim(scope)
                    if scope ~= '' and not vim.tbl_contains(filetypes, scope) then
                        table.insert(filetypes, scope)
                    end
                end
            end
        end

        if #filetypes == 0 then
            if basename == 'global' then
                filetypes = { 'all' }
            else
                filetypes = { basename }
            end
        end

        local link_name = basename .. '.json'
        local link_path = cache_dir .. '/' .. link_name
        local hard_ok = pcall(vim.loop.fs_link, filepath, link_path)
        if not hard_ok then
            vim.fn.writefile(vim.fn.readfile(filepath), link_path)
        end

        for _, ft in ipairs(filetypes) do
            table.insert(snippets_contribs, { language = ft, path = './' .. link_name })
        end

        ::continue::
    end

    if #snippets_contribs > 0 then
        local package = { name = 'project-vscode-snippets', contributes = { snippets = snippets_contribs } }
        vim.fn.writefile(vim.split(vim.json.encode(package), '\n'), cache_dir .. '/package.json')
    end

    return cache_dir
end

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
    keymap = {
        preset = 'super-tab',
        -- override the 'super-tab' preset
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
        ['<C-k>'] = { 'snippet_backward', 'fallback' },
        ['<C-j>'] = { 'snippet_forward', 'fallback' },
        ['<C-e>'] = { 'hide', 'hide_signature', 'fallback' },
    },
    completion = {
        list = {
            selection = { preselect = true, auto_insert = false },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
        menu = {
            auto_show = true,
        },
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
        providers = {
            lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                score_offset = 100,
            },
        },
    },
    fuzzy = { implementation = 'prefer_rust' },
    signature = { enabled = true },
    cmdline = {
        keymap = { preset = 'inherit' },
        completion = { menu = { auto_show = true } },
    },
}

M.config = function(opts)
    -- 注入项目级 .vscode/*.code-snippets 到 search_paths
    local vscode_cache = prepare_vscode_snippets_cache()
    if vscode_cache then
        local snippets_provider = ((opts.sources or {}).providers or {}).snippets or {}
        local snippets_opts = snippets_provider.opts or {}
        snippets_opts.search_paths = snippets_opts.search_paths or {}
        table.insert(snippets_opts.search_paths, vscode_cache)
        snippets_provider.opts = snippets_opts
        opts.sources = opts.sources or {}
        opts.sources.providers = opts.sources.providers or {}
        opts.sources.providers.snippets = snippets_provider
    end

    local blink_cmp = require('blink.cmp')

    local command = require('utils.command')
    local Notify = require('utils.notify')
    local notify = Notify.new({ title = 'blink.cmp' })

    local rust_install = {
        install_cmd_name = 'InstallRustToolchain',
        install_command = 'rustup default stable',
    }

    local function command_works(args)
        local result = vim.system(args, { text = true }):wait()
        return result.code == 0
    end
    local rust_ready = command.ensure_command({
        {
            command = 'rustup',
            missing_message = 'blink.cmp Rust fuzzy matcher requires rustup in PATH.',
            notify = notify,
            schedule_notify = true,
            installer = {
                install_cmd_name = 'InstallRustup',
                install_command = "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh",
            },
        },
        {
            command = 'cargo',
            missing_message = 'blink.cmp Rust fuzzy matcher requires cargo in PATH.',
            notify = notify,
            schedule_notify = true,
            checks = {
                {
                    name = 'cargo-version',
                    run = function()
                        if command_works({ 'cargo', '--version' }) then
                            return true
                        end
                        return false, 'cargo exists but is not usable. Run `rustup default stable`.'
                    end,
                },
                {
                    name = 'rustc-version',
                    run = function()
                        if command_works({ 'rustc', '--version' }) then
                            return true
                        end
                        return false, 'rustc is not usable. Run `rustup default stable`.'
                    end,
                },
            },
            installer = rust_install,
        },
    })

    if rust_ready then
        blink_cmp.build():wait(60000)
    end

    blink_cmp.setup(opts)
end

return M
