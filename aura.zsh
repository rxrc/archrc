#!/usr/bin/env zsh

set -e
set -u

main () {
  url='https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz'
  tar_file='aura-bin.tar.gz'

  sudo -S pacman -S --noconfirm curl grep sed sudo tar

  sudo cp /etc/makepkg.conf /etc/makepkg.conf.bak
  sudo cp etc/makepkg.conf /etc/makepkg.conf

  build_dir=$(mktemp -d)
  cd $build_dir

  curl -L -o $tar_file $url
  tar -xzf $tar_file
  cd aura-bin

  depends=$(grep "^depends=" PKGBUILD)
  depends=("${(s/=/)depends}")
  depends=($=depends[2])
  depends=$(echo $depends | tr '(' ' ' | tr ')' ' ' | sed "s/'//g")

  sudo -S pacman -S --noconfirm $(echo $depends)

  sudo -S chgrp -R nobody $build_dir
  sudo -S chmod -R g+rwX $build_dir
  sudo -S -u nobody makepkg

  aura_bin=$(ls aura-bin-*.tar.zst)
  sudo -S pacman -U --noconfirm $aura_bin

  sudo -S rm -rf $build_dir
  sudo cp /etc/makepkg.conf.bak /etc/makepkg.conf
}

main
exit
