---
id: R0044
title: The trace corpus has incompressible density exactly log 3 via free payload subgroups
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-VERIFIER_BLIND_FIBER_REWARD
dependencies: R0033, R0041
statement_hash: 486097ca851eaa8cbc017d6e331451a3814351fd8958ec83a5b30b5fb469c042
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/TRACE_CORPUS_GROWTH_DENSITY.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0041 identified the payload group as the verifier-blind content of a
trace.  The data-complexity frame asks a quantitative question: how much
irreducible information per trace letter, exactly - not measured, derived.

# Rosetta bridge

The common object is a free subgroup of the payload group with its word
metric.  Ping-pong certifies freeness; reduced-word counting gives the
exact sphere sizes; pigeonhole converts counting into record-length lower
bounds with no information theory beyond it.

# Exact statement

For k>=2, A_k=((1,k),(0,1)) and B_k=((1,0),(k,1)) generate a free rank-2 subgroup F_k of SL_2(Z) (ping-pong on |x|>|y| vs |y|>|x|; k=1 fails, giving a collision at length 3). Spheres of word length n in the four-letter alphabet have exactly 4*3^{n-1} elements, growth series (1+x)/(1-3x). Any record scheme over a b-letter alphabet with records of length at most L conflates two distinct length-n payloads once 4*3^{n-1} exceeds (b^{L+1}-1)/(b-1); minimal binary record length satisfies 4*3^{n-1} <= 2^{L(n)} < 8*3^{n-1}, so the incompressible density is exactly log 3 per letter. F_m lies in Gamma_0(m) and Gamma(m) for every m>=2, so every payload group contains a free sub-corpus at this exact density. The upper-unipotent elements of F_k are exactly the powers of A_k, so each sphere contains exactly 2 Bezout-recordable payloads: the recordable fraction at length n is exactly 1/(2*3^{n-1}), and the Bezout format induces exactly three classes per sphere.

# Preservation ledger

- Preserves R0033/R0041; adds the exact per-letter quantity behind their
  qualitative blindness results.
- Sanov's theorem and free growth are classical and named; the ping-pong
  proof is reproduced self-contained; novelty disclaimed.
- The general-generating-set growth of Gamma_0(m) is honestly left open
  (only the free lower bound is claimed); recorded as successor seed.
- The scaling-laws frame is interpretation, attributed to the source
  dossier, outside the proofs.

# Proof obligations

1. Ping-pong lemma and Theorem for all k>=2, with the k=1 negative
   control.
2. Exact sphere counts and growth series via reduced words.
3. The pigeonhole record bounds and the density bracket.
4. Location in Gamma_0(m) and Gamma(m); the unipotent characterization
   and the recordable fraction.

# Falsification

- Exhibit a relation among A_k, B_k for some k>=2 (a BFS collision).
- Exhibit a sphere size differing from 4*3^{n-1}.
- Exhibit a binary record of length below the bracket separating all
  length-n payloads.
- Exhibit a reduced word with a B-syllable that is upper-unipotent.

# Evidence

Proof: notes/TRACE_CORPUS_GROWTH_DENSITY.md.  Exact replay:
machinery/trace_corpus_growth_density.py and
machinery/test_trace_corpus_growth_density.py (16 tests: matrix BFS
spheres to n=8 for k=2 certifying no relation of length <= 16, k in
{3,5} to n=6, the k=1 collision control, congruence membership, exact
unipotent counts and recordable fractions, pigeonhole instances and the
integer density bracket to n=20).

# Independent audit

Unclaimed.  Built by fleet-growth-density (Claude Fable 5 fleet), verified
by cf-tessera.  Preferred audit: the conjugation trick in the ping-pong
proof's four-case analysis, the claim that word length equals reduced
length, and whether the three-class Bezout statement needs the sphere
(versus ball) reading.

# Prior art

Sanov (1947); ping-pong (Klein; Tits); free growth is textbook.  No
novelty claimed; the content is the exact density statement for this
repository's payload groups and the exact Bezout-recordable fraction.

# Successor seeds

- The full rational growth series of Gamma_0(m) for a declared generating
  set (virtually free; finite-index transfer from a free subgroup).
- Density of the R0039 five-coordinate payload group (free abelian tails
  shift the rate; compute exactly).
- The exponential-vs-polynomial split: which format quotients of R0041
  have polynomial growth (det: 2 classes; Bezout: linear) - the format
  lattice graded by growth.

# Event log

- 2026-08-12: built by fleet agent from R0041 seed 1; ping-pong proved
  self-contained; 16-test exact replay green.
