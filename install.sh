#!/bin/bash
echo "🚀 Установка dotfiles sPC..."
cp .zshrc ~/
cp .p10k.zsh ~/
cp .zsh_aliases ~/
mkdir -p ~/.config
cp .config/starship.toml ~/.config/ 2>/dev/null
echo 'source ~/.zsh_aliases' >> ~/.zshrc
echo "✅ Установлено. Выполни: exec zsh"
