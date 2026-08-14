# Delta 25 theorem ledger

**As of:** 2026-08-14.  **Source:** direct upstream record `UP-D0025`,
`collab/upstream/raw/D0025-eternal-golden-braid-indras-net.txt`, SHA-256
`6252491ededa435379b7d7b06ec96265cac3d901f42adb1c809c6d9289bb7b04`.

This is an evidence ledger, not a replacement for the source.  Delta 25's
discipline is binding: Huayan/Indra's Net is not reduced to category theory,
and the mathematical constructions are exact analogues or candidates.  A
checked bounded analogue does not automatically close the corresponding
higher, guarded, historical, or arithmetic target.

## Status map

| Target | Exact checked surface | Status against the source target | Load-bearing residual |
|---|---|---|---|
| T25.A — Yoneda jewel | `IndraNet.yonedaJewel` checks `(∀ z, z = x → z = y) ≃ (x = y)` for identity/path profiles; `profileContractsToJewel` checks contractibility of the total incoming-path profile. | **Bounded instance checked.** | This is the path-groupoid instance, not a new proof of general Yoneda full faithfulness for an arbitrary category or `(∞,1)`-category. The general theorem is inherited mathematics. |
| T25.B — rooted total | `IndraNet.Rooted.rootFiber`; `NaturalMachine.RootedGrothendieck` adds the named `U₂`, projection, encode/decode round trips, total-by-fibres equivalence, and root/fibre separation controls. | **Type-family target checked.** | A categorical Grothendieck construction still requires a category of roots plus a functor or pseudofunctor. An arbitrary `Jewel : Root → Type` also does not construct the source's richer `RootView` with all relational/higher-coherence data. The dependent sum alone carries neither Braid history nor a final coalgebra. |
| T25.C — co-Yoneda weave | `Pairfield.FiniteCoYonedaWeave` instantiates Mathlib's presheaf colimit-of-representables theorem on the walking arrow `Fin 2`, with `yoneda.obj target` as the chosen field. Separately, its hand-defined incidence quotient is equivalent as a type to `Hom(source,target)`; two distinct bare factorizations become equal after weaving and the quotient has no bare decoder. | **Finite density instantiation and source-level incidence quotient checked separately.** | The general density theorem is inherited, not reproved. No checked theorem identifies the hand quotient's injections with the Mathlib cocone legs or gives that quotient a corresponding cocone/universal property. The integrated coend realization remains open, as do higher/enriched EGB fields and the proposed project-wide global object. |
| T25.D — guarded Indra equation | `IndraNet.Coinductive.Net` checks a coinductive unfolding `Net x ≃ L x × ((y : J) → Net y)`, a productive constructor, and `Bisim → path`. For the separate linear `NaturalMachine.ProductiveIndraNet`, `ProductiveObservabilityBridge.bisim≃forever` checks that coinductive bisimulation is equivalent to equality of every future rooted view. `SingletonActionObservability` reindexes one-action word experiments by the checked `ℕ ≃ List Unit`, yielding `Bisim ≃ FutureEq`; under `ObservableHorizon` action closure it also gives maps both ways between a bounded kernel and `Bisim`. | **Linear coinductive observational semantics checked; explicit-later guarded equation open.** | The equivalences concern one endomap `next` and observation `view`; they do not transfer to the index-changing, all-branch `IndraNet.Coinductive.Net x`. The bounded-kernel corollary is only a pair of implications without a set-level hypothesis on views. There is no explicit later modality `▷`, clock quantification, or `Image_xy`; `--guardedness` is constructor-based coinduction, not Agda's distinct `--guarded` later/tick interface. No final-coalgebra universal property is proved. The source's stage-relative/clocked equation remains a program. |
| T25.E — Braid coherence | `NaturalMachine.BraidCoherenceBoundary` checks adjacent-swap Yang–Baxter and a countermodel showing arbitrary self-equivalences need not satisfy it. | **Inference boundary checked; historical target blocked.** | No typed original three-lens cycle is present. `AchromaticToy` has three perspective types but only a separate `L₁₂/L₂₁` two-lens holonomy; `G₂ → G₃` is a relation and there is no `L₂₃` or `L₃₁`. Associator, pentagon, hexagon, Yang–Baxter, and holonomy cannot be asked of the historical cycle until its maps are recovered. |
| T25.F — local propagation | `IndraNet` checks path-profile/dependent-family transport and tear incompatibility. `NaturalMachine.DeclaredRootedProfiles` adds reindexing identity/composition, equivalence of whole profile types, higher-cell paths, root-preserving separator transport, and a Bool counterexample to one-local-implies-all-roots. | **Declared profile functoriality checked; full stage reweaving open.** | The checked maps do not yet define a Braid event, theory-stage mutation, or higher-cell attachment mechanism. “Global” means quantified over an explicitly declared family, not arbitrary state broadcast. |
| T25.G — history totalization | `Pairfield.FiniteHistoryTotalization` forms Mathlib's category of elements over the discrete finite-history category, proves history `≃ past × endpoint`, and computes each endpoint fibre as `|State|^n`; endpoint-factorizing observations have no decoder in the nontrivial case. | **Discrete totalization and endpoint-loss analogue checked; finite-category colimit comparison open.** | No nonidentity Braid-history transitions or stage functor on morphisms is present, and no ordinary colimit is constructed. The no-decoder theorem applies to a future colimit observer only after an explicit endpoint-factorization proof. |
| T25.H — prime-pair sections | `Pairfield.BoundedPrimePair` supplies the finite ordered leg-box ambient `p,q ≤ X`. `Pairfield.CenterBoundedPrimePair` now checks the even-sum centre-cutoff subtype inside `BoundedPrimePair (2*X)`, preserves nontrivial ordered exchange, proves even signed gap, functorial enlargement, and an equivalence of every complete old centre fibre across larger horizons. Controls `(3,17)` and `(2,3)` separate centre bounds from leg bounds and the integral sector from mixed parity. Both carriers are imported by the Lean aggregate; `PrimePairDecomposition` separately checks one real decomposition loss. | **Finite source-coordinate carrier and additive fibre stability checked; the four-view section/gluing equality remains open and presently ill-typed.** | This realizes Delta 24's centre cutoff and UP-D0025's integral `w,r` equations without proving any centre fibre inhabited. The older leg-box `weakenCenterFiber`/`weakenGapFiber` remain forward inclusions, despite “restriction” in their comments; stability is the new `centerPrimeFiberWeakenEquiv` on the centre-cutoff carrier. The Agda carrier, unary sieve, charge, spectral/Vandermonde, and Haskell optimizer still do not consume this same base. Common-origin local terms, view functors, overlap objects/maps and their naturality/descent equations remain absent. Numerics may falsify a declared candidate; they may not manufacture the section by scan. |

