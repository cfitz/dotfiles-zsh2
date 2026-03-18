return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright", "ruff" },
                automatic_installation = true,
            })

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        format = { enable = false },
                    },
                },
            })

            lspconfig.pyright.setup({ capabilities = capabilities })
            lspconfig.ruff.setup({ capabilities = capabilities })

            -- Keymaps set on LSP attach
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local m = function(keys, fn, desc)
                        vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
                    end
                    m("gd", vim.lsp.buf.definition, "Go to definition")
                    m("gr", vim.lsp.buf.references, "References")
                    m("K", vim.lsp.buf.hover, "Hover docs")
                    m("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                    m("<leader>ca", vim.lsp.buf.code_action, "Code action")
                end,
            })
        end,
    },
}
