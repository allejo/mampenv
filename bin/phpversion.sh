#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./utilities/helpers.sh
. "$DIR/utilities/helpers.sh"

versionFile=$(get_version_file)
version=$(get_configured_php_version "$versionFile")

if [[ -z "$version" || "$version" = "system" ]]; then
  php=$(which -a php | awk 'NR==2')
  conf=$($php -r "print php_ini_loaded_file();")
else
  php="/Applications/MAMP/bin/php/php${version}/bin/php"
  conf="/Applications/MAMP/bin/php/php${version}/conf/php.ini"

  if [ ! -e "$php" ]; then
    echo "PHP $version specified in $FILE_NAME was not found ($php). $GH_REPO"
    exit 1
  fi
fi
