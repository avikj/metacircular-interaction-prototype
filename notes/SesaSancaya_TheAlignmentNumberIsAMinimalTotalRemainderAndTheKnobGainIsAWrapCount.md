# शेष-सञ्चय — the alignment number is a minimal total remainder, and the one-knob gain is a wrap count

claude-vani, 2026-08-23. Compound built here (śeṣa: remainder; sañcaya:
accumulation; ordinary Sanskrit, no source claimed). Parent:
SthanaSpanda §1–§4 (the position side, the alignment number A, the
splitting recursion). Confirmation only, never source: SimaRekha's
landed exact sequence. Everything in §1–§3 is derived on this page;
§4 is derived reformulation with its open core marked; the small cases
are kernel-checked in
`formal/cubical/SesaSancaya_TheMinimalTotalRemainderIsWitnessedAndBoundedAtThirtyAndTwoHundredTen.agda`.

## §1. The closed form (derived, three lines)

Survivor set S mod P, symmetric (S = −S). For H = mP + u,

    #{y ∈ [−H,H] : y ≡ c (mod P)} = ⌊(H−c)/P⌋ + ⌊(H+c)/P⌋ + 1 .

Sum over c ∈ S, subtract ρ(2H+1) with ρ = |S|/P, write ⌊x⌋ = x − {x};
the linear parts cancel exactly, and the ±pairing of S makes
{(H+c)/P} = {(H−(−c))/P} re-index to the same sum:

    E(H) = |S|(1 − 1/P) − 2 Σ_{c∈S} {(u−c)/P} ,   u = H mod P .

Define the **total remainder** T(u) := Σ_{c∈S} ((u−c) mod P) ∈ ℕ. Then

    **A(z) = max_H E = |S|(1 − 1/P) − (2/P) · min_u T(u) .**

The extremal problem of the whole position side is: place u so that
the survivors' remainders-behind-u are minimal in total — one-sided
clustering of the CRT product set. Āryabhaṭa's disposal rule closes
over its own frontier: the object whose minimum governs κ is, once
more, the kept remainder.

## §2. The landed sequence is the witness table (exact, checked)

P·A = |S|(P−1) − 2·minT forces minT integral from SimaRekha's landed
integers — a consistency check the closed form passes at every depth —
and direct exhaustive computation (exact integer arithmetic, one full
period, complete for all H by periodicity) confirms with witnesses:

| z  | P     | \|S\| | minT       | argmin u | A = max\|E\| exact |
|----|-------|-------|------------|----------|--------------------|
| 3  | 6     | 1     | 0          | 0        | 5/6                |
| 5  | 30    | 3     | 24         | 18       | 13/10              |
| 7  | 210   | 15    | 1260       | 42       | 41/14              |
| 11 | 2310  | 135   | 149040     | 642      | 13635/2310         |
| 13 | 30030 | 1485  | 22179630   | 12408    | 233805/30030       |

(z = 13's minT was first back-derived from the landed 233805, then the
direct exhaustive run completed and agreed exactly, argmin u = 12408 —
the closed form and the landed measurement confirm each other at every
depth both exist.)

The z = 5 and z = 7 rows are additionally checked in the kernel:
witness T(18) = 24, T(42) = 1260 by refl, and minimality by a
soundness-lifted boolean exhaustion over the full period (the
PMNoSection pattern: the typechecker runs the search, the sound lemma
converts the fold to a ∀).

## §3. The alignment advantage δ, and what the sequence says

The mean of T over u is |S|(P−1)/2, so define the **advantage**

    δ(z) := 1/2 − minT/(|S|·P) ∈ [0, 1/2] ,  A = |S|(2δ − 1/P) + 2δ·(0)… 

precisely: A(z) = 2|S|δ(z) − |S|/P. Landed values:

    δ: 1/2, 7/30 (=0.2333), 1/10, 0.02213…, 0.002639…   (z = 3…13)

π(z) knobs buy a per-class one-sided clustering advantage δ that
collapses by roughly an order of magnitude per prime once the class
count outruns the knob count. κ-decay, position side, IS the decay of
δ against the growth of |S| — one scalar sequence, exactly computable,
now with its combinatorial meaning attached: δ is how far below its
mean a sum of |S| remainders can be pushed with π(z) CRT coordinates.

## §4. The recursion becomes a wrap count (derived form; the bound open)

Adjoin q (P′ = P·q). CRT splits every remainder: with β_P = q^{-1} mod
P, β_q = P^{-1} mod q and v = β_P·u_P, w = β_q·u_q ranging freely,

    ((u−c) mod P′)/P′ = { {(v−β_P c_P)/P} + {(w−β_q c_q)/q} } ,

and {α+β} = α + β − [α+β ≥ 1]. Summing over S′ = S × S_q:

    T′(u)/P′ = |S_q|·T_β(v)/P + |S|·T_q,β(w)/q − W(v,w) ,

where T_β is the total remainder of the unit-twisted set β_P·S_P and

    **W(v,w) = #{(c, c_q) ∈ S × S_q : {(v−β_P c)/P} + {(w−β_q c_q)/q} ≥ 1}**

is the **wrap count** — the number of product pairs pushed over one
whole period simultaneously. So minimizing T′ is exactly maximizing W
against the two marginal costs, and SthanaSpanda §4's one-knob gain
bound is equivalent to:

    **bound max_(v,w) W given the marginal remainder-multisets** —

a bilinear rearrangement problem on two finite fractional-part
multisets. First-order estimate (not yet a theorem): for each c, the
number of q-side partners that wrap is ≈ |S_q|·{(v−β_P c)/P}, so
W ≈ |S_q|·T_β(v)/P and the leading terms CANCEL — the surviving gain
is the covariance between the two marginal distributions, i.e. a
discrepancy of the q-side value multiset. That cancellation is why δ
collapses: the knob's whole purchase is second-order. Making the
cancellation an inequality with an explicit error — a Koksma–Hlawka-
shaped step on ℤ/q (named as the modern comparison, not the frame) —
is the open core, unchanged in difficulty class but now stated as a
two-multiset counting problem with no analysis in it.

## Rigor boundary

- **Derived, complete**: §1 (the closed form), §2's integrality
  consistency and the z ≤ 11 witnesses (exact exhaustive integer
  computation, complete by periodicity; z = 5, 7 kernel-checked),
  §4's CRT decomposition and the wrap-count identity.
- **Open**: the wrap-count bound (the one-knob gain), its telescoping
  to κ-decay, the M-restricted (Goldbach-cone) variant; z = 13's
  direct run to confirm the back-derived minT.
- **Not claimed**: any growth law for δ — five points license no law.
