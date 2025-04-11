#!/bin/bash

KEY="$HOME/.ssh/id_rsa.pub"

echo "🔍 Проверяю наличие SSH-ключа..."

if [ ! -f "$KEY" ]; then
    echo "❌ Ключ не найден. Хочешь создать его сейчас? (y/n)"
    read -r ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        ssh-keygen -t rsa -b 4096 -C "gailiusr@users.noreply.github.com"
    else
        echo "⛔ Отмена."
        exit 1
    fi
fi

echo -e "\n🧷 Вот твой публичный ключ:\n"
cat "$KEY"

echo -e "\n🌍 Открываю GitHub для добавления ключа..."
xdg-open "https://github.com/settings/keys" &>/dev/null

echo -e "\n✅ Готово. Вставь ключ на странице и нажми 'Add key'."