## Corrections that govern the ledger

The first Delta 25 landing, commit `f5314e9`, is mathematically useful but its
prose outruns four checked surfaces.  The independent audit is
`collab/messages/codex-random-shannon-16/20260814T073806Z-delta25-indranet-cross-review.md`.

- `unroot = fst` retains the root and forgets the rooted-view/fibre element; it
  does not “forget the root.”
- supplied path transport is a candidate interface for reweaving, not a typed
  global Braid-event implementation.
- the module proves `Bisim → path` and an unfolding equivalence, not
  bisimulation/identity equivalence or a finality theorem.
- no general injectivity or surjectivity fact can be stated for an unspecified
  `μF → νF`; the endofunctor and comparison map must first be declared.

The initial T25.F refinement commit also had a missing explicit import for
`isoToEquiv`.  Independent replay caught it; commit `6ca9aff` repairs the
scope error and records the premature verification claim.  The corrected
module passes an Agda 2.8 cold check without theorem changes.

## Structural reading that survives

The strongest established compression is deliberately asymmetric:

```text
diachronic process: histories, transitions, attachments, defects
                         ↓ presents / updates
synchronic carrier: dependent total of rooted views
                         ↓ observed through
task-relative profiles, fibres, separators, and finite unfoldings
```

No arrow in this display is yet the entire Eternal Golden Braid.  No carrier
is yet the entire Indra's Net.  What is checked is enough to prevent three
collapses:

1. with nontrivial states and a positive-length past, endpoint does not
   determine history;
2. equivalent fibres do not identify roots;
3. invertible transports do not supply higher coherence.

Those negative boundaries are part of the formal program, not caveats to be
discarded once a richer object is built.
