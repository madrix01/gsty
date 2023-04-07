#!/bin/sh

if [ "$1" = "edit" ]; then
    gist_id=$(gh api gists | jq -r '.[] | [.id, .public, .description] | @tsv' | fzf | awk '{print $1}')
    gh gist edit $gist_id
fi

if [ "$1" = "create" ]; then
    read -p "Enter Gist Name > " gist_name
    read -p "Enter File Name (without extension) > " file_name
    file_path=$file_name.md
    echo "# $file_name" > $file_path
    gh gist create $file_path -d $gist_name 
    rm $file_path 
fi

if [ "$1" = "add" ]; then
    gist_id=$(gh api gists | jq -r '.[] | [.id, .public, .description] | @tsv' | fzf | awk '{print $1}')
    read -p "Enter File Name (without extension) > " file_name
    file_path=$file_name.md
    echo "# $file_name" > $file_path
    gh gist edit $gist_id -a $file_path
    rm $file_path
fi

