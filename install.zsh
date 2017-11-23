#!/usr/bin/env zsh

set -e
set -u

cmd="${1:=install}"

if [[ "$cmd" == 'update' ]]; then
  cmd='update'
else
  cmd='install'
fi

echo "\n $ npm install"
npm install

echo "\n$ bundle ${cmd}\n"
$(rbenv which bundle) $cmd

echo '\n$ curate -v\n'
sudo -S $(rbenv which bundle) exec curate -v

echo '\n$ ./units.zsh\n'
./units.zsh

exit
