#!/usr/bin/env python3
"""For every RESULT-CHANGED row of compare.sh output, check that the new root
#Pair{T, v} carries exactly the baseline value v (the old root).
usage: typed_point_values.py CMP_TXT BASEDIR NEWDIR"""
import sys
cmp, base, new = sys.argv[1:4]
def split_pair(n):
    body = n[len('#Pair{'):]; d = 0
    for i, c in enumerate(body):
        if c in '{(': d += 1
        elif c in '})': d -= 1
        elif c == ',' and d == 0: return body[:i], body[i+1:]
    return None, None
ok, other = 0, []
for line in open(cmp):
    if not line.startswith('RESULT-CHANGED ') or '/' not in line: continue
    path = line.split()[1]; slug = path.replace('/', '__')
    o = open(f'{base}/{slug}.norm').read().strip(); n = open(f'{new}/{slug}.norm').read().strip()
    ty, rest = split_pair(n) if n.startswith('#Pair{') else (None, None)
    if rest == o + '}': ok += 1
    else: other.append((path, (rest or n)[:160], o[:160]))
print('value-identical', ok, 'other', len(other))
for p, a, b in other: print(p, '\n  new:', a, '\n  old:', b)
