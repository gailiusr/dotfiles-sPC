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

# 🛠 Установка Mint Optimization скрипта и systemd-сервиса
echo "🛠 Установка оптимизации Linux Mint..."
sudo cp mint-optimize.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/mint-optimize.sh

sudo cp mint-optimize.service /etc/systemd/system/
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable mint-optimize.service

echo "✅ Mint Optimization добавлен в автозапуск systemd"
echo ""
echo "🎉 Установка завершена!"
echo "✅ Mint Optimization будет запускаться при каждой загрузке системы"
echo "🌀 ZSH с Powerlevel10k активен"
echo "📁 Конфиги скопированы"
echo ""

# Если есть notify-send и активная сессия, покажем уведомление:
if command -v notify-send >/dev/null; then
  su -l $SUDO_USER -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send '✅ Dotfiles install complete!' 'Все готово к бою 😎'"
fi

# Запускаем ZSH
exec zsh
