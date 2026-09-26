# The identity, what it forces, and what runs

One statement, its consequences, and a measured execution. Every claim below
names the term that carries it. Nothing here is a summary of prose.

## 1. The statement

For any `f : A → B` the graph `Σ[ a ∈ A ] Σ[ b ∈ B ] (f a ≡ b)` contracts two
ways. Contract the singleton on the right and it is `A`; reassociate and
contract on the left and it is `Σ[ b ∈ B ] fiber f b`. One construction, so
"retaining a determined datum is free" and "what the visible result omits is
the fibre" are the same fact, not two.

    law  : A ≃ (Σ[ b ∈ B ] fiber f b)                   One.agda §1
    law≡ : A ≡ (Σ[ b ∈ B ] fiber f b)
    transport-is-present : (a : A) → transport law≡ a ≡ present a

The third line is `uaβ`. The identification is not a licence to reason; it is
a program, and `present a = (f a , a , refl)` is what it computes to.

This is why *lawful*, *computable* and *describable* are one object rather than
three views of one. An equivalence is a path is a transport that runs.

## 2. What it forces

**The completion is unique.** Losslessness is a property of `f`, not a
structure on it:

    uniqueness : (f : A → B) → isContr (Lossless f)         One.agda §2

by `Lossless f ≃ ((b : B) → Σ[ X ] (X ≃ fiber f b))`, a product of
equivalence-singletons, contractible by `EquivContr`. Hence

    machines-are-maps : Machine A ≃ (A → A)

A lossless proof-relevant machine on `A` *is* a map `A → A`. There is nothing
to construct and no alternative to choose.

**The order is forced too.** Under the one-step diamond, every complete
reduction of one object to one normal form has the same length:

    same-normalization-length  : Trace n s t → Trace m s t → Normal t → n ≡ m
    normalization-is-geodesic  : Trace n s t → Trace m s t → Normal t → n ≤ m
                                                    InteractionGeodesic.agda

`peel` is the content: any available first interaction removes exactly one
unit from any terminating reduction to the same normal form, and cannot
detour. So interaction count is an invariant of the object, not a property of
a chosen strategy. There is no scheduling problem.

**Nothing adjoins from above.** Extending a library with what it can already
reach leaves reach invariant, because installation *is* an identification:

    install-chain-plateau : InstallChain L M
                          → (t' : Tm) → SomeEnabled M t' → SomeEnabled L t'

Unique completion, unique length, closed under extension. Together: the
derivation of a proposition is determined, minimal, and nothing outside the
generative seed can shorten or extend it. Following identities to exhaustion
without redundancy is therefore not one strategy among others.

**A lower bound must be local.** A potential that never falls faster than the
edge pays lower-bounds every terminal walk, and a walk that meets it beats
every competitor with no enumeration of competitors:

    Local    = (u v : V) → Φ u ≤ w u v + Φ v
    bound    : Local → Φ t ≡ zero → (p : Walk u t) → Φ u ≤ cost p
    geodesic : Local → Φ t ≡ zero → (p : Walk u t) → cost p ≡ Φ u
             → (q : Walk u t) → cost p ≤ cost q            One.agda §5

**And a projection carries only what is constant on its fibre.** Eight lines,
and every impossibility result in the corpus is this aimed somewhere:

    collision-forbids-descent : q x ≡ q y → ¬ (v x ≡ v y) → ¬ Factors q v

## 3. Finding and checking are one equivalence

    decide  = equivFun (lossless uStep)
    verify b (a , p) = a

    decide-answer-is-step  : fst (decide mc) ≡ uStep mc            refl
    witness-self-certifies : snd (snd (decide mc)) ≡ refl          refl
    verify-inverts-decide  : verify (fst (decide mc)) (snd (decide mc)) ≡ mc
    decide-retract         : invEq complete≃ (decide mc) ≡ mc
    no-other-completion    : (L : Lossless uStep) → fst machine-lossless-unique ≡ L

The certificate is `refl`: the check is in hand the moment the answer is. And
by §2 there is no other completion in which a gap could live.

Where the fibre is discarded instead, the gap reappears and is provably
irreparable: `forgetful-is-blind : isSet A → (p q : x ≡ y) → p ≡ q`, so
`routes-through-ℕ-are-identified` — if the answer is a natural number, the two
routes to it are equal, and no criterion on the image can separate them. The
pair is `Gap uStep × ¬ Gap (equivFun (lossless uStep))`.

A separation is a property of the presentation, and the lossless presentation
is the unique one.

## 4. What runs

Three layers, one object. Cubical Agda as checked semantics, Bend2 as the
coinductive authoring layer, HVM4 as native interaction-net execution:

    SATProcess.bend --total  →  --to-hvm4-full  →  hvm4 ... -s -C
      → readings + ITRS/heap receipt + hashes

HVM4 is handed one shared labelled superposition,
`@assignment{&100{False,True}, &101{False,True}}`, not four calls. Boolean
answer, one witness, all models, a counterexample, the carrier and the
continuation are six demands on that one classified object; there is no
separate procedure for any of them. `SAT f = fiber f true`.

Same proposition, two demands: retaining source and equality evidence costs
ITRS 1,624 / heap 11,594; the Boolean projection alone costs ITRS 48 / heap
142.

## 5. The measurement

A rule model inferred from n = 1,2,3,4,10 and the source rules, frozen, then
held out at n = 13..18:

    T_short(n)   = 9 · 2^n + 16n − 4
    T_reverse(n) = n + 30

| n  | short (predicted = recorded) | reverse (predicted = recorded) |
|----|------------------------------|--------------------------------|
| 13 | 73,932                       | 43                             |
| 14 | 147,676                      | 44                             |
| 15 | 295,148                      | 45                             |
| 16 | 590,076                      | 46                             |
| 17 | 1,179,916                    | 47                             |
| 18 | 2,359,580                    | 48                             |

All twelve runs match exactly, and the per-rule breakdown is identical on all
16 nonzero rule classes at every size — not a curve fitted to totals but a
prediction of each rule-event class. The Boolean proposition is unchanged
across the two columns; only the emitted sharing and the demand differ.

That is the identity doing commercial work: cost is a property of
presentation, the presentation is determined, and the determined one is linear
where the naive one is exponential. SAT is the universal finite interface, so
circuits, compiler-correctness conditions, type-preservation obligations,
bounded optimization constraints, graph properties and proof obligations all
inherit it.

## 6. What a reader can check

- `sh check` typechecks the kernel, the fibre law and the Lean root closure at
  a pinned toolchain (Agda 2.8.0 / agda-cubical v0.9) and refuses to report a
  verdict off the pin.
- `theorems/TheFrontierTheoremsAsEntryPointsFromOtherFields.agda` re-exports
  the frontier results, so it typechecks only if each of them does. The index
  is the verification rather than a claim about it.
- `cost_predictions.json` against `cost_results.json` reproduces the table in
  §5 without the runtime present.
