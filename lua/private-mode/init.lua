local private_mode_local_group = vim.api.nvim_create_augroup("PrivateModeLocal", {})
local private_mode_global_group = vim.api.nvim_create_augroup("PrivateModeGlobal", {})

-- In case cmp is lazy loaded, we check :CmpStatus instead of a pcall to require
-- so we maintain the lazy load.
local function has_cmp()
    return vim.fn.exists(':CmpStatus') > 0
end

-- <https://vi.stackexchange.com/questions/6177/the-simplest-way-to-start-vim-in-private-mode>
local function private_mode()
    if has_cmp() then
        require('cmp').setup.buffer({ enabled = false })
    end

    vim.opt_local.history = 0
    vim.opt_local.backup = false
    vim.opt_local.modeline = false
    vim.opt_local.shelltemp = false
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
    vim.opt_local.writebackup = false
    vim.opt_local.secure = true
    vim.opt_local.viminfo = ""
end

local function private_mode_global()
    vim.api.nvim_create_autocmd("BufReadPre", {
        group = private_mode_global_group,
        callback = private_mode,
    })
end

vim.api.nvim_create_user_command("PrivateModeStart", private_mode, {})
vim.api.nvim_create_user_command("PrivateModeStartGlobal", private_mode_global, {})
vim.api.nvim_create_user_command("IncognitoStopGlobal", function()
    vim.api.nvim_del_augroup_by_id(private_mode_global_group)
end, {})

M = {
    opts = {
        file_patterns = {}
    },
}

M.setup = function(opts)
    opts = opts or {}
    M.opts = vim.tbl_deep_extend("force", M.opts, opts)
    if next(M.opts.file_patterns) ~= nil then
        vim.api.nvim_create_autocmd("BufReadPre", {
            group = private_mode_local_group,
            pattern = M.opts.file_patterns,
            callback = private_mode,
        })
    end
end

return M
