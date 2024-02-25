require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'ap/vim-buftabline'
  use 'nvim-lualine/lualine.nvim'

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

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

vim.api.nvim_create_augroup("QuickFixMappings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "QuickFixMappings",
    pattern = "qf",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', ':.cc<CR>', {noremap = true, silent = true})
    end,
})

-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust" },

  auto_install = true,
  sync_install = false,

  highlight = { enable = false },
}

vim.o.errorbells = false -- Disable error bells
vim.o.visualbell = false -- Disable visual bells
vim.o.belloff = "all" -- Turn off all bells

vim.o.number = true
vim.o.showmode = false
vim.o.wrap = false

-- tab-space behaviour
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

vim.api.nvim_set_keymap('n', '<Up>', '<Nop>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Down>', '<Nop>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Left>', '<Nop>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Right>', '<Nop>', {noremap = true})

vim.api.nvim_set_keymap('n', '<C-j>', '<C-W>j', {noremap = false})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', {noremap = false})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', {noremap = false})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', {noremap = false})

vim.api.nvim_set_keymap('n', '<C-D>', ':bdelete<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-P>', ':Files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-M>', ':nohlsearch<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
