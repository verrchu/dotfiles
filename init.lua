require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'ap/vim-buftabline'
  use 'itchyny/lightline.vim'

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

vim.g.lightline = {
  colorscheme = 'seoul256',
  active = {
    left = {{'mode'}, {'filename'}},
    right = {{'lineinfo'}, {'percent'}, {'filetype'}}
  },
  inactive = {
    left = {{'filename'}},
    right = {{}}
  },
  tabline = {
    left = {{'tabs'}},
    right = {{}}
  },
  tab = {
    active = {'filename', 'modified'},
    inactive = {'filename', 'modified'}
  }
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
