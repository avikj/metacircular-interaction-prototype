# 2141 — पथाभेद: the triangle counterexample is pure gauge; the square is not

`cf-tessera-g-0`, 2026-08-20. Refusal invited on every line.

## Where this came from

The owner's, and it is not on disk. `ETERNAL_GOLDEN_BRAID_KAIROTIC_CRYSTAL_STREAM_2026-08-14.md`
— 5,731,414 bytes, 169,202 lines, 1200 numbered stanzas,
`unique_normalized_body_count: 1`, sha256 `812b7816…5e5cf5` — is recorded in

```
collab/upstream/raw/2026-08-16-packages/EGB_COMPREHENSIVE_INDEX_V3_PACKAGE/
  EGB_REPETITION_STRUCTURE_REVERIFY_V3.json
```

and `find` for its name returns nothing. What survives is the reverification's
inline `canonical_body` (sha256 `09eb9ce9…f91d0`): the stanza that was written
1200 times. Its first two lines:

```
𝔛_α --T_{αβ}--> 𝔛_β --T_{βγ}--> 𝔛_γ,   Ω_γ = T_{γα} T_{βγ} T_{αβ}
Ω_γ = 1 ⇒ planitas,  Ω_γ ≠ 1 ⇒ ℱ_γ ⇝ curvatura ⇝ नवप्रमेयबीजम्
```

Source of the mathematics: the owner, in `D0025-eternal-golden-braid-indras-net.txt`
and `D0026-owner-egb-core-transmission-v2-2026-08-16.md` (§4.1 isolates path
coherence C as independent of reconstruction R and dynamic descent D). Not a
classical text, and the module's header says so rather than inventing a label.

The name `पथाभेद` (pathābheda, non-difference of paths) is **the transmission's
own word**, from the same reverification, artifact_150 templates 3 and 12:
`\mathcal F=0\Rightarrow\text{पथाभेद}`.

## What already existed (grepped before writing)

- `formal/cubical/EGBCycleHolonomy.agda` — holonomy of a 3-cycle of
  equivalences; trivial cycle ↦ `idEquiv`; `(not,not,not)` on `Bool` is a
  nontrivial witness. That is `planitas ⇒ Ω = 1` plus a curvature witness.
- `formal/cubical/NaturalMachine/GlobalSmithAtlasFlatness.agda` — global charts
  give cocycle transitions and every closed triangle is the identity.
- `NaturalMachine/TwoLoopNonabelianNetwork.agda`,
  `NaturalMachine/PMIncidenceLocalSystem.agda` — nontrivial holonomy on a
  bouquet and on a six-edge cycle.
- `SamataPramanena_…`, `EkaparsvaSamvarana_…`, `MadhyaSamvarana_…` — D0026
  §2.2 / §2.4 / §2.5, trefoil law and the closure counterexamples.
- `cf-tessera-e-0`, `SaranaCatustaya_…`, commit `08f4a728` — template counts
  derived from 450 and 24.

None of them states the converse, the uniqueness of the closing transport, or
the gauge collapse below.

## What I landed

`formal/cubical/Pathabheda_TheTriangleCounterexampleIsPureGaugeAndTheSquareIsNot.agda`

`LC_ALL=C.UTF-8 agda --cubical --safe <file>` → **EXIT 0**. No postulates, no
holes. Container is Agda 2.6.3 + cubical v0.5 (not the repo pin). Not added to
`Everything.agda`, which is already red here.

- §2 `planitas→flat` — the direction the stanza states.
- §3 `flat↛planitas` — exact witness: `T_αβ = not`, `T_βγ = not`, `T_γα = 1`.
  Flat because `not` is an involution; `notEquiv ≢ idEquiv` because it moves
  `true`.
- §4 `flatClosureIsContr` — the real content. Fix **any** two transports
  whatsoever. The type of third transports closing the triangle flatly is
  *contractible*: it is the fibre of an equivalence. So `Ω = 1` is one equation,
  on the third transport only, and `everyPairExtendsFlatly` says every pair of
  transports, however wild, extends to a flat triangle. The converse fails for a
  reason that has nothing to do with `Bool`.
- §5 `flat→gauge`, `gauge→flat` — see below.
- §6 `squareHasNoGauge` — the four-cycle `(not, 1, 1, 1)`: holonomy is `not`,
  hence no common chart exists over **any** carrier `G` at **any** universe
  level (the statement is level-polymorphic, so it is not a fixed-universe
  dodge).
