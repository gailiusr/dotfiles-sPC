#!/bin/bash

echo "🚀 Настройка максимальной производительности..."

# --- CPU: Turbo Boost + Performance Governor ---
echo "Включаю Turbo Boost и governor=performance..."
echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

for CPU in /sys/devices/system/cpu/cpu[0-9]*; do
  echo performance | sudo tee "$CPU/cpufreq/scaling_governor"
  echo 4500000 | sudo tee "$CPU/cpufreq/scaling_max_freq"
done

# --- Установка и настройка TLP ---
echo "Устанавливаю TLP..."
sudo apt update
sudo apt install -y tlp tlp-rdw

sudo systemctl enable --now tlp

echo "Настраиваю TLP..."
sudo sed -i '/^#CPU_SCALING_GOVERNOR_ON_AC/c\CPU_SCALING_GOVERNOR_ON_AC=performance' /etc/tlp.conf
sudo sed -i '/^#CPU_SCALING_GOVERNOR_ON_BAT/c\CPU_SCALING_GOVERNOR_ON_BAT=powersave' /etc/tlp.conf
sudo sed -i '/^#CPU_MIN_PERF_ON_AC/c\CPU_MIN_PERF_ON_AC=100' /etc/tlp.conf
sudo sed -i '/^#CPU_MAX_PERF_ON_AC/c\CPU_MAX_PERF_ON_AC=100' /etc/tlp.conf
sudo sed -i '/^#CPU_BOOST_ON_AC/c\CPU_BOOST_ON_AC=1' /etc/tlp.conf
sudo sed -i '/^#CPU_BOOST_ON_BAT/c\CPU_BOOST_ON_BAT=0' /etc/tlp.conf
sudo sed -i '/^#ENERGY_PERF_POLICY_ON_AC/c\ENERGY_PERF_POLICY_ON_AC=performance' /etc/tlp.conf
sudo sed -i '/^#ENERGY_PERF_POLICY_ON_BAT/c\ENERGY_PERF_POLICY_ON_BAT=power' /etc/tlp.conf
sudo sed -i '/^#DISK_DEVICES/c\DISK_DEVICES="nvme0n1"' /etc/tlp.conf
sudo sed -i '/^#DISK_APM_LEVEL_ON_AC/c\DISK_APM_LEVEL_ON_AC="254"' /etc/tlp.conf
sudo sed -i '/^#DISK_APM_LEVEL_ON_BAT/c\DISK_APM_LEVEL_ON_BAT="128"' /etc/tlp.conf

sudo systemctl restart tlp

# --- SSD: TRIM, noatime, discard ---
echo "Включаю TRIM и оптимизирую fstab..."
sudo systemctl enable fstrim.timer
sudo fstrim -av

sudo cp /etc/fstab /etc/fstab.backup

# Обновление строки с ext4 (корневая файловая система)
sudo sed -i 's/errors=remount-ro/defaults,noatime,discard,commit=60/' /etc/fstab

# --- Swappiness ---
echo "Настраиваю swappiness..."
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# --- Очистка системы ---
echo "Очищаю систему..."
sudo apt autoremove -y
sudo apt clean

# --- Установка утилит мониторинга ---
echo "Устанавливаю утилиты мониторинга..."
sudo apt install -y htop iotop cpufetch lm-sensors stress

echo "✅ Готово. Рекомендуется перезагрузить систему."

