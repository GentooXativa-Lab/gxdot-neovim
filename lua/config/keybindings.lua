-- Neovim keybindings configuration file
-- All keybindings are defined here and then required by other files

local M = {}

-- Default options for keybindings
local opt = {
    noremap = true,
    silent = true
}

-- Initialize keybindings
function M.setup()
    local map = vim.api.nvim_set_keymap
    
    -- Set leader keys
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    -- Telescope keybindings
    map("n", "<leader>tf", "<cmd>:Telescope find_files<CR>", opt)
    map("n", "<leader>tC", "<cmd>:Telescope dap configurations<CR>", opt)
    map("n", "<leader>tc", "<cmd>:Telescope commands<CR>", opt)
    map("n", "<leader>tv", "<cmd>:Telescope dap variables<CR>", opt)
    map("n", "<leader>pp", "<cmd>:VenvSelect<CR>", opt)
    
    -- Debug related keybindings
    map("n", "<F5>", '<cmd>lua require("dap").continue()<CR>', opt)
    map("i", "<F5>", '<cmd>lua require("dap").continue()<CR>', opt)
    map("n", "<F6>", '<cmd>lua require("dap").step_over()<CR>', opt)
    map("i", "<F6>", '<cmd>lua require("dap").step_over()<CR>', opt)
    map("n", "<F7>", '<cmd>lua require("dap").step_into()<CR>', opt)
    map("i", "<F7>", '<cmd>lua require("dap").step_into()<CR>', opt)
    map("n", "<F8>", '<cmd>lua require("dap").step_out()<CR>', opt)
    map("i", "<F8>", '<cmd>lua require("dap").step_out()<CR>', opt)
    
    map("n", "<leader>Vc", ':source $MYVIMRC<CR>', opt)
    
    map("n", "<leader>Di", '<cmd>lua require("dapui").float_element()<CR>', opt)
    map("n", "<leader>dt", '<cmd>lua require("dapui").toggle()<CR>', opt)
    map("n", "<leader>De", '<cmd>lua require("dapui").eval()<CR>', opt)
    map("n", "<leader>dc", '<cmd>lua require("dap").continue()<CR>', opt)
    map("n", "<leader>db", '<cmd>lua require("dap").toggle_breakpoint()<CR>', opt)
    map("n", "<leader>dn", '<cmd>lua require("dap").step_over()<CR>', opt)
    map("n", "<leader>di", '<cmd>lua require("dap").step_into()<CR>', opt)
    map("n", "<leader>do", '<cmd>lua require("dap").step_out()<CR>', opt)
    map("n", "<leader>ds", '<cmd>lua require("dap").close()<CR>', opt)
    map("n", "<leader>dl", '<cmd>lua require("dap").run_last()<CR>', opt)
    map("n", "<leader>dp", '<cmd>lua require("dap").pause()<CR>', opt)
    map("n", "<leader>da", '<cmd>lua require("dap").attach()<CR>', opt)
    map("n", "<leader>dpy", '<cmd>lua require("dap-python").test_method()<CR>', opt)
    map("v", "<leader>dw", '<cmd>lua require("dapui").elements.watches.add(vim.fn.expand("<cexpr>"))<CR>', opt)
    map("n", "<leader>dw", '<cmd>lua require("dapui").elements.watches.add(vim.fn.expand("<cword>"))<CR>', opt)
    map("n", "<leader>dpc", '<cmd>lua require("dap-python").test_class()<CR>', opt)
    map("n", "<leader>dps", '<cmd>lua require("dap-python").debug_selection()<CR>', opt)
    
    -- Copilot keybindings
    vim.keymap.set("i", "<A-c>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
    })
    vim.g.copilot_no_tab_map = true
    
    vim.keymap.set('i', '<A-d>', '<Plug>(copilot-next)')
    vim.keymap.set('i', '<A-a>', '<Plug>(copilot-previous)')
    vim.keymap.set('i', '<A-s>', '<cmd>Copilot panel<CR>')
    
    -- LSP formatting
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.format()<CR>', opt)
    vim.keymap.set('i', '<F4>', '<cmd>lua vim.lsp.buf.format()<CR>', opt)
    
    -- Barbar keybindings
    -- Move to previous/next
    map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opt)
    map("n", "<A-.>", "<Cmd>BufferNext<CR>", opt)
    
    -- Re-order to previous/next
    map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opt)
    map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opt)
    
    -- Goto buffer in position...
    map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opt)
    map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opt)
    map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opt)
    map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opt)
    map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opt)
    map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opt)
    map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opt)
    map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opt)
    map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opt)
    map("n", "<A-0>", "<Cmd>BufferLast<CR>", opt)
    
    -- Pin/unpin buffer
    map("n", "<A-p>", "<Cmd>BufferPin<CR>", opt)
    
    -- Close buffer
    map("n", "<A-c>", "<Cmd>BufferClose<CR>", opt)
    
    -- Magic buffer-picking mode
    map("n", "<C-p>", "<Cmd>BufferPick<CR>", opt)
    map("n", "<C-s-p>", "<Cmd>BufferPickDelete<CR>", opt)
    
    -- Sort automatically by...
    map("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", opt)
    map("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>", opt)
    map("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", opt)
    map("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", opt)
    map("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", opt)

    -- Add keybindings from other files
    M.setup_markdown_keybindings()
    M.setup_formatter_keybindings()
    
    -- Load snacks keybindings later when the plugin is available
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
            pcall(M.setup_snacks_keybindings)
        end
    })
