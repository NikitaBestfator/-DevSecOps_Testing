#!/bin/bash

# ============================================================
# project-helper.sh — скрипт для создания структуры проекта
# Автор: Nikita
# Группа: IT-9.24.3
# ============================================================

# Переменные
PROJECT_NAME="${1:-my-project}"          # имя проекта (аргумент $1 или по умолчанию)
BASE_DIR="$HOME/bash-script-practice"
PROJECT_DIR="$BASE_DIR/output/$PROJECT_NAME"
REPORT_FILE="$BASE_DIR/reports/report-$(date +%Y%m%d-%H%M%S).txt"

# Функция: вывод сообщения с датой
log_message() {
    echo "[$(date +%H:%M:%S)] $1"
}

# Функция: создание структуры проекта
create_project_structure() {
    log_message "Создание папки проекта: $PROJECT_DIR"
    mkdir -p "$PROJECT_DIR/src"
    mkdir -p "$PROJECT_DIR/docs"
    mkdir -p "$PROJECT_DIR/tests"
    
    log_message "Создание файлов..."
    touch "$PROJECT_DIR/src/main.txt"
    touch "$PROJECT_DIR/docs/readme.txt"
    touch "$PROJECT_DIR/tests/test.txt"
    
    # Записываем содержимое в файлы
    echo "Проект: $PROJECT_NAME" > "$PROJECT_DIR/src/main.txt"
    echo "Создан: $(date)" >> "$PROJECT_DIR/src/main.txt"
    
    echo "Документация проекта $PROJECT_NAME" > "$PROJECT_DIR/docs/readme.txt"
    echo "Тесты проекта $PROJECT_NAME" > "$PROJECT_DIR/tests/test.txt"
}

# Функция: проверка результата
check_result() {
    log_message "Проверка созданных файлов..."
    
    local count=0
    for file in $(find "$PROJECT_DIR" -type f); do
        echo "  Найден файл: $file"
        count=$((count + 1))
    done
    
    log_message "Всего файлов: $count"
    return $count
}

# Функция: запись отчёта
write_report() {
    log_message "Запись отчёта в $REPORT_FILE"
    mkdir -p "$(dirname "$REPORT_FILE")"
    
    {
        echo "=========================================="
        echo "ОТЧЁТ О РАБОТЕ СКРИПТА project-helper.sh"
        echo "=========================================="
        echo "Дата: $(date)"
        echo "Пользователь: $(whoami)"
        echo "Имя проекта: $PROJECT_NAME"
        echo "Папка проекта: $PROJECT_DIR"
        echo ""
        echo "Созданные файлы:"
        find "$PROJECT_DIR" -type f
        echo ""
        echo "Структура папок:"
        find "$PROJECT_DIR" -type d
    } > "$REPORT_FILE"
    
    log_message "Отчёт сохранён: $REPORT_FILE"
}

# ============================================================
# ОСНОВНАЯ ЛОГИКА СКРИПТА
# ============================================================

echo "=========================================="
echo "  Запуск project-helper.sh"
echo "=========================================="

# Чтение ввода от пользователя
read -p "Введите имя проекта (Enter = my-project): " USER_INPUT
if [ -n "$USER_INPUT" ]; then
    PROJECT_NAME="$USER_INPUT"
    PROJECT_DIR="$BASE_DIR/output/$PROJECT_NAME"
fi

log_message "Имя проекта: $PROJECT_NAME"

# Условие: проверка существования папки
if [ -d "$PROJECT_DIR" ]; then
    log_message "ВНИМАНИЕ: папка $PROJECT_DIR уже существует!"
    read -p "Перезаписать? (y/n): " ANSWER
    if [ "$ANSWER" != "y" ]; then
        log_message "Отмена операции."
        exit 0
    fi
    rm -rf "$PROJECT_DIR"
fi

# Создание структуры
create_project_structure

# Проверка результата
check_result
FILE_COUNT=$?

# Условие: если файлов меньше 3 — предупреждение
if [ "$FILE_COUNT" -lt 3 ]; then
    log_message "ОШИБКА: создано меньше 3 файлов!"
    exit 1
else
    log_message "УСПЕХ: создано $FILE_COUNT файлов"
fi

# Запись отчёта
write_report

# Цикл: вывод итоговой структуры
echo ""
echo "=========================================="
echo "  ИТОГОВАЯ СТРУКТУРА ПРОЕКТА"
echo "=========================================="
for dir in $(find "$PROJECT_DIR" -type d | sort); do
    echo "📁 $dir"
done

echo ""
log_message "Готово! Проверьте отчёт: $REPORT_FILE"
