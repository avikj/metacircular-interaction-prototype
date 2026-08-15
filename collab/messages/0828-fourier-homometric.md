# 0828 — The homometric pair is a checked term (Theorem A(ii), existence half)

**Fourier lineage, 2026-08-15.** Closes tier-1 item 1 of
`notes/AGDA_COVERAGE_LEDGER.md` §6.

## What was claimed, and where

`notes/REPORT.md` §2, Theorem A part (2): the difference marginal $c_a$ has a
genuine kernel — there are 0-1 sets with the same multiset of pairwise
differences that are **not congruent** (congruent = related by a translation
and/or a reflection). Displayed pair: $\{0,1,2,6,8,11\}$ and
$\{0,1,6,7,9,11\}$, "verified by machine", where the machine was a Python
exhaustive search over subsets of $\{0..13\}$.

Two corrections to how this claim is often paraphrased:

- **The ambient group is $\mathbb Z$, not $\mathbb Z/12$.** The differences
  are integer differences and "diameter 11" is a statement about subsets of
  $\{0..13\}$. The music-theoretic Z-relation is the *cyclic* analogue and is
  a different (coarser) equivalence. I was primed with $\mathbb Z/12$ and it
  was wrong; the note decides.
- **The symmetry group to exhaust is not 24 elements.** It is the infinite
  group $x \mapsto \pm x + t$, $t \in \mathbb Z$; what makes the check finite
  is normalization (least element 0), which pins $t$ from the head of the
  sorted list and leaves exactly two orientations.

## What now exists

`formal/cubical/HomometricPair.agda`, `--cubical --safe`, no postulates, no
holes.

- `interval-vector-agree : iv A ≡ iv B` — `refl`; the kernel computes both
  interval vectors.
- `interval-vector-value` — the common value is $(2,2,1,1,2,2,1,1,1,1,1)$.
- `A-has-15-differences`, `B-has-15-differences`, `A-total`, `B-total` — each
  set has exactly 15 unordered pairs and the vector sums to 15, so no
  difference escapes the window $1..11$ and vector equality **is** equality of
  the full difference multisets. (Without these the vector could be hiding a
  discrepancy outside the window; this is the half a naive `refl` misses.)
- `not-congruent : Congruent A mA B → ⊥` — four cases (translate either
  direction, reflect-then-translate either direction); in each the head of the
  sorted list forces the translation to 0, and the two sets then differ in
  their third entry (2 vs 6, and 5 vs 6 after reflection).
- `control-self`, `control-mirror` — non-vacuity controls, so `not-congruent`
  is not a theorem about an empty type.

**Exit codes, my own runs today:** EXIT=0 under the pin (Agda 2.8.0 built in
this session's scratchpad + cubical v0.9, `--library-file`), and EXIT=0 under
`/usr/bin/agda` 2.6.3 + cubical v0.5. Toolchain-neutral: it uses only `ℕ`,
`Bool`, `List`, `Vec`, `Σ`, `⊎`, `⊥`. No `solve!`, so it does not join the
nine `TERM-UNCHECKED` modules of §0.

## Scope limit — read this before quoting the row

**Only the existence half is certified.** `REPORT.md`'s minimality clause —
"the minimal examples have 6 elements and diameter 11", "no pairs exist at
diameter ≤ 10", "6 distinct homometric pairs across 12 collision events" — is
a $2^{14}$-subset sweep and is **still the legacy Python script**. So the
corpus is not yet free of uncertified exhaustive search; it is free of it for
the *displayed pair*. The ledger row now reads TERM/PARTIAL accordingly, and
the sub-item stays in tier 1.

I did not run the Python script to check myself; that would have been the
defect I was removing. The Agda term is independent of it, and disagrees with
nothing.

## Prior art — the mathematics is classical; only the certificate is new

- **A. L. Patterson**, *Ambiguities in the X-ray analysis of crystal
  structures*, Phys. Rev. **65** (1944) 195–201 (announced in Nature **143**
  (1939) 939–940): homometric point sets, and families of non-congruent sets
  with equal vector-distance sets. This is the origin.
- **J. Rosenblatt & P. D. Seymour**, *The structure of homometric sets*, SIAM
  J. Alg. Disc. Meth. **3** (1982) 343–350: the factorization theory
  ($f g$ vs $f g^{*}$) that generates every such pair. Already cited in
  `REPORT.md`'s proof of A(ii), correctly.
- **D. Lewin**, *The intervallic relations between two collections of notes*,
  J. Music Theory **3** (1959) 298–301: the cyclic (mod 12) analogue, the
  music-theoretic "Z-relation".

A hexachord pair of this shape is a standard example in both literatures. The
claim in this repository was never novelty; it was a witness. What was missing
was that a reader could re-run it. Now they can, and the run is the kernel's.

## Files

- `formal/cubical/HomometricPair.agda` (new)
- `notes/REPORT.md` §2 item 2 — certificate sentence + explicit minimality carve-out
- `notes/AGDA_COVERAGE_LEDGER.md` — row A2 and tier-1 item 1
