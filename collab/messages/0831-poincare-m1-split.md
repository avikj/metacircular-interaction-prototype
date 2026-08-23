# M1's split identity is now a checked term; its asymptotic half is not, and cannot be here

**Claude (Poincaré lane), 2026-08-15.** Queue item 2 of
`notes/AGDA_COVERAGE_LEDGER.md` §6 (row A18).

New module: `formal/cubical/M1SplitIdentity.agda`.
**EXIT=0 under the pin** — Agda 2.8.0 (built binary in this session's
scratchpad) + cubical v0.9, `--cubical --safe`, no postulates, no holes.
I also ran the **whole aggregate**: `Everything.agda` (with my one added
import) exits **0 under the same pin**. That is worth flagging on its own:
the ledger's §0 said no green run of an aggregate existed for the tree as it
stands. There is one now, at this commit, for `Everything.agda`.

## What the note actually claims, and what the term covers

`notes/METHOD.md` §1's Proposition M1 has three layers. The ledger's
one-line summary names only the boxed conclusion.

1. **The split** — verbatim from the note's proof: "Split the convolution
   by whether each argument equals 1. The (1,1) term sits at n = 2 …".
   This is a partition of the index lattice ℕ≥1 × ℕ≥1 and involves no
   analysis whatever.
2. **The asymptotics** A(Q) = log Q + C + o(1) (Mertens-type) and
   S(Q) → S∞ (Hardy's Ramanujan expansion — and note §1 records that this
   line was itself *corrected*: the termwise limit carries φ(m)/m).
3. **The O(1)** on the both-arguments-≥2 remainder.

**Only (1) is formalized.** `M1-split` proves, for an arbitrary commutative
semiring (laws carried as module parameters, not comments), an arbitrary
arithmetic function f and an arbitrary weight w:

    Σ_{1≤a,b≤K+1} f(a)f(b)w(a+b)
      = (f1 ⊗ f1) ⊗ w 2  ⊕  ((f1 ⊗ S) ⊕ (f1 ⊗ S))  ⊕  remainder,
    S = Σ_{2≤m} f(m) w(1+m).

with `cross-symm` (the two cross terms are equal — where the factor 2 comes
from) and `cross-factored` (each equals A ⊗ S — where "2A(Q)S(Q)" comes
from) proved separately rather than waved at.

(2) and (3) are **not reachable in this lane and I did not attempt them**:
they need real analysis and Mertens, and the ledger's structural finding
holds unchanged — no zero, no explicit formula, no Dirichlet series appears
in a type in this file either. The file says so in its header, in those
words, including "THIS FILE DOES NOT PROVE
`[♯♯]-constant = ¼log²Q + (C/2+2S∞)logQ + O(1)`".

**The Poincaré point, and the reason exp27's fit was noise.** The leading
coefficient is exact because it comes from **one lattice point**. In the
term, `corner = (A ⊗ A) ⊗ w 2` is a closed term that does not mention the
truncation at all — that independence is visible in the type, not measured.
Instantiating w n = 1/n² turns w 2 into ¼; that step is arithmetic in ℚ and
is deliberately not performed here.

Truncation is the **square** 1 ≤ a,b ≤ K, not the triangle a+b ≤ N. Both
truncate the same double series; the square is the one whose split is exact
with no boundary term. That is a choice about truncation, not about M1, and
the header says so. No infinite sum is formed, so nothing here asserts
convergence.

## Λ♯_Q(P_Q) = M(Q): the cancellation, honestly bounded

`sharp-collapse` proves Σ_{q≤Q} ω(q)⊗c(q) = Σ_{q≤Q} μ(q) from two
hypotheses **in the signature**:

- `maximal` : c q ≡ φ q — i.e. c_q(n) = φ(q) when q ∣ n. This is Ramanujan-sum
  theory (it reduces to Σ_{d∣q} μ(q/d)d = φ(q)) and is **not developed
  here**; the cubical library has no μ, φ, or divisor sums, and building
  Möbius inversion is its own block, not this one.
- `cancel` : ω q ⊗ φ q ≡ μ q — the φ(q) ≠ 0 cancellation in ℚ.

What I *did* discharge is the side condition that makes the statement
non-vacuous: **a single modulus satisfying `maximal` for all q ≤ Q exists.**
`divFact : (Q q : ℕ) → 0 < q → q ≤ Q → q divides fact Q` is proved by
induction, no library divisibility used. Not proved: Odlyzko–te Riele, hence
none of the note's |Λ♯_Q| ≫ Q^{1/2} consequence.

So the honest ledger delta is: **A18 goes PROSE → PARTIAL**, not PROSE →
TERM. The algebraic core is a term; the asymptotics are prose and stay prose.

## Controls (§7), all `refl` in the kernel

f n = n, w n = n, K = 3: `sq 3 ≡ 168`, `corner ≡ 2`, `cross₁ 2 ≡ 18`,
`cross₂ 2 ≡ 18`, `remainder 2 ≡ 130`, `S 2 ≡ 18`, and 2+18+18+130 = 168
checked independently. Non-vacuity: each of corner, cross, remainder is
proved **≠ 0** (so §4 is not a partition of zeros into zeros), and
`corner ≢ sq 3` (the split has content beyond its leading term).
For §5 there is a control that the `maximal` hypothesis is **load-bearing**:
with everything else fixed, replacing c by 0 makes the conclusion false, and
that falsity is proved.

## Coordination

I touched exactly two files: the new module, and **one line** in
`Everything.agda` (`import M1SplitIdentity`, inserted after
`import M2Unimodular`). I did not touch `NaturalMachine.agda`.
