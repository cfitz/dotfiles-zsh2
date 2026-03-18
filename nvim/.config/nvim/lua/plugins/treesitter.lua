return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua", "python", "javascript", "typescript",
                    "bash", "json", "yaml", "toml", "markdown",
                    "html", "css", "rust", "go",
                },
                highlight = { enable = true },
                indent = { enable = true },
                auto_install = true,
            })
        end,
    },
}
