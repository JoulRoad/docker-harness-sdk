#!/bin/bash
/details.sh
[ -n "$*" ] && exec "$@" || exec /bin/bash
