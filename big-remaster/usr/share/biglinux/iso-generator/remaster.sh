#!/bin/bash

######################
# BigLinux Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015

# remaster.sh arquitetura versao pasta de trabalho
# Exemplo: /usr/share/biglinux/iso-generator/remaster.sh amd64 biglinux "/home/user/remaster"
# Exemplo: /usr/share/biglinux/iso-generator/remaster.sh i386 biglinux "/home/user/remaster"

# Cria as pastas e adiciona os arquivos basicos

cd "/usr/share/biglinux/iso-generator/"

rm -Rf "$3/remaster/chroot"
mkdir -p "$3/remaster/chroot"
cp -Rf "/usr/share/biglinux/iso-generator/image" "$3/image"
mkdir -p "$3/remaster/chroot/var/cache/apt"
mv "$3/cache" "$3/remaster/chroot/var/cache/apt/archives"


#Adiciona configuração para evitar falhas na instalação de pacotes
mkdir -p "$3/remaster/chroot/etc/apt/apt.conf.d/"
cp -f "/usr/share/biglinux/iso-generator/18bigtweaks" "$3/remaster/chroot/etc/apt/apt.conf.d/18bigtweaks"
#cp -f "/usr/share/biglinux/iso-generator/19bigcleanset" "$3/remaster/chroot/etc/apt/apt.conf.d/19bigcleanset"

mkdir -p "$3/remaster/chroot/usr/bin"
cp -f "/usr/share/biglinux/iso-generator/dpkg-clean-set" "$3/remaster/chroot/usr/bin/dpkg-clean-set"



if [ "$2" = "biglinux" ]; then


    echo '193.62.202.27 snapshot.debian.org' >> "$3/remaster/chroot/etc/hosts"
    COUNT=0
    while [  $COUNT = 0 ]; do
        debootstrap --arch=$1 disco "$3/remaster/chroot" http://ubuntu-archive.locaweb.com.br/ubuntu/
        if [ $? -eq 0 ]; then
            COUNT=1;
        fi
    done
    
else

    COUNT=0
    while [  $COUNT = 0 ]; do
        debootstrap --arch=$1 $2 "$3/remaster/chroot"
        if [ $? -eq 0 ]; then
            COUNT=1;
        fi
    done
fi




mkdir -p "$3/image/.disk"

echo "#define DISKNAME  BigLinux
#define TYPE  binary
#define TYPEbinary  1
#define ARCH  $1
#define ARCH$1  1
#define DISKNUM  1
#define DISKNUM1  1
#define TOTALNUM  0
#define TOTALNUM0  1" > "$3/image/README.diskdefines"



# Efetua configuracao inicial
/usr/share/biglinux/iso-generator/chroot-on.sh "$3"

# Adiciona o sources.list indicado
mkdir -p "$3/remaster/chroot/etc/apt/sources.list.d"
cp -f "/usr/share/biglinux/iso-generator/sources.list.$2" "$3/remaster/chroot/etc/apt/sources.list"
cp -f "/usr/share/biglinux/iso-generator/install-apps.txt.$2" "$3/install-apps.txt"
cp -f "/usr/share/biglinux/iso-generator/install-drivers.txt.$2" "$3/install-drivers.txt"


# Adiciona o sources.list BigLinux
cp -f /usr/share/biglinux/iso-generator/biglinux.list "$3/remaster/chroot/etc/apt/sources.list.d/biglinux.list"


# Adiciona a chave do repositório BigLinux
mkdir -p "$3/remaster/chroot/etc/apt/trusted.gpg.d"

cp -f /usr/share/biglinux/iso-generator/biglinux2016.asc "$3/remaster/chroot/etc/apt/trusted.gpg.d/biglinux2016.asc"

