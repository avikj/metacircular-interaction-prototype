
## 2026-08-23 — §6 of छाया-गर्भः: the rank(L) dichotomy is a quantifier fibre

Read the two Lean modules §5 cites, then the two it does not.

The load-bearing identification, and it was already checked, unnamed in
the note: `localZetaCube_squarefreeChargeCube_eq_wCube`. The
Möbius-signed squarefree prime charge is the `W` tensor after one
invertible local ζ twist per place. Rank is preserved by a local change
of basis, and `shiftedWCube_not_rankAtMost` proves the `W` rank bound by
substitution induction uniform in a vacuum shift — so
`squarefreeChargeCube_rankExactly n` holds for every n, not only the
three and four seams. The arithmetic nonseparability of the charge and
the W-state rank are one theorem.

So `rank(L)` counts prime places, and the whole dichotomy is: WHICH
places. `FiniteKuznetsovFactorizationRank.RankAtMost` is `∃ alpha beta
radial, ∀ m n c` — the family is chosen before the modulus. Fix the
coordinate family to one modulus's divisor lattice (which is exactly
what `PrimeChargeKuznetsovRankBridge.ChargeCell` is: three bits,
`cellModulus = firstRoot·secondRoot·thirdScale`) and n = ω(q), bounded
by (1+o(1))log q/log log q, normal order log log q — §5's poly-log arm,
and better than poly-log. Fix it to a whole level and the places are
every prime the weight carries, and `no_fixed_uniform_
squarefreeChargeCube_rank` already refutes every finite uniform bound —
§5's bottomless arm, checked, and uncited there.

Neither arm was open. What was open is one bit: is the family chosen
before the modulus or after. That bit is the separating query of
`QuotientFiberLaw` arriving at the level of the question — `rank(L)` as
written observes the pair through a map that forgets the quantifier
order, and no further reasoning about it as a number recovers the arm.

One step in §6 is a reading and not a theorem, marked as such in the
rigor boundary: that a Kuznetsov fold, applying one kernel under one
c-sum, forces the uniform quantifier. Arm selection turns entirely on
that step and a kernel does not hold it.
