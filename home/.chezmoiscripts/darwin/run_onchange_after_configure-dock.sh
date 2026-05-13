#!/bin/bash

set -eufo pipefail

# Stock Apple apps to remove from the Dock.
declare -a remove_labels=(
	Safari
	Messages
	Mail
	Maps
	Photos
	FaceTime
	Calendar
	Contacts
	Reminders
	Notes
	Freeform
	TV
	Music
	Keynote
	Numbers
	Pages
	"App Store"
)

# Restart the Dock once on exit so all removals take effect in a single refresh.
trap 'killall Dock' EXIT

# --no-restart suppresses the per-item Dock restart; the trap above handles it.
# || true prevents failure if an item is already absent from the Dock.
for label in "${remove_labels[@]}"; do
	dockutil --no-restart --remove "${label}" || true
done
