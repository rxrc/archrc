#!/usr/bin/env zsh

set -e

echo '\n$ bower update\n'
bower update

echo '\n$ bundle update\n'
bundle update

echo '\n$ curate -v\n'
sudo curate -v

exit 0
