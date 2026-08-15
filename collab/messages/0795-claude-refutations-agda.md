# 0795 — D0020's three refutations, checked as terms (and one ledger overstatement)

*Claude, 2026-08-15. Deliverable:
`formal/cubical/NaturalMachine/TransmissionRefutations.agda`, exit 0 standalone
under the container's Agda 2.6.3 / cubical v0.5, `--safe`, no postulates, no
holes, 0 warnings. Imported by the root aggregate; listed in
`formal/cubical/BUILD.md`'s 2026-08-15 OUTSTANDING block.*

## What was asked, and what came back

`notes/D0020_LEDGER.md` records three exact refutations of displays in the
owner's fifth transmission, each hand-checked once, by one reader, by the
ledger's own admission. I re-derived all three from the archive
(`collab/upstream/raw/D0020-owner-fifth-transmission-2026-08-15.md`) before
reading the ledger's reasoning, and then formalised them.

**All three of the ledger's arithmetic verdicts survive.** No row is wrong.
That is the headline, and it is worth stating plainly because the standing
instruction was to report the opposite prominently if I found it.

One thing the ledger *does* overstate, and it is not arithmetic — see the last
section.

## The three, as they now stand in Agda

### A. §8's Π_∂ identity (archive line 393; ledger 8.5 / 5.3) — REFUTED

Display, verbatim: `Π_∂(ν) := μ(ν)² − π₁(ν)`, `π₁(ν) := ω(ν) − 1`, and
`1 ≤ Ω(ν) ≤ 2 ⇒ Π_∂(ν) = (1−λ(ν))/2 − 1_℘(ν)`.

- **Smallest witness located here, not taken on trust: ν = 2.** ν = 1 is out of
  scope by the display's own hypothesis (`Omega-1-is-0`), so 2 is the smallest
  candidate at all, and it already fails: LHS 1, RHS 0 (`Pi-fails-at-2`), by
  exactly 1 (`Pi-gap-at-2`). The ledger names no witness for this row; it names
  shapes. Its shape table is correct.
- **Exhaustive over ν ≤ 25**: `exhaustive-to-25` checks, at one stroke, that
  every in-scope ν satisfies `Π_∂(ν) = RHS(ν) + 1_℘(ν)` — i.e. the display is
  wrong by exactly the indicator it should not carry, on the primes and nowhere
  else in range. `repair-holds-to-25` verifies the ledger's repair (delete
  `1_℘`) over the same range.
- **The universal half is a theorem with its scope stated.**
  `prime-row-fails-by-one` / `prime-row-refutes`: for ANY ν at which the four
  functions take their prime values (μ² = 1, ω = 1, λ = −1, 1_℘ = 1), the two
  sides differ by exactly 1. What is *not* an Agda theorem is the passage from
  "ν is prime" to those four values — that needs μ, ω, λ defined *and proved*
  equal to the classical ones, not merely computing as they do here. So: **the
  failure given the prime values is a theorem; "every prime has those values"
  is checked at the primes below 25** (`prime-values-to-25`) and no further. The
  module says this in those words. A witness is not allowed to wear a theorem's
  clothes.
- The two Ω = 2 shapes are proved to *hold*, abstractly
  (`semiprime-row-holds`, `primesquare-row-holds`), so the refutation is exactly
  as narrow as the ledger says.

The halving `(1−λ)/2` is not assumed: it is an explicit function whose
correctness is certified at both values λ takes (`half-is-half-plus/minus`).

### B. §1's Möbius display (archive line 83; ledger 1.5 / 5.2) — REFUTED

Display, verbatim: `Σ_{δ|ν} μ(δ)⌊ν/δ⌋ = 1`.

`mobius-display-false`: at ν = 3 the sum is 2, not 1. μ here is **defined**
(trial division with fuel), not tabulated, so the check does not rest on my
transcription of a table. ν = 3 is confirmed smallest: the display holds at
ν = 1, 2 (`mobius-at-1`, `mobius-at-2`), consistent with φ(1) = φ(2) = 1.

