# At one remaining coordinate, the arithmetic state collapses to one bit

Let one coordinate remain with required sum `S`, so the unique feasible suffix
is `(S)` (assuming `0<=S<=C`). Let `R,Q` be the squarefree child and complement
gcd states.

**Theorem.** The coarsest exact continuation quotient has two classes,
determined by
\[
\chi(R,Q)=1_{\gcd(R,S)=1\ \text{and}\ \gcd(Q,C-S)=1}.         \tag{1}
\]

*Proof.* The continuation language is either the singleton `{(S)}` when (1)
holds or the empty set otherwise. States with the same bit therefore have
identical languages, while states with different bits are separated by the
only suffix. ∎

Consequently the coupled surviving-divisor profile from
`COUPLED_DIVISOR_SURVIVAL` is sufficient information but not generally the
coarsest predictive state. Example: with `C=6,S=1`, states `(R,Q)=(1,1)` and
`(5,1)` have different divisor histories, yet both accept because neither
`1` nor `5` shares a factor with the forced chosen coordinate `1` and the
complement condition is trivial.

The mathematical state contracts discontinuously as the future narrows: many
prime-support histories become one Boolean at the terminal interface.

## Rigor boundary

This completely classifies the `r=1` quotient only. For `r>=2`, multiple
suffixes remain and the coarsest language quotient can retain more structure.
