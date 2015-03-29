#!/usr/bin/env zsh

set -e

url='https://aur.archlinux.org/packages/au/aura-bin/aura-bin.tar.gz'
tar_file='aura-bin.tar.gz'

function pacin () {
  if ! (pacman -Q $1 >/dev/null); then
    if [[ $(id -u) -ne 0 ]]; then
      sudo pacman -S --noconfirm $1
    else
      pacman -S --noconfirm $1
    fi
  fi
}

command -v aura >/dev/null 2>&1 && \
  echo 'Aura is already installed.' && exit 0

pacin curl
pacin grep
pacin tar
pacin sed

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

makepkg

aura_bin=$(ls aura-bin-*.xz)
if [[ $(id -u) -ne 0 ]]; then
  sudo pacman -U --noconfirm $aura_bin
else
  pacman -U --noconfirm $aura_bin
fi

rm -rf $build_dir

exit 0
