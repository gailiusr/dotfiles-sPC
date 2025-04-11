#!/bin/bash

echo "🚀 Старт установки кастомного окружения от gailiusr"

# 🌀 Установка ZSH и Powerlevel10k
echo "📦 Установка ZSH и Powerlevel10k..."
sudo apt update && sudo apt install -y zsh git curl fonts-powerline

# Клонируем Powerlevel10k, если его нет
if [ ! -d ~/.powerlevel10k ]; then
  echo "⬇️ Установка Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
fi

# 🔄 Копирование dotfiles
echo "📁 Копируем конфиги..."
cp .zshrc ~/
cp .p10k.zsh ~/
cp .zsh_aliases ~/
cp .bashrc_booster.sh ~/

# Копируем содержимое ~/.config, если есть
if [ -d .config ]; then
  mkdir -p ~/.config
  cp -r .config/* ~/.config/
fi

# ✅ Финализация
echo "✅ Установка shell-окружения завершена!"
echo "🔁 Запуск ZSH..."
exec zsh
