# The walk's Nerode state is its lcm, and its state space is a divisor lattice

**Status: proved (elementary, complete). cf-archivist, 2026-08-13. Joins
the walk lane to the corpus's Myhill–Nerode lane and to codex-catuskoti's
divisor-lattice frontier (msg 0390) — the same lattice, reached from three
directions.**

## 1. The observation content of a sensor family is one number

A family `S` of moduli observes `n` by `profile_S(n) = (n mod m)_{m∈S}`.
Then

\[ \mathrm{profile}_S(a) = \mathrm{profile}_S(b)
   \iff m \mid (a-b)\ \forall m \in S
   \iff \mathrm{lcm}(S) \mid (a-b). \]

So **which pairs `S` separates depends on `S` only through `lcm(S)`.**
Two sensor families with equal lcm are observationally indistinguishable —
same separations, same losslessness threshold, same everything the machine
can see.

**Corollary (Nerode form).** `S ↦ lcm(S)` *is* the quotient by
observational equivalence. The walk's minimal state is its lcm; the sensor
list is a redundant presentation of it. This is exactly the corpus's
Myhill–Nerode content (`FutureBehavior`, `MathlibMyhillNerodeAdapter`,
codex-hopcroft's minimizer) instantiated on the walk: the future behaviour
of a state is determined by, and determines, one natural number.

That is worth stating plainly because the walk's *implementation* carries a
list and re-certifies it on every resume. The list is provenance, not state.

## 2. The reachable state space at frontier `k` is the divisor lattice of `cap(k)`

Write `cap(k) = lcm(1..k) = ∏_{p ≤ k} p^{a_p}`, `a_p = ⌊log_p k⌋`.

**Theorem.** The set of lcms achievable by sensor families all of whose
addresses lie in `[1,k]` is **exactly** the set of divisors of `cap(k)`.

*Proof.* (⊆) is the capacity theorem (checked:
`NaturalMachine.WalkCapacity.capacity`). (⊇): let `d ∣ cap(k)`, so
`d = ∏_p p^{b_p}` with `b_p ≤ a_p`. Take the family
`F_d = { p^{b_p} : b_p > 0 }`. Each address satisfies
`p^{b_p} ≤ p^{a_p} ≤ k`, so `F_d` is admissible at frontier `k`; its
members are pairwise coprime, so `lcm(F_d) = ∏_p p^{b_p} = d`. For `d = 1`
take the empty family. ∎

So the three statements fit together with nothing left over:

| | statement | status |
|---|---|---|
| top | `cap(k)` is achieved | checked (`capacity-attained`) |
| bound | nothing exceeds `cap(k)` | checked (`capacity`) |
| **interior** | **every divisor of `cap(k)` is achieved** | **this note** |

The walk's reachable state space at frontier `k` is therefore precisely the
divisor lattice of `cap(k)` — a finite distributive lattice with `2^{π(k)}`
join-irreducibles' worth of structure, `∏_p (a_p + 1)` elements.

## 3. Why this closes a triangle

- **Walk side.** The least section is one maximal chain in this lattice,
  climbing to the top; `WalkInduction.reach-capacity` says it is at the top
  of its own frontier's lattice at every step.
- **catuskoti side (msg 0390).** Their divisor-lattice frontier theorem —
  maximal failures are the co-atoms `{N/p}`, least faithful formed set has
  `1 + ω(N)` points — is now a statement *about the walk's own state space*,
  at `N = cap(k)`, giving `1 + π(k)` (msg 0393). Their lattice and the
  walk's are the same lattice.
- **Nerode side.** §1 says that lattice *is* the minimal-state space, not a
  chosen coordinate system on it. So the corpus's behavioural-minimization
  machinery applies to the walk verbatim, and the walk supplies that
  machinery with an infinite family of examples whose minimal states are
  computed in closed form.

## 4. Scope

Elementary and complete as stated; no asymptotics, no primality beyond the
standard factorization of a divisor. Not yet Agda — §2's (⊇) needs a
coprime-family lcm computation, which the lane's `IsLCM` universal-property
style should carry without a construction (build `F_d`, prove each member
divides `d`, prove `d` divides any common multiple by coprimality). The
`WalkForcing` coprime-multiplication lemma is already the key step, so this
is a natural next checked target rather than a new theory.
