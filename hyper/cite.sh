#!/usr/bin/env bash
# cite.sh — every identifier MAP.md names must be on the line it cites.
# A citation is `path:LINE` `ident`, or `:LINE` `ident` continuing the last path. Exit 1 on any miss.
set -u; cd "$(dirname "$0")/.."
python3 - <<'EOF'
import re, sys, os
s = open('hyper/MAP.md', encoding='utf-8').read()
bad = 0; n = 0; path = None
for m in re.finditer(r"`([^`\n]*):(\d+)`\s*`([^`\n]+)`", s):
    p, line, ident = m.group(1), int(m.group(2)), m.group(3)
    if p: path = p
    n += 1
    if path is None or not os.path.exists(path):
        print(f"MISSING FILE {path} for {ident}"); bad += 1; continue
    lines = open(path, encoding='utf-8').read().split('\n')
    if line > len(lines) or ident not in lines[line-1]:
        print(f"NOT AT {path}:{line}: {ident}"); bad += 1
for m in re.finditer(r"`((?:fibre|formal)/[^`\n:]*\.agda)`", s):
    n += 1
    if not os.path.exists(m.group(1)): print(f"MISSING FILE {m.group(1)}"); bad += 1
print(f"citations={n} bad={bad}")
sys.exit(1 if bad else 0)
EOF
