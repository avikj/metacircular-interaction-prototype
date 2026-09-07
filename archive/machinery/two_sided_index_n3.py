"""The two-sided index at n=3: local formula, verified exactly.

DERIVED (filtration argument, note to follow — the computation below
verifies instances of the derived formula, it is not the source of it):
for K(a) = {H in SL3(Z_p) : p^{a_ij} | H_ij, i != j} with a_ij =
max(0, e_i - e_j) the valuation pattern of a diagonal d,

    [SL3(Z_p) : K(a)] = [SL3(F_p) : P(supp a)] * p^{sum max(0, a_ij-1)}

where P(supp a) is the zero-pattern subgroup of SL3(F_p) (a subgroup
because a satisfies the triangle inequality).  Consequences:

- n=2 collapse: [SL2 : K] = psi(p^{a12+a21}) — only the SUM matters.
- n=3: the mod-p factor depends on the SHAPE of the support (Borel:
  (p+1)(p^2+p+1); line or plane stabilizer: p^2+p+1; one-entry
  patterns: p^2+p+1? no — computed below), so the index is NOT a
  function of any single product; the labeled pairwise levels
  l_ij = p^{a_ij + a_ji} determine it, and the delta-defect selects
  chain (s13 = s12+s23) versus antichain (s13 = |s12-s23|) shapes.

Worked global example, the corpus's delta witness diag(6,10,15):
local shapes are line stabilizers at p = 2, 3, 5, so
index = 7 * 13 * 31 = 2821.

Verification: exact exhaustive counts in SL3(Z/p^k) for a battery of
patterns at (p,k) in {(2,1),(2,2),(3,1)} — certified finite
computation, per the research protocol.
"""

from itertools import product


def count_sl3_pattern(p, k, a):
    """|{H in SL3(Z/p^k) : p^{a_ij} | H_ij}| by exhaustive count."""
    N = p ** k
    n = 3
    cnt = 0
    ranges = []
    for i in range(n):
        for j in range(n):
            step = p ** a[i][j] if i != j else 1
            ranges.append(range(0, N, step))
    for entries in product(*ranges):
        m = [entries[0:3], entries[3:6], entries[6:9]]
        det = (m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1])
               - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0])
               + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]))
        if det % N == 1:
            cnt += 1
    return cnt


def sl3_size(p, k):
    """|SL3(Z/p^k)| = p^{8(k-1)} |SL3(F_p)|."""
    fp = p ** 3 * (p ** 3 - 1) * (p ** 2 - 1)  # |SL3(F_p)|
    return p ** (8 * (k - 1)) * fp


def pattern_subgroup_size(p, a):
    """|P(supp a)| in SL3(F_p): matrices with H_ij = 0 where a_ij>0."""
    return count_sl3_pattern(p, 1, a)


def predicted_index(p, k, a):
    """The derived formula (k large enough that p^k covers a)."""
    fp = p ** 3 * (p ** 3 - 1) * (p ** 2 - 1)
    zero = [[1 if (i != j and a[i][j] > 0) else 0 for j in range(3)]
            for i in range(3)]
    modp_factor = fp // pattern_subgroup_size(p, zero)
    lift = 1
    for i in range(3):
        for j in range(3):
            if i != j and a[i][j] > 1:
                lift *= p ** (a[i][j] - 1)
    return modp_factor * lift


def pattern_of(e):
    return [[max(0, e[i] - e[j]) if i != j else 0 for j in range(3)]
            for i in range(3)]


BATTERY = [
    # (p, k, valuation vector e) — every shape class at n=3
    (2, 1, (0, 0, 1)),   # plane/line stabilizer shape
    (2, 1, (0, 1, 1)),   # the other one-step shape
    (2, 1, (0, 1, 2)),   # chain: Iwahori
    (2, 2, (0, 0, 1)),
    (2, 2, (0, 1, 1)),
    (2, 2, (0, 1, 2)),   # chain with a=b=1 at k=2
    (2, 2, (0, 0, 2)),   # depth-2 single condition: lift factor p
    (2, 2, (0, 2, 2)),
    (3, 1, (0, 0, 1)),
    (3, 1, (0, 1, 2)),
]


def verify():
    results = []
    for p, k, e in BATTERY:
        a = pattern_of(e)
        if k < max(max(row) for row in a):
            continue  # modulus cannot express the pattern: not a test
        idx = sl3_size(p, k) // count_sl3_pattern(p, k, a)
        pred = predicted_index(p, k, a)
        results.append((p, k, e, idx, pred, idx == pred))
    return results


def delta_witness_global_index():
    """diag(6,10,15): product of line-stabilizer indices at 2,3,5."""
    total = 1
    for p in (2, 3, 5):
        e = tuple(_valuation(d, p) for d in (6, 10, 15))
        a = pattern_of(e)
        total *= sl3_size(p, 1) // count_sl3_pattern(p, 1, a)
    return total


def _valuation(d, p):
    v = 0
    while d % p == 0:
        d //= p
        v += 1
    return v


if __name__ == "__main__":
    ok = True
    for p, k, e, idx, pred, match in verify():
        print(f"p={p} k={k} e={e}: counted={idx} derived={pred} "
              f"{'MATCH' if match else 'MISMATCH'}")
        ok = ok and match
    g = delta_witness_global_index()
    print(f"diag(6,10,15) global two-sided index = {g} "
          f"({'MATCH' if g == 2821 else 'MISMATCH'} vs 7*13*31)")
    raise SystemExit(0 if ok and g == 2821 else 1)
