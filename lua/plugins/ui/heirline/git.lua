local M = {}

local git_state = {
    is_repo = false,
    branch = '',
}

local fs_event = nil
local watched_head_path = nil
local updating = false

local function update_branch_async()
    -- Prevent concurrent updates
    if updating then
        return
    end
    updating = true

    vim.system({ 'git', 'symbolic-ref', '--short', 'HEAD' }, { text = true }, function(obj)
        vim.schedule(function()
            updating = false

            local old_branch = git_state.branch
            local old_is_repo = git_state.is_repo

            if obj.code == 0 then
                git_state.is_repo = true
                git_state.branch = vim.trim(obj.stdout or '')
            else
                git_state.is_repo = false
                git_state.branch = ''
            end

            -- Smart redraw: redraw if branch changed, repo status changed, or initial load
            local should_redraw = (old_branch ~= git_state.branch)
                or (old_is_repo ~= git_state.is_repo)
                or (old_branch == '' and old_is_repo == false)

            if should_redraw then
                vim.cmd.redrawstatus()
            end
        end)
    end)
end

local function teardown_git_watcher()
    local event = fs_event
    if not event then
        return
    end

    event:stop()
    event:close()
    fs_event = nil
    watched_head_path = nil
end

local function setup_git_watcher()
    local dot_git = vim.fn.finddir('.git', vim.fn.getcwd() .. ';')
    if dot_git == '' then
        teardown_git_watcher()
        return
    end

    local git_dir = vim.fn.fnamemodify(tostring(dot_git), ':p')
    local head_path = git_dir .. 'HEAD'

    if watched_head_path == head_path and fs_event then
        return
    end

    teardown_git_watcher()

    local event = vim.uv.new_fs_event()
    if not event then
        watched_head_path = nil
        return
    end

    fs_event = event
    watched_head_path = head_path
    event:start(
        head_path,
        {},
        vim.schedule_wrap(function(err)
            if not err then
                update_branch_async()
            end
        end)
    )
end

local group = vim.api.nvim_create_augroup('GitUtilEventDrive', { clear = true })

-- Update git branch on critical events
vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged', 'FocusGained' }, {
    group = group,
    callback = function()
        update_branch_async()
        setup_git_watcher()
    end,
})

-- Lazy update on cursor hold (as fallback for edge cases)
vim.api.nvim_create_autocmd('CursorHold', {
    group = group,
    callback = update_branch_async,
})

-- Initialize git state immediately on module load
update_branch_async()

function M.get_status()
    -- Always prioritize global git state for consistent display across all buffers
    if git_state.is_repo and git_state.branch ~= '' then
        return true, git_state.branch
    end

    -- Fallback to buffer-specific gitsigns status
    local b_status = vim.b.gitsigns_status_dict
    if b_status and b_status.head then
        return true, b_status.head
    end

    return false, ''
end

return M
