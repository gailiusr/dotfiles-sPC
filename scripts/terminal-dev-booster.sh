#!/bin/bash

echo "🚀 Установка терминального бустера..."

# 1. ZSH
sudo apt install -y zsh git curl

# 2. Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k

# 3. Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# 4. ZSH Plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "⬇️  Ставим oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Автоподсказки
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# Подсветка
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

# 5. Настройка .zshrc
echo "🛠️  Настраиваем .zshrc..."

cat << 'EOF' > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.
