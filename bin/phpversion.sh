#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/utilities/helpers.sh"

# This function will look for a `.php-version` OR a `~/.mampenv/version`
# file that contains the PHP version to use. If none is found, it will
# try looking for a `php` executable in the PATH.
phpVersion=$(get_configured_php_version)
if [ -z "$phpVersion" ]; then
  phpVersions=($(_split_string "$(which -a php | tr '\n' ' ')" " "))

  if [[ ${#phpVersions[@]} -gt 1 ]]; then
    php="${phpVersions[1]}"
    conf=$($php -r "print php_ini_loaded_file();")
  fi
else
  php="/Applications/MAMP/bin/php/php${phpVersion}/bin/php"
  conf="/Library/Application Support/appsolute/MAMP PRO/conf/php${phpVersion}.ini"

  if [ ! -e "$php" ]; then
    echo "PHP $phpVersion specified in $FILE_NAME was not found ($php). $GH_REPO"
    exit 1
  fi
fi