end

-- Markdown keybindings
function M.setup_markdown_keybindings()
    -- Setup markdown preview keybindings
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
            vim.api.nvim_buf_set_keymap(0, "n", "<leader>cp", "<cmd>MarkdownPreviewToggle<CR>", opt)
        end
    })

    -- Toggle markdown rendering
    vim.keymap.set("n", "<leader>um", function() require("various-textobjs").toggleMarkdownConceal() end, 
        { desc = "Toggle Render Markdown" })
end

-- Formatter keybindings
function M.setup_formatter_keybindings()
    vim.keymap.set("n", "<leader>F", function() require("conform").format({ async = true }) end, 
        { desc = "Format buffer (async)" })
    
    vim.keymap.set({"n", "v"}, "<leader>C", function() require("conform").format({ async = false }) end, 
        { desc = "Format file or range" })
end

-- Snacks keybindings
function M.setup_snacks_keybindings()
    local map = vim.keymap.set
    local snacks_util_available = pcall(require, "snacks.util")

    -- General keybindings
    map("n", "<leader><space>", "<cmd>Telescope smart_files<cr>", { desc = "Smart Find Files" })
    map("n", "<leader>,", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
    map("n", "<leader>/", "<cmd>Telescope live_grep<cr>", { desc = "Grep" })
    map("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
    map("n", "<leader>n", "<cmd>Telescope notify<cr>", { desc = "Notification History" })
    map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "File Explorer" })

    -- Find keybindings
    map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
    map("n", "<leader>fc", "<cmd>Telescope config_files<cr>", { desc = "Find Config File" })
    map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
    map("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Find Git Files" })
    map("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Projects" })
    map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent" })

    -- Git keybindings
    map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Git Branches" })
    map("n", "<leader>gl", "<cmd>Telescope git_commits<CR>", { desc = "Git Log" })
    map("n", "<leader>gL", "<cmd>Telescope git_bcommits<CR>", { desc = "Git Log Line" })
    map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git Status" })
    map("n", "<leader>gS", "<cmd>Telescope git_stash<CR>", { desc = "Git Stash" })
    map("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { desc = "Git Diff (Hunks)" })
    map("n", "<leader>gf", "<cmd>Telescope git_bcommits<CR>", { desc = "Git Log File" })

    -- Grep/Search keybindings
    map("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer Lines" })
    map("n", "<leader>sB", "<cmd>Telescope grep_string grep_open_files=true<cr>", { desc = "Grep Open Buffers" })
    map("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Grep" })
    map({"n", "v"}, "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Visual selection or word" })
    map("n", '<leader>s"', "<cmd>Telescope registers<cr>", { desc = "Registers" })
    map("n", "<leader>s/", "<cmd>Telescope search_history<cr>", { desc = "Search History" })
    map("n", "<leader>sa", "<cmd>Telescope autocommands<cr>", { desc = "Autocmds" })
    map("n", "<leader>sc", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
    map("n", "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
    map("n", "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })
    map("n", "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Buffer Diagnostics" })
    map("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help Pages" })
    map("n", "<leader>sH", "<cmd>Telescope highlights<cr>", { desc = "Highlights" })
    map("n", "<leader>si", "<cmd>Telescope symbols<cr>", { desc = "Icons" })
    map("n", "<leader>sj", "<cmd>Telescope jumplist<cr>", { desc = "Jumps" })
    map("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
    map("n", "<leader>sl", "<cmd>Telescope loclist<cr>", { desc = "Location List" })
    map("n", "<leader>sm", "<cmd>Telescope marks<cr>", { desc = "Marks" })
    map("n", "<leader>sM", "<cmd>Telescope man_pages<cr>", { desc = "Man Pages" })
    map("n", "<leader>sp", "<cmd>Telescope plugin_specs<cr>", { desc = "Search for Plugin Spec" })
    map("n", "<leader>sq", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix List" })
    map("n", "<leader>sR", "<cmd>Telescope resume<cr>", { desc = "Resume" })
    map("n", "<leader>su", "<cmd>Telescope undo<cr>", { desc = "Undo History" })
    map("n", "<leader>uC", "<cmd>Telescope colorscheme<cr>", { desc = "Colorschemes" })

    -- LSP keybindings
    map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Goto Definition" })
    map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
    map("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
    map("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { desc = "Goto Implementation" })
    map("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Goto Type Definition" })
    map("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Symbols" })
    map("n", "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace Symbols" })

    -- Other keybindings
    map("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Toggle Zen Mode" })
    map("n", "<leader>Z", "<cmd>WindowsMaximize<cr>", { desc = "Toggle Zoom" })
    map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete Buffer" })
    map({"n", "v"}, "<leader>gB", ":GBrowse<cr>", { desc = "Git Browse" })
    map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Lazygit" })
    map("n", "<leader>un", function() require("notify").dismiss() end, { desc = "Dismiss All Notifications" })
    map({"n", "t"}, "<c-/>", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })
    map({"n", "t"}, "<c-_>", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })
    map({"n", "t"}, "]]", "<cmd>tabnext<cr>", { desc = "Next Reference" })
    map({"n", "t"}, "[[", "<cmd>tabprevious<cr>", { desc = "Prev Reference" })
    map("n", "<leader>N", "<cmd>Neovim<cr>", { desc = "Neovim News" })
    
    -- Only add snacks.util dependent keybindings if the module is available
    if snacks_util_available then
        local snacks_util = require("snacks.util")
        
        map("n", "<leader>.", function() snacks_util.scratch.toggle() end, { desc = "Toggle Scratch Buffer" })
        map("n", "<leader>S", function() snacks_util.scratch.select() end, { desc = "Select Scratch Buffer" })
        map("n", "<leader>cR", function() snacks_util.rename_file() end, { desc = "Rename File" })
        map("n", "<leader>us", function() snacks_util.toggle("spell") end, { desc = "Toggle Spelling" })
        map("n", "<leader>uw", function() snacks_util.toggle("wrap") end, { desc = "Toggle Wrap" })
        map("n", "<leader>uL", function() snacks_util.toggle("relativenumber") end, { desc = "Toggle Relative Number" })
        map("n", "<leader>ud", function() snacks_util.toggle_diagnostics() end, { desc = "Toggle Diagnostics" })
        map("n", "<leader>ul", function() snacks_util.toggle.number() end, { desc = "Toggle Line Number" })
        map("n", "<leader>uc", function() snacks_util.toggle.conceallevel() end, { desc = "Toggle Conceallevel" })
        map("n", "<leader>ub", function() snacks_util.toggle_background() end, { desc = "Toggle Dark Background" })
        map("n", "<leader>ug", function() snacks_util.toggle("showtabline", 0, 2) end, { desc = "Toggle Indent" })
        map("n", "<leader>uD", snacks_util.toggle_dim, { desc = "Toggle Dim" })
    end
    
    -- Add inlay hints toggle which doesn't depend on snacks
    map("n", "<leader>uh", function() vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle Inlay Hints" })
    map("n", "<leader>uT", "<cmd>TSJToggle<cr>", { desc = "Toggle Treesitter" })
end

return M