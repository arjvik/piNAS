#!/bin/sh

set -euo pipefail

WAIT1=1s
WAIT2=7d

function notify() { curl -s -F body="${2-$1}" ${2+-F title="${1}"} apprise/notify; }
function die() { notify "$@"; exit 1; }

while true; do
	sleep "$WAIT1"

	until notify "Starting BTRFS scrub"; do
		sleep 1;
	done

	# Assumes that the relevant BTRFS filesystem is the same one storing the docker directory and subvolumes
	scrub=$(btrfs scrub start -BR / | tee /dev/stderr) || notify "BTRFS Scrub could not complete!" "$scrub"

	if echo "${scrub}" | grep -q '_errors: [^0]'; then
		notify "BTRFS Scrub failed!" "$scrub"
	else
		notify "BTRFS Scrub succeeded!" "$scrub"
	fi
	
	if fstrim -v /; then
		notify "SSD Trim successful"
	else
		notify "SSD Trim failed!"
	fi

	sleep "$WAIT2"
done
