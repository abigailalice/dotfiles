vim.opt_local.conceallevel = 2

vim.api.nvim_set_hl(0, "HaskellLabel", { fg = "#73daca" })

-- Conceal the # sigil before overloaded labels (#fieldName → fieldName)
vim.fn.matchadd("Conceal", "#\\ze[a-zA-Z_]", 10, -1, { conceal = "" })
-- Color the label name itself
vim.fn.matchadd("HaskellLabel", "\\(#\\)\\zs[a-zA-Z_][a-zA-Z0-9_']*")
