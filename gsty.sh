#!/bin/sh

BASEDIR=$(dirname $0)

CLEAR_CODE="\033c"
source $BASEDIR/color.sh

quick_note () {
    gist_id=$(cat ${BASEDIR}/gstore | grep "quick" | awk '{print $1}')
    gh gist edit $gist_id
}

end_session () {
    kill -9 $PPID
}

echo ${Blue}
cat ${BASEDIR}/logo.txt
while :
do
    echo ${Green}
    read -p "~ " cmd
    echo $Color_Off
    if [ "$cmd" = "exit" ]; then
        end_session

    elif [ "$cmd" = "quick" ]; then
        quick_note

    elif [ "$cmd" = "clear" ]; then
        printf $CLEAR_CODE 
        echo ${Blue}
        cat ${BASEDIR}/logo.txt

    elif [ "$cmd" = "ls" ]; then
        cat ${BASEDIR}/gstore | awk '{print $2}'

    elif [ "$cmd" = "init" ]; then
        echo "this may remove previously present gstore file."
        echo "Creating gstore at ${BASEDIR}"
        rm "${BASEDIR}/gstore"
        touch "${BASEDIR}/gstore"

    elif [ "$cmd" = "edit" ]; then
        gist_id=$(cat "$BASEDIR/gstore" | fzf | awk '{print $1}')
        gh gist edit $gist_id

    elif [ "$cmd" = "create" ]; then
        read -p "Enter Gist Name > " gist_name
        read -p "Enter File Name > " file_name
        file_path="$BASEDIR/$file_name.md"
        echo "# $file_name" > $file_path
        gh gist create $file_path -d $gist_name 
        rm $file_path 

    elif [ "$cmd" = "add_file" ]; then
        gist_id=$(cat "$BASEDIR/gstore" | fzf | awk '{print $1}')
        read -p "Enter File Name > " file_name
        echo "# $file_name" > "$BASEDIR/$file_name"
        gh gist edit $gist_id -a $BASEDIR/$file_name
        rm "$BASEDIR/$file_name"

    elif [ "$cmd" = "add" ]; then
        gist_id=$(gh api gists | jq -r '.[] | [.id, .public, .description] | @tsv' | fzf | awk '{print $1 " " $3}')
        echo "$gist_id" >> "$BASEDIR/gstore"
        echo "$gist_id added to gstore."

    else
        echo "Allowed commands are add, add_file, clear, create, edit."
    fi
done
