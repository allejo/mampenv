#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./utilities/helpers.sh
. "$DIR/utilities/helpers.sh"

# This function will look for a `.php-version` OR a `~/.mampenv/version`
# file that contains the PHP version to use. If none is found, it will
# try looking for a `php` executable in the PATH.
version=$(get_configured_php_version)

if [[ -z "$version" || "$version" = "system" ]]; then
  php=$(which -a php | awk 'NR==2')
  conf=$($php -r "print php_ini_loaded_file();")
else
  php="/Applications/MAMP/bin/php/php${version}/bin/php"
  conf="/Library/Application Support/appsolute/MAMP PRO/conf/php${version}.ini"

  if [ ! -e "$php" ]; then
    echo "PHP $version specified in $FILE_NAME was not found ($php). $GH_REPO"
    exit 1
  fi
fi
