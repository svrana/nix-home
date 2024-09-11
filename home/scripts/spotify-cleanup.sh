# unfortunately this script uses a pulse audio client to retrieve the list of current
# clients. pw-cli would be better but its output is much more difficult to parse. as
# a result, this script will fail if there are already MAX_CLIENTS/64 pulse clients, so
# make sure this is run frequent enough to prevent this.

spotifyClients=()

while read -r LINE1; read -r LINE2; do
	IFS=' = '

	read -ra L1 <<< $LINE1
	read -ra L2 <<< $LINE2

	INDEX_STR=$(echo "${L1[0]}" | tr -d '\t')
	NAME_STR=$(echo "${L2[0]}" | tr -d '\t')

	if [[ $INDEX_STR != 'object.id' || $NAME_STR != 'application.name' ]]; then
		echo 'ERROR'
		exit
	fi

	INDEX=${L1[1]}
	NAME=${L2[1]}

	if [[ $NAME == '"spotify"' ]]; then
		objectId=$(echo "$INDEX" | tr -d \")
		spotifyClients+=( "$objectId" )
		#echo "object.id $objectId app: $NAME"
	fi
done < <(pactl list clients | grep -e 'object.id' -e 'application.name')

# remove last element (active client)
if (( ${#spotifyClients[@]} > 0 )); then
	echo "ignoring the last spotify instance"
	unset 'spotifyClients[-1]'
fi

for s in ${spotifyClients[@]}; do
	echo "pw-cli destroy $s"
	pw-cli destroy "$s"
done
