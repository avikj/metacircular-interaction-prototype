---
id: R0009
title: Exact nonic obstruction for prime-prefix polynomials
status: proving
kind: obstruction
certificate: exact-finite
load_bearing: false
novelty: unsearched
generator: factor-pipeline-acceptance
dependencies: none
statement_hash: eea3b5dc2ffeea6fb8f1e215f71d69ff30430ed9d13aa7fcc5d7773835df7ab7
cycle: 3
max_cycles: 8
owner: codex
breaker: octic-frontier plus independent exp37/41/42 audit lineages — accepted
source: notes/NONIC_OBSTRUCTION.md
supersedes: R0002
updated: 2026-08-11
---

# Tension

The original R0002 packet asked whether the degree-nine factor layer would
break the exact low-degree pipeline.  Its statement omitted the necessary
boundary $X\ge2$.  The corrected theorem must both close that boundary and
show that the substantially larger unit-resultant census remains exhaustive.

# Rosetta bridge

Combine the unique negative-root carrier for odd degree with the
even--odd unit resultant, exponent-addressed Graeffe bounds, exact sharded
enumeration, and the negative-root resultant-tail inequality.  The bridge is
load-bearing only because each stage has an independent hostile audit.

# Exact statement

For every real X at least 2, the prime-prefix polynomial F_X(x) = sum over primes p at most X of x^(p-2) has no irreducible factor of degree 9 over Q.

# Preservation ledger

- The theorem begins at $X=2$; for $X<2$, $F_X=0$ and the unqualified
  divisibility statement would be false.
- Every coefficient and Graeffe filter is a proved necessary condition and is
  indexed by its actual exponent.
- Root counts, resultants, finite-field witnesses, factor products, rational
  root bounds, and tail inequalities are exact; elapsed times and printed
  decimal margins are annotations only.
- The integrated wrapper regenerates all 441 shards and does not accept an old
  candidate checkpoint as evidence.

# Proof obligations

1. Prove the coefficient box and reversed exponent-addressed Graeffe bounds.
2. Exhaust all 441 $(a,j)$ shards with safe exact resultant arithmetic.
3. Partition every survivor by exact real/annulus/radius-two counts and
   complete irreducibility witnesses.
4. Check every earlier prefix resultant and prove a strict tail inequality
   covering every later prefix.
5. Reproduce each gate independently and bind the integrated replay by hashes.

# Falsification

- Reverse the Graeffe vector or remove each pruning rule and test containment.
- Search directly for an omitted unit-resultant tuple or an overflow/division
  failure in the Sylvester determinant.
- Attack the strict radius-two premise, Cohn singleton, factor-box
  completeness, prefix recurrence, and odd-root tail orientation.
- Factor accessible prime prefixes independently and look for a degree-nine
  counterexample.

# Evidence

`notes/NONIC_OBSTRUCTION.md` gives the proof.  The fresh integrated replay
`code/exp44_nonic_certificate.py --workers 8` passes and binds the 22,077
unit-resultant candidate digest, the strict 767-tuple root set, the 755
irreducibles, and all 3,556 production prefix resultants.

# Independent audit

Exp37 was rerun in all 441 shards without checkpoint reuse; every count and
candidate digest matched, all 22,077 resultants were independently checked,
and the signed-128-bit bound was verified.  Exp41 received an independent
Rabin/factor/Cohn/root-count audit, which found and repaired the relaxed
radius-two gap.  Exp42 was independently reimplemented with finer rational
root isolation and direct prefix construction; it closed the same 755
candidates.  Verdict: ACCEPT at all three gates.

# Prior art

The root-counting, resultant, Rabin, Cohn, and finite factor-search ingredients
are classical.  No novelty claim is made for the prime-prefix specialization;
a targeted literature search has not yet been recorded for this exact theorem.

**PRIOR-ART SWEEP 2026-08-14 — one is now recorded: RESOLVED-NO-MATCH for the
degree-nine theorem** (search-summary/śabda grade; `WebSearch` works,
`WebFetch` is EGRESS_BLOCKED on every host, so no source text was read).
Nothing was located on the factorization of the prime-prefix polynomial
$F_X(x)=\sum_{p\le X}x^{p-2}$ at any degree. The classical ingredients confirm:
**Cohn's irreducibility theorem** — if a prime's base-$b$ expansion is
$\sum a_ib^i$ then $\sum a_ix^i$ is irreducible over $\mathbb Q$, for every
$b\ge2$ — is a real and much-generalized theorem, which is the nearest located
neighbour of a "0–1 coefficients indexed by primes ⟹ factorization
restriction" statement, but it constrains a polynomial built *from the digits
of one prime*, not one *supported on the primes*, so it is a neighbour and not
a match. Adjacent and worth the next block's time: the Dumas-criterion
generalizations of arXiv:2512.20262 and the surveys arXiv:2310.02860,
arXiv:2302.14849. Query: *irreducible factors of polynomials with 0–1
coefficients supported on primes prime-prefix polynomial sum x^(p−2)
factorization degree*. Absence of a located source is not evidence of novelty,
and the packet's own `no novelty claim is made` stands unchanged. Note for the
pipeline owner: the front-matter field `novelty: unsearched` is machine
metadata and has deliberately **not** been edited by this sweep — a human or
the owning generator should decide whether it now reads `searched-no-match`.
Attribution status only; the theorem, its $X\ge2$ boundary and every gate are
untouched.

# Successor seeds

- Determine whether degree ten admits a symmetry/resultant reduction before
  attempting any enumeration.
- Extract the odd-degree negative-root tail inequality as a generic certified
  checker shared by degrees seven, nine, and later odd layers.
- Formalize the finite witness semantics for Rabin, factor products, and strict
  tail inequalities.

# Event log

- 2026-08-11: corrected successor to R0002 after all three independent gates
  and the fresh integrated replay passed.
