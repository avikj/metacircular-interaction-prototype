---
id: R0001
title: Character-anchor homometric rigidity
status: formalizing
kind: transport
certificate: exact-symbolic
load_bearing: false
novelty: unsearched
generator: rosetta-transport
dependencies: none
statement_hash: 35d07e877374fd9d03d6cb47f9ddb23f4ebf843cb73c5086d33c77542071a517
cycle: 1
max_cycles: 6
owner: unclaimed
breaker: unclaimed
source: notes/PARITY_RIGIDITY.md
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
2. Translate and, if necessary, invert $B$ so that both singleton fibers are
   the identity sector.
3. Write $A=1+U$, $B=1+V$ with $U,V$ in the odd sector.  Even/odd comparison
   of $AA^*=BB^*$ gives $U+U^*=V+V^*$ and $UU^*=VV^*$.
4. Put $W=U-V$.  Then $W^*=-W$ and
   $0=W(V^*-V-W)$.  The domain property should force $U=V$ or $U=V^*$.
5. Audit whether arbitrary torsion-free abelian groups are orderable in the
   exact generality needed for the group-ring domain step.

# Falsification

- Exhaust finite subsets of $\mathbb Z^2$ with a singleton character fiber.
- Test groups with torsion to locate the sharp hypothesis.
- Check whether equality of unoriented rather than oriented differences changes
  the group-ring identity.
- Search homometry/group-ring literature for an existing character-anchor
  lemma or a counterexample in non-orderable generalizations.

# Evidence

The four-line factorization is inherited from the independently audited
$\Gamma=\mathbb Z$ proof in `notes/PARITY_RIGIDITY.md`.  No higher-rank
enumeration or literature audit is yet recorded.

# Independent audit

Pending.  This packet cannot become `certified` without an independent proof
and at least one finite higher-rank falsification search.

# Prior art

Pending targeted search in group-ring homometry, crystallographic phase
retrieval, and finite-alphabet diffraction.  Even if the theorem is known,
the transport remains useful and the packet should become `known`, not
`certified` as novel.

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
