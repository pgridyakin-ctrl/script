#!/bin/bash

# Скрипт анализа производительности сервера
# Автор: [Ваше имя]
# Версия: 1.0

echo "========================================"
echo " СТАТИСТИКА ПРОИЗВОДИТЕЛЬНОСТИ СЕРВЕРА "
echo "========================================"
echo

# --- ОСНОВНАЯ ИНФОРМАЦИЯ ---
echo "🖥️  Основная информация:"
echo "ОС: $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
echo "Имя хоста: $(hostname)"
echo "Время работы: $(uptime -p)"
echo "Текущая дата: $(date)"
echo

# --- ЗАГРУЗКА ЦП ---
echo "⚙️  Загрузка процессора:"
top -bn1 | grep "Cpu(s)" | awk '{print "Используется: " $2 + $4 "%, Свободно: " $8 "%"}'
echo "Средняя загрузка (load average): $(uptime | awk -F'load average:' '{print $2}')"
echo

# --- ИСПОЛЬЗОВАНИЕ ПАМЯТИ ---
echo "💾 Использование памяти:"
free -h | awk 'NR==2{printf "Используется: %s / %s (%.2f%%)\n", $3, $2, $3*100/$2}'
echo

# --- ИСПОЛЬЗОВАНИЕ ДИСКА ---
echo "📀 Использование дисков:"
df -h --total | awk '/total/{printf "Используется: %s / %s (%s)\n", $3, $2, $5}'
echo

# --- ТОП-5 ПРОЦЕССОВ ПО CPU ---
echo "🔥 Топ-5 процессов по загрузке CPU:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk 'NR==1{print "PID\tКоманда\tCPU%"} NR>1{print $1"\t"$2"\t"$3}'
echo

# --- ТОП-5 ПРОЦЕССОВ ПО ПАМЯТИ ---
echo "🧠 Топ-5 процессов по использованию памяти:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk 'NR==1{print "PID\tКоманда\tMEM%"} NR>1{print $1"\t"$2"\t"$3}'
echo

# --- (Дополнительно) Пользователи и неудачные входы ---
echo "👥 Пользователи в системе:"
who | awk '{print $1}' | sort | uniq
echo

if command -v lastb &>/dev/null; then
  echo "🚫 Количество неудачных попыток входа:"
  lastb | grep -c '^[a-zA-Z]'
else
  echo "🚫 Команда lastb недоступна — пропущено."
fi
echo

echo "========================================"
echo " Конец отчёта "
echo "========================================"
