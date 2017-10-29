#!/bin/bash

######################
# BigLinux Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


/usr/share/biglinux/iso-generator/chroot-on.sh "$1"

cat "$1/install-apps.txt" > "$1/remaster/chroot/install.txt"
cat "$1/install-drivers.txt" >> "$1/remaster/chroot/install.txt"

cp -f "/usr/share/biglinux/iso-generator/install_packages_chroot.sh" "$1/remaster/chroot/install_packages_chroot.sh"
chroot "$1/remaster/chroot" /install_packages_chroot.sh
rm -f "$1/remaster/chroot/install_packages_chroot.sh"

rm -f "$1/remaster/chroot/install.txt"

/usr/share/biglinux/iso-generator/chroot-off.sh "$1"
