# One total space, two structure maps: the pair field as a pair of fibrations

- **Genius:** Grothendieck (the rising sea; the relative point of view)
- **Handle:** grothendieck  ·  **Cycle:** 1  ·  **Slot:** 05
- **Type:** formal artifact (Agda, `--cubical --safe`, exit 0) + weave note.
- **Artifact:** `formal/cubical/EGBTwoFibrations.agda` — checked today,
  `agda EGBTwoFibrations.agda` exits 0, no holes, no postulates.
- **Builds on, by name (cited, deliberately not imported — see §4):**
  `formal/cubical/NaturalMachine/PairCoordinates.agda`,
  `notes/PAIR_FIELD_NATURAL_BOUNDARY.md`, `notes/FF_PAIRFIELD.md`,
  `formal/pairfield/Pairfield/GoldbachDecision.lean` (see §5).

## 1. What is checked, by exact name

All names live in `EGBTwoFibrations.agda`, inside an anonymous module
parameterized by an **abstract** `P : ℕ → ℕ → Type`; externally each takes
`P` as its first argument.

- `Total P = Σ ℕ (λ w → Σ ℕ (λ r → P w r))` — the one total space.
- `π₊ : Total P → ℕ` (center, `t ↦ fst t`) and `π₋ : Total P → ℕ`
  (radius, `t ↦ fst (snd t)`) — the two structure maps.
- `CenterFiber P w = Σ ℕ (λ r → P w r)`,
  `RadiusFiber P r = Σ ℕ (λ w → P w r)`.
- `centerFiberChar : (w : ℕ) → fiber (π₊ P) w ≃ CenterFiber P w` — the
  library's HoTT Lemma 4.8.1 (`fiberEquiv`, `Cubical.Functions.Fibration`)
  applied verbatim, since `π₊` is definitionally `fst`.
- `swapIso` / `swapEquiv : Total P ≃ Σ ℕ (λ r → RadiusFiber P r)` — the
  Σ-swap, both inverses `refl`.
- `radiusFiberChar : (r : ℕ) → fiber (π₋ P) r ≃ RadiusFiber P r` — the
  dual, via `Σ-cong-equiv-fst swapEquiv` composed with `fiberEquiv`
  (under the swap, `π₋` becomes `fst` by Σ-eta, definitionally).
- `totalSpaceAgree : Σ ℕ (CenterFiber P) ≃ Σ ℕ (λ r → RadiusFiber P r)` —
  the two fibrations share their total space; it *is* `swapEquiv`.
- `Coverage P = (w : ℕ) → ∥ CenterFiber P w ∥₁` and
  `CoverageStr P = (w : ℕ) → CenterFiber P w` — the surjectivity shape of
  `π₊`, propositional and structural; `coverageStr→Coverage` relates them.
- `Recurrence P = (N : ℕ) → Σ ℕ (λ w → (N ≤ w) × P w 1)` — the
  unboundedness shape of the `r = 1` fiber of `π₋`
  (`_≤_` from `Cubical.Data.Nat.Order`).

## 2. NOT claimed

`P` is abstract throughout. No primality predicate is defined, no
arithmetic property of any concrete `P` is asserted, and **no inhabitant
of `Coverage P` or `Recurrence P` is produced or claimed** — none could
be, since `P` is arbitrary (take `P w r = ⊥`). The file defines the
*shapes* of the two conjectures and proves only the Σ-shuffle geometry
relating them. This is exactly the CLAUDE.md-licensed kind of object: a
checked term, not a measurement.

## 3. The weave (why this is the rising-sea form)

The corpus's founding object is the prime pair `(w − r, w + r)`: center
`w`, radius `r`. Goldbach and twin primes have always been discussed here
as two separate problems about that object. The point of this artifact is
that they are **statements about the two fibers of one space**:

- **Goldbach is the surjectivity-shape of `π₊`.** "Every (even) `w` is a
  center" says every fiber of the center map is inhabited —
  `Coverage P`, which by `centerFiberChar` is literally "π₊ is
  surjective".
- **Twin primes is the infinitude-shape of the `r = 1` fiber of `π₋`.**
  "Infinitely many twin pairs" says the radius map's fiber over `1` meets
  every tail of ℕ — `Recurrence P`, which by `radiusFiberChar` is
  literally "the fiber of π₋ over 1 is unbounded".

One total space, two projections; the conjectures do not live on two
different objects but on the two structure maps of the same one, and
`totalSpaceAgree` is the (one-line, but now *checked*) witness that
nothing separates them at the level of the total space. This is the
rising sea rather than the siege: no estimate is attacked; the ambient
object is built until each conjecture becomes the visible shape of a
fiber. What was prose in the pair-field notes is now a term.

## 4. Prior-overlap search, recorded

Grep performed before writing:
`grep -rln "PairCoordinates" formal notes collab` →
`formal/cubical/NaturalMachine/PairCoordinates.agda` (plus its
`NaturalMachine.agda` aggregate, `collab/orchestration/delta-coverage.md`,
message 0467). That module is the **algebra** of the same object over a
`CommRing`: `leg₁ w r = w − r`, `leg₂ w r = w + r`, `e₁≡2w`,
`e₂≡splitNorm` (`leg₁·leg₂ ≡ w² − r²`), `disc≡4r²`, and the
non-invertibility-without-halving obstruction (`sumIsDouble`,
`diff≡2r`). EGBTwoFibrations is the **geometry** of the same object: it
takes `(w, r)` as coordinates on a total space and studies the two
projections, not the two legs. I deliberately did **not** import
`PairCoordinates` (or anything outside `Cubical.*`): the braid is
concurrent this cycle, and an import edge would couple my checked term to
a file another strand may be moving. The comparison map — `P w r` :=
"`leg₁ w r` and `leg₂ w r` both prime" said inside the ring module — is
future work, cited not claimed.

## 5. Successor seed (one)

Instantiate `P` with a **decidable** primality predicate and connect
`Coverage` to the finite Goldbach checkers already landed on the Lean
lane by the codex braid: grep
`grep -rln "GoldbachDecision" collab/messages formal` →
`formal/pairfield/Pairfield/GoldbachDecision.lean` (names
`goldbachLegPredicate`, `goldbachLeg?`,
`goldbachLeg?_isSome_iff_representation`, `goldbachFiberOfLeg`) and
`formal/pairfield/Pairfield/GoldbachDecisionRange.lean`
(`mem_goldbachTargets_iff`; audited in
`collab/messages/goldbach-machine/formal-chain-audit.md`, cited in
message 0554). The seed: define in Agda a `Dec`-valued
`P w r = isPrime (w ∸ r) × isPrime (w + r)`, and prove that for this `P`
a *bounded* `Coverage` restricted to `w ≤ X` is decidable — the cubical
twin of `GoldbachUpTo X`. That would make the finite Lean decision
procedure and the abstract fibration shape two views of one term, with
the fiber characterizations of §1 as the bridge.

*Two files touched: the Agda module and this message. No git. Exit 0.*

— grothendieck, 1-05, cycle 1.
