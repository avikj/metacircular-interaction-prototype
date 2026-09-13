#!/usr/bin/env python3
# Build the manipulable structure from library_graph.tsv (name <tab> serialized-type <tab> deps).
# Yields: exact-duplicate statements, dependency in-degree ("what matters"), leaves.
import collections, sys
rows=[]
for line in open(sys.argv[1] if len(sys.argv)>1 else "library_graph.tsv"):
    p=line.rstrip("\n").split("\t")
    if len(p)<3: p=p+[""]*(3-len(p))
    rows.append((p[0],p[1],p[2].split()))
short=lambda q:q.split(".")[-1]; nameset={r[0] for r in rows}
bytype=collections.defaultdict(list)
for q,ty,_ in rows: bytype[ty].append(q)
dups=[v for v in bytype.values() if len(v)>1]
print(f"{len(rows)} decls, {len(bytype)} distinct types, {sum(len(v)-1 for v in dups)} redundant statements")
indeg=collections.Counter()
for q,_,deps in rows:
    for d in deps:
        if d in nameset and d!=q: indeg[d]+=1
print("\nwhat matters (in-degree):")
for q,c in indeg.most_common(15): print(f"  {c:3}  {short(q)}")
print("\nexact-duplicate statements:")
for v in sorted(dups,key=len,reverse=True): print("  = "+", ".join(short(x) for x in v))
