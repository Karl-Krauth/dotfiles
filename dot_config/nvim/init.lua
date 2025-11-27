-- Define aliases.
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt
local keymap = vim.keymap

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
g.mapleader = " "
g.maplocalleader = "\\"

-- Bootstrap lazy.nvim.
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            {"Failed to clone lazy.nvim:\n", "ErrorMsg"},
            {out, "WarningMsg"},
            {"\nPress any key to exit..."},
        }, true, {})
        fn.getchar()
        os.exit(1)
    end
end
opt.rtp:prepend(lazypath)

-- Setup lazy.nvim.
require("lazy").setup({
  spec = {
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "1.*",
        opts = {},
    },
    {"hrsh7th/cmp-nvim-lsp"},
    {"hrsh7th/nvim-cmp"},
    {"williamboman/mason.nvim", commit = "4da89f3"},
    {"williamboman/mason-lspconfig.nvim", commit = "1a31f82"},
    {"neovim/nvim-lspconfig"},
    {"supermaven-inc/supermaven-nvim"},
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = true
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },
  },
  install = {colorscheme = {"habamax"}},
  checker = {enabled = true},
})

-- Subterminal configuration.
require("toggleterm").setup{
  size = 20,
  open_mapping = [[<leader>t]],
  close_mapping = [[<leader>t]],
  hide_numbers = true,
  autochdir = false,
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = false,
  terminal_mappings = true,
  persist_size = true,
  persist_mode = true,
  direction = "horizontal",
  close_on_exit = true,
  shell = vim.o.shell,
  auto_scroll = true,
}

-- Syntax highlighting.
require("nvim-treesitter.configs").setup{
  ensure_installed = "all",
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  ignore_install = {
    "ipkg",
  },
}

-- Reserve a space in the gutter.
opt.signcolumn = "yes"

-- Add cmp_nvim_lsp capabilities settings to lspconfig before configuring language servers.
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Commands that get defined when an LSP is attached.
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local opts = {buffer = event.buf}

    keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    keymap.set({"n", "x"}, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
    keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  end,
})

-- LSP installer.
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
      "clangd",
      "pyright",
      "ruff",
      "tinymist",
      "vtsls",
  },
})

-- Typst LSP config.
vim.lsp.config("tinymist", {
                formatterMode = "typstyle",
                exportPdf = "onType",
                semanticTokens = "disable"
        }
)

-- Automatically open the typst previewer when opening a typst file.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then return end
    if vim.b[args.buf].typst_preview_started then return end
    vim.b[args.buf].typst_preview_started = true
    vim.cmd("TypstPreview")
  end,
})

-- Configure AI code completion to integrate with cmp.
require("supermaven-nvim").setup({
    keymaps = {
        accept_suggestion = "",
        clear_suggestion = "",
        accept_word = ""
    },
    disable_inline_completion = true
})

local cmp = require("cmp")
cmp.setup({
    sources = {
        {name = "supermaven"},
        {name = "nvim_lsp"},
    },
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({select = true}),
        ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end),
    }),
})

-- File navigation.
local builtin = require("telescope.builtin")
keymap.set("n", "<leader>ff", builtin.find_files, {})
keymap.set("n", "<leader>fg", builtin.live_grep, {})
keymap.set("n", "<leader>fb", builtin.buffers, {})
keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- Go to center of page after page up/down.
keymap.set("n", "<C-d>", "<C-d>zz", {noremap = true})
keymap.set("n", "<C-u>", "<C-u>zz", {noremap = true})

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
require("catppuccin").setup{
    no_italic = true,
    integrations = {
        treesitter = true,
    },
}
cmd.colorscheme("catppuccin-macchiato")

-- Show trailing whitespaces and tabs.
cmd("highlight unwanted_characters ctermbg=red guibg=red")
cmd("match unwanted_characters /\\s\\+$\\|\\t/")

-- Make sure clipboard uses the system clipboard.
opt.clipboard = "unnamedplus"
if fn.has("wsl") == 1 then
    g.clipboard = {
        name = "WslClipboard",
        copy = {
            ["+"] = "clip.exe",
            ["*"] = "clip.exe",
        },
        paste = {
            ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
