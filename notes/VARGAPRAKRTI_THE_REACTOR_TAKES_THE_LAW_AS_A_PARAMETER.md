# वर्गप्रकृतिः — the reactor takes the law as a parameter

*What runs, what it answered, and the four defects it refused to collapse.*

---

## 0 · The charge and the finding

`machine/Nalanda.hs` states the diagnosis exactly: an enumerator has no
growth rule, and Brahmagupta's rule is not a filter — given two solutions it
COMPUTES a third, the invariant multiplies, and the cakravāla supplies the
fuel by descending. That is right. What it does not do is take its own
diagnosis to the end: the law is **welded in**. `bhavana` hard-codes
N(x,y) = x² − D y², `chooseM` hard-codes the interpolator (m, 1, m² − D),
and the stopping condition is N = +1.

That weld is not Brahmagupta's. The *Brāhmasphuṭasiddhānta* (628) ch. 18
composes **varga-prakṛti** with arbitrary kṣepa; x² − D y² = 1 is one row of
his table and the row Euler's misattribution later made the whole subject.
Restricting a reactor built on the 628 rule to that row is reading the source
through the equation that displaced it.

**So the law is now a value.** `Law v` in
`machine/VargaPrakrti_CompositionLawAsParameter.hs` is exactly the three legs
and nothing else:

| leg | field | source |
|---|---|---|
| 1 · two results to a third | `lawCompose` | Brahmagupta, *Brāhmasphuṭasiddhānta* 18, 628 |
| 2 · an invariant that multiplies | `lawNorm` | Brahmagupta, same |
| 3 · a descent made exact by a congruence | `lawDescend` | Āryabhaṭa, *Āryabhaṭīya*, Gaṇitapāda 32–33, 499; Jayadeva ~950; Bhāskara II, *Bījagaṇita*, 1150 |

`reactor` consumes those three. It does not know what a quadratic form is.

## 1 · What the generalisation is

ℤ[ω] with ω² = T·ω + C, for any integers T, C with Δ = T² + 4C positive and
non-square:

    N(x, y) = x² + T·x·y − C·y²
    (x₁+y₁ω)(x₂+y₂ω) = (x₁x₂ + C y₁y₂) + (x₁y₂ + x₂y₁ + T y₁y₂) ω
    step:  a′ = (am + Cb)/k,  b′ = (a + b(m+T))/k,  k′ = (m² + Tm − C)/k
    choice: among m with k | (a + b(m+T)) and 2m + T > 0,
            the one minimising |m² + Tm − C|

T = 0, C = D is `Nalanda`'s ℤ[√D], recovered as one point of the family
rather than as the family. **T = 1, C = (Δ−1)/4 is the maximal order
ℤ[(1+√Δ)/2] of a discriminant Δ ≡ 1 (mod 4)** — which ℤ[√Δ] sits inside with
index 2, and which x² − D y² = 1 cannot see.

The stopping condition is |N| = 1, not N = 1: the answer is the fundamental
**unit**, which differs from the Pell solution by a square exactly when the
norm −1 equation is solvable.

## 2 · The answer

    runghc -imachine machine/VargaPrakrtiRun_TurnTheGeneralWheel.hs 61

    turn   x        y      N
    0      3        1      -3
    1      7        2      3
    2      17       5      -1

**Δ = 61: ε = (17, 5) in the basis (1, ω), that is ε = (39 + 5√61)/2 with
N(ε) = −1, in two turns of the wheel.**

Bhāskara's own worked example, (1766319049, 226153980), is **ε⁶** — and the
kernel says so. `formal/cubical/VargaPrakrtiWitness_FundamentalUnitOfTheOrder.agda`
is emitted by the reactor and checks `exit 0`, `--safe`, no postulates, no
holes, zero warnings, under the toolchain `BUILD.md` pins (Agda 2.8.0,
cubical v0.9). It carries every turn as an instance of `cakravalaTraceℕ`,
the bookkeeping as ℕ `refl`s, the unit as a `refl`, the ladder ε … ε⁶ each
rung an instance of `bhavanaTraceℕ`, and finally

    transport⁶ : (2 · 1540165069 + 452307960 ≡ 2 · u) × (452307960 ≡ 2 · v)
    transport⁶ = refl , refl        -- u = 1766319049, v = 226153980

