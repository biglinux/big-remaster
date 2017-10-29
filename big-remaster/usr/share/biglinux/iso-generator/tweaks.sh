#!/bin/bash

######################
# BigLinux Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


#Translation
export TEXTDOMAINDIR="/usr/share/locale-langpack"
export TEXTDOMAIN=biglinux-iso-generator


rm -f "$1/remaster/chroot/etc/xdg/autostart/psensor.desktop"

mkdir -p /etc/X11/xorg.conf.d/ 2> /dev/null

#Corrige o netbios do samba
if [ "$(grep "netbios name =" "$1/remaster/chroot/etc/samba/smb.conf")" != "" ]; then
  #Altera a linha netbios
  sed -i "s|.*netbios name =.*|netbios name = BigLinux|g" "$1/remaster/chroot/etc/samba/smb.conf"
else
  #Inclui a linha netbios
sed -i "\|\[global\]|{p;s|.*|netbios name = BigLinux|;}" "$1/remaster/chroot/etc/samba/smb.conf"
fi
sed -i 's|Ubuntu|BigLinux|g' "$1/remaster/chroot/etc/samba/smb.conf"




