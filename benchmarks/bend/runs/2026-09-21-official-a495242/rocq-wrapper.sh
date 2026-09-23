#!/bin/sh
export OCAMLFIND_CONF=/private/tmp/bend-bench-20260921/rocq-findlib.conf
export OCAMLPATH=/private/tmp/bend-bench-20260921/Rocq-Platform-release-2026.07.0-version-9.1-2026.07-MacOS-arm64/Rocq-Platform-9.1-2026.07.app/Contents/Resources/lib
export ROCQLIB=/private/tmp/bend-bench-20260921/Rocq-Platform-release-2026.07.0-version-9.1-2026.07-MacOS-arm64/Rocq-Platform-9.1-2026.07.app/Contents/Resources/lib/coq
export COQLIB="$ROCQLIB"
export CAML_LD_LIBRARY_PATH=/private/tmp/bend-bench-20260921/Rocq-Platform-release-2026.07.0-version-9.1-2026.07-MacOS-arm64/Rocq-Platform-9.1-2026.07.app/Contents/Resources/lib/stublibs
exec /private/tmp/bend-bench-20260921/Rocq-Platform-release-2026.07.0-version-9.1-2026.07-MacOS-arm64/Rocq-Platform-9.1-2026.07.app/Contents/Resources/bin/rocq "$@"
