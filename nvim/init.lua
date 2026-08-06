-- Zeilennummern anzeigen
vim.opt.number = true

-- Farbschema
vim.cmd.colorscheme("slate")

-- Nur y/p auf Systemzwischenablage ("+), d/c/x bleiben unangetastet
vim.keymap.set({ "n", "x" }, "y", '"+y')
vim.keymap.set("n", "Y", '"+y$')
vim.keymap.set("n", "p", '"+p')
vim.keymap.set("n", "P", '"+P')

-- Fallback fuer Remote-Sessions ohne lokalen X-/Wayland-Server (z.B. SSH
-- auf VMs): xclip/xsel/wl-copy sind zwar evtl. installiert, koennen aber
-- ohne $DISPLAY bzw. $WAYLAND_DISPLAY keine Verbindung aufbauen und
-- scheitern dann lautlos. OSC 52 schreibt stattdessen ueber die
-- Terminal-Escape-Sequenz direkt in die Zwischenablage des lokalen
-- Terminal-Emulators (erfordert Neovim >=0.10 und ein OSC-52-faehiges
-- Terminal, z.B. kitty, wezterm, foot, Konsole >=24.12, Alacritty,
-- iTerm2, Windows Terminal; bei tmux zusaetzlich
-- "set -as terminal-features ',*:clipboard'" setzen).
-- Kein OSC-52-Support: VTE-basierte Terminals (GNOME Terminal, XFCE
-- Terminal, Terminator, QTerminal) -- dort bleibt die Sequenz wirkungslos.
local has_display = vim.env.DISPLAY ~= nil and vim.env.DISPLAY ~= ""
local has_wayland = vim.env.WAYLAND_DISPLAY ~= nil and vim.env.WAYLAND_DISPLAY ~= ""

local has_clipboard_tool = (has_display and (vim.fn.executable("xclip") == 1 or vim.fn.executable("xsel") == 1))
    or (has_wayland and vim.fn.executable("wl-copy") == 1)

if not has_clipboard_tool then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
