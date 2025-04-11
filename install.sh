#!/bin/bash

echo "🚀 Старт установки кастомного окружения от gailiusr"

# 🌀 Установка ZSH и Powerlevel10k
echo "📦 Установка ZSH и Powerlevel10k..."
sudo apt update && sudo apt install -y zsh git curl fonts-powerline

# Установка Powerlevel10k
if [ ! -d "$HOME/.powerlevel10k" ]; then
  echo "⬇️ Клонируем Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.powerlevel10k"
fi

# 🔄 Копирование dotfiles
echo "📁 Копируем конфиги..."
cp .zshrc "$HOME"/
cp .p10k.zsh "$HOME"/
cp .zsh_aliases "$HOME"/
cp .bashrc_booster.sh "$HOME"/

# Копирование из .config (если есть)
if [ -d .config ]; then
  echo "🧩 Копируем .config содержимое..."
  mkdir -p "$HOME/.config"
  cp -r .config/* "$HOME/.config/"
fi

# 🛠 Установка Mint Optimization скрипта и systemd-сервиса
echo "🛠 Установка системной оптимизации..."
sudo cp mint-optimize.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/mint-optimize.sh

sudo cp mint-optimize.service /etc/systemd/system/
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable mint-optimize.service

# 📦 Установка пользовательских вспомогательных скриптов
echo "📦 Установка пользовательских утилит..."

if ls scripts/*.sh &>/dev/null; then
  for script in scripts/*.sh; do
      name=$(basename "$script")
      echo "  🔧 Устанавливается $name..."
      sudo cp "$script" /usr/local/bin/
      sudo chmod +x "/usr/local/bin/$name"
  done
  echo "✅ Все скрипты из scripts/ установлены в /usr/local/bin/"
else
  echo "⚠️ Нет файлов в scripts/ — пропущено."
fi

# 🎉 Финальное сообщение
echo ""
echo "🎉 Установка завершена!"
echo "✅ Mint Optimization будет запускаться при каждой загрузке системы"
echo "🌀 ZSH с Powerlevel10k активен"
echo "📁 Конфиги скопированы"
echo ""

# Отправка уведомления, если есть GUI
if command -v notify-send >/dev/null && [ "$DISPLAY" ]; then
  notify-send "✅ Установка завершена" "Окружение и оптимизация установлены!"
fi

# 🌀 Запуск ZSH
exec zsh
