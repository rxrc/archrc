#!/usr/bin/env zsh

set -e

if [[ "$1" == 'update' ]]; then
  cmd='update'
else
  cmd='install'
fi

echo "\n$ bower ${cmd}\n"
bower $cmd

echo "\n$ bundle ${cmd}\n"
bundle $cmd

echo '\n$ curate -v\n'
sudo curate -v

echo '\n$ ./units.zsh\n'
./units.zsh

exit 0
