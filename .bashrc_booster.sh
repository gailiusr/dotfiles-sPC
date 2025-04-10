#!/bin/bash

BASHRC="$HOME/.bashrc"
MARKER="# >>> Bashrc Booster >>>"

echo "🚀 Устанавливаем bashrc booster..."

# Проверка — если уже добавлено, ничего не делаем
if grep -q "$MARKER" "$BASHRC"; then
  echo "⚠️  Уже установлено. Ничего не меняю."
  exit 0
fi

# Добавление улучшений
cat << 'EOF' >> "$BASHRC"

# >>> Bashrc Booster >>>
alias ls='eza --icons'
alias ll='eza -la --icons'
alias la='eza -la --icons'
alias cat='bat'
alias grep='rg'
alias vim='nvim'
alias cleanmem="sync; echo 3 | sudo tee /proc/sys/vm/drop_caches"
export BAT_THEME="Monokai Extended"

# FZF keybinds
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# <<< Bashrc Booster <<<
EOF

echo "✅ Добавлено в ~/.bashrc"

# Применение
source "$BASHRC"
echo "✅ Booster активирован. Перезапусти терминал или введи: source ~/.bashrc"
