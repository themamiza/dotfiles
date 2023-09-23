#!/bin/sh

dotfilesrepo="https://github.com/themamiza/dotfiles"
progsfile="https://raw.githubusercontent.com/themamiza/dotfiles/master/.local/share/progs.csv"
aurhelper="paru"
repobranch="master"

installpkg() {
	pacman --noconfirm --needed -S "$1" >/dev/null 2>&1
}

error() {
	printf ":: %s\n" "$1" >&2
	exit 1
}

welcomemsg() {
	whiptail --title "Welcome!" \
		--msgbox "Welcome to Mamiza's Auto-Rice Bootstrapping Script!\\n\\nThis script will automatically install a fully-featured Linux desktop, which I use as my main machine.\\n\\n-Mamiza" 10 60

	whiptail --title "Important Note!" \
		--yes-button "All ready!" \
		--no-button "Return..." \
		--yesno "Be sure the computer you are using has current pacman updates and refreshed Arch keyrings.\\n\\nIf it does not, the installation of some programs might fail." 8 70

}

getuserandpass() {
	name=$(whiptail --inputbox "First, please enter a name for the new user account." 10 60 3>&1 1>&2 2>&3 3>&1) || exit 1
	while ! echo "$name" | grep -q "^[a-z_][a-z0-9_-]*$"; do
		name=$(whiptail --nocancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _." 10 60 3>&1 1>&2 2>&3 3>&1)
	done

	pass1=$(whiptail --nocancel --passwordbox "Enter a password for that user." 10 60 3>&1 1>&2 2>&3 3>&1)
	pass2=$(whiptail --nocancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	while ! [ "$pass1" = "$pass2" ]; do
		unset pass2
		pass1=$(whiptail --nocancel --passwordbox "Passwords do not match.\\n\\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
		pass2=$(whiptail --nocancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	done
}

usercheck() {
	! { id -u "$name" > /dev/null 2>&1; } ||
		whiptail --title "WARNING" \
			--yes-button "CONTINUE" \
			--no-button "No wait..." \
			--yesno "The user \'$name\' already exists on this system. MARBS can install for a user already existing, but it will OVERWRITE any conflicting settings/dotfiles on the user account\\n\\nMARBS will not overwrite your user files, documents, videos, etc., so don't worry about that, but only click <CONTINUE> if you don't mind your settings being overwritten.\\n\\nNote also that MARBS will chane $name's password to the one you just gave." 14 70
}

preinstallmsg() {
	whiptail --title "let's get this party started!" \
		--yes-button "let's go!" \
		--no-button "no, nevermind!" \
		--yesno "the rest of the installation will now be totally automated, so you can sit back and relax.\\n\\nit will take some time, but when done, you can relax even more with your complete system.\\n\\nnow just press <let's go!> and the system will begin installation!" 13 60 || { clear; exit 1; }
}

adduserandpass() {
	whiptail --infobox "Adding user \"$name\"..." 7 50
	useradd -m -g wheel -s /bin/zsh "$name" > /dev/null 2>&1 ||
		usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
	export repodir="/home/$name/.local/src"
	mkdir -p "$repodir"
	chown -R "$name":wheel "$(dirname "$repodir")"
	echo "$name:$pass1" | chpasswd
	unset pass1 pass2
}

refreshkeys() {
	case "$(readlink -f /sbin/init)" in
		*systemd*)
			whiptail --infobox "Refreshing Arch Keyring..." 7 40
			pacman --noconfirm -S archlinux-keyring >/dev/null 2>&1
			;;
		*)
			whiptail --infobox "Enabling Arch Repositories for more a more extensive software collection..." 7 40
			pacman --noconfirm --needed -S \
				artix-keyring artix-archlinux-support >/dev/null 2>&1
			grep -q "^\[extra\]" /etc/pacman.conf ||
				echo "[extra]
Include = /etc/pacman.d/mirrorlist-arch" >> /etc/pacman.conf
			pacman -Sy --noconfirm >/dev/null 2>&1
			pacman-key --populate archlinux >/dev/null 2>&1
			;;
	esac
}

manualinstall() {
	pacman -Qq "$1" && return 0
	whiptail --infobox "Installing \"$1\" manually." 7 50
	sudo -u "$name" mkdir -p "$repodir/$1"
	sudo -u "$name" git -C "$repodir" clone --depth 1 --single-branch \
		--no-tags -q "https://aur.archlinux.org/$1.git" "$repodir/$1" ||
		{
			cd "$repodir/$1" || return 1
			sudo -u "$name" git pull --force origin master
		}
	cd "$repodir/$1" || exit 1
	sudo -u "$name" -D "$repodir/$1" \
		makepkg --noconfirm -si >/dev/null 2>&1 || return 1
}

maininstall() {
	whiptail --title "MARBS Installation" --infobox "Installing \'$1\' ($n of $total). $1 $2" 9 70
	installpkg "$1"
}

gitmakeinstall() {
	progname="${1##*/}"
	progname="${progname%.git}"
	dir="$repodir/$progname"
	whiptail --title "MARBS Installation" \
		--infobox "Installing \`$progname\` ($n of $total) via \`git\` and \`make\`. $(basename "$1") $2" 8 70
	sudo -u "$name" git -C "$repodir" clone --depth 1 --single-branch \
		--no-tags -q "$1" "$dir" ||
		{
			cd "$dir" || return 1
			sudo -u "$name" git pull --force origin master
		}
	cd "$dir" || exit 1
	make >/dev/null 2>&1
	cd /tmp || return 1
}

installdoom() {
	whiptail --title "MARBS Installation" \
		--infobox "Installing DoomEmacs. Doom $2" 9 70
	sudo -u "$name" git clone --depth 1 "$1" /home/"$name"/.config/emacs
	sudo -u "$name" /home/"$name"/.config/emacs/bin/doom install --force --env --fonts

	whiptail --title "MARBS Installation" \
		--infobox "Syncing DoomEmacs." 9 70
	sudo -u "$name" /home/"$name"/.config/emacs/bin/doom sync
}

aurinstall() {
	whiptail --title "MARBS Installation" \
		--infobox "Installing \`$1\` ($n of $total) from the AUR. $1 $2" 9 70
	echo "$aurinstalled" | grep -q "^$1$" && return 1
	sudo -u "$name" $aurhelper -S --noconfirm "$1" >/dev/null 2>&1
}

installationloop() {
	([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) ||
		curl -Ls "$progsfile" | sed '/^#/d' > /tmp/progs.csv
	total=$(wc -l </tmp/progs.csv)
	aurinstalled=$(pacman -Qqm)
	while IFS=, read -r tag program comment; do
		n=$((n + 1))
		echo "$comment" | grep -q "^\".*\"$" &&
			comment="$(echo "$comment" | sed -E "s/(^\"|\"$)//g")"
		case "$tag" in
			"A") aurinstall "$program" "$comment";;
			"G") gitmakeinstall "$program" "$comment";;
			"D") installdoom "$program" "$comment";;
			*) maininstall "$program" "$comment";;
		esac
	done </tmp/progs.csv
}

