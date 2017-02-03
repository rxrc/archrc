#!/usr/bin/env zsh

set -e
set -u

url='https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz'
tar_file='aura-bin.tar.gz'

function pacin () {
  if ! (pacman -Q $1 >/dev/null); then
    sudo -S pacman -S --noconfirm $1
  fi
}

pacin curl
pacin grep
pacin tar
pacin sed
pacin sudo

build_dir=$(mktemp -d)
cd $build_dir

curl -L -o $tar_file $url
tar -xzf $tar_file
cd aura-bin

string=$(grep "^depends=" PKGBUILD)
array=("${(s/=/)string}")
depends=($=array[2])

for p in $depends; do
  pacin $(echo $p | sed 's/\((\|)\)//' | sed "s/'//g")
done

sudo -S chgrp -R nobody $build_dir
sudo -S chmod -R g+rwX $build_dir
sudo -S -u nobody makepkg

aura_bin=$(ls aura-bin-*.xz)
sudo -S pacman -U --noconfirm $aura_bin

sudo -S rm -rf $build_dir

exit
