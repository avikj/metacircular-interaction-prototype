"""exp57_geodesics.py — the corpus computes its own geodesics.

Builds the citation graph of the merged corpus (every notes/*.md and
papers/*.md is a node; an edge A->B when A's text cites B by filename),
then measures the shape of the knowledge object itself:

  1. degree + betweenness centrality (which documents are load-bearing:
     where audits and formalization effort buy the most trust);
  2. the undirected diameter and its realizing geodesic (the longest
     shortest-path: the two results whose connection is thinnest);
  3. join candidates: pairs of documents at graph distance >= 4 that are
     nonetheless lexically close (shared rare vocabulary) — i.e. pairs the
     corpus treats as unrelated but talks about in the same words. Per
     TENSIONS.md's standing instruction ("treat 'these two things are
     unrelated' as a bookkeeping failure"), these are the highest-value
     next joins.

Companion note: DEPENDENT_ORIGINATION.md. Pure stdlib; deterministic.
"""

import os, re, sys, math, itertools, collections

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
DIRS = ["notes", "papers"]

# ---------------------------------------------------------------- corpus
docs = {}  # name -> text
for d in DIRS:
    for fn in sorted(os.listdir(os.path.join(ROOT, d))):
        if fn.endswith(".md"):
            with open(os.path.join(ROOT, d, fn), encoding="utf-8") as f:
                docs[fn[:-3]] = f.read()

names = sorted(docs)
idx = {n: i for i, n in enumerate(names)}
N = len(names)

# citation edges: A cites B if B's filename stem appears in A's text
pat = {n: re.compile(r"\b" + re.escape(n) + r"(\.md)?\b") for n in names}
adj = collections.defaultdict(set)      # directed A -> B
for a in names:
    for b in names:
        if a != b and pat[b].search(docs[a]):
            adj[a].add(b)
und = collections.defaultdict(set)      # undirected
for a in adj:
    for b in adj[a]:
        und[a].add(b); und[b].add(a)

E = sum(len(v) for v in adj.values())
print(f"corpus: {N} documents, {E} directed citation edges")

# ---------------------------------------------------------------- BFS core
def bfs(src, graph):
    dist = {src: 0}; q = [src]
    for u in q:
        for v in graph[u]:
            if v not in dist:
                dist[v] = dist[u] + 1; q.append(v)
    return dist

# largest connected component (undirected)
seen, comps = set(), []
for n in names:
    if n not in seen and (und[n] or True):
        comp = set(bfs(n, und)); comps.append(comp); seen |= comp
main_comp = max(comps, key=len)
isolated = [n for n in names if n not in main_comp]
print(f"main component: {len(main_comp)} docs; outside it: {len(isolated)}"
      f" ({', '.join(sorted(isolated)[:8])}{'...' if len(isolated) > 8 else ''})")

# ---------------------------------------------------------------- diameter
ecc, far = {}, {}
for n in sorted(main_comp):
    d = bfs(n, und)
    m = max((v, k) for k, v in d.items() if k in main_comp)
    ecc[n], far[n] = m[0], m[1]
diam = max(ecc.values())
a = min([n for n in ecc if ecc[n] == diam])
b = far[a]
# reconstruct one geodesic a..b
d_from_a = bfs(a, und)
path = [b]
while path[-1] != a:
    u = path[-1]
    path.append(min(v for v in und[u] if d_from_a.get(v, 99) == d_from_a[u] - 1))
print(f"\nundirected diameter = {diam}")
print("realizing geodesic: " + " -- ".join(reversed(path)))

# ---------------------------------------------------------------- betweenness (Brandes, unweighted)
bc = dict.fromkeys(main_comp, 0.0)
for s in main_comp:
    S, P, sigma = [], collections.defaultdict(list), collections.defaultdict(int)
    sigma[s] = 1; dist = {s: 0}; q = [s]
    for u in q:
        S.append(u)
        for v in und[u]:
            if v not in dist:
                dist[v] = dist[u] + 1; q.append(v)
            if dist.get(v) == dist[u] + 1:
                sigma[v] += sigma[u]; P[v].append(u)
    delta = collections.defaultdict(float)
    for u in reversed(S):
        for p in P[u]:
            delta[p] += sigma[p] / sigma[u] * (1 + delta[u])
        if u != s:
            bc[u] += delta[u]
top = sorted(bc.items(), key=lambda kv: -kv[1])[:12]
print("\nload-bearing documents (betweenness):")
for n, v in top:
    print(f"  {v/((len(main_comp)-1)*(len(main_comp)-2)):.4f}  {n}  "
          f"(in {sum(1 for x in adj if n in adj[x])}, out {len(adj[n])})")

# ---------------------------------------------------------------- join candidates
STOP = set("""the a an of and or to in is are was were be been for with on at by from
as that this these those it its if then than so not no we our their between over
under all any each which what where when how into out up down more most can may
""".split())
def vocab(t):
    words = re.findall(r"[a-zA-Z_]{6,}", t.lower())
    return {w for w, c in collections.Counter(words).items() if c >= 3} - STOP
V = {n: vocab(docs[n]) for n in main_comp}
df = collections.Counter(w for n in main_comp for w in V[n])
rare = {w for w, c in df.items() if c <= max(3, N // 12)}  # rare across corpus

cand = []
for x, y in itertools.combinations(sorted(main_comp), 2):
    dxy = bfs(x, und).get(y, 99)
    if dxy >= 4:
        shared = V[x] & V[y] & rare
        if len(shared) >= 3:
            cand.append((len(shared), dxy, x, y, sorted(shared)[:6]))
cand.sort(key=lambda t: (-t[0], -t[1]))
print(f"\njoin candidates (graph distance >= 4, >= 3 shared rare terms): {len(cand)}")
for k, dxy, x, y, sh in cand[:10]:
    print(f"  d={dxy}  shared={k:2d}  {x} × {y}   [{', '.join(sh)}]")

print("\nexp57: done. The geodesic structure above is the joins queue.")
