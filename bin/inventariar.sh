#!/usr/bin/env bash
set -euo pipefail

if [ "$#" != "1" ]; then
	cat >&2 <<EoD
Este script genera un inventario de los archivos en el DIR especificado
como primer argumento

Uso:
	$0 <DIR>

EoD
	exit 1
fi

DIR="$1"

case "$(uname -s)" in
	Linux*)
		STAT_OPTS=(-c '%s')
	;;
	Darwin*|*BSD*|FreeBSD*|OpenBSD*|NetBSD*)
		STAT_OPTS=(-f '%z')
	;;
	*)
		echo "ERROR: Sistema '$(uname -a)' no soportado." >&2
		exit 1
	;;
esac
echo "opciones: ${STAT_OPTS[@]}"

while IFS= read -r -d '' FILE; do
	#SIZE=$(wc -c <"$FILE")
	SIZE=$(stat "${STAT_OPTS[@]}" -- "$FILE")
	HASH=$(md5sum -- "$FILE" | awk '{print $1}')
	echo "$FILE	$SIZE	$HASH"
done < <(find "$DIR" -type f -print0)
