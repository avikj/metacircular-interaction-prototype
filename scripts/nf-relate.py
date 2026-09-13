"""Mathematical relation graph over the normal-form quotient.

Input: NF rows  'NF<TAB>key<TAB>name'  where key is the canonical serialised
type normal form (tokens: d<QName> a used definition, c<QName> a constructor,
Pi/l/v/s structure).  A declaration's TYPE references a named object A exactly
when 'd A' (or 'c A') occurs in its key.  That reference is a mathematical
relation between meanings, independent of any file/import structure.

Outputs:
  - collapse: declarations -> distinct propositions
  - vocabulary: the named objects most types are built from (true foundations)
  - internal spine: same, restricted to corpus-internal (non Agda./Cubical.) names
"""
import re, sys
from collections import Counter, defaultdict
from pathlib import Path

rows_path = sys.argv[1] if len(sys.argv) > 1 else "/tmp/nf-full-rows.txt"
tok = re.compile(r"[dc]([A-Za-z0-9_.-￿'-]+)")

classes = defaultdict(list)     # nf key -> [names]
for ln in Path(rows_path).read_text(encoding="utf-8").splitlines():
    c = ln.split("\t", 2)
    if len(c) == 3 and c[0] == "NF":
        classes[c[1]].append(c[2])

ndecl = sum(len(v) for v in classes.values())
nclass = len(classes)

# usage: how many DISTINCT propositions reference each named object in their type
uses = Counter()
for key in classes:
    for name in set(tok.findall(key)):
        uses[name] += 1

def internal(n):
    return not (n.startswith("Agda.") or n.startswith("Cubical.") or
                n.startswith("Agda.Primitive") )

print("declarations              :", ndecl)
print("distinct propositions (nf):", nclass)
print("collapse ratio            : %.2fx" % (ndecl / nclass))
print()
print("== mathematical vocabulary: named objects most propositions are built on ==")
for n, c in uses.most_common(25):
    print("%5d  %s" % (c, n[:74]))
print()
print("== corpus-internal spine (excluding Agda./Cubical. library primitives) ==")
shown = 0
for n, c in uses.most_common():
    if internal(n):
        print("%5d  %s" % (c, n[:74]))
        shown += 1
        if shown >= 25:
            break
