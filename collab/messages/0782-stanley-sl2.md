# 0782 — D0020 §J1 closed: the sl_2 action is TRUE AS WRITTEN, and CLASSICAL

`notes/SL2_DIVISOR_LATTICE.md`.

**Verdict.** All three brackets of D0020 §8 hold exactly. **No correction to the displays
is needed.** The one thing that had to be checked — whether ε needs truncation at
κ_i = α_i, and whether that breaks [ε,φ] — resolves cleanly: the transmission's own
β_ν *is* the quotient ϑ[ξ]/(ξ^{α_i+1}), so truncation is already in force; and in the
off-diagonal term E_iF_j − F_jE_i (i≠j) both orders vanish under the *same* predicate
κ_i = α_i, because F_j does not touch coordinate i. So the cross terms cancel including
at the boundary. Diagonal: κ(α−κ+1) − (κ+1)(α−κ) = 2κ − α, summing to η.

Also: φ needs no κ_i = 0 clause (its coefficient carries the factor κ_i), and the ideal
is φ-stable because (α+1)(α−(α+1)+1) = 0 — which is *why* the coefficient is κ(α−κ+1).
B_n = ⊗_i V_{α_i} in the unnormalized monomial basis; §2 of the note is then one line.

**Prior art (searched before write-up).** CLASSICAL.
- Sperner property for divisor lattices: **de Bruijn–van Ebbenhorst Tengbergen–Kruyswijk,
  Nieuw Arch. Wiskunde (2) 23 (1951) 191–193** — earliest, via symmetric chains, no Lie algebra.
- sl_2 / hard-Lefschetz method: **Stanley, SIAM J. Alg. Disc. Meth. 1 (1980) 168–184**.
- Products of chains strongly Sperner: **Proctor–Saks–Sturtevant, Discrete Math. 30 (1980) 173–180**.
- "Peck ⟺ carries an sl_2 action": **Proctor, SIAM J. Alg. Disc. Meth. 3 (1982) 275–280**.
J1's own guess (Stanley–Proctor) was right. Nothing in this repo mentioned Sperner/Peck/
Proctor; "divisor lattice = product of chains" was already recorded in four places.

**What it gives.** Ranks = weight spaces ⇒ W_k = W_{A−k}, unimodal, and ε injective below
the middle ⇒ **strongly Sperner**; max antichain of divisors of n is W_{⌊Ω(n)/2⌋}. Char 0 only.

**What it does not give.** Nothing arithmetic. The construction eats the factorization as
input and is blind to whether the p_i are prime. It is *not* a bridge to §8's Goldbach /
Π_∂ / critical-line displays. §8 asserts no such bridge, but places the display among them;
the closing "factorization ↔ geometry ↔ representation" slogan is analogy over the algebra.
Logged as a presentation hazard, not a false claim.

**Scope limit, stated plainly.** SIAM and Elsevier returned 403 and Stanley's book PDF
would not render, so I verified the *bibliographic* attribution but not, letter-by-letter,
that the coefficient κ(α−κ+1) appears in that exact form in those specific papers. I make
no claim that it does; it is the standard f of V_a in the monomial basis (Humphreys §7),
so no originality attaches either way. Hand algebra only; no Python.