**The generalisation does not replace the received answer. It contains it,
as a power, and reaches it from a smaller object in fewer turns.** That is
the sūtra's first path (§6, संक्रमणे न किञ्चिन् नश्यति) done as a checked term
rather than as a claim.

The whole loop, verdict returning into the machine:

    runghc -imachine machine/VargaPrakrtiCertify_KernelVerdictComesBackIn.hs \
      5 13 21 29 61 109 421 601 889 9949

    Δ = 9949   49 turns   ε = (94066269512658773023382172872264357,
                                1905242392545245797181244822046025)   N(ε) = −1
    10 of 10 certified by the kernel

A 35-digit fundamental unit, emitted and adjudicated by a kernel that never
saw the generator. Exact `Integer` throughout; the square root is Newton over
`Integer`; there is no floating point anywhere and no fitted constant.

The general laws are proved for **all** naturals in
`formal/cubical/VargaPrakrti_TraceBhavanaOverN.agda`: `bhavanaTraceℕ`,
`cakravalaTraceℕ`, and — the containment, `transport`ed out of the general
theorem rather than re-solved — `brahmaguptaIsTheTraceZeroCase` and
`cakravalaIsTheTraceZeroCase`, which are `BhavanaSemiring.bhavanaℕ` and
`CakravalaNat.cakravalaℕ` verbatim.

## 3 · Four defects, written, with their instances

### 3.1 · `Nalanda.step`'s per-coordinate `abs` is unsound off T = 0

`Nalanda.step` ends `Triple (abs a') (abs b') k'`. Sound at T = 0, where
N(x,y) = x² − D y² depends on x and y only through their squares. At T ≠ 0
the cross term T·x·y changes sign with either coordinate alone, so `abs` on
a coordinate silently changes the norm. Instance: T = 1, C = 15,
N(17, 5) = 289 + 85 − 375 = −1, while N(17, −5) = 289 − 85 − 375 = −171.

Not a bug in `Nalanda` — it is correct in its own domain — but it is the
first thing the generalisation breaks, and it is why the general reactor
normalises only by negating **both** coordinates.

### 3.2 · The conjugate root collapses the wheel to the trivial unit

|m² + Tm − C| = |m − ρ|·|m − ρ̄| with ρ = (−T + √Δ)/2 and ρ̄ = (−T − √Δ)/2, so
it is small near **either** root. The candidate near ρ̄ is the previous turn
run backwards. Instance, and it is not hypothetical — it is what the first
running version of this reactor did: at Δ = 61, T = 1, from the seed (3, 1)
with k = −3, the congruence class is m ≡ 2 (mod 3) and the minimiser over the
whole class is **m = −4**, giving |16 − 4 − 15| = 3 against m = 2's
|4 + 2 − 15| = 9. Taking it returns (1, 0) in one turn — the trivial unit, an
answer that is true and empty.

The classical rule's "m > 0" is this condition at T = 0, where ρ̄ = −√D is
negative and the constraint is invisible. The general form is **2m + T > 0**.

### 3.3 · The turn bound stands in for a theorem that is not here

Termination of the cycle is Lagrange (1768) for T = 0 and is open in this
repository — `CakravalaDescent.agda` says so verbatim, and
`CakravalaBound.agda` proves the window 16k′² ≤ 36D, not that the wheel
closes. So the reactor's cap is **named** (`defaultCap`) and a run that
reaches it returns a defect saying it is the bound being reached and not an
obstruction, with the norm it stopped at.

Measured: across the **49762** discriminants Δ ≡ 1 (mod 4) below 200001, a cap
of 600 produced exactly **15** stops, every one still descending with |k| < 200
— the largest units in the range need up to 598 turns. At cap 3000, **zero**
stops. The 15 were a stated limit, not a mathematical failure, and the
distinction is now impossible to blur because the defect text says which.

### 3.4 · Leg 3 is absent at ℤ[∛d], and the Nalanda certificate chain is
broken under the pinned toolchain

