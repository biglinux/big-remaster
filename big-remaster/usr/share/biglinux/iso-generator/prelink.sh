#!/bin/bash

######################
# BigLinux Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


#Translation
export TEXTDOMAINDIR="/usr/share/locale-langpack"
export TEXTDOMAIN=biglinux-iso-generator


/usr/share/biglinux/iso-generator/chroot-on.sh "$1"

chroot "$1/remaster/chroot" prelink -amR


/usr/share/biglinux/iso-generator/chroot-off.sh "$1"


