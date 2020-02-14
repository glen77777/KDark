set -e -u
pacman-key --init
pacman-key --populate
pacman-key --update
fdisk -l
read -p "drive to install to? " drive
echo 'type=83' | sudo sfdisk $drive
mkfs.ext4 $drive1
mount $drive1 /mnt
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
rsync -E /home/kdark/installpostchroot.sh /mnt/installpostchroot.sh
rsync -E /home/kdark/start_conky_maia /mnt/usr/bin/start_conky_maia
mkdir /mnt/usr/share/conky
rsync -E /home/kdark/conky_maia /mnt/usr/share/conky/conky_maia
mkdir /mnt/kdark
rsync -arv /home/kdark/ /mnt/kdark 
rsync /home/kdark/pacman.conf /mnt/etc/pacman.conf
echo -e '\nServer = https://arch.mirror.constant.com/$repo/os/$arch\nServer = https://mirror.dc02.hackingand.coffee/arch/$repo/os/$arch\nServer = https://mirrors.kernel.org/archlinux/$repo/os/$arch' > /mnt/etc/pacman.d/mirrorlist
cp /home/kdark/packages.x86_64 /mnt/packages.x86_64
arch-chroot /mnt ./installpostchroot.sh
