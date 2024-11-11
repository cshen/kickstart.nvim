#!/data/data/com.termux/files/usr/bin/bash
# CS: 11 Nov 2024 20:18

mkdir -p  ~/.local/share/nvim/mason/packages/lua-language-server/libexec/bin/
ln -s "$(command -v lua-language-server)" ~/.local/share/nvim/mason/packages/lua-language-server/libexec/bin/lua-language-server
ln -s ~/.config/nvim/fix-termux/lua-language-server ~/.local/share/nvim/mason/packages/lua-language-server/lua-language-server

mkdir -p  ~/.local/share/nvim/mason/packages/stylua
ln -s "$(command -v stylua)" ~/.local/share/nvim/mason/packages/stylua/stylua


