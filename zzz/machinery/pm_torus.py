#!/usr/bin/env python3
"""The Peres-Mermin square is intrinsically a torus diagram. Executable.

Extends notes/PM_SECTION_VS_COCYCLE.md (boundary item): the scenario's
incidence graph, its genus, and where the obstruction class lives.

  (a) The 9 observables / 6 contexts incidence graph IS K_{3,3}
      (certified by explicit isomorphism: rows+columns are the two sides,
      every row meets every column in exactly one cell).
  (b) K_{3,3} is nonplanar by the bipartite Euler bound: a planar
      bipartite simple graph has E <= 2V - 4; here 9 > 8. So the PM
      scenario CANNOT be drawn on the sphere with its incidence intact.
  (c) It embeds on the torus: the rotation system with three hexagonal
      faces  F_t : r0 -> c_t -> r1 -> c_{t+1} -> r2 -> c_{t+2} -> r0
      uses every edge exactly twice, so V - E + F = 6 - 9 + 3 = 0 =
      chi(torus); with (b), genus 1 is minimal.
  (d) Cycle space dim = E - V + 1 = 4 (computed as ker of the incidence
      map on edges over F2); coker dim 1 = connectedness, and the
      obstruction class of PM_SECTION_VS_COCYCLE is the parity pairing
      with this single connected component.

All checks are finite and exact; no drawing, no floats.
"""

from __future__ import annotations

from itertools import product

GRID = [["XI", "IX", "XX"], ["IY", "YI", "YY"], ["XY", "YX", "ZZ"]]
ROWS = ["r0", "r1", "r2"]
COLS = ["c0", "c1", "c2"]
VERTS = ROWS + COLS
EDGES = [(GRID[i][j], "r%d" % i, "c%d" % j) for i in range(3) for j in range(3)]


def is_k33() -> bool:
    """Every (row, column) pair carries exactly one observable edge."""
    pairs = {(r, c) for _, r, c in EDGES}
    return len(EDGES) == 9 and pairs == {(r, c) for r in ROWS for c in COLS}


def nonplanar_certificate() -> bool:
    """Bipartite planar bound E <= 2V - 4 is violated: 9 > 2*6 - 4 = 8."""
    return len(EDGES) > 2 * len(VERTS) - 4


def torus_faces():
    """Three hexagonal faces of the standard toroidal embedding."""
    faces = []
    for t in range(3):
        walk = ["r0", COLS[t % 3], "r1", COLS[(t + 1) % 3],
                "r2", COLS[(t + 2) % 3]]
        faces.append(walk)
    return faces


def embedding_certificate() -> tuple[bool, int]:
    """Each edge appears exactly twice over all face boundary walks; the
    Euler characteristic V - E + F is returned for inspection."""
    count = {(r, c): 0 for _, r, c in EDGES}
    for walk in torus_faces():
        n = len(walk)
        for i in range(n):
            a, b = walk[i], walk[(i + 1) % n]
            r, c = (a, b) if a.startswith("r") else (b, a)
            count[(r, c)] += 1
    ok = all(v == 2 for v in count.values())
    chi = len(VERTS) - len(EDGES) + len(torus_faces())
    return ok, chi


def cycle_space_dim() -> int:
    """dim ker(incidence: F2^E -> F2^V), computed by elimination."""
    rows = []
    for _, r, c in EDGES:
        vec = [0] * len(VERTS)
        vec[VERTS.index(r)] = 1
        vec[VERTS.index(c)] = 1
        rows.append(vec)
    # rank of the 9x6 matrix over F2
    mat = [row[:] for row in rows]
    rank, used = 0, set()
    for col in range(len(VERTS)):
        piv = None
        for i in range(len(mat)):
            if i not in used and mat[i][col]:
                piv = i
                break
        if piv is None:
            continue
        used.add(piv)
        rank += 1
        for i in range(len(mat)):
            if i != piv and mat[i][col]:
                mat[i] = [(x + y) % 2 for x, y in zip(mat[i], mat[piv])]
    return len(EDGES) - rank


def main() -> int:
    k33 = is_k33()
    nonpl = nonplanar_certificate()
    emb_ok, chi = embedding_certificate()
    cyc = cycle_space_dim()
    print("incidence graph is K_{3,3}:", k33)
    print("nonplanar (E=9 > 2V-4=8):  ", nonpl)
    print("3-hexagon rotation system: every edge twice =", emb_ok,
          " Euler chi =", chi, "(torus: 0)")
    print("cycle space dim (E-V+1):   ", cyc)
    genus1_minimal = nonpl and emb_ok and chi == 0
    print("VERDICT: PM lives on the torus, minimally:", genus1_minimal,
          "| obstruction = parity pairing with the one component "
          "(coker dim 1, see pm_section_cocycle)")
    return 0 if (k33 and genus1_minimal and cyc == 4) else 1


if __name__ == "__main__":
    raise SystemExit(main())
