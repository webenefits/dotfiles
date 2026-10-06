-- dotfiles: yazi init.lua (→ ~/.config/yazi/init.lua)

-- Git status in the file list (plugin: yazi-rs/plugins:git, fetchers in yazi.toml)
require("git"):setup {
	order = 1500,
}
