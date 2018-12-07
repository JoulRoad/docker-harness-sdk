#!/bin/bash
/details.sh
[ -n "$*" ] && exec "$@" || exec /usr/bin/scala
