#!/usr/bin/env zsh

set -e
set -u

url='https://aur.archlinux.org/packages/au/aura-bin/aura-bin.tar.gz'
tar_file='aura-bin.tar.gz'

function pacin () {
  if ! (pacman -Q $1 >/dev/null); then
    sudo pacman -S --noconfirm $1
  fi
}

command -v aura >/dev/null 2>&1 && \
  echo 'Aura is already installed.' && exit 0

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

sudo chgrp -R nobody $build_dir
sudo chmod -R g+rwX $build_dir
sudo -u nobody makepkg

aura_bin=$(ls aura-bin-*.xz)
sudo pacman -U --noconfirm $aura_bin

sudo rm -rf $build_dir

exit