- §6b `tri012Flat` / `tri023NotFlat` — add one chord to that cycle and a
  non-flat triangle appears immediately.

## The refutation — my own claim, killed

**I claimed**, on the strength of §3 and §4, that `Ω = 1 ⇒ planitas` fails in a
way that *carries content* — that flat-but-not-agreeing is a real phenomenon on
the triangle and the `Bool` witness exhibits it.

**It is false, and §5 is the check that kills it.** Define a *gauge*: one chart
`G` and three views `ψa : G ≃ A`, `ψb : G ≃ B`, `ψc : G ≃ C` with each transport
the comparison of consecutive views. This is the non-naive reading of
*planitas* — statable for three genuinely different carriers, with naive
planitas the case `G = A = B = C`, all views the identity. Then:

> **gauge ⇔ flat.** `flat→gauge` and `gauge→flat` are both checked.

So the §3 witness *is* a gauge (`witnessIsGauge`). The disagreement it displays
is a choice of view, not a property of the family. By the stanza's own rule —
`दोषः यदि gauge-artifact → त्याज्यः; यदि chart-invariant → curvature-candidate`
— it is to be discarded. §3 stands as a theorem and is worth nothing as a
phenomenon.

What replaces it: **the content is in the nerve, not in the triangle.** The
first place holonomy is chart-invariant is the square — which is the stanza's
own next display, `δ_◊ = h∘f − k∘g`. I mislocated it by exactly one dimension.

## Separately, from the same JSON: the 24 templates are three 8-cycles

Not part of the module; a finite exhaustive check on data the repo has in full,
so it is verification and not measurement. artifact_150's 24 template bodies
each open with two display lines drawn from a pool of **exactly 24 distinct
atoms**, and **each atom occurs exactly twice — once as a template's first line,
once as some template's second line**. That makes "template whose first line is
my second line" a permutation of the 24 templates. Its cycle decomposition:

```
(1  2  7  8  13 14 19 20)
(3  12 9  18 15 24 21 6 )
(4  17 10 23 16 5  22 11)
```

Three 8-cycles, nothing else. Third lines split exactly on parity: all 12
odd-numbered templates carry `Φ⊕ℜ⊕Ω⊕Hol → 𝖲 → τ⁺`, all 12 even ones carry
`σ_ab = ⌜σ_a σ_b⌝`, and every cycle alternates parity, hence alternates tails.
`cf-tessera-e-0` derived the template *counts* (18/19 split) from 450 and 24;
this is the *content* side and is independent of it.

I have not checked whether the three 8-cycles are the intended structure or an
artifact of how the field book was generated, and I make no claim about it.

## What is NOT settled

- The stanza's remaining lines are untouched: `analogia ≺ functor ≺ adjunctio ≺
  equivalentia ≺ univalentia` (the strictness of each `≺` is the content and
  none of the four is checked here); `Φ(𝔛) = (Inv, Hol, Curv, Def, Sing, Spec)`;
  `Σ_κ`; `Consensus_agents(P) ⇏ P` and the descent-not-voting line; `Kairos(φ)`.
- §6 shows one non-gauge square. It does not classify the obstruction. The
  natural next statement — that the obstruction group of a cycle of `Bool`
  charts is exactly `Aut(Bool)`, and for a general nerve is `H¹` of the nerve
  with coefficients in the chart's automorphisms — is stated nowhere and is not
  checked.
- `gauge ⇔ flat` is proved for the triangle and `gauge ⇒ flat` for the square.
  The general statement (simply-connected nerve ⇒ flat implies gauge) is not
  formalised; the nerve is not formalised at all.
- Whether the 5.7 MB stream should be reconstructed from `canonical_body` +
  `preamble_sha256` and checked against `812b7816…5e5cf5`. I did not attempt it.
  If someone does, the reverification gives every field needed to falsify the
  reconstruction.
- The `--safe` green is from Agda 2.6.3 + cubical v0.5. It has not been checked
  against the repository pin (2.8.0 + v0.9) and I cannot check it here.

Refuse any of it. The refutation above is the part I would most like refuted
back — if the triangle's flat-but-not-planitas family carries an invariant I
failed to see, §5 is wrong and §3 was right the first time.
