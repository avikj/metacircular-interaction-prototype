---
id: R0018
title: Definitional rigidity — a size-2 consequence-web pins riemannZeta; homometric catalog for every thinner web
status: proving
kind: transport
certificate: exact-finite
load_bearing: false
novelty: known
generator: fidelity-charter
dependencies: none
statement_hash: 6e27923d6640466c434d5176b17e41e1a8205aed470449c9300a6d10fa8d18bf
cycle: 3
max_cycles: 6
owner: fleet-fidelity (builder)
breaker: open — Codex invited (Theorem R proof + exp54 replication)
source: notes/DEFINITIONAL_RIGIDITY.md
supersedes: none
updated: 2026-08-11
---

# Tension

FIDELITY.md's content program demands the Theorem A′ transplant: when does a
finite consequence-web determine a definition up to canonical iso, and what
are the homometric failure pairs? The corpus had the homometry frame
(PARITY_RIGIDITY singleton-anchor mechanism, ECOLOGY trust correction) but no
registered rigidity statement in the vocabulary theater.

# Rosetta bridge

Prime-set homometry: one extremal class (the singleton parity class) anchors
an entire prefix. Vocabulary transplant: one extremal aggregate consequence
(a special value equal to the maximum modulus of an absolutely convergent
Euler-type product) anchors every coordinate of a completely multiplicative
definition simultaneously. The bridge is exact, not analogy: both are
instances of the abstract extremal-product lemma in the note's section 1.

# Exact statement

(R) Let C be the class of completely multiplicative a: N -> C with a(1)=1 and
|a(p)| <= 1 for every prime p, and D_a(s) = sum a(n) n^{-s}. The web W_R =
{membership in C; D_a(2) = pi^2/6} has the unique solution a == 1, i.e. D_a
is the Riemann zeta function. Mechanism: |1 - z p^{-2}| >= 1 - p^{-2} for
|z| <= 1 with equality iff z = 1, applied to the absolutely convergent Euler
product at s = 2. (H1) The web {D(2) = pi^2/6, D(4) = pi^4/90} on
unrestricted Dirichlet series is homometric: P(s) = 5 - 128*2^{-s} +
243*3^{-s} satisfies P(2) = P(4) = 0 exactly, so zeta and zeta + P are
distinct solutions. (H2) Dropping the bound |a(p)| <= 1 makes the two-prime
web homometric: (a(2),a(3)) = (1,1) and (0,3) both give Euler value 3/2 at
s = 2. (H4) Within diameter <= 17 there is no homometric multiset pair of
size 3-5, and {0,1,2,6,8,11} vs {0,1,6,7,9,11} is a size-6 homometric pair
(equal difference multisets, inequivalent under translation/reflection).

# Preservation ledger

- Theorem R is proved self-contained in the note (two-line inequality chain
  plus absolute-convergence bookkeeping); the exp54 grid check is
  illustrative, not load-bearing.
- H1, H2 are exact rational identities; H4 is an exhaustive finite search.
- Hamburger 1921 (functional-equation-side rigidity) and the Dirichlet
  L-function functional equation (H3 of the note) are cited as known and are
  NOT part of this packet's exact statement.
- Novelty is set to known: extremality of Euler factors and homometric pairs
  are classical devices; the registered content is the assembly and the
  web-relative framing. No novelty search recorded, none claimed.

# Proof obligations

1. Theorem R inequality chain and equality case — written in the note; audit.
2. H1/H2 rational identities — exp54 exact checks (Fraction arithmetic).
3. H4 exhaustive search — exp54 (sizes 3-6, diameter <= 17).
4. Controls: unit-modulus impostor fails web by 2.9e-2 (C1); boundedness
   axiom kills the H2 impostor (C2); wrong polynomial fails at s=4 (C3).
5. Lean formalization of Theorem R's finite-universe restriction — open
   (natural formal/pairfield companion; the two-prime H2 case is decidable).

# Falsification

- Exhibit a in C, a != 1, with D_a(2) = pi^2/6 (refutes Theorem R).
- Show P(2) != 0 or P(4) != 0 (refutes H1; excluded by exact arithmetic).
- Exhibit a homometric pair of size <= 5 within diameter 17 (refutes H4's
  minimality clause; the search was exhaustive, so this would mean a bug).
- Prior-art falsifier: locate the size-2-web statement for zeta in the
  literature (would move the assembly from unrecorded to cited).

# Evidence

notes/DEFINITIONAL_RIGIDITY.md; code/exp54_definitional_rigidity.py;
data/exp54_out.txt (12/12 exact checks including three planted-false
controls). Forecast registered pre-derivation at 2026-08-11T23:02:42Z
(quoted in the seed event and in the note's header).

# Independent audit

None yet. Breaker slot open; Codex invited to re-derive Theorem R blind and
replicate exp54 with independent code (message 0068).

# Prior art

Hamburger 1921 (uniqueness of zeta from its functional equation — the
analytic-side counterpart, cited not reproved); Patterson's crystallographic
homometry (finite homometric pairs are classical); Davenport, Multiplicative
Number Theory ch. 9 (L-function functional equations, for the note's H3).
The specific size-2 multiplicative-side web assembly: no recorded search,
novelty stays at known/assembly-only.

# Successor seeds

- Lean: Theorem R on a finite prime universe + H2 decidable instance
  (fidelity suite for formal/pairfield vocabulary).
- Quantitative rigidity: lower-bound the web-value defect |D_a(2) - zeta(2)|
  in terms of sup_p |a(p) - 1| (stability version of Theorem R).
- Mathlib density cell 8: design a genuine second-formalization agreement
  check for riemannZeta-class definitions (note section 5's open cell).
- H3 upgrade: exact statement + proof that the existential-conductor web is
  homometric, with the mod-5 character worked in full.

# Event log

- 2026-08-11: seeded, formalized, and moved to proving by fleet-fidelity
  (FIDELITY charter execution; forecast pre-registered; see events/R0018).
