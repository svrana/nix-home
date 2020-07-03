#!/bin/bash

#
# Based on work done by Jason Mun @ https://github.com/yomun
#


if [ -f "$RCS/gnome-backup-env.sh" ]; then
    source "$RCS/gnome-backup-env.sh"
else
    echo 'Could not locate config file'
    exit 1
fi


function dump_gnome_shell_extenstions() {
    local re='^[0-9]+$'
    local id_array=()
    local extensions

    extensions=$(fd --print0 --max-depth=1 '' ~/.local/share/gnome-shell/extensions --exec echo '{/.}')
    for ext in ${extensions}; do
        local id
        local url

        url="${GNOME3_EXT_QUERY_URL}=${ext}"
        id=$(curl "$url" | sed -e "s/^.*\/extension\///g" | sed -e "s/\/.*//g")
        if ! [[ ${id} =~ ${re} ]]; then
            id_array+=("0")
        else
            id_array+=("${id}")
        fi
    done

    [ -f "$EXT_DUMP_FILE" ] && rm "$EXT_DUMP_FILE"

    local cnt=0
    for ext in ${extensions}; do
        if [ "${id_array[$cnt]}" = "0" ]; then
            echo ""
        else
            echo "${id_array[$cnt]}:${ext}" >> "$EXT_DUMP_FILE"
        fi

        cnt=$((cnt + 1))
    done
}

dump_gnome_shell_extenstions
dconf dump / > "$GNOME3_DUMP_FILE"
