require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'ap/vim-buftabline'
  use 'nvim-lualine/lualine.nvim'

  use 'folke/trouble.nvim'

  -- I don't know yet if I need these
  -- use 'hrsh7th/cmp-buffer'
  -- use 'hrsh7th/cmp-path'
  -- use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/nvim-cmp'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use 'rbgrouleff/bclose.vim' -- needed by ranger plugin
  use 'francoiscabrol/ranger.vim'

  use { 'junegunn/fzf', run = './install --all' }
  use 'junegunn/fzf.vim'

  use 'tpope/vim-abolish' -- smart rename
  use 'tpope/vim-commentary'
  use 'tpope/vim-unimpaired' -- smart left-right movement

  use 'kana/vim-textobj-entire'
  use 'kana/vim-textobj-indent'
  use 'kana/vim-textobj-user'

  use 'neovim/nvim-lspconfig'

  use 'JarrodCTaylor/spartan' -- colorscheme
end)

vim.cmd [[colorscheme spartan]]

local cmp = require('cmp')
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }),
  sorting = {
    comparators = {
      -- sort completion items alphabetically
      function(entry1, entry2)
         local label1 = entry1:get_completion_item().label
         local label2 = entry2:get_completion_item().label
         return label1 < label2
       end,
    },
  },
})


require("trouble").setup {
    icons = false,
    cycle_results = false,
    multiline = false,
    fold_open = "v",
    fold_closed = ">",
    signs = { error = "E", warning = "W", hint = "H", information = "I", other = "+" },
    use_diagnostic_signs = false,
    auto_fold = true,
}

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = {},
    section_separators = {},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

vim.g.ranger_replace_netrw = 1

vim.fn.setenv("FZF_DEFAULT_COMMAND", "rg --files --hidden --follow --glob '!.git/*'")

local lspconfig = require('lspconfig')
lspconfig.rust_analyzer.setup {
    settings = {
        ["rust-analyzer"] = {
            diagnostics = {
                disabled = {"unresolved-proc-macro"},
            },
        },
    },
}

-- common lsp key mappings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    -- use "trouble" plugin for typical lsp stuff
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- quickfix window mappings
vim.api.nvim_create_augroup("QuickFixMappings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "QuickFixMappings",
    pattern = "qf",
    callback = function()
        -- open a buffer by clicking `enter` on it
        vim.api.nvim_buf_set_keymap(
            0, 'n', '<CR>', ':.cc<CR>', {noremap = true, silent = true}
        )
    end,
})

-- folding config
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99 -- open all folds by default

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust", "python", "lua", "elixir" },

  auto_install = true,
  sync_install = false,

  highlight = { enable = false } -- treesitter is used for folding only
}

vim.o.errorbells = false -- Disable error bells
vim.o.visualbell = false -- Disable visual bells
vim.o.belloff = "all" -- Turn off all bells

vim.o.number = true
vim.o.showmode = false -- do not show mode as it is shown by status line
vim.o.wrap = false

-- tab-space behaviour
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

-- disable backups
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- disable arrow keys (just like that)
vim.api.nvim_set_keymap('n', '<Up>', '<Nop>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Down>', '<Nop>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Left>', '<Nop>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Right>', '<Nop>', {noremap = true})

-- vim-like movement between splits
vim.api.nvim_set_keymap('n', '<C-j>', '<C-W>j', {noremap = false})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', {noremap = false})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', {noremap = false})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', {noremap = false})

-- close current buffer (tab)
vim.api.nvim_set_keymap('n', '<C-D>', ':bdelete<CR>', {noremap = true, silent = true})
-- open fzf file search
vim.api.nvim_set_keymap('n', '<C-P>', ':Files<CR>', {noremap = true, silent = true})
-- "reset" hlsearch results highlighting
vim.api.nvim_set_keymap('n', '<C-M>', ':nohlsearch<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap(
  'n', '<leader>dw', ':TroubleToggle workspace_diagnostics<CR>',
  {noremap = true, silent = true}
)
vim.api.nvim_set_keymap(
  'n', '<leader>dd', ':TroubleToggle document_diagnostics<CR>',
  {noremap = true, silent = true}
)
vim.keymap.set("n", "gr", function() require("trouble").toggle("lsp_references") end)
vim.keymap.set("n", "gi", function() require("trouble").toggle("lsp_implementations") end)
vim.keymap.set("n", "gd", function() require("trouble").toggle("lsp_definitions") end)

-- make escape act in terminal mode the same as in insert mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
