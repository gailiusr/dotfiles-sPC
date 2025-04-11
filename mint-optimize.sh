#!/bin/bash

LOG="/var/log/mint-optimize.log"
exec >> $LOG 2>&1

echo ""
echo "▶️ $(date) — Запуск оптимизации Linux Mint"

# 1. Enable fstrim.timer
echo "💾 Проверка TRIM..."
systemctl enable fstrim.timer
systemctl start fstrim.timer

# 2. Проверка fstab
echo "📂 Проверка fstab на discard/noatime..."
grep -E 'discard|noatime' /etc/fstab || echo "⚠️ fstab может быть не оптимален"

# 3. Установка performance governor
echo "🚀 Установка режима CPU: performance"
for GOV in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo performance | tee $GOV
done

# 4. Обновление
echo "⬆️ Обновление системы..."
apt update && apt upgrade -y

# 5. Очистка
echo "🧹 Очистка системы..."
apt autoremove -y
apt autoclean -y
journalctl --vacuum-time=7d

# 6. SWAP / ZRAM
echo "🧊 SWAP статус:"
swapon --show || echo "Нет swap"
echo "ZRAM:"
lsmod | grep zram || echo "❌ ZRAM не загружен"

# 7. Firewall
echo "🛡️ Проверка UFW..."
ufw enable
ufw status verbose

echo "✅ $(date) — Оптимизация завершена"
