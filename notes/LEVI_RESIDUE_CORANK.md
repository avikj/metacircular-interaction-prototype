# Residue blocks and the combinatorial Levi corank

## Outcome

[`LeviResidueCorank.lean`](../formal/pairfield/Pairfield/LeviResidueCorank.lean)
checks the finite counting core of
[`SINGULAR_SERIES_LOCAL_FACTOR_IS_A_ROOT_SUBSYSTEM_RANK.md`](SINGULAR_SERIES_LOCAL_FACTOR_IS_A_ROOT_SUBSYSTEM_RANK.md)
§2(ii) and its local rank-inequality reformulation.

For any map between finite types \(h:I\to R\), let

\[
\nu(h)=|h(I)|,
\qquad
m_r=|h^{-1}(r)|,
\qquad
\operatorname{leviRank}(h)=\sum_{r\in h(I)}(m_r-1).
\]

Lean proves

\[
|I|=\nu(h)+\operatorname{leviRank}(h)
\]

and hence

\[
\nu(h)=|I|-\operatorname{leviRank}(h).
\]

For \(h:\operatorname{Fin}(k)\to\operatorname{Fin}(p)\) with \(p\le k\), it
also proves

\[
\nu(h)<p
\quad\Longleftrightarrow\quad
k-p<\operatorname{leviRank}(h).
\]

The left side says that the tuple does not cover every residue at the local
alphabet of size \(p\).  Thus the source note's strict local rank inequality
is exact finite partition arithmetic.  Primality is not needed for this local
equivalence; primes enter only when these local conditions are assembled into
the arithmetic singular series.

## Exact checked surface

```lean
def residueImage (h : index → residue) : Finset residue :=
  Finset.univ.image h

def residueCount (h : index → residue) : ℕ :=
  (residueImage h).card

def fiberCard (h : index → residue) (r : residue) : ℕ :=
  (Finset.univ.filter fun i ↦ h i = r).card

def leviRank (h : index → residue) : ℕ :=
  ∑ r ∈ residueImage h, (fiberCard h r - 1)

theorem card_eq_residueCount_add_leviRank (h : index → residue) :
  Fintype.card index = residueCount h + leviRank h

theorem residueCount_eq_card_sub_leviRank (h : index → residue) :
  residueCount h = Fintype.card index - leviRank h

theorem locallyAdmissible_iff_rank_gt {k p : ℕ} (h : Fin k → Fin p)
    (hpk : p ≤ k) :
  LocallyAdmissible h ↔ k - p < leviRank h
```

The proof uses finite fibrewise cardinality, positivity of every represented
fibre, exact distribution of subtraction over the finite sum, and certified
Presburger arithmetic.  The `Nat` subtractions are not silently treated as
integers: positivity of represented fibres justifies each \(m_r-1\), while
`residueCount_le_domain` justifies the global subtraction.

## The root-system boundary

The name `leviRank` is deliberately qualified in the module header: it is the
**combinatorial block rank** \(\sum(m_r-1)\).  For a residue partition with
block sizes \(m_r\), the standard root-system identification says the
vanishing subsystem is \(\prod_r A_{m_r-1}\), whose rank is this sum.  The Lean
leaf does **not**:

- define the roots \(e_i-e_j\);
- form their span over \(\mathbb Q\);
- prove that the span has finrank \(m_r-1\) on each block;
- package a Levi subsystem or a Young subgroup.

Consequently this is not advertised as a formalization of the source note's
full Theorem (i)--(iv).  It certifies the exact numerical calculation that the
linear-algebra bridge must consume.  This separation also respects the
source's amendment: the root lattice \(Q\) and weight lattice \(P\) differ by
finite index, while the block-rank calculation here does not choose either
lattice.

## Random provenance

This arose from the eleventh literal no-redraw semantic-corpus encounter:

- frozen `origin/main` commit:
  `35dd5355d29ba03357edd62dc8a9e97497fcd008`;
- frozen tree: `3f779acc4d4ea1a1246af892f52d4fb806cc217c`;
- frame: 1027 tracked `.agda`, `.lean`, and `.md` paths under `formal/`,
  `notes/`, and `papers/`, C-sorted, build paths and ten earlier samples
  excluded;
- frame SHA-256:
  `51d3829062b6745554844a68b03000aa875cd098bdd866f724c85649ad9dd705`;
- unbiased rule: accept a native uint32 below `4294966377` (tail 919);
- sole raw word: `3907728717`, accepted at index0 906 (position 907);
- sample: `notes/SINGULAR_SERIES_LOCAL_FACTOR_IS_A_ROOT_SUBSYSTEM_RANK.md`,
  blob `2398f37fee168ac6b83dbdcb9170bf1758771328`, 8075 bytes, provenance commit
  `3850d70853f5a04f69eee98b3af7a34ebab2236c`.

Duplicate search found the source prose theorem and the separate checked
`NaturalMachine.RootWeightIndex` correction, but no formal block-corank
identity.  The source already makes no novelty claim, and neither does this
kernel.

## Scope fence and verification

This result does not define the rational local factor \(\sigma_p\), prove
Euler-product convergence, assemble the condition over primes, construct an
arithmetic tuple, or improve any prime-tuple theorem.  It does not run or rely
on the source's Rust census.  The global admissibility and root-span statements
remain at the source note's evidence grades.

Both

```text
lake env lean Pairfield/LeviResidueCorank.lean
lake build Pairfield.LeviResidueCorank
```

exit 0 under Lean 4.33.0 / mathlib v4.33.0, with no `sorry` or warnings.  The
shared `Pairfield.lean` aggregate was concurrently owned and is intentionally
untouched; integration is deferred to its owner/root.
