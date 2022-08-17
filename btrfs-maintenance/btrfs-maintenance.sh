#!/bin/sh

set -euo pipefail

WAIT1=6h
WAIT2=7d

function notify() { echo '$ notify' "$@"; curl -s -F body="${2-$1}" ${2+-F title="${1}"} ${3+-F tag="$(echo "$3" | tr '[:upper:]' '[:lower:]')"} apprise/notify/main; }
function die() { notify "$@"; exit 1; }

until notify "Initializing BTRFS maintenance process"; do
	sleep 1;
done

while true; do
	sleep "$WAIT1"

	notify "Starting BTRFS scrub"

	# Assumes that the relevant BTRFS filesystem is the same one storing the docker directory and subvolumes
	scrub=$(btrfs scrub start -BR / | tee /dev/stderr) || notify "BTRFS Scrub could not complete!" "$scrub" CRITICAL

	if echo "${scrub}" | grep -q 'errors: [^0]'; then
		notify "BTRFS Scrub failed!" "$scrub" CRITICAL
	else
		notify "BTRFS Scrub succeeded!" "$scrub"
	fi
	
	# Can't fstrim inside a directory because all mountpoints are bindmounted
	#if fstrim -v /; then
	#	notify "SSD Trim successful"
	#else
	#	notify "SSD Trim failed!"
	#fi

	sleep "$WAIT2"
done
