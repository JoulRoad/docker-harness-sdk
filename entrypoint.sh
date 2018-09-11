#!/bin/bash

# bold filter
bold() {
  echo -ne "\e[1m"
  cat
  echo -ne "\e[0m"
}

## SDK_VERBOSE output
#
if [ "$SDK_VERBOSE" = "yes" ]; then
  echo -n "=> " && mvn --version # maven makes the first line bold
  echo -n "=> " && scalac -version | bold
  echo -n "=> " && python --version | bold

  if [ -n "$VW_GITREV" ]; then
    echo -n "=> " && echo "Vowpal Wabbit version: ${VW_GITREV}" | bold
    echo "Shared library path: `find /lib /usr/lib -name libvw_jni.so`"
  fi
fi

# execute command if given or start scala CLI
[ -n "$*" ] && exec "$@" || exec /usr/bin/scala