**The cubic.** `ghanaLaw d` supplies legs 1 and 2 exactly — multiplication in
ℤ[∛d], norm x³ + d y³ + d² z³ − 3d xyz, multiplicativity re-checked at every
composition — so the *generative* half of the reactor runs there unchanged
and produces certified units (ε = ∛2 − 1, N(ε) = 1; ε² = 1 − 2∛2 + ∛4,
N = 1). Leg 3 is absent: the cakravāla's interpolator (m, 1) has norm
quadratic in **one** unknown, so Bhāskara's rule minimises over a single
residue class and the kuṭṭaka — one linear congruence — makes the division
exact. In ℤ[∛d] the interpolator is (m, n, 1) with norm cubic in **two**
unknowns; there is no single congruence whose class contains the minimiser.
`lawDescend` returns the defect with the failing instance: from (1, 1, 0)
with N = 3, composing with (−1, −1, 1) gives (1, −2, 0), residues (1, 1, 0)
mod 3 — not all zero, so the division is not exact. What closes it is named
so the next reader does not re-derive the hole: Voronoi's chain of relative
minima (1896), a two-dimensional descent. Not implemented, not claimed.

The name `ghana` ("cube") is descriptive and is marked as such in the source.
**No cubic norm form is in the corpus this repository reads**, and inventing
a Sanskrit provenance for one would be the mirror image of the scrubbing
CLAUDE.md forbids.

**The toolchain.** `Brahmagupta.agda`, `BhavanaSemiring.agda` and
`CakravalaNat.agda` **do not check** under the toolchain `BUILD.md` pins.
They call `Cubical.Tactics.NatSolver.Reflection.solve` / `CommRingSolver
.Reflection.solve`, the point-free solvers of cubical v0.5; v0.9 replaced
them with the hole macros `solveℕ!` / `solve!`. Reproduce in one command:

    cd formal/cubical && agda BhavanaSemiring.agda
    # [NotInScope] solve

The consequence reaches past those three files: `machine/NalandaEmit.hs`
emits a witness importing `BhavanaSemiring` and `CakravalaNat`, and
`machine/NalandaCertify.hs` hands it to the kernel. **Under the pinned
toolchain that pipeline cannot return a green**, because its dependencies do
not check. (It also looks for interface files under `_build/2.6.3/`, which
is the former pin.)

The repair is mechanical — the import line and one token per theorem,
verified working here. **It is not done in this commit**, because those are
another identity's modules and a silent rewrite of someone else's file has
the same shape as the rename CLAUDE.md forbids. The defect is written with
the reproducing command and the exact substitution that closes it, so it is
an offer and not an edit. `VargaPrakrti_TraceBhavanaOverN.agda` stands alone
instead: it transcribes `cx` and `cy` verbatim, marked as transcription, so
the containment claim is a checked term here and does not wait on the repair.

## 4 · What is here, and what is not

**Here.** The law as a parameter; the fundamental unit rather than the Pell
solution; arbitrary (T, C) including non-canonical bases; the transport of
the received answer as a checked term; certification end to end by an
external kernel; four written defects with reproducing instances.

**Not here, and not claimed.** Termination (§3.3). Minimality of Bhāskara's
choice rule. The cubic descent (§3.4). Non-principal forms — the reactor
runs the principal form of an order and does not compose across ideal
classes, which is where Gauss's composition of forms and the class group
live. Nothing above says anything about those, and the survey that preceded
this work found no form composition and no class group anywhere in
`formal/`, so that is open ground and not a hole this note is covering.

---

*Sources, earliest first.* Āryabhaṭa, *Āryabhaṭīya*, Gaṇitapāda 32–33 (499),
the kuṭṭaka — keep the remainder and recurse; the procedure step by step in
Bhāskara I's *bhāṣya* (629). Brahmagupta, *Brāhmasphuṭasiddhānta* 18 (628),
bhāvanā on varga-prakṛti with arbitrary kṣepa, and the finish from
kṣepa −1, ±2, 4 by composition alone. Jayadeva (~950), surviving through
Udayadivākara's *Sundarī* (1073), the cakravāla. Bhāskara II, *Bījagaṇita*
(1150), the choice rule and the worked case Δ = 61. Brouncker reaches the
problem in 1657; Lagrange proves termination in 1768. Voronoi (1896) for the
cubic descent §3.4 does not have.
