local configs = require('modules.autoim.config')
local utils = require('modules.autoim.utils')
local notify = require('utils.notify').with({
    icon = configs.notify_icon,
    title = configs.notify_title,
})

local state = {
    prev_im = nil,
    ready = false,
}

local pure = {}

function pure.get_current_im()
    local ok, current_im = utils.run(configs.im_switch_command)
    if not ok then
        notify.error('Failed to get current input method: ' .. current_im)
        return false, current_im
    end
    return true, current_im
end

pure.get_treesitter_nodes = (function()
    local cached_nodes
    return function()
        if cached_nodes then
            return cached_nodes
        end

        local nodes = {}
        for _, node_list in pairs(configs.treesitter_nodes) do
            for _, node in ipairs(node_list) do
                table.insert(nodes, node)
            end
        end

        cached_nodes = nodes
        return nodes
    end
end)()

function pure.in_special_syntax()
    if not vim.treesitter then
        notify.warn('nvim-treesitter not available, falling back to default input method')
        return false
    end

    local filetype = vim.bo.filetype
    local lang = vim.treesitter.language.get_lang(filetype) or filetype
    local ok, parser = pcall(vim.treesitter.get_parser, 0, lang)
    if not ok or not parser then
        return false
    end

    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local node = vim.treesitter.get_node({ pos = { line - 1, col } })
    if not node then
        return false
    end

    local valid_nodes = pure.get_treesitter_nodes()
    while node do
        for _, valid_node in ipairs(valid_nodes) do
            if node:type() == valid_node then
                return true
            end
        end
        node = node:parent()
    end

    return false
end

function pure.contains_chinese()
    local line = vim.api.nvim_get_current_line()
    return line:find('[\228-\233][\128-\191][\128-\191]') ~= nil
end

function pure.should_handle_default_event(args)
    if args.event == 'BufEnter' and not state.ready then
        return false
    end
    return vim.bo.buftype == ''
end

local actions = {}

function actions.switch_to(im_name)
    local ok, current_im = pure.get_current_im()
    if not ok then
        return
    end

    state.prev_im = current_im

    if current_im == im_name then
        return
    end

    local switch_ok, switch_output =
        utils.run(configs.im_switch_command .. ' ' .. utils.shellescape(im_name))
    if not switch_ok then
        notify.error('Failed to switch to ' .. im_name .. ': ' .. switch_output)
    end
end

function actions.switch_to_default()
    actions.switch_to(configs.default_im)
end

function actions.switch_to_prev()
    local filetype = vim.bo.filetype
    local target_im

    if utils.contains(configs.text_filetypes, filetype) then
        target_im = state.prev_im or configs.default_im
    elseif pure.in_special_syntax() or pure.contains_chinese() then
        target_im = state.prev_im or configs.default_im
    else
        target_im = configs.default_im
    end

    actions.switch_to(target_im)
end

return {
    state = state,
    pure = pure,
    actions = actions,
}
