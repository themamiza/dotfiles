#!/bin/sh

progsfile="PUT URL HERE"

custom() {
	whiptail --title "Are you sure?" \
		--no-button "Return..." \
		--yes-button "Yes" \ # not needed (defualt behavior)
		--yesno "Choosing Custom means you will have to choose all your programs one by one. Do you want to continue?" 20 80 3>&1 1>&2 2>&3 3>&1 || return

	([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) ||
		curl -Ls "$progsfile" | sed "/^#/d" > /tmp/progs.csv

	# Removes the first 2 lines:
	#sed -i "1,2d" /tmp/progs.csv
	# Splits the file into pieces based on newlines
	#awk -v RS= '{print > ("/tmp/progs-" NR ".csv")}' /tmp/progs.csv
}

while true; do
	progs=$(whiptail --title "Choose Programs" --menu "What programs do want installed?" 20 80 5 \
		"Minimalist" "A pre made list of Minimalist set of programs." \
		"Full" "Full list of programs needed for daily use and development." \
		"Custom" "Choose your own programs. (Recommended)" 3>&1 1>&2 2>&3 3>&1)

	case "$progs" in
		"Minimalist") progsfile="link to minimalist progs.csv" && break;;
		"Full") progsfile="link to full progs.csv" && break;;
		"Custom") custom && break; continue;;
	esac
done
