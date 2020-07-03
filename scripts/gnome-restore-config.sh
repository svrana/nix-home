#!/bin/bash

#
# Based on work done by Jason Mun @ https://github.com/yomun
#


if [ -f "$RCS/gnome-backup-env.sh" ]; then
    source "$RCS/gnome-backup-env.sh"
else
    echo "Could not locate config file"
    exit 1
fi

if [ ! -f "$EXT_DUMP_FILE" ]; then
    echo "Could not find $EXT_DUMP_FILE"
    exit 1
fi

ENABLE_ALL_GNOME_SHELL_EXTENSIONS="0"
VERSION=$(gnome-shell --version | sed 's/GNOME Shell //g')
VER=${VERSION:0:4}


function get_ext_ids() {
    local ext_ids
    ext_ids=$(sed -e "s/:.*//g" "$EXT_DUMP_FILE" | tr "\n" " ")
    echo "$ext_ids"
}

function fetch_extension() {
    local gid="$1"
	local url
    url=$(curl "https://extensions.gnome.org/extension-info/?pk=${gid}&shell_version=${VER}" | sed 's/^.*download_url": "//g' | sed 's/", "pk".*//g')
	local full_url
    full_url="https://extensions.gnome.org${url}"
	local folder_name
    folder_name=`echo "$url" | sed 's/\/download-extension\///g' | sed 's/.shell-extension.zip.*//g'`

	echo "[$gid] $full_url"
	echo "[$gid] $folder_name"

	if [ -d "${GNOME3_EXT_PATH}/${folder_name}" ]
	then
		echo "${folder_name} installed already.."
	else
		wget -O /tmp/extension.zip "$full_url"
		mkdir -p "${GNOME3_EXT_PATH}/$folder_name"
		unzip /tmp/extension.zip -d "${GNOME3_EXT_PATH}/$folder_name"
		echo "Installed ${folder_name}"
	fi
}

function download_extensions() {
    for eid in $(get_ext_ids); do
        fetch_extension	 "$eid"
    done

    if [ "$ENABLE_ALL_GNOME_SHELL_EXTENSIONS" = "1" ]; then
        for eid in $(get_ext_ids) ; do
            gnome-shell-extension-tool -e "$eid"
        done
    fi
}

function gnome_config_load() {
    dconf load / < "$GNOME3_DUMP_FILE"
}

download_extensions
gnome_config_load

unset ENABLE_ALL_GNOME_SHELL_EXTENSIONS
unset VERSION
unset VER
