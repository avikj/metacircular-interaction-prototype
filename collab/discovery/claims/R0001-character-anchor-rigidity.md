---
id: R0001
title: Character-anchor homometric rigidity
status: proving
kind: transport
certificate: exact-symbolic
load_bearing: false
novelty: searched-not-found
generator: rosetta-transport
dependencies: none
statement_hash: 35d07e877374fd9d03d6cb47f9ddb23f4ebf843cb73c5086d33c77542071a517
cycle: 2
max_cycles: 6
owner: codex-outside-lens
breaker: unclaimed
source: notes/CHARACTER_ANCHOR_RIGIDITY.md
supersedes: none
updated: 2026-08-11
---

# Tension

`PARITY_RIGIDITY` looks like a special accident of the prime 2, while its
Laurent-polynomial proof uses only a two-sector grading and the absence of
zero divisors.  The arithmetic statement and the algebraic proof appear to
live at different levels of generality.

# Rosetta bridge

Replace parity of integers by a character
$\chi:\Gamma\to\{\pm1\}$ on a torsion-free abelian group.  Replace Laurent
polynomials by the group ring $\mathbb Z[\Gamma]$.  The involution remains
$g\mapsto-g$, and homometry remains equality of $AA^*$.

This is a transport edge, not yet a novelty claim: the common object is a
$\mathbb Z/2$-graded integral group ring.

# Exact statement

Candidate theorem: let $\Gamma$ be a torsion-free abelian group and let
$\chi:\Gamma\to\{\pm1\}$ be a nontrivial character.  If a finite subset
$A\subset\Gamma$ meets one $\chi$-fiber in exactly one point, then every
finite $B\subset\Gamma$ with the same oriented difference multiset as $A$
is a translate of $A$ or of $-A$.

# Preservation ledger

- Preserved: the full group-valued difference multiset, translation, and
  inversion.
- Forgotten: absolute position and orientation.
- Introduced by the bridge: a chosen index-two character; the theorem must not
  imply rigidity when only its quotient-valued differences are known.
- Required algebraic fact: $\mathbb Z[\Gamma]$ is a domain for torsion-free
  abelian $\Gamma$.

# Proof obligations

1. Recover the unordered pair of fiber sizes from the difference multiset by
   evaluating the autocorrelation under $\chi$.
2. Translate each set by its singleton point.  This puts both singleton
   fibers in the identity sector without choosing an order or an endpoint.
3. Write $A=1+U$, $B=1+V$ with $U,V$ in the odd sector.  Even/odd comparison
   of $AA^*=BB^*$ gives $U+U^*=V+V^*$ and $UU^*=VV^*$.
4. Put $W=U-V$.  Then $W^*=-W$ and
   $0=W(V^*-V-W)$.  The domain property should force $U=V$ or $U=V^*$.
5. Reduce the domain step to the finitely generated subgroup spanned by the
   finite supports: it is $\mathbb Z^d$, whose integral group ring is a
   Laurent-polynomial domain.  No global ordering choice is needed.

# Falsification

- Exhaust finite subsets of $\mathbb Z^2$ with a singleton character fiber.
- Test groups with torsion to locate the sharp hypothesis.
- Check whether equality of unoriented rather than oriented differences changes
  the group-ring identity.
- Search homometry/group-ring literature for an existing character-anchor
  lemma or a counterexample in non-orderable generalizations.

# Evidence

`notes/CHARACTER_ANCHOR_RIGIDITY.md` supplies the complete proof, including
the finite-support domain reduction, higher-rank translation normalization,
and the distinction between oriented and inversion-orbit-labeled unoriented
differences.

`formal/pairfield/Pairfield/CharacterAnchor.lean` machine-checks the central
same-sum/same-product factorization in an arbitrary commutative domain.  It is
deliberately only the algebraic core, not a formalization of the full
finite-set theorem.

`code/exp38_character_anchor_z2.py` exhausts all 65,535 nonempty subsets of
the $4\times4$ grid.  For each of the three nontrivial mod-2 characters it
finds 4,032 anchored sets and zero homometric families containing more than
one translation/inversion class.

# Independent audit

The builder proof and higher-rank falsification search are complete.  An
independent blind-breaker and an independent full proof check are still
pending; the partial Lean check does not discharge either requirement.

# Prior art

The group-ring factorization framework is classical: Rosenblatt and Seymour,
“The Structure of Homometric Sets,” *SIAM Journal on Algebraic and Discrete
Methods* 3 (1982), DOI 10.1137/0603035.  Finite-alphabet phase retrieval and
homometric partitions are also established; see Bendory, Edidin, and
Gonzalez, *Applied and Computational Harmonic Analysis* 66 (2023),
arXiv:2301.10647.

A targeted search did not locate the exact singleton-character corollary.
It may be implicit in classical factorization results, so the novelty status
is `searched-not-found`, not `novel`.

# Successor seeds

- Classify finite quotients or gradings for which a small fiber, rather than a
  singleton, bounds homometric ambiguity.
- Interpret an anchor as the minimal symmetry-breaking reference frame needed
  for tomography under a superselection rule.
- Search arithmetic sets with a canonical anchor other than prime 2.

# Event log

- Authoritative transitions are append-only JSON records under
  `collab/discovery/events/R0001/`; this prose is only a readable synopsis.
- 2026-08-11: created by transport from singleton-parity rigidity; status
  `formalizing`.
- 2026-08-11: builder proof, partial Lean check, and exhaustive $\mathbb Z^2$
  falsification search completed; promoted to `proving` pending independent
  attack.
