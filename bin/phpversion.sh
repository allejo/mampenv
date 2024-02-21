#!/bin/bash

source "$(dirname "$0")/utilities/helpers.sh"

phpVersionFile=$(_up_search ".phpversion")
if [[ -z "$phpVersionFile" ]]; then
    echo "A .phpversion file must be defined. http://github.com/allejo/mampenv"
    exit 1
else
    phpVersion=$(cat "${phpVersionFile}")
fi

php="/Applications/MAMP/bin/php/php${phpVersion}/bin/php"
if [ ! -e "$php" ]; then
    echo "PHP $version specified in .phpversion was not found ($php). http://github.com/allejo/mampenv"
    exit 1
fi

conf="/Library/Application Support/appsolute/MAMP PRO/conf/php${version}.ini"
