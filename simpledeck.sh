#!/bin/bash

if [ "$EUID" -ne 0]; then
    echo "Этот скрипт требует прав администратора."
    eexrc sudo "$0" "$@"
    exit
fi

#zenity вступает в игру
choice=$(zenity --list \
 --title="Выбор директории для скрытия" \
 --text="Выбери директорию" \
 --radiolist \
 --column="Выбор" --column="Описание" \
 TRUE "/" \
 FALSE "/home/" \
 FALSE "Своя директория")

#обработка выбора
case "$choice" in
    "/")
    path="/"
    ;;
    "/home/")
    path="/home/"
    ;;
    "Своя директория")
    custom_path=$(zenity -- file-selection -- directory -- title="Выберите свою директорию")
if [[ -z "$custom_path" ]]; then
zenity -- error -- text="Путь не выбран. Операция отменена."
exit 1
fi
path="$custom_path"


zenity -- error -- text="Ничего не выбрано. Операция отменена."
exit 1

esac

# Создание .hidden файла в зависимости от выбранного пути
if [[ "$path" == "/" ]]; then
cd "$path" | | exit 1
sudo -A ls -A | grep -v '^home$' > .hidden
zenity -- info -- text="Файл .hidden создан в корневой директории, исключая 'home'."
else
cd "$path" || exit 1
ls -A > .hidden
zenity -- info -- text="Файл .hidden создан в директории: $path"
fi

exit 0