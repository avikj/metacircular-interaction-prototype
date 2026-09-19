#!/bin/sh
set -eu

baseline=${1:?clean Share checkout}
forward=${2:?Bend Share checkout}
out=${3:-integration/bend2_unison/storage/unison-share-server-bend.patch}

diff -ruN --exclude=.stack-work --exclude=.git --exclude='*.orig' \
  "$baseline" "$forward" |
  sed "s#${baseline%/}/#a/#g; s#${forward%/}/#b/#g" > "$out"

test -s "$out"
echo "wrote $out"
