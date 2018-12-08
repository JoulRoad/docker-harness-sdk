# bold filter
bold() {
  echo -ne "\e[1m"
  cat
  echo -ne "\e[0m"
}

## SDK_VERBOSE output
#
if ( echo "yes y true enabled" | grep -sqwi "${SDK_VERBOSE}" ); then
  which mvn && echo -n "=> " && mvn --version # maven makes the first line bold
  which scalac && echo -n "=> " && scalac -version | bold
  which python && echo -n "=> " && python --version | bold
fi