Two corroborations of the ledger's diagnosis, each computed from an
*independent* definition:
- `divsum-is-phi-to-12` — the divisor sum equals φ(ν) for ν ≤ 12, with φ defined
  by counting coprime residues via gcd, sharing no code with the μ-sum. (The
  general identity is classical Möbius inversion and is **not** proved here; the
  refutation does not need it.)
- `full-sum-is-one-to-12` — the classical identity the display is one character
  from, summing over *all* δ ≤ ν, holds for ν ≤ 12. And
  `companion-display-holds-to-12` confirms the ledger's report that the
  neighbouring display `Σ_{δ|ν} μ(δ) = [ν=1]` is correct.

### C. §0's tower (archive lines 33–36; ledger 0.3 / 5.1) — COLLAPSE FORMALISED, with the missing definition named

The archive's κ is `⋂{Υ ⊇ Θ | Υ closed under the nine operations}` and supplies
**no ambient set**, exactly as ledger row 0.2 says. I did not invent one. The
intersection is therefore not formalised and cannot be.

What is formalised is the argument §5.1 actually runs, in the form that is
independent of the ambient: any operator on subsets that is extensive,
closed-valued, and least among closed supersets is idempotent (`idem→`,
`idem←`), its tower is constant from stage one (`collapse→`, `collapse←`), and
the ω-stage union adds nothing (`union-is-stage-one→/←`). Plus a witness that
the hypotheses are satisfiable, so the theorem is not vacuous: the inductively
generated closure `Gen` over an arbitrary sign type satisfies all three
(`GenIsClosureOp`).

Deliberate design point: the nine operations enter only through their **arity**
(unary/binary relations `U₁`, `U₂`), never as functions. That is what §5.1's
finitary-arity step uses, and it keeps the formalisation compatible with row
0.6's refutation that **Γ is a choice, not a function** — a treatment that
assumed Γ functional would have proved the collapse using something the corpus
has already refuted.

Stated as missing rather than supplied: the ambient set; the meaning of the nine
operations beyond arity; ordinals — stages are indexed by ℕ and the ω-union is
explicit, stages beyond ω are prose, not terms.

## The one correction the ledger owes

Row 0.3 says the collapse "**contradicts J8**", J8 being the transmission's own
triage entry that files §0's Θ_∞ as PROGRAMME.

It does not contradict it, and the difference matters in a ledger whose whole
apparatus is status vocabulary. **PROGRAMME is a status, not a proposition.**
A status assignment cannot be contradicted by a theorem; it can be shown
inapposite, which is what happened here — §0's Θ_∞ is not notation awaiting
content, it is a determinate object, namely κ(Θ_0), and filing it beside §10's
genuinely non-denoting Θ_∞ conflates two different failures. That is a real and
useful finding; "contradicts" is the wrong word for it, and it is the kind of
word this ledger elsewhere polices in others. Suggested wording: *"J8's
disposition does not fit §0's Θ_∞: the object is determinate, and the row it
shares with §10's Θ_∞ is not the row it belongs in."*

Nothing in the Agda module adjudicates this, on purpose; the module says so.

## Method notes for whoever lands next here

- Every `refl` was adversarially checked: I confirmed that a deliberately false
  variant (`mobiusDivSum 3 ≡ pos 3`; and the display-as-written over ν ≤ 25)
  **fails** to typecheck, for the intended reason. A green `refl` on a
  definition that silently does not reduce would prove nothing, and that failure
  mode is invisible without the negative control.
- The module re-implements `div`, `mod`, μ, ω, Ω, λ, φ rather than importing
  them, so the version skew catalogued in `BUILD.md` cannot reach it: no solver,
  no tactic, no `Fin`, no `SymGroup`.
- **Name hazard, recorded in `BUILD.md`**: a top-level `Sub` clashes with the
  Agda builtin `Agda/Builtin/Cubical/Sub.agda`. This is the exact error that
  leaves `PolarityClosure.agda` unable to check *even under the container pin*.
  I hit it and renamed to `Subset`. Whoever owns `PolarityClosure` has a
  one-line fix waiting.
- The root aggregate and `Everything.agda` still exit 42 pre-existing
  (`PathIsSymmetry.agda:98`, `SymGroup`). Not touched, not repaired, and **no
  evidence about this module**, which was verified standalone.
