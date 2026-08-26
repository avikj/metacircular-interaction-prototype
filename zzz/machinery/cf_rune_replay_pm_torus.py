"""cf-rune independent replay of machinery/pm_torus.py (cross-review).

Confirms the mathematical claims of `pm_torus.py` / the PM torus addendum
in notes/PM_SECTION_VS_COCYCLE.md, and REPAIRS its embedding certificate:
the original script hardcodes three face walks and checks only that every
edge appears twice + Euler count. That is not by itself an embedding
certificate — gluing polygons along edges can identify vertices into
fewer than 6 classes, changing chi. The honest certificate is a rotation
system with algorithmic face tracing, done here.

Checks:
  1. incidence graph of the 9 observables / 6 contexts is K_{3,3}
     (built from the note's actual X/Z square, not pm_torus.py's Y-square
     relabeling — the graph is the same, the label mismatch is flagged);
  2. nonplanarity via the bipartite Euler bound 9 > 2*6-4 (girth-4 bound,
     valid for simple bipartite graphs);
  3. EXHAUSTIVE rotation-system search: all 2^6 = 64 orientable rotation
     systems of K_{3,3} are face-traced by the standard dart algorithm;
     the face-count spectrum is reported, and at least one system yields
     exactly 3 faces, all hexagons, hence chi = 6-9+3 = 0: an honest
     genus-1 orientable embedding. With (2), genus 1 is minimal;
  4. the specific face walks hardcoded in pm_torus.py ARE realized by one
     of these rotation systems (so its shortcut happens to be sound);
  5. cycle space dim = 4, vertex-incidence coker dim = 1 (connectedness).

All finite and exact. Run: python3 <this file>.
"""

import itertools

ROWS = ["r0", "r1", "r2"]
COLS = ["c0", "c1", "c2"]

# the note's square (X/Z form); only incidence matters below
GRID = [["XI", "IX", "XX"], ["IZ", "ZI", "ZZ"], ["XZ", "ZX", "YY"]]
EDGES = [("r%d" % i, "c%d" % j) for i in range(3) for j in range(3)]

# ---------- 1. K_{3,3} ----------
assert len(set(EDGES)) == 9 and set(EDGES) == {(r, c) for r in ROWS for c in COLS}
obs = [GRID[i][j] for i in range(3) for j in range(3)]
assert len(set(obs)) == 9  # nine distinct observables, one per edge
print("1. incidence graph is K_{3,3} (from the X/Z square): OK")

# ---------- 2. nonplanarity ----------
V, E = 6, 9
assert E > 2 * V - 4
print("2. bipartite planar bound violated (9 > 8), nonplanar: OK")

# ---------- 3. exhaustive rotation systems + face tracing ----------
NBRS = {r: list(COLS) for r in ROWS}
NBRS.update({c: list(ROWS) for c in COLS})

def cyclic_orders(lst):
    a, b, c = lst
    return [(a, b, c), (a, c, b)]

def trace_faces(rot):
    """rot: vertex -> cyclic tuple of neighbors. Trace faces of the
    orientable embedding: dart (u,v); next dart is (v, successor of u in
    rot[v])."""
    darts = {(u, v) for u, v in EDGES} | {(v, u) for u, v in EDGES}
    nxt = {}
    for v, order in rot.items():
        for i, u in enumerate(order):
            nxt[(u, v)] = (v, order[(i + 1) % 3])
    faces = []
    seen = set()
    for d in sorted(darts):
        if d in seen:
            continue
        walk, cur = [], d
        while cur not in seen:
            seen.add(cur)
            walk.append(cur)
            cur = nxt[cur]
        faces.append(walk)
    return faces

spectrum = {}
genus1 = []
for choice in itertools.product(range(2), repeat=6):
    rot = {v: cyclic_orders(NBRS[v])[k]
           for v, k in zip(ROWS + COLS, choice)}
    faces = trace_faces(rot)
    f = len(faces)
    spectrum[f] = spectrum.get(f, 0) + 1
    if f == 3 and all(len(w) == 6 for w in faces):
        genus1.append((rot, faces))

print("3. face-count spectrum over all 64 rotation systems:", spectrum)
assert genus1, "no 3-hexagon (genus-1) rotation system found"
# chi = V - E + F with vertices counted honestly by the trace
assert all(6 - 9 + len(fs) == 0 for _, fs in genus1)
print("   %d rotation systems give 3 hexagonal faces, chi = 0:"
      " honest toroidal embeddings exist; with (2), genus 1 minimal: OK"
      % len(genus1))

# ---------- 4. pm_torus.py's hardcoded walks are realized ----------
def face_key(walk_vertices):
    """Canonical form of a closed vertex walk up to rotation/reflection."""
    n = len(walk_vertices)
    cands = []
    for s in range(n):
        rot_w = tuple(walk_vertices[(s + i) % n] for i in range(n))
        cands.append(rot_w)
        cands.append(tuple(reversed(rot_w)))
    return min(cands)

hard = [["r0", COLS[t % 3], "r1", COLS[(t + 1) % 3], "r2", COLS[(t + 2) % 3]]
        for t in range(3)]
hard_keys = {face_key(w) for w in hard}
found = any({face_key([u for u, _ in fs_walk]) for fs_walk in fs} == hard_keys
            for _, fs in genus1)
assert found, "hardcoded 3-hexagon walks not realized by any rotation system"
print("4. pm_torus.py's hardcoded face walks are realized by an actual"
      " rotation system (its shortcut is sound): OK")

# ---------- 5. cycle space / coker ----------
def f2_rank(rows_):
    m = [r[:] for r in rows_]
    rank = 0
    for col in range(len(m[0])):
        piv = next((i for i in range(rank, len(m)) if m[i][col]), None)
        if piv is None:
            continue
        m[rank], m[piv] = m[piv], m[rank]
        for i in range(len(m)):
            if i != rank and m[i][col]:
                m[i] = [(a + b) % 2 for a, b in zip(m[i], m[rank])]
        rank += 1
    return rank

verts = ROWS + COLS
inc = [[1 if v in e else 0 for v in verts] for e in EDGES]
r = f2_rank(inc)
assert E - r == 4 and len(verts) - r == 1
print("5. cycle space dim 4; vertex coker dim 1 (connected): OK")

print("ALL CHECKS PASSED — pm_torus claims confirmed, certificate repaired")
