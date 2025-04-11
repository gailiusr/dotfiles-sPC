#!/bin/bash

LOG=/tmp/gamemode-fix.log
echo "=== GameMode Fix Script ===" > $LOG

# Проверка установки gamemode
if ! dpkg -l | grep -q gamemode; then
    echo "❌ GameMode not installed. Installing..." | tee -a $LOG
    sudo apt update && sudo apt install -y gamemode libgamemodeauto0
else
    echo "✅ GameMode is installed." | tee -a $LOG
fi

# Поиск библиотеки
LIB_PATH=$(find /usr/lib -name "libgamemodeauto.so.0" | head -n 1)
LINK_PATH="/usr/lib/x86_64-linux-gnu/libgamemodeauto.so"

if [ -n "$LIB_PATH" ]; then
    echo "✅ Found: $LIB_PATH" | tee -a $LOG

    if [ ! -e "$LINK_PATH" ]; then
        echo "🔧 Creating symlink: $LINK_PATH → $LIB_PATH" | tee -a $LOG
        sudo ln -s "$LIB_PATH" "$LINK_PATH"
    else
        echo "✅ Symlink already exists." | tee -a $LOG
    fi
else
    echo "❌ libgamemodeauto.so.0 not found." | tee -a $LOG
    exit 1
fi

# Проверка демона
if ! pgrep -x gamemoded > /dev/null; then
    echo "🔄 Trying to start gamemoded manually..." | tee -a $LOG
    /usr/bin/gamemoded &
    sleep 1
else
    echo "✅ gamemoded already running." | tee -a $LOG
fi

# Проверка статуса
STATUS=$(gamemoded -s 2>&1)
echo "🔍 GameMode status:" | tee -a $LOG
echo "$STATUS" | tee -a $LOG

# Результат
if echo "$STATUS" | grep -q "active"; then
    echo "✅ GameMode is ACTIVE." | tee -a $LOG
else
    echo "⚠️ GameMode is still inactive. Try testing with glxgears or a game." | tee -a $LOG
fi

echo "📄 Log saved to: $LOG"
