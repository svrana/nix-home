spotifyInstances=()

while read -r LINE1; read -r LINE2; do
	IFS=' = '

	read -ra L1 <<< $LINE1
	read -ra L2 <<< $LINE2

	# trim leading/trailing spaces for error checking
	INDEX_STR=$(echo "${L1[0]}" | xargs)
	NAME_STR=$(echo "${L2[0]}" | xargs)

	if [[ $INDEX_STR != 'object.id' || $NAME_STR != 'application.name' ]]; then
		echo 'ERROR'
		exit
	fi

	INDEX=${L1[1]}
	NAME=${L2[1]}


	if [[ $NAME == '"spotify"' ]]; then
		objectId=$(echo "$INDEX" | tr -d \")
		spotifyInstances+=( "$objectId" )
		#echo "object.id $objectId app: $NAME"
	fi
done < <(pactl list clients | grep -e 'object.id' -e 'application.name')

# remove last element (active client)
if [ ${#spotifyInstances[@]} -ge 1 ]; then
	unset 'spotifyInstances[-1]'
fi

for s in ${spotifyInstances[@]}; do
	echo "pw-cli destroy $s"
	pw-cli destroy "$s"
done

exit 0
