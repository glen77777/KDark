set -e -u
echo -e "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc --utc
echo KDark > /etc/hostname
echo KDark > /etc/hosts
pacman -Syuu
pacman -S --noconfirm - < packages.x86_64
echo 8.8.8.8 /etc/resolv.conf
echo 8.8.4.4 /etc/resolv.conf
read -p "drive to install bootloader to?(same in most cases) " $bootloader
grub-install $bootloader
grub-mkconfig -o /boot/grub/grub.cfg
usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root
systemctl set-default graphical.target
systemctl enable NetworkManager
systemctl enable wpa_supplicant
systemctl enable sddm
systemctl enable ufw
echo -e "\n%wheel ALL=(ALL) ALL\nroot ALL=(ALL) ALL" > /etc/sudoers
useradd -G wheel,network,audio,video -m kdark
read -p "root password? " $rootpass
read -p "user password? " $userpass
echo root:$rootpass | chpasswd
echo kdark:$userpass | chpasswd
rsync -arv /kdark /home
pacman-key --init
pacman-key --populate
pacman-key --update
rm -rf /packages.x86_64
rm -rf /kdark
rm -rf /home/kdark/conky_maia
rm -rf /home/kdark/InstallKDark.sh
rm -rf /home/kdark/installpostchroot.sh
rm -rf /home/kdark/packages.x86_64
rm -rf /home/kdark/pacman.conf
rm -rf /home/kdark/start_conky_maia
rm -rf /home/kdark/Desktop/"Install KDark"
rm -rf /installpostchroot.sh
echo unmount live disk and restart to finish install

