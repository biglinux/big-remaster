#!/bin/bash

######################
# BigLinux Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


sed 's|$| install|g' "$1/install-drivers.txt" > /tmp/biglinux-iso-generator-install.txt
echo "
" >> /tmp/biglinux-iso-generator-install.txt
sed 's|$| install|g' "$1/install-apps.txt" >> /tmp/biglinux-iso-generator-install.txt

/usr/share/biglinux/iso-generator/chroot-on.sh "$1"

cd "$1/remaster/chroot"



#Resolve conflito ao gerar iso de 32 bits em sistema de 64 bits
mkdir -p usr/lib/apt/
ln -s /usr/lib/apt/methods usr/lib/apt/methods-biglinux

mv -f /root/.synaptic/synaptic.conf /root/.synaptic/synaptic.conf-bkp
cp -f /usr/share/biglinux/iso-generator/synaptic.conf /root/.synaptic/synaptic.conf

# confere se é 64 ou 32 bits
if [ "$(chroot . getconf LONG_BIT)" = "32" ]; then
    synaptic -o RootDir=. -o APT::Architecture=i386 -o Dir::Bin::Methods=/usr/lib/apt/methods-biglinux/ --non-interactive --hide-main-window --update-at-startup
    synaptic -o RootDir=. -o Install-Recommends=0 -o APT::Install-Recommends=false -o APT::Architecture=i386 -o Dir::Bin::Methods=/usr/lib/apt/methods-biglinux/ --dist-upgrade-mode --set-selections < /tmp/biglinux-iso-generator-install.txt
    apt-get -f install
else
    synaptic -o RootDir=. -o Dir::Bin::Methods=/usr/lib/apt/methods-biglinux/ --non-interactive --hide-main-window --update-at-startup
    synaptic -o RootDir=. -o Install-Recommends=0 -o APT::Install-Recommends=false -o Dir::Bin::Methods=/usr/lib/apt/methods-biglinux/ --dist-upgrade-mode --set-selections < /tmp/biglinux-iso-generator-install.txt
    apt-get -f install
fi
mv -f /root/.synaptic/synaptic.conf-bkp /root/.synaptic/synaptic.conf



#Remove a gambiarra para evitar conflito de gerar iso 32 bits em sistema de 64 bits
rm -f usr/lib/apt/methods-biglinux

chroot "$1/remaster/chroot" dpkg --configure -a
chroot "$1/remaster/chroot" apt-get -f install
chroot "$1/remaster/chroot" dpkg --configure -a

cd ../..

/usr/share/biglinux/iso-generator/chroot-off.sh "$1"
