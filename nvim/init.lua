-- Zeilennummern anzeigen
vim.opt.number = true

-- Farbschema
vim.cmd.colorscheme("slate")

-- Nur y/p auf Systemzwischenablage ("+), d/c/x bleiben unangetastet
vim.keymap.set({ "n", "x" }, "y", '"+y')
vim.keymap.set("n", "Y", '"+y$')
vim.keymap.set("n", "p", '"+p')
vim.keymap.set("n", "P", '"+P')
