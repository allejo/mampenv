function _up_search() {
  slashes=${PWD//[^\/]/}
  directory="$PWD"

  for (( n=${#slashes}; n > 0; --n )); do
    test -e "${directory}"/"$1" && echo "$directory"/"$1" && return
    directory="$directory"/..
  done
}

function _split_string() {
  IFS="$2" read -r -a parts <<< "$1"
  echo "${parts[@]}"
}

function _find_closest_version() {
  local input_version=$1
  shift
  local versions=("$@")
  local highest_version=""

  input_version_components=$(_split_string "$input_version" ".")

  for version in "${versions[@]}"; do
    version_components=$(_split_string "$version" ".")

    # Check if the input version has minor and patch versions
    if [[ "${#input_version_components[@]}" -eq 1 ]]; then
      # If input version has only major version, consider any version with the same major version
      if [[ "${version_components[0]}" == "${input_version_components[0]}" && ( -z "$highest_version" || "$version" > "$highest_version" ) ]]; then
        highest_version="$version"
      fi
    else
      # Compare each component
      if (( ${version_components[0]} > ${input_version_components[0]} ||
          (${version_components[0]} == ${input_version_components[0]} && ${version_components[1]} > ${input_version_components[1]}) ||
          (${version_components[0]} == ${input_version_components[0]} && ${version_components[1]} == ${input_version_components[1]} && ${version_components[2]} > ${input_version_components[2]}))); then
        highest_version="$version"
      fi
    fi
  done

  echo "$highest_version"
}

function get_php_versions() {
  versions=()

  for file in /Applications/MAMP/bin/php/php*; do
    if [ -d "$file" ]; then
      name=$(basename "$file")
      versions+=("${name/php/}")
    fi
  done

  echo ${versions[@]}
}

function get_configured_php_version() {
  value=$(_up_search ".phpversion")

  if [[ -z "$value" ]]; then
    echo ""
    exit 1
  fi

  echo $(cat "$value")
}