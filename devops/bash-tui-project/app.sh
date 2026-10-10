#!/bin/bash

# app.sh — Менеджер задач (TUI)
# Автор: Nikita
# Группа: IT-9.24.3
# Тема: Менеджер задач (добавление, просмотр, поиск, удаление)

# ---------- НАСТРОЙКИ ----------
DATA_DIR="data"
TASKS_FILE="$DATA_DIR/tasks.txt"
DONE_FILE="$DATA_DIR/done.txt"
REPORTS_DIR="reports"

# ---------- ЦВЕТА ----------
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================
# ФУНКЦИИ
# ============================================================

# Инициализация файлов
init_files() {
    mkdir -p "$DATA_DIR" "$REPORTS_DIR"
    touch "$TASKS_FILE" "$DONE_FILE"
}

# Пауза
pause() {
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# Добавить задачу
add_task() {
    clear
    echo -e "${CYAN}=== ДОБАВЛЕНИЕ ЗАДАЧИ ===${NC}"
    read -p "Введите задачу: " task
    
    if [ -z "$task" ]; then
        echo -e "${RED}Ошибка: задача не может быть пустой!${NC}"
        pause
        return
    fi
    
    # Формат: дата | задача
    echo "$(date '+%Y-%m-%d %H:%M') | $task" >> "$TASKS_FILE"
    echo -e "${GREEN}✓ Задача добавлена!${NC}"
    pause
}

# Показать все задачи
show_tasks() {
    clear
    echo -e "${CYAN}=== СПИСОК ЗАДАЧ ===${NC}"
    
    if [ ! -s "$TASKS_FILE" ]; then
        echo -e "${YELLOW}Список задач пуст.${NC}"
        pause
        return
    fi
    
    echo ""
    nl -w2 -s'. ' "$TASKS_FILE"
    echo ""
    echo -e "${YELLOW}Всего задач: $(wc -l < "$TASKS_FILE")${NC}"
    pause
}

# Поиск задач
search_task() {
    clear
    echo -e "${CYAN}=== ПОИСК ЗАДАЧИ ===${NC}"
    read -p "Введите ключевое слово: " keyword
    
    if [ -z "$keyword" ]; then
        echo -e "${RED}Ошибка: пустой запрос!${NC}"
        pause
        return
    fi
    
    echo ""
    local result=$(grep -i "$keyword" "$TASKS_FILE")
    
    if [ -z "$result" ]; then
        echo -e "${YELLOW}Ничего не найдено по запросу: $keyword${NC}"
    else
        echo -e "${GREEN}Найдено:${NC}"
        echo "$result"
    fi
    pause
}

# Удалить задачу
delete_task() {
    clear
    echo -e "${CYAN}=== УДАЛЕНИЕ ЗАДАЧИ ===${NC}"
    
    if [ ! -s "$TASKS_FILE" ]; then
        echo -e "${YELLOW}Список задач пуст.${NC}"
        pause
        return
    fi
    
    echo ""
    nl -w2 -s'. ' "$TASKS_FILE"
    echo ""
    read -p "Введите номер задачи для удаления: " num
    
    # Проверка: число ли это
    if ! [[ "$num" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Ошибка: нужно ввести число!${NC}"
        pause
        return
    fi
    
    # Проверка: существует ли строка
    local total=$(wc -l < "$TASKS_FILE")
    if [ "$num" -lt 1 ] || [ "$num" -gt "$total" ]; then
        echo -e "${RED}Ошибка: задачи с номером $num не существует!${NC}"
        pause
        return
    fi
    
    # Удаляем строку через sed
    sed -i "${num}d" "$TASKS_FILE"
    echo -e "${GREEN}✓ Задача №$num удалена!${NC}"
    pause
}

# Отметить задачу как выполненную
complete_task() {
    clear
    echo -e "${CYAN}=== ОТМЕТИТЬ КАК ВЫПОЛНЕННУЮ ===${NC}"
    
    if [ ! -s "$TASKS_FILE" ]; then
        echo -e "${YELLOW}Список задач пуст.${NC}"
        pause
        return
    fi
    
    echo ""
    nl -w2 -s'. ' "$TASKS_FILE"
    echo ""
    read -p "Введите номер выполненной задачи: " num
    
    if ! [[ "$num" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Ошибка: нужно ввести число!${NC}"
        pause
        return
    fi
    
    local total=$(wc -l < "$TASKS_FILE")
    if [ "$num" -lt 1 ] || [ "$num" -gt "$total" ]; then
        echo -e "${RED}Ошибка: задачи с номером $num не существует!${NC}"
        pause
        return
    fi
    
    # Берём строку, добавляем в done, удаляем из tasks
    local task=$(sed -n "${num}p" "$TASKS_FILE")
    echo "$task" >> "$DONE_FILE"
    sed -i "${num}d" "$TASKS_FILE"
    
    echo -e "${GREEN}✓ Задача отмечена как выполненная!${NC}"
    pause
}

# Показать выполненные
show_done() {
    clear
    echo -e "${CYAN}=== ВЫПОЛНЕННЫЕ ЗАДАЧИ ===${NC}"
    
    if [ ! -s "$DONE_FILE" ]; then
        echo -e "${YELLOW}Выполненных задач нет.${NC}"
        pause
        return
    fi
    
    echo ""
    nl -w2 -s'. ' "$DONE_FILE"
    echo ""
    echo -e "${GREEN}Всего выполнено: $(wc -l < "$DONE_FILE")${NC}"
    pause
}

# Сохранить отчёт
save_report() {
    clear
    echo -e "${CYAN}=== СОХРАНЕНИЕ ОТЧЁТА ===${NC}"
    
    local report_file="$REPORTS_DIR/report-$(date '+%Y%m%d-%H%M%S').txt"
    local total=$(wc -l < "$TASKS_FILE" 2>/dev/null || echo 0)
    local done=$(wc -l < "$DONE_FILE" 2>/dev/null || echo 0)
    
    {
        echo "=========================================="
        echo "ОТЧЁТ ПО ЗАДАЧАМ"
        echo "=========================================="
        echo "Дата: $(date)"
        echo "Пользователь: $(whoami)"
        echo ""
        echo "Активных задач: $total"
        echo "Выполненных задач: $done"
        echo ""
        echo "--- АКТИВНЫЕ ЗАДАЧИ ---"
        cat "$TASKS_FILE" 2>/dev/null || echo "(пусто)"
        echo ""
        echo "--- ВЫПОЛНЕННЫЕ ЗАДАЧИ ---"
        cat "$DONE_FILE" 2>/dev/null || echo "(пусто)"
    } > "$report_file"
    
    echo -e "${GREEN}✓ Отчёт сохранён: $report_file${NC}"
    pause
}

# ============================================================
# ГЛАВНОЕ МЕНЮ
# ============================================================
show_menu() {
    clear
    echo "=========================================="
    echo "     МЕНЕДЖЕР ЗАДАЧ (TUI)"
    echo "=========================================="
    echo " 1. Добавить задачу"
    echo " 2. Показать все задачи"
    echo " 3. Найти задачу"
    echo " 4. Удалить задачу"
    echo " 5. Отметить как выполненную"
    echo " 6. Показать выполненные"
    echo " 7. Сохранить отчёт"
    echo " 0. Выход"
    echo "=========================================="
}

# ============================================================
# ОСНОВНОЙ ЦИКЛ
# ============================================================
main() {
    init_files
    
    while true; do
        show_menu
        read -p "Выберите пункт меню: " choice
        
        case "$choice" in
            1) add_task ;;
            2) show_tasks ;;
            3) search_task ;;
            4) delete_task ;;
            5) complete_task ;;
            6) show_done ;;
            7) save_report ;;
            0)
                echo ""
                echo -e "${GREEN}До свидания!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Ошибка: неверный пункт меню! Попробуйте снова.${NC}"
                pause
                ;;
        esac
    done
}

# Запуск
main
