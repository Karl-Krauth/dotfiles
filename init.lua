-- Define aliases.
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

require("plugins")

-- Subterminal configuration.
require("toggleterm").setup{
  size = 20,
  open_mapping = [[<c-\>]],
  close_mapping = [[<c-\>]],
  hide_numbers = true,
  autochdir = false,
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  persist_mode = true,
  direction = 'horizontal',
  close_on_exit = true,
  shell = vim.o.shell,
  auto_scroll = true,
}

-- Syntax highlighting.
require'nvim-treesitter.configs'.setup{
  ensure_installed = "all",
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- Code completion and navigation.
local lsp = require('lsp-zero')
lsp.preset('recommended')

local cmp_sources = lsp.defaults.cmp_sources()
table.insert(cmp_sources, {name = 'copilot'})
lsp.setup_nvim_cmp({
  sources = cmp_sources
})
lsp.setup()

-- Display more line info in vim.
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.colorcolumn = "101"

-- Set indentation to 4 spaces.
opt.tabstop = 4
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true

-- Color settings.
cmd.colorscheme("catppuccin-macchiato")

-- Show trailing whitespaces and tabs.
cmd("highlight unwanted_characters ctermbg=red guibg=red")
cmd("match unwanted_characters /\\s\\+$\\|\\t/")
