"""Two failures of view-gluing are ker and coker of one restriction map.

Executable companion to notes/VIEW_GLUING_TWO_FAILURES.md. Constructs, in
two settings the corpus already owns, the map

    rho : (global states) -> (tuples of local readings)

and computes its kernel (hidden fiber / ambiguity) and cokernel
(unrealizable readings / gluing obstruction) exactly.

  A. CRT views (README "Several views do not automatically make a whole";
     machinery/natural_crystal.py glue-remainders): rho : Z/mn ->
     Z/m x Z/n. Verified for all 2 <= m, n <= 12:
     |ker rho| = |coker rho| = gcd(m,n) — the overlap condition and the
     hidden fiber are the SAME number at the two ends of one exact
     sequence; existence failure and ambiguity are balanced.

  B. Peres-Mermin (notes/PM_SECTION_VS_COCYCLE.md): delta : F2^9 -> F2^6
     restricting a value assignment to its six context parities.
     dim ker = 4, dim coker = 1: 16-fold ambiguity against a 1-bit
     obstruction — the CRT balance is broken, and the actual sign vector
     sits in the nonzero coker class, so gluing fails while ambiguity
     stays maximal on the twisted problem.

  Both satisfy the index law |source| * |coker| = |target| * |ker|.

All exact; pure Python. Run: python3 <this file>.
"""

from math import gcd
import itertools

# ---------- A. CRT restriction map ----------
for m, n in itertools.product(range(2, 13), repeat=2):
    src = m * n
    image = {(x % m, x % n) for x in range(src)}
    ker = sum(1 for x in range(src) if x % m == 0 and x % n == 0)
    coker = (m * n) // len(image)          # target size / image size
    g = gcd(m, n)
    assert ker == g and coker == g, (m, n, ker, coker)
    assert src * coker == (m * n) * ker    # index law
print("A. CRT rho: |ker| = |coker| = gcd(m,n) for all 2<=m,n<=12: OK")
print("   (hidden fiber and unrealizable readings are the same number)")

# ---------- B. PM restriction map over F2 ----------
names = ["XI", "IX", "XX", "IZ", "ZI", "ZZ", "XZ", "ZX", "YY"]
square = [names[0:3], names[3:6], names[6:9]]
contexts = [tuple(r) for r in square] + \
           [tuple(square[i][j] for i in range(3)) for j in range(3)]
s = [0, 0, 0, 0, 0, 1]  # exact matrix signs, replayed in
                        # machinery/cf_rune_replay_pm_section_cocycle.py

image = {tuple(sum(x[names.index(o)] for o in c) % 2 for c in contexts)
         for x in itertools.product((0, 1), repeat=9)}
dim_im = len(image).bit_length() - 1
dim_ker = 9 - dim_im
dim_coker = 6 - dim_im
assert (dim_ker, dim_coker) == (4, 1)
assert 2 ** 9 * 2 ** dim_coker == 2 ** 6 * 2 ** dim_ker  # index law
assert tuple(s) not in image                 # the physical signs obstruct
flip = list(s); flip[5] ^= 1                 # kill the class: 16 sections
assert tuple(flip) in image
count = sum(1 for x in itertools.product((0, 1), repeat=9)
            if all(sum(x[names.index(o)] for o in c) % 2 == v
                   for c, v in zip(contexts, flip)))
assert count == 2 ** dim_ker == 16
print("B. PM delta: dim ker = 4, dim coker = 1, signs outside image,")
print("   twisted problem has exactly 16 sections: OK")
print("   (ambiguity 16 vs obstruction 2 — the CRT balance is broken)")

print("BOTH SETTINGS PASS — two failures, one exact sequence")
