#!/usr/bin/env zsh

set -e
set -u

puts () {
  echo "\n-- [${1:-}] ${2:-}"
}

install_dynocsv () {
  dynocsv_url='https://github.com/zshamrock/dynocsv/releases/download/v1.1.4/dynocsv'
  dynocsv_bin="/usr/local/bin/dynocsv"
  dynocsv_sha256="85f26284eb3ec0dffe089639449eec8ada893b95c6150bfdfd183b9ad00b0e62"

  puts 'Installing' 'dynocsv'

  if ! [[ -e $dynocsv_bin ]]; then
    puts 'Installing' 'dynocsv'
    sudo -S curl -L -o $dynocsv_bin $dynocsv_url
  fi

  echo "${dynocsv_sha256}  ${dynocsv_bin}" | sha256sum --strict --check

  if [[ -e $dynocsv_bin ]]; then
    sudo -S chmod +x $dynocsv_bin
    puts 'Installed' 'dynocsv'
  fi
}

main () {
  echo "\n$ npm install"
  npm install

  echo "\n$ npm start"
  sudo npm start

  echo '\n$ ./units.zsh\n'
  ./units.zsh

  install_dynocsv
}

main
exit
