#!/bin/bash

if [ "$EUID" -ne 0]; then
    echo "���� ������ ������� ���� ��������������."
    eexrc sudo "$0" "$@"
    exit
fi

#zenity �������� � ����
choice=$(zenity --list \
 --title="����� ���������� ��� �������" \
 --text="������ ����������" \
 --radiolist \
 --column="�����" --column="��������" \
 TRUE "/" \
 FALSE "/home/" \
 FALSE "���� ����������")

#��������� ������
case "$choice" in
    "/")
    path="/"
    ;;
    "/home/")
    path="/home/"
    ;;
    "���� ����������")
    custom_path=$(zenity -- file-selection -- directory -- title="�������� ���� ����������")
if [[ -z "$custom_path" ]]; then
zenity -- error -- text="���� �� ������. �������� ��������."
exit 1
fi
path="$custom_path"


zenity -- error -- text="������ �� �������. �������� ��������."
exit 1

esac

# �������� .hidden ����� � ����������� �� ���������� ����
if [[ "$path" == "/" ]]; then
cd "$path" | | exit 1
sudo -A ls -A | grep -v '^home$' > .hidden
zenity -- info -- text="���� .hidden ������ � �������� ����������, �������� 'home'."
else
cd "$path" || exit 1
ls -A > .hidden
zenity -- info -- text="���� .hidden ������ � ����������: $path"
fi

exit 0