putgitrepo() {
	whiptail --infobox "Downloading and installing config files..." 7 60
	[ -z "$3" ] && branch="master" || branch="$repobranch"
	dir=$(mktemp -d)
	[ ! -d "$2" ] && mkdir -p "$2"
	chown "$name":"$name" "$dir" "$2"
	sudo -u "$name" git -C "$repodir" clone --depth 1 \
		--single-branch --no-tags -q --recursive -b "$branch" \
		--recurse-submodules "$1" "$dir"
	sudo -u "$name" cp -rfT "$dir" "$2"
}

finalize() {
	whiptail --title "All done!" \
		--msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\\n\\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment (it will start automatically in tty1).\\n\\n.t Mamiza" 13 80
}

pacman --noconfirm --needed -Sy libnewt ||
	error "Are you sure you're running this as the root user, are on an Arch-based distribution and have an internet connection?"

welcomemsg || error "User exited."

getuserandpass || error "User exited."

usercheck || error "User exited."

preinstallmsg || error "User exited."

refreshkeys ||
	error "Error automatically refreshing Arch keyring. Consider doing so manually."

for x in curl ca-certificates base-devel git zsh; do
	whiptail --title "MARBS Installation" \
		--infobox "Installing \`$x\` which is required to install and configure other programs." 8 70
	installpkg "$x"
done

whiptail --title "MARBS Installation" \
	--infobox "Synchronizing system time to ensure successful and secure installation of software..." 8 70
timedatectl set-ntp true

adduserandpass || error "Error adding username and/or password."

[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers

trap 'rm -f /etc/sudoers.d/marbs-temp' HUP INT QUIT TERM PWR EXIT
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/marbs-temp

grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
sed -Ei "s/^#(ParallelDownloads).*/\1 = 5/;/^#Color$/s/#//" /etc/pacman.conf

sed -i "s/-j2/-j$(nproc)/;/^#MAKEFLAGS/s/^#//" /etc/makepkg.conf

manualinstall $aurhelper || error "Failed to install AUR helper."

installationloop

putgitrepo "$dotfilesrepo" "/home/$name" "$repobranch"
rm -rf "/home/$name/.git/" "/home/$name/README.md" "/home/$name/LICENSE"
sudo -u "$name" mkdir -p "/home/$name/.cache/zsh"

chsh -s /bin/zsh "$name" >/dev/null 2>&1
usermod -aG libvirt "$name" >/dev/null 2>&1

dbus-uuidgen >/var/lib/dbus/machine-id

echo "export \$(dbus-launch)" >/etc/profile.d/dbus.sh

[ ! -f /etc/X11/xorg.conf.d/40-libinput.conf ] && printf 'Section "InputClass"
  		Identifier "libinput touchpad catchall"
		MatchIsTouchpad "on"
		MatchDevicePath "/dev/input/event*"
		Driver "libinput"
		Option "Tapping" "on"
		Option "NaturalScrolling" "true"
EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf

echo "%wheel ALL=(ALL:ALL) ALL" >/etc/sudoers.d/00-marbs-wheel-can-sudo
echo "%wheel ALL=(ALL:ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/pacman -Syyu --noconfirm" >/etc/sudoers.d/01-marbs-cmds-without-password
echo "Defaults editor=/usr/bin/nvim" > /etc/sudoers.d/02-marbs-visudo-editor

blkid | grep "TYPE=\"swap\"" | cut -d " " -f1 | sed "s/://" | xargs df -h | awk 'NR==2P{print $2}' | sed "s/\..*//" | xargs test 7 -le && {#!
sed -i "/^HOOKS=(.*)$/s/)$/ resume)/" /etc/mkinitcpio.conf
mkinitcpio -P
swapuuid=$(blkid | grep swap | grep -Po " UUID=\".*?\"" | sed "s/ //;s/UUID=//;s/\"//g")
sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/s/quiet\"/resume=UUID=$swapuuid\"/" /etc/default/grub
sed -i "/^GRUB_TIMEOUT=.*$/s/=.*/=3/;/^#GRUB_DISABLE_OS_PROBER=false$/s/#//" /etc/default/grub
sed -i "/^GRUB_DEFAULT=.*$/s/=.*/=saved/;/^#GRUB_SAVEDEFAULT=true$/s/#//" /etc/default/grub
unset swapuuid
grub-mkconfig -o /boot/grub/grub.cfg
}

finalize
