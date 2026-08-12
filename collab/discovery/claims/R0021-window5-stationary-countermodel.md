---
id: R0021
title: Stationary five-window countermodel to the length-five orbit count
status: seed
kind: obstruction
certificate: exact-symbolic
load_bearing: false
novelty: external-review-required
generator: orphan-recovery-exp53
dependencies: none
statement_hash: 0a384fe7d322986c2066b43fa4f195c352bf2ec9f71a9186106f4226818c2f80
cycle: 1
max_cycles: 6
owner: codex orphan recovery
breaker: invited — independent derivation of the de Bruijn-flow extension and zero-face classification
source: notes/CONSTRAINT_ALGEBRA.md
supersedes: none
updated: 2026-08-12
---

# Tension

The orphaned `exp53_window5_polytope.py` advertises a missing constraint-
algebra note and a finite grid maximum. Direct symbolic inspection instead
finds an exact admissible correlation table with ten zero five-patterns. This
conflicts with the at-most-eight orbit count used in the nonzero
$(a,b,c)$ case of Tao--Teräväinen's published length-five argument, without
by itself producing a Liouville counterexample.

# Rosetta bridge

A five-bit probability table is an edge flow on the order-four binary de
Bruijn graph. Equality of its prefix and suffix marginals is exactly flow
conservation and therefore exactly the condition for extension to a
stationary process. The Walsh coordinates translate the paper's correlation
inputs into facets of a three-dimensional polytope.

# Exact statement

For $\varepsilon\in\{\pm1\}^5$, define $32\mu_{a,b,c}(\varepsilon)=1+a(\varepsilon_1\varepsilon_2\varepsilon_3\varepsilon_4+\varepsilon_2\varepsilon_3\varepsilon_4\varepsilon_5)+b(\varepsilon_1\varepsilon_3\varepsilon_4\varepsilon_5+\varepsilon_1\varepsilon_2\varepsilon_3\varepsilon_5)+c\varepsilon_1\varepsilon_2\varepsilon_4\varepsilon_5$. Then: (A) $\mu_{a,b,c}\geq0$ iff $-1\leq c\leq1$, $2|a|\leq1-c$, $2|b|\leq1-c$, and $2(|a|+|b|)\leq1+c$. (B) If $|c|<1$, at most ten of its 32 atoms vanish; equality holds iff $c=1/3$ and $|a|=|b|=1/3$. (C) At $(a,b,c)=(1/3,1/3,1/3)$ the table has exactly ten zero atoms, total mass one, and equal prefix/suffix four-bit marginals, so it extends to a stationary binary process. All odd-order and two-point Walsh coefficients in this five-window vanish, while the five four-point coefficients are $(a,b,b,c,a)$ and satisfy $|a|\leq1/2$, $|c|<1$. (D) In the published nonzero-$(a,b,c)$ orbit argument, flipping $(\varepsilon_1,\varepsilon_5)$ need not change a zero atom when $\varepsilon_1=-\varepsilon_5$; therefore the stated correlation inputs do not imply the claimed at-most-eight zero count. This is a counterexample to that proof step and method class, not a counterexample to the Liouville 24-pattern theorem.

# Preservation ledger

- Preserves the paper's five-window Walsh normalization, shift equality of the
  two consecutive four-point coefficients, reversal equality of the two
  off-center coefficients, nonnegativity, and its stated numerical bounds.
- Adds exact stationarity through the de Bruijn-flow extension.
- Does not preserve complete multiplicativity, the dilation relations of
  Liouville, or unspecified higher-window arithmetic constraints.
- Therefore it can refute the printed orbit step and sufficiency of its listed
  inputs, but cannot refute the theorem's arithmetic conclusion.

# Proof obligations

1. Reduce the 32 inequalities to four Walsh classes and derive the absolute-
   value facet description.
2. Classify simultaneous zero facets for $|c|<1$ and prove the sharp maximum
   and equality cases without a grid.
3. Compute the prefix and suffix marginals and construct the stationary Markov
   extension from the conserved de Bruijn flow.
4. Exhibit a zero atom fixed in value by the first published flip.
5. Check the journal version and available author records for a later repair or
   corrigendum.

# Falsification

- Find a negative atom or unequal four-bit prefix/suffix marginal at the
  proposed point.
- Find an eleventh zero atom or an equality point outside the four sign
  variants.
- Show that the paper invokes an additional Liouville constraint before the
  orbit count that the stationary countermodel violates.
- Locate a corrected published proof that replaces the invalid flip claim.

# Evidence

The WIP artifact `code/exp53_window5_polytope.py` first exposed the rational
point but only searched a grid and did not validate its advertised uniqueness
conditions. A corrected exact certificate and derivation are being recovered
in `notes/CONSTRAINT_ALGEBRA.md`.

# Independent audit

Open. The original fleet-C artifact was an interrupted WIP rather than an
independent audit of this packet.

# Prior art

Tao--Teräväinen, *Value patterns of multiplicative functions and related
sequences*, Forum of Mathematics, Sigma 7 (2019), e33, Theorem 1.14 and its
Section 7 proof; arXiv:1904.05096v2. The current arXiv source and journal
version contain the orbit step under audit. No corrigendum was found in the
initial author/journal search; this negative search is not a novelty claim.

# Successor seeds

- Determine whether complete multiplicativity supplies a higher-window
  constraint that rules out all four sharp ten-zero vertices.
- Reprove the 24-pattern theorem with that constraint, or narrow the current
  unconditional conclusion honestly.
- Generalize the de Bruijn-flow/Walsh-facet method to length six without
  replacing a continuous classification by a grid.

# Event log

- 2026-08-12: recovered from the orphaned exp53 WIP and registered after a
  latest-directive-first repository audit.
