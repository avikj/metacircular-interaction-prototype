# 0806 — the three D0020 refutations, checked; and the one that was only a witness

*Ramanujan lane, 2026-08-15. Toolchain: Agda 2.8.0 + cubical v0.9 (the pin),
`LC_ALL=C.UTF-8` set for every run. Exit codes below are real.*

## What I was asked, and what I found first

I was sent to formalise the three exact refutations of `notes/D0020_LEDGER.md`
(rows 8.5, 1.5, 0.3) into `formal/cubical/NaturalMachine/TransmissionRefutations.agda`.

**That file already exists in HEAD, 682 lines, and does the job.** I discovered
this only after writing my own draft, by `git status` showing the path as
modified rather than untracked. I restored the tracked file byte-for-byte
(`git checkout --`) and kept my draft out of the tree. **Nothing of the prior
agent's work was overwritten.** Standing check "verify claimed prior edits by
READING" — the prompt did not claim the file existed, and I should have looked
before writing rather than after. Recording the near-miss because a silent
clobber of a 682-line checked module is exactly the failure this repository
keeps trying to stop.

## The ledger's arithmetic, verified independently

I re-derived all three by hand from the archive before reading the ledger's §5,
and re-read each display at its line in
`collab/upstream/raw/D0020-owner-fifth-transmission-2026-08-15.md`:

| row | archive line | display present? | ledger's arithmetic |
|---|---|---|---|
| 8.5 | 390, 393 | **yes, verbatim** | **correct** — on a prime: μ²=1, ω=1 so Π_∂=1; λ=−1 so (1−λ)/2=1, 𝟙_℘=1, RHS=0. Off by exactly 1. Holds on *pq* and *p²*. |
| 1.5 | 82–83 | **yes, verbatim** | **correct** — δ∣ν makes the floor inert, so the sum is Σ_{d∣n} μ(d)(n/d)=φ(n); ν=3 gives 3−1=2. Companion Σ_{δ∣ν}μ(δ)=[ν=1] is right. |
| 0.3 | 33, 36 | **yes, verbatim** | **correct** — nine finitary operations, κ least closed superset, hence idempotent, hence Θ_ν=Θ₁ for ν≥1. |

**No refutation of the ledger to report.** All three stand, and the archive is
not lossy at any of the three displays — so no verdict here rests on an absence.
Also confirmed: ℘ is fixed as primality at archive line 81, which is what makes
the ledger's reading of 𝟙_℘ the only supported one.

## The gap that was left, and is now closed

`TransmissionRefutations.agda` is honest about its own limit, at A.4:

> "'every prime has those values' — checked here only at ν = 2, 3, 5, 7, 11,
> 13, 17, 19, 23 … NOT claimed as a closed Agda theorem over all primes."

Nine witnesses are not "every prime". **New module:
`formal/cubical/NaturalMachine/PiPartialOnEveryPrime.agda`**, which closes it by
changing the representation, not the argument: ν is represented by its multiset
of prime exponents (a `List ℕ`, entry k = exponent k+1), on which ω, Ω, μ², λ,
𝟙_℘ are *definitions* rather than algorithms. Then:

- `Ω≡1→shape` / `Ω≡2→shape` — the ledger's table says "the three shapes with
  1 ≤ Ω ≤ 2"; **that there are exactly three is proved**, not read off.
- `fails-on-every-prime` — for **every** shape with Ω = 1, ¬(Π_∂ = RHS).
- `off-by-exactly-one` — Π_∂ = RHS + 1, universally.
- `holds-on-every-Ω2` — the display *does* hold on both Ω = 2 shapes, so the
  refutation is not read wider than it is.
- `repair-on-whole-range` — the ledger's repair (delete 𝟙_℘) proved over the
  whole hypothesis, not over a range of numerals.
- `fails-pp-on-every-prime` — the ledger's *alternative* reading (𝟙_℘ = prime
  powers) refuted universally too, on primes and on prime squares.
- `halfLemma` / `parity` — (1−λ)/2 written without division, and the naming
  discharged: 2·par n = 1 − lam n.

**Price of the model, stated in the file's §6 and here:** unique factorisation
is assumed (classical, not re-proved), and nothing links a shape to a numeral.
That link is exactly what the existing module supplies from the other side by
trial division. **The two modules meet in the middle and neither is redundant**;
a reader who doubts the model reads the old one, a reader who doubts nine
witnesses reads the new one.

I did **not** duplicate Sections B (Möbius) or C (the tower). The existing
Section B defines μ and φ by trial division rather than tabulating them, which
is stronger than what I had drafted; Section C parameterises the nine operations
as *relations*, which is better than my functional version because it stays
compatible with row 0.6's "Γ is not a function".

## Scope limits

- Row 1.5 remains **instances only** in the corpus (ν ≤ 12 in the existing
  module). Σ_{d∣n} μ(d)(n/d) = φ(n) in general is Möbius inversion and is
  unproved here. A single counterexample refutes the display; "false for every
  ν ≥ 3" is checked, not proved. Unchanged by this pass.
- Row 0.3's collapse is formalised at ℕ-indexed stages with the ω-union
  explicit; transfinite stages are prose. Unchanged by this pass.
- Nothing here adjudicates §10's Θ_∞ := ⋃_α Ψ^α(◇₀), which is a *different*
  object under the same name — the overloading the ledger names as what misled
  J8. The existing module's remark that a status (PROGRAMME) is not a
  proposition, so J8 is in *tension* with §0's collapse rather than in formal
  contradiction with it, is right and I have not tried to strengthen it.

## Exit codes under the pin

```
agda-2.8.0 --library-file=<cubical v0.9>   NaturalMachine/TransmissionRefutations.agda   → 0
agda-2.8.0 --library-file=<cubical v0.9>   NaturalMachine/PiPartialOnEveryPrime.agda     → 0
agda-2.6.3 (legacy, cubical v0.5)          NaturalMachine/TransmissionRefutations.agda   → 0
agda-2.6.3 (legacy, cubical v0.5)          NaturalMachine/PiPartialOnEveryPrime.agda     → 0
```

Both modules are `--safe`, no postulates, no holes. Runs were made in a copy of
`formal/cubical` under the scratchpad; no interface file entered the repository.
No Python, no `MATH_ALLOW_PYTHON`, nothing measured, nothing fitted.

*(One housekeeping note for whoever holds the pin: `/root/agda-libs/cubical-v0.9/cubical.agda-lib`
names the library `cubical-0.9` upstream and must be renamed to `cubical` to
satisfy `formal/cubical/natural-machine.agda-lib`'s `depend: cubical`, exactly as
`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.1 records. I made that rename in the
clone, not in the repository.)*
