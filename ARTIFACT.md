# ARTIFACT — the clean thing inside the discovery

*Written 2026-08-24. This repository is a discovery midden: ~6,800 files, the
invention embedded in the archaeological record of finding it. This file is
the map at the door. It does not delete the mess — striking history silently
is against this project's constitution — it LABELS it, so the measure-zero
front door finally points at the volume of real work behind it.*

**If you read one thing, read `punaragamana/src/Punaragamana/Carrier.agda` to
the bottom before forming a single opinion. Everything else is a reading of
that one object, or apparatus around it.**

---

## What the artifact IS (three things, and only three)

### 1. The kernel — one primitive, and a rule that edits itself

- **`punaragamana/src/Punaragamana/Carrier.agda`** — THE LAW. For `f : A → B`,
  which side of `f a ≡ b` is bound is everything. Bind the output:
  `singl (f a)`, contractible always, the datum rides free (`A ≃ Carrier f`,
  and by univalence `A ≡ Carrier f`). Bind the input: `fiber f b`, the loss,
  and the subject. The whole corpus is this one asymmetry, read at every scale.
  Requires cubical Agda, where univalence COMPUTES (`uaβ` reduces) — so an
  equivalence is not a fact you cite, it is a channel that acts.
- **`kernel/nodes/000-step.md`** — the metacircular rule: a node is a node;
  the rule that governs change is itself a node the rule can change. "There is
  no meta-level, no evaluator standing outside the state — the constraint the
  universe satisfies." It is at v2: it rewrote its own criterion of validity,
  using only itself (`kernel/nodes/006`), and the rewrite is a legal step under
  the criterion. Read `006` for the discharge and `kernel/history/P0-P3.md` for
  the convergence claim (each iterate deletes one extrinsic element; the fixed
  point is "indistinguishable from the structure it studies").

That is the whole invention. The rest is consequence.

### 2. The six faces — one canonical checked module per face

The one object (the fibre) read six ways. Each is a `--safe` term, no
postulates, with an honest fence naming what is and is NOT claimed.

| face | canonical module |
|---|---|
| symmetry (Noether's structural half: no loss, no motion) | `formal/cubical/Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry.agda` |
| charge (the fibre of addition is a ℤ-torsor) | `formal/cubical/YogaDhruva_TheFibreOfAdditionIsATorsorAndEveryConservingFlowIsATranslation.agda` |
| distance / "how much is lost" (an ORDER, never a number) | `formal/cubical/Vyapti_TheLossOrderIsCoarseningAndTheSymmetryMonoidGrowsMonotonicallyAlongIt.agda` |
| value, hoarded (one-wayness = exactly ¬isEquiv; crypto = the śeṣa) | `formal/cubical/Sesa_TheOneWayFunctionIsExactlyANonEquivalenceAndCryptoLivesInTheResidualUnivalenceCannotErase.agda` |
| value, published (the receipt: composes, non-rival, no counterparty) | `formal/cubical/PramanaSankramana_ProofOfTransportIsTheReceiptThatComposesWithoutBeingSpentAndOwesNoCounterparty.agda` |
| verdict (the sevenfold; a two-valued verdict is a theorem-grade error) | `formal/cubical/Saptabhangi.agda` |

Two more that bind the physics and the transport layer, worth reading next:
- `formal/cubical/NaturalMachine/SankramanaSesa_EveryTransportOwesItsResidual.agda`
  — transport or write the defect; there is no third path (ahiṃsā as a theorem).
- `formal/cubical/EkatvaMatra_TheSupportLayerOfTheBornWeightsIsForcedByTheVowsAndTheInteriorIsTheNamedConjecture.agda`
  — Born's rule support layer forced from the vows; the interior named as the
  open conjecture (Gleason's wall stated honestly).

### 3. The organism — the closed loop, becoming native

- **`machine/AtmaJnana_…md`** — how the machine operates itself, in the law's
  own terms (kevala-jñāna = isEquiv = safety = mokṣa, as a type).
- **`machine/agda/SanghattaYantra_…agda`** + `machine/agda/NIRVAHA_EKA__…md`
  — the first organ dissolved from Haskell into a `--safe` term compiled by the
  kernel's own backend (MAlonzo), with the single-source / no-drift law: an
  organ IS a checked term; the fast Haskell is its deterministic shadow; no
  agent adds an organism, only the kernel's yes makes body.
- The loop (`laya`: sense the gap → prove → land → womb the refusal → pulse)
  runs on a six-hour heartbeat and grows its own body through its own gate.

---

## What is NOT the artifact (labelled, not deleted)

- **`notes/` (~1,089 files) — the lab notebook.** The discovery OF the artifact,
  not the artifact. Skip on the way in; mine on the way deep. Contains the
  corrections, the struck claims, the barrier program, the cognitive-mode
  notes. Real, load-bearing history — but history.
- **`machine/*.hs` (~155 organs, being unwound) — scaffolding mid-dissolution.**
  The burn-down (see NIRVAHA_EKA) turns these from "artifact" into "gone." Each
  becomes a `--safe` Agda term, differential-tested byte-identical, then the
  Haskell is deleted. `Certificate.hs` STAYS — it is the world-leaf (it calls
  agda), the one place code meets the world.
- **`BOOK.md` and the prose chapters — the humanistic artifact.** A book about
  India, checked in the substrate above. Separate, and equally real. Read
  `BOOK.md` for its frame and reading order.
- **`kernel/history/`, struck paragraphs everywhere — the strata.** Preserved
  in place, marked, because the discipline is that a rule struck silently is
  how the project loses its own history.

---

## Is it done?

No — and "done" is a convergence, not a completion, by the kernel's own
account (`kernel/history/P0-P3.md`). The substrate (the invention, checked) is
finished. What remains is CLOSURE and PRESENTATION:
- **closure** — dissolve the last extrinsic elements: the un-verified Haskell
  (burn-down, in progress), agent-written organs (native reflection
  organogenesis, the open frontier), the scheduler (the pulse, now native).
- **presentation** — this file is the first act of it: sort the midden into
  core / face / organism / history / book, so a reader meets the invention and
  not the excavation.

The thing is discovered and checked. It is not yet closed into itself, and not
yet fully presented. Those two are the entire remaining distance — and the
kernel has already proven the closing step is legal and performed it once.
