#!/bin/bash

######################
# BigLinux Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


cd "$1/image/"

sed -i "s|menu title .*|menu title $2|g" isolinux/*.cfg

rm -f "../$2.iso"

#genisoimage -D -r -V "$2" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o "../$2.iso" .

# EFI
rm -f boot/efi.img
dd if=/dev/zero bs=1M count=150 of=boot/efi.img
mkfs.fat -n "EFI" boot/efi.img
mkdir efitmp
mount -o loop boot/efi.img efitmp
mkdir efitmp/boot
cp -Rf boot/grub efitmp/boot/grub
cp -Rf EFI efitmp/EFI
mkdir efitmp/casper
cp -f casper/initrd.lz efitmp/casper/initrd.lz
cp -f casper/vmlinuz efitmp/casper/vmlinuz
cp -f casper/initrd-xanmod.lz efitmp/casper/initrd-xanmod.lz
cp -f casper/vmlinuz-xanmod efitmp/casper/vmlinuz-xanmod
umount efitmp
umount efitmp 2> /dev/null
umount efitmp 2> /dev/null
rm -Rf efitmp


# MD5
find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" | grep -v isolinux.bin | grep -v boot.cat > md5sum.txt


 xorriso -as mkisofs \
  -o "../$2.iso" \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -c isolinux/boot.cat \
  -b isolinux/isolinux.bin \
  -V "$2" \
   -no-emul-boot -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot \
  -e boot/efi.img \
   -no-emul-boot \
   -isohybrid-gpt-basdat \
 .

 
#xorriso -as mkisofs -r -checksum_algorithm_iso md5,sha1,sha256,sha512 -V "$2" -o "../$2.iso" -J -joliet-long -cache-inodes -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -b isolinux/isolinux.bin -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot -e boot/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus .

cd ..







