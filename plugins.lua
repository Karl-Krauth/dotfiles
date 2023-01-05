return require("packer").startup(function(use)
    -- Vim package manager.
    use("wbthomason/packer.nvim")

    -- Pastel color scheme.
    use{"catppuccin/nvim", as="catppuccin"}

    -- Code completion and navigation.
    use {
        "VonHeikemen/lsp-zero.nvim",
        requires = {
            -- LSP Support
            {"neovim/nvim-lspconfig"},
            {"williamboman/mason.nvim"},
            {"williamboman/mason-lspconfig.nvim"},

            -- Autocompletion
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-buffer"},
            {"hrsh7th/cmp-path"},
            {"saadparwaiz1/cmp_luasnip"},
            {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-nvim-lua"},

            -- Snippets
            {"L3MON4D3/LuaSnip"},
            -- Snippet Collection (Optional)
            {"rafamadriz/friendly-snippets"},
        }
    }

    -- AI code completion.
    use {
        "zbirenbaum/copilot.lua",
        event = "VimEnter",
        config = function()
            vim.defer_fn(
                function() require("copilot").setup() end, 100
            )
        end,
    }

    -- Makes copilot appear in the completion menu.
    use {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function () require("copilot_cmp").setup() end
    }

    -- Subterminals.
    use {
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function() require("toggleterm").setup() end
     }

     -- Better syntax highlighting.
     use("nvim-treesitter/nvim-treesitter", {run=":TSUpdate"})
end)
