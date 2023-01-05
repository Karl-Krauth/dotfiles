return require('packer').startup(function(use)
    use("wbthomason/packer.nvim")
    use{"catppuccin/nvim", as="catppuccin"}
    use("github/copilot.vim")
    use{
        "akinsho/toggleterm.nvim",
        tag='*',
        config=function() require("toggleterm").setup() end
     }
end)
