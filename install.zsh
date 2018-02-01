#!/usr/bin/env zsh

set -e
set -u

main () {
  echo "\n$ npm install"
  npm install

  echo "\n$ npm start"
  sudo npm start

  echo '\n$ ./units.zsh\n'
  ./units.zsh
}

main
exit
