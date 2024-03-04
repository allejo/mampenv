#!/bin/bash

FILE_NAME=".php-version"
GH_REPO="http://github.com/allejo/mampenv"

_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

_up_search() {
  local n
  local slashes=${PWD//[^\/]/}
  local directory="$PWD"

  for (( n=${#slashes}; n > 0; --n )); do
    test -e "${directory}"/"$1" && echo "$directory"/"$1" && return
    local directory="$directory"/..
  done
}

_split_string() {
  IFS="$2" read -r -a parts <<< "$1"

  echo "${parts[@]}"
}

_find_closest_version() {
  local input_version=$1
  shift
  local versions=("$@")
  local highest_version=""
  local input_version_components

  input_version_components=$(_split_string "$input_version" ".")

  for version in "${versions[@]}"; do
    local version_components
    version_components=$(_split_string "$version" ".")

    # Check if the input version has minor and patch versions
    if [[ "${#input_version_components[@]}" -eq 1 ]]; then
      # If input version has only major version, consider any version with the same major version
      if [[ "${version_components[0]}" == "${input_version_components[0]}" && ( -z "$highest_version" || "$version" > "$highest_version" ) ]]; then
        highest_version="$version"
      fi
    else
      # Compare each component
      if ((
        version_components[0] > input_version_components[0] ||
        (version_components[0] == input_version_components[0] && version_components[1] > input_version_components[1]) ||
        (version_components[0] == input_version_components[0] && version_components[1] == input_version_components[1] && version_components[2] > input_version_components[2])
      )); then
        highest_version="$version"
      fi
    fi
  done

  echo "$highest_version"
}

get_php_versions() {
  local file
  local versions=()

  for file in /Applications/MAMP/bin/php/php*; do
    if [ -d "$file" ]; then
      local name

      name=$(basename "$file")
      versions+=("${name/php/}")
    fi
  done

  echo "${versions[@]}"
}

get_version_file() {
  local localVersionSpec
  local globalVersionSpec

  localVersionSpec=$(_up_search $FILE_NAME)

  if [[ -z "$localVersionSpec" ]]; then
     globalVersionSpec=$(realpath -q "$_DIR/../../version")

    if [[ -f "$globalVersionSpec" ]]; then
      echo "$globalVersionSpec"
    fi
  else
    echo "$localVersionSpec"
  fi
}

get_configured_php_version() {
  local versionSpec

  if [ -n "$1" ]; then
    versionSpec=$1
  else
    versionSpec=$(get_version_file)
  fi

  if [ -n "$versionSpec" ]; then
    cat "$versionSpec"
  else
    echo "system"
  fi
}
