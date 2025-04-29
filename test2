#!/bin/bash

# Проверка, запущен ли скрипт с правами администратора
if [ "$EUID" -ne 0 ]; then
    echo "Этот скрипт требует прав администратора."
    # Перезапуск скрипта с sudo
    exec sudo "$0" "$@"
    exit 1
fi

# Запрос пароля через Zenity
password=$(zenity --password --title="Права суперпользователя требуются")

# Проверка, что пароль введён
if [[ -z "$password" ]]; then
  zenity --error --text="Пароль не введён. Операция отменена."
  exit 1
fi

# Проверка правильности пароля
echo "$password" | sudo -S -v &>/dev/null
if [[ $? -ne 0 ]]; then
  zenity --error --text="Неверный пароль или отказ в доступе."
  exit 1
fi

# Предложение выбора директории
choice=$(zenity --list \
  --title="Выбор директории" \
  --text="Выберите директорию для работы:" \
  --radiolist \
  --column="Выбор" --column="Описание" \
  TRUE "/" \
  FALSE "/home/" \
  FALSE "Свой путь")

# Обработка выбора
case "$choice" in
  "/")
    path="/"
    ;;
  "/home/")
    path="/home/"
    ;;
  "Свой путь")
    custom_path=$(zenity --file-selection --directory --title="Выберите свою директорию")
    if [[ -z "$custom_path" ]]; then
      zenity --error --text="Путь не выбран. Операция отменена."
      exit 1
    fi
    path="$custom_path"
    ;;
  *)
    zenity --error --text="Ничего не выбрано. Операция отменена."
    exit 1
    ;;
esac

# Создание .hidden файла в зависимости от выбранного пути
if [[ "$path" == "/" ]]; then
  cd "$path" || exit 1
  sudo -A ls -A | grep -v '^home$' > .hidden
  zenity --info --text="Файл .hidden создан в корневой директории, исключая 'home'."
else
  cd "$path" || exit 1
  ls -A > .hidden
  zenity --info --text="Файл .hidden создан в директории: $path"
fi

exit 0
