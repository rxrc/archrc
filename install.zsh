#!/usr/bin/env zsh

set -e
set -u

echo "\n$ npm install"
npm install

echo "\n$ npm run archrc"
npm run archrc

echo '\n$ ./units.zsh\n'
./units.zsh

exit