# Adiciona a chave do repositorio Ubuntu, Debian e Deepin e instala o dbus
chroot "$3/remaster/chroot" apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 12345678
chroot "$3/remaster/chroot" apt-get update
chroot "$3/remaster/chroot" apt-get update
chroot "$3/remaster/chroot" apt-get update



    COUNT=0
    while [  $COUNT = 0 ]; do
        chroot "$3/remaster/chroot" apt-get dist-upgrade --yes --allow-unauthenticated
        if [ $? -eq 0 ]; then
            COUNT=1;
        fi
    done


    COUNT=0
    while [  $COUNT = 0 ]; do
        chroot "$3/remaster/chroot" apt-get install --yes --allow-unauthenticated dbus software-properties-common wget debian-archive-keyring synaptic
        if [ $? -eq 0 ]; then
            COUNT=1;
        fi
    done



# Configuracao basica do dbus
chroot "$3/remaster/chroot" dbus-uuidgen | tee $3/chroot/var/lib/dbus/machine-id

# Adiciona suporte a pacotes i386
chroot "$3/remaster/chroot" dpkg --add-architecture i386

# Configura o synaptic
mkdir -p "$3/remaster/chroot/root/.synaptic"
mkdir -p "$3/remaster/chroot/etc/apt/apt.conf.d"
echo 'APT::Install-Recommends "false";' > "$3/remaster/chroot/etc/apt/apt.conf.d/99synaptic"
echo 'Synaptic "" {
  ViewMode "3";
  showWelcomeDialog "0";
  vpanedPos "353";
  hpanedPos "200";
  windowWidth "1920";
  windowHeight "1021";
  windowX "0";
  windowY "0";
  ToolbarState "2";
  Maximized "1";
  Install-Recommends "0";
  closeZvt "false";
  LastSearchType "0";
  update "" {
    last "1505966343";
    type "0";
  };

  ShowAllPkgInfoInMain "false";
  AskRelated "true";
  OneClickOnStatusActions "false";
  delAction "3";
  upgradeType "1";
  undoStackSize "20";
  UseTerminal "false";
  AskQuitOnProceed "false";
  useUserFont "0";
  useUserTerminalFont "0";
  statusColumnPos "0";
  statusColumnVisible "1";
  supportedColumnPos "1";
  supportedColumnVisible "1";
  nameColumnPos "2";
  nameColumnVisible "1";
  sectionColumnPos "3";
  sectionColumnVisible "0";
  componentColumnPos "4";
  componentColumnVisible "0";
  instVerColumnPos "5";
  instVerColumnVisible "1";
  availVerColumnPos "6";
  availVerColumnVisible "1";
  instSizeColumnPos "7";
  instSizeColumnVisible "1";
  downloadSizeColumnPos "8";
  downloadSizeColumnVisible "1";
  descrColumnPos "9";
  descrColumnVisible "1";
  color-install "rgb(138,226,52)";
  color-reinstall "rgb(78,154,6)";
  color-upgrade "rgb(252,233,79)";
  color-downgrade "rgb(173,127,168)";
  color-remove "rgb(239,41,41)";
  color-purge "rgb(164,0,0)";
  color-available "";
  color-available-locked "rgb(164,0,0)";
  color-installed-updated "";
  color-installed-outdated "";
  color-installed-locked "rgb(164,0,0)";
  color-broken "";
  color-new "";
  UseStatusColors "true";
  CleanCache "false";
  AutoCleanCache "true";
  delHistory "30";
  useProxy "0";
  httpProxy "";
  httpProxyPort "3128";
  ftpProxy "";
  ftpProxyPort "3128";
  noProxy "";
};
' > "$3/remaster/chroot/root/.synaptic/synaptic.conf"


# Roda o fix_initctl.sh
cp -f "/usr/share/biglinux/iso-generator/fix_initctl.sh" "$3/remaster/chroot/fix_initctl.sh"
chroot "$3/remaster/chroot" /fix_initctl.sh
rm -f "$3/remaster/chroot/fix_initctl.sh"

	
#if ! [ -e "$3/remaster/chroot/etc/lib/modules" ]
#then
    # Roda o install_kernel.sh
#    cp -f "/usr/share/biglinux/iso-generator/install_kernel.sh" "$3/remaster/chroot/install_kernel.sh"
#    chroot "$3/remaster/chroot" /install_kernel.sh
#    rm -f "$3/remaster/chroot/install_kernel.sh"
#fi



# Roda o chroot-off.sh
/usr/share/biglinux/iso-generator/chroot-off.sh "$3"
