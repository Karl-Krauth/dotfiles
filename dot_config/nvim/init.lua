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
if not vim.uv.fs_stat(lazypath) then
  local out = fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
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
      "akinsho/toggleterm.nvim",
      config = true,
      version = "*",
      opts = {
        open_mapping = [[<leader>t]],
        hide_numbers = true,
        autochdir = true,
        insert_mappings = false,
        direction = "horizontal",
      },
    },
    {

      "catppuccin/nvim",
      name = "catppuccin",
      opts = {
        auto_integrations = true,
        flavour = "macchiato",
      },
      version = "*",
    },
    {
      "chomosuke/typst-preview.nvim",
      config = true,
      ft = "typst",
      version = "*",
    },
    {
      "folke/conform.nvim",
      version = "*",
      opts = {
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          -- Config files
          json = { "prettierd" },
          toml = { "taplo" },
          yaml = { "prettierd" },
          -- Frontend
          css = { "prettierd" },
          html = { "prettierd" },
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          svelte = { "prettierd" },
          -- Scripting
          lua = { "stylua" },
          python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
          sh = { "shfmt" },
          -- Systems
          c = { "clang-format" },
          cpp = { "clang-format" },
          go = { "goimports", "gofmt" },
          rust = { "rustfmt" },
          -- Typesetting
          markdown = { "prettierd" },
          tex = { "tex-fmt" },
          typst = { "typstyle" },
          -- Defaults
          ["*"] = { "injected" },
        },
        formatters = {
          stylua = {
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          },
        },
      },
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "mrcjkb/rustaceanvim", version = "*", lazy = false },
    -- LSP installer.
    {
      "mason-org/mason-lspconfig.nvim",
      dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
      },
      opts = {
        ensure_installed = {
          "clangd",
          "cssls",
          "gopls",
          "jsonls",
          "lua_ls",
          "pyright",
          "ruff",
          "superhtml",
          "svelte",
          "tailwindcss",
          "taplo",
          "texlab",
          "tinymist",
          "vtsls",
          "wgsl_analyzer",
          "yamlls",
        },
      },
      version = "*",
    },
    { "mason-org/mason.nvim", config = true, version = "*" },
    { "neovim/nvim-lspconfig", version = "*" },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      version = "*",
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      lazy = false,
      version = "*",
    },
    -- Configure AI code completion to integrate with cmp.
    {
      "supermaven-inc/supermaven-nvim",
      opts = {
        keymaps = {
          accept_suggestion = "",
          clear_suggestion = "",
          accept_word = "",
        },
        disable_inline_completion = true,
      },
    },
    {
      "zapling/mason-conform.nvim",
      config = true,
      dependencies = {
        "mason-org/mason.nvim",
        "folke/conform.nvim",
      },
    },
  },
  checker = { enabled = true, frequency = 604800 },
})

-- Catppuccin colorscheme.
cmd.colorscheme("catppuccin")

-- Syntax highlighting.
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- Add cmp_nvim_lsp capabilities settings to lspconfig before configuring language servers.
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Commands that get defined when an LSP is attached.
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local opts = { buffer = event.buf }

    keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
    keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    -- Show diagnostics in a floating window when cursor is held
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = "rounded",
          source = "always",
          prefix = " ",
          scope = "cursor",
        }
        vim.diagnostic.open_float(nil, opts)
      end,
    })
    opt.updatetime = 300
  end,
})

-- Typst LSP config.
vim.lsp.config("tinymist", {
  formatterMode = "typstyle",
  exportPdf = "onType",
  semanticTokens = "disable",
})

-- Automatically open the typst previewer when opening a typst file.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    if vim.b[args.buf].typst_preview_started then
      return
    end
    vim.b[args.buf].typst_preview_started = true
    vim.cmd("TypstPreview")
  end,
})

local cmp = require("cmp")
cmp.setup({
  sources = {
    { name = "supermaven" },
    { name = "nvim_lsp" },
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
})

-- File navigation.
local builtin = require("telescope.builtin")
keymap.set("n", "<leader>ff", builtin.find_files, {})
keymap.set("n", "<leader>fg", builtin.live_grep, {})
keymap.set("n", "<leader>fb", builtin.buffers, {})
keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- Go to center of page after page up/down.
keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })

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

-- Reserve a space in the gutter.
opt.signcolumn = "yes"

-- Show trailing whitespaces and tabs.
cmd("highlight unwanted_characters ctermbg=red guibg=red")
cmd("match unwanted_characters /\\s\\+$\\|\\t/")

-- Make sure clipboard uses the system clipboard.
opt.clipboard = "unnamedplus"
if fn.has("wsl") == 1 then
  if os.getenv("SSH_CONNECTION") then
    -- Avoid clip.exe when inside an SSH session into WSL.
    return
  end

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
