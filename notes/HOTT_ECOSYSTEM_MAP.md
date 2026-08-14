# The HoTT/univalent-foundations ecosystem, mapped against this corpus

**Filed 2026-08-14. Ingestion only — no new mathematics is produced here.**
Owner's standing correction: *consume all existing HoTT work; be current with the
2026 frontier.* This note is the consumption. Its purpose is to say, claim by
claim, what already exists and where, so that no further block re-proves a
textbook example.

The headline, stated first because it is the point of the document:

> **Of the 15 univalent claims this corpus makes or machine-checks, 12 are
> already proved elsewhere — 9 of them in libraries this repository has had
> on disk the whole time, and one of them (`ℕ` is homotopy-initial, with a
> *contractible* type of algebra maps) is in `Cubical.Data.Nat.Algebra`, a
> module of our own pinned `cubical` v0.5 that `AtlasResiduals.agda` does not
> import and reproves in a strictly weaker form.**
>
> The corpus's §3 of `ATLAS_OF_N.md` is, essentially in its entirety,
> Example 4.2.x of the *Symmetry* book (Bezem–Buchholtz–Cagne–Dundas–Grayson),
> where `\SG_n := Aut_Set(bn n)` and `\BSG_n := (FinSet_n, bn n)` are given as a
> **definition and a first example**, not as theorems.

---

## 0. Channel facts and evidence grading

Recorded because the grading of every claim below depends on them.

| channel | status | consequence |
|---|---|---|
| `WebFetch` | **EGRESS_BLOCKED on every host**, verified again this session against `ncatlab.org/nlab/show/univalence+axiom` (error `EGRESS_BLOCKED`) | **The nLab cannot be read from this repository.** No nLab page is cited below. Do not try to route around it. |
| `WebSearch` | works, but returns *search summaries*; no page body is retrieved | every literature claim below is **śabda** (testimony) grade and is labelled `[śabda]` |
| git over HTTPS | works; `raw.githubusercontent.com` returns 200 | source that was **cloned and grepped locally** is labelled `[read]` and carries file path + line number |

`[read]` claims are direct observation of source text. `[śabda]` claims are
hearsay from a search-result summary and must not be quoted as if a paper had
been read.

## 1. What is on disk, and at what version

| library | path | commit / tag | date |
|---|---|---|---|
| `agda/cubical` (**our pin**) | `~/agda-libs/cubical` | `132a2a3` tag **v0.5** | 2023-07-05 |
| `agda/cubical` master | `~/agda-libs/cubical-master` | `9216603` | **2026-06-25** |
| `agda-unimath` | `~/agda-libs/agda-unimath` | `48a91b4` | 2026-08-10 |
| `HoTT/Coq-HoTT` | `~/agda-libs/Coq-HoTT` | `fd31233` | 2026-08-12 |
| `UniMath/UniMath` | `~/agda-libs/UniMath` | `5ed6c6b` | 2026-08-08 |
| `UniMath/SymmetryBook` | `~/agda-libs/symmetrybook` | `b43cc6f` | **2026-08-13** (yesterday) |
| `plt-amy/1lab` | `~/agda-libs/1lab` | `f505559` | 2026-07-28 (read-only, AGPL — **do not link against**) |
| `mathlib4` | `~/agda-libs/mathlib4` | `9058eaf` | 2026-08-14 |

The four newly cloned ones (cubical-master, UniMath, symmetrybook, 1lab) were
fetched this session with `--filter=blob:none --depth 1`. **`UniMath` briefly
landed inside the working tree by a shell-parsing accident and was moved to
`~/agda-libs/UniMath`; `git status` is clean of it.**

---

## 2. Claim-by-claim map

Verdicts: **ALREADY** (proved elsewhere, in a form at least as strong),
**PARTIAL** (the core is elsewhere; some packaging or a corollary is not),
**OURS** (no ecosystem hit found).

### Summary table

| # | corpus claim | where it lives here | verdict | where it already is |
|---|---|---|---|---|
| C1 | $BS_n=\sum_{X:\mathcal U}\lVert X\simeq\mathrm{Fin}\,n\rVert$, the type of $n$-element types | `ATLAS_OF_N` §3.1; `AtlasResiduals.BS` | **ALREADY** | agda-unimath `Type-With-Cardinality-ℕ`; Coq-HoTT `BAut`; *Symmetry* `\FinSet_n` |
| C2 | $\mathbf{FinType}\simeq\sum_{n}BS_n$ | `ATLAS_OF_N` Thm 3.1(1) | **ALREADY** | agda-unimath `compute-total-Type-With-Cardinality-ℕ` |
| C3 | $BS_n$ connected, $\Omega BS_n\simeq S_n$ **as groups** | Thm 3.1(2); `PathIsSymmetry.ΩFin≃Sym`; `Decategorification.FinSetLoop≃Sym` | **ALREADY** | agda-unimath `iso-loop-group-fin-Type-With-Cardinality-ℕ-Group` + `iso-symmetric-group-loop-group-Set`; *Symmetry* Ex. `ex:permgroup` |
| C4 | $\lVert\mathbf{FinType}\rVert_0\simeq\mathbb N$ | Thm 3.1(3); `Decategorification.ℕ≃π₀FinSet` | **PARTIAL** | all inputs in agda-unimath (`is-0-connected-…`, `compute-total-…`); the assembled $\pi_0$ statement not found verbatim |
| C5 | $\sum_{X:BS_n}\mathrm{LinOrd}(X)$ contractible | Thm 3.2; `AtlasResiduals.isContrOrdTotal` | **ALREADY** (as stated — see below, the statement as checked is a based path space) | is the standard `is-torsorial-Id`/`is-torsorial-equiv-…` argument |
| C5′ | orders on $X$ form an $S_n$-torsor | Thm 2.5; `AtlasResiduals.linOrd-torsor` | **ALREADY** | same; agda-unimath `torsors.lagda.md`, `principal-torsors-concrete-groups` |
| **C5″** | **$\mathrm{LinOrd}'(X)\simeq(X\simeq\mathrm{Fin}\,n)$ for a genuine decidable total order** | **the OPEN OBLIGATION** in `AtlasResiduals` "NOT CLAIMED"; **the hard half now checked** in `LinearOrderFinite.agda` (commit `1356718`) | **OURS, in HoTT** | **not in agda-unimath, not in cubical (either version), and in UniMath the proof is literally `Abort`ed.** Present classically as `mathlib4 monoEquivOfFin` |
| C6 | ordinals: $\sum_X\mathrm{WellOrd}(X)$ not contractible past $\omega$; $+$ non-commutative | §3.2 remark | **ALREADY** | HoTT Book Ch. 10 `[śabda]`; cubical **master** `Cubical/Data/Ordinal/`, `Relation/Binary/Order/Woset` |
| C7 | $(\mathbb F_{\ge1},\times)$ is not the free symmetric monoidal groupoid on the primes | §3.3, §6 Thm 6.1 | **OURS** | no hit; agda-unimath `species/` has the ambient machinery but not this negative |
| C8 | endian $\mathbb Z/2$-torsor $=$ a point of $B(\mathbb Z/2)$ $=$ the type of 2-element types | §3.4 | **ALREADY** (the object) | agda-unimath `2-Element-Type`; cubical v0.5 `Data/FinSet/Binary/`; Coq-HoTT `Spaces/BAut/Bool.v`; *Symmetry* `group.tex` §4 opening example |
| C9 | carry class $[c_n]\ne0$ in $H^2(\mathbb Z/b^n;\mathbb Z/b)$ | Prop. 2.11, §8 table | **OURS** (and **unformalized anywhere**) | **no group cohomology $H^2$ / central extensions in agda-unimath or cubical.** Cubical has only *space*-level EM cohomology |
| C10 | "residual $=$ $\mathrm{Aut}$ of the endpoint $=$ loop space"; path $=$ bijection | §7; `CROSS_LENS` §8; `PathIsSymmetry` | **ALREADY** | this *is* univalence: HoTT Book §2.10 `[śabda]`; and it is the thesis statement of the entire *Symmetry* book |
| M5 | $\mathbb N$ initial for $X\mapsto1+X$ with **contractible** type of algebra maps | `AtlasResiduals` `ℕ-isInitial`, `isContrAlgIso` | **ALREADY, in our own pin** | **`~/agda-libs/cubical/Cubical/Data/Nat/Algebra.agda`** — and the library version is *stronger* |
| M7 | $(\mathrm{Fin}\,n\simeq\mathrm{Fin}\,n)\simeq\mathrm{Fin}(n!)$ | `SymmetryEnumeration.symmetryEnum`, `SymmetryCardinality` | **ALREADY** ×3 | agda-unimath `equiv-count-Permutation`; UniMath `weqfromweqstntostn`; Coq-HoTT `fcard_aut` |
| M8 | Myhill–Nerode / future-behaviour quotient, terminality, effectivity | `FutureBehavior.agda` | **PARTIAL** | classical form in `mathlib4 Mathlib/Computability/MyhillNerode.lean`; the *univalent* effectivity Iso is not there |

Tally: **12 of 15 ALREADY or PARTIAL**; 3 genuinely without an ecosystem hit
(C5″, C7, C9), of which C5″ is the one another library nearly discharges.

---

### 2.1 `agda-unimath` — the type of $n$-element types, and its loop group

All paths relative to `~/agda-libs/agda-unimath/`. `[read]` throughout.

**C1. $BS_n$.** `src/univalent-combinatorics/finite-types.lagda.md:121`

```agda
Type-With-Cardinality-ℕ : (l : Level) → ℕ → UU (lsuc l)
Type-With-Cardinality-ℕ l k = Σ (UU l) (has-cardinality-ℕ k)
```

This is `AtlasResiduals.BS` verbatim, except universe-polymorphic where ours is
fixed at `Type₀`. Companions in the same file:

- `:720 is-1-type-Type-With-Cardinality-ℕ` — $BS_n$ is a groupoid.
- `:740 is-0-connected-Type-With-Cardinality-ℕ` — $BS_n$ is connected. This is
  §3.1's "(2) Connectedness is the propositional truncation in the definition".
- `:665ff` "We characterize the identity type of `Type-With-Cardinality-ℕ`":
  `equiv-eq-Type-With-Cardinality-ℕ`, `is-torsorial-equiv-Type-With-Cardinality-ℕ`,
  `is-equiv-equiv-eq-Type-With-Cardinality-ℕ`. This is §3.1's "a path in $BS_n$
  is a path in $\mathcal U$ together with a path in a proposition, hence just the
  former" — done properly, as a torsoriality statement.

**C2. $\mathbf{FinType}\simeq\sum_n BS_n$.** `finite-types.lagda.md:554`

```agda
compute-total-Type-With-Cardinality-ℕ :
  {l : Level} → Σ ℕ (Type-With-Cardinality-ℕ l) ≃ Finite-Type l
```

That is Theorem 3.1(1), exactly, as a named library equivalence. Our note proves
it by "the $n$ is unique by the pigeonhole principle"; the library has the
pigeonhole principle at `src/univalent-combinatorics/pigeonhole-principle.lagda.md`.

**C3. $\Omega BS_n\simeq S_n$ as groups.**
`src/finite-group-theory/finite-type-groups.lagda.md` — the module is titled
*"The group of n-element types"*. Read the chain:

- `:57` `classifying-type-Type-With-Cardinality-ℕ-Concrete-Group = Type-With-Cardinality-ℕ l n`
- `:61` `shape-… = raise-Fin-Type-With-Cardinality-ℕ l n` (the basepoint $\mathrm{Fin}\,n$)
- `:77` `∞-group-…` — $BS_n$ as an $\infty$-group
- `:93` `Type-With-Cardinality-ℕ-Concrete-Group : Concrete-Group (lsuc l)`
- `:98` `Type-With-Cardinality-ℕ-Group : Group (lsuc l)` — the loop group
- `:193` **`iso-loop-group-fin-Type-With-Cardinality-ℕ-Group : iso-Group (Type-With-Cardinality-ℕ-Group l n) (loop-group-Set (raise-Set l (Fin-Set n)))`**

and then `src/group-theory/loop-groups-sets.lagda.md:184`
**`iso-symmetric-group-loop-group-Set : iso-Group (loop-group-Set X) (symmetric-Group X)`**.

Compose the two and you have `PathIsSymmetry.ΩFin≃Sym` and
`Decategorification.FinSetLoop≃Sym`, as a **group isomorphism**, universe-
polymorphic, with the concrete-group packaging our modules do not have. Our
`PathIsSymmetry.pathToEquiv-∙` (multiplicativity of `pathToEquiv`) is the
content of `hom-symmetric-group-loop-group-Set`'s second component.

Note the universe-level remark in `PathIsSymmetry` ("$(X\equiv X)$ lives one
level above $X$… an honest universe-level fact, not a defect") — agda-unimath
records the same fact by typing the group at `Group (lsuc l)`. We rediscovered
a library design decision and wrote a comment about it.

**M7. $n!$.** Two independent hits:
- `src/finite-group-theory/counting-permutations-standard-finite-types.lagda.md:72`
  `equiv-count-Permutation : (n : ℕ) → Fin (factorial-ℕ n) ≃ Permutation n` —
  this is `SymmetryEnumeration.symmetryEnum` inverted.
- `src/finite-group-theory/counting-automorphisms-finite-types.lagda.md` —
  `has-cardinality-factorial-aut-has-cardinality-ℕ`, i.e. $\mathrm{Aut}$ of an
  $n$-element type is an $n!$-element type; and
  `number-of-elements-aut-Finite-Type`. This is `SymmetryCardinality`.

**The sign homomorphism, i.e. the very paper `ATLAS_OF_N` §3.1 cites.**
Mangel–Rijke (arXiv:2301.10011) is **fully formalized** in agda-unimath, in
three variants, all citing `{{#reference MR23}}`:

- `src/finite-group-theory/sign-homomorphism.lagda.md` (into $\mathbb Z/2$, and into $S_2$)
- `src/finite-group-theory/delooping-sign-homomorphism.lagda.md` (1651 lines; §"Corollary 25", §"Proposition 22")
- `src/finite-group-theory/cartier-delooping-sign-homomorphism.lagda.md`
- `src/finite-group-theory/simpson-delooping-sign-homomorphism.lagda.md`

`ATLAS_OF_N` §3.1 quotes this paper's abstract as a **FETCHED** citation for the
*definition* of $BS_n$. The paper's actual theorems — which are about a
genuinely non-trivial pointed map $BS_n\to BS_2$ — are machine-checked and sat
one `grep` away. That is the shape of the miss: we cited the abstract for the
easy half and did not look at what the paper proves.

**C8. The type of 2-element types.**
`src/univalent-combinatorics/2-element-types.lagda.md:89`
`2-Element-Type l = Type-With-Cardinality-ℕ l 2`, plus
`2-element-subtypes`, `2-element-decidable-subtypes`. §3.4's "$B(\mathbb Z/2)$ =
the type of 2-element types" is this definition.

**C5″. The linear-order obligation — NOT in agda-unimath.**
`src/order-theory/` has 24 order modules including
`finite-total-orders.lagda.md`, `decidable-total-orders.lagda.md`,
`inhabited-finite-total-orders.lagda.md`,
`precategory-of-finite-total-orders.lagda.md`. I read
`finite-total-orders.lagda.md` in full: it defines
`Finite-Total-Order l1 l2 = Σ (Finite-Poset l1 l2) (λ P → is-total-Poset …)` and
the projections, **and stops there**. There is no rank map, no
$\mathrm{Fin}\,n$ comparison, no contractibility, no uniqueness. Grepping the
whole library for a `Total-Order` ↔ `Fin` connection returns nothing.
There is `elementary-number-theory/decidable-total-order-standard-finite-types.lagda.md`
(the *standard* order on $\mathrm{Fin}\,n$) but nothing saying every finite total
order is that one.

### 2.2 `Coq-HoTT` and `UniMath`

**Coq-HoTT** (`~/agda-libs/Coq-HoTT/`) `[read]`:

- `theories/Universes/BAut.v:13`
  `Definition BAut (X : Type@{u}) := { Z : Type@{u} & merely (Z = X) }.`
  With `path_baut : (Z = Z') <~> (Z.1 <~> Z'.1)` at `:23`,
  `transport_path_baut` at `:35`, `baut_ind_hset` at `:101`.
  `BAut (Fin n)` **is** $BS_n$, and `path_baut` **is** C3.
- `theories/Algebra/Aut.v:12` `Definition Aut (X : Type) : ooGroup` — the
  automorphism $\infty$-group, i.e. the delooping, one line.
- `theories/Spaces/Finite/Finite.v:370`
  `Definition fcard_aut : fcard (X <~> X) = factorial (fcard X).` — M7.
  Also `fcard_sum`, `fcard_prod`, `fcard_arrow`, `fcard_sigma`, `fcard_forall`,
  `fcard_quotient`, `leq_inj_finite`, `geq_surj_finite` (pigeonhole both ways).
- `theories/Spaces/BAut/Bool.v` — the type of 2-element types, worked in detail
  (C8), including `IncoherentIdempotent`.
- **No sign homomorphism.** Grepping `theories/Algebra/Groups/` for `sign`
  returns only `word_change_sign` inside the free-group construction. Coq-HoTT
  has `Groups/{FreeGroup,Presentation,QuotientGroup,ShortExactSequence,Subgroup,
  Commutator,Perfect,Finite}.v` but no symmetric group and no delooped sign.
  **This is the one place agda-unimath is strictly ahead of Coq-HoTT** on our
  objects.
- Orders: `theories/Classes/interfaces/orders.v:28 Class TotalOrder`. No
  finite-total-order-is-standard theorem.

**UniMath** (`~/agda-libs/UniMath/`) `[read]` — and here is the sharpest single
observation in this document:

`UniMath/OrderTheory/OrderedSets/OrderedSets.v`

```coq
:302  Definition FiniteOrderedSet := ∑ X:OrderedSet, isfinite X.
:352  Definition FiniteOrderedSet_segment {X:FiniteOrderedSet} (x:X) : FiniteSet.
:356  Definition height {X:FiniteOrderedSet} : X -> nat.
:360  Definition height_stn {X:FiniteOrderedSet} : X -> stn (cardinalityFiniteSet X).
      Proof.
        intros x.
        exists (height x).

      (* Defined. *)
      Abort.
```

**UniMath defines the rank map and then aborts the proof.** The obligation
`AtlasResiduals` states as its open item is, in the oldest and largest univalent
library, an abandoned `Abort`ed definition with a commented-out `Defined.`
UniMath does have `standardFiniteOrderedSet` (`⟦n⟧`), `transportFiniteOrdering`,
`inducedPartialOrder`, and — relevant — `Combinatorics/StandardFiniteSets.v:2023`
`Lemma stn_ord_bij {n} (f : ⟦n⟧ ≃ ⟦n⟧) : (∏ i j, i ≤ j → f i ≤ f j) → ∏ i, f i = i`,
which is the **uniqueness** half (an order-preserving self-equivalence of
$\mathrm{Fin}\,n$ is the identity). The **existence** half — every finite total
order admits an order-isomorphism with $\mathrm{Fin}\,n$ — is the aborted one.

Also in UniMath: `Combinatorics/StandardFiniteSets.v:1622`
`Theorem weqfromweqstntostn (n) : ((⟦n⟧) ≃ (⟦n⟧)) ≃ ⟦factorial n⟧` — M7 again,
independently.

### 2.3 `cubical` master vs. our v0.5 pin

Our pin is **v0.5, 2023-07-05 — three years and one month stale.** Master
(`9216603`, 2026-06-25) has **403 additional `.agda` files.** What matters for
this corpus:

**(i) Nothing about the corpus's objects is missing from v0.5 that master
supplies — with one large exception: the order hierarchy.**

v0.5 `Cubical/Relation/Binary/` contains exactly
`{Base, Extensionality, Poset, Properties}.agda`. Master contains a full
`Cubical/Relation/Binary/Order/` with

```
Apartness/  Loset/  Poset/  Proset/  Pseudolattice/  Quoset/
StrictOrder/  Toset/  Woset/  QuosetReasoning.agda
```

and in `Order/Toset/Base.agda:38`

```agda
record IsToset {A : Type ℓ} (_≤_ : A → A → Type ℓ') : Type (ℓ-max ℓ ℓ') where
  field
    is-set is-prop-valued is-refl is-trans is-antisym is-total
```

together with `TosetStr`, `TosetEquiv`, `isPropIsToset`, and a SIP-ready
`𝒮ᴰ-Toset : DUARel (𝒮-Univ ℓ) (TosetStr ℓ') (ℓ-max ℓ ℓ')`.

**`LinearOrderFinite.agda` hand-rolls `record IsLinOrd` with exactly these
fields and hand-rolls `isPropIsLinOrd` and `LinOrd′≡` — all three of which
`Cubical.Relation.Binary.Order.Toset.Base` supplies upstream, the last one via a
displayed-univalent-structure automation we did not use.** The only difference
is that our `total` is `∥ (x ≤ y) ⊎ (y ≤ x) ∥₁` where master's `isTotal` is
likewise truncated. This is a direct, avoidable cost of the stale pin.

**(ii) Ordinals.** Master has `Cubical/Data/Ordinal/{Base,Properties}.agda`
built on `Relation/Binary/Order/Woset` and `Woset/Simulation`, with `Ord`,
`isSetOrd`, `suc`, `𝟘`, `𝟙`, `+IdR`, `+IdL`, `suc≡+𝟙`, `suc≺`. §3.2's remark
about $\sum_X\mathrm{WellOrd}(X)$ and about ordinal addition failing to commute
past $\omega$ is *formalizable today upstream* and not at all at our pin.

**(iii) Cohomology.** Master adds `Cubical/Cohomology/EilenbergMacLane/`
(`Gysin`, `MayerVietoris`, `EilenbergSteenrod`, rings for `RP2`, `RPinf`, `Sn`,
`KleinBottle`) and `Cubical/CW/Homology/`. **None of this is group cohomology.**
There is no $H^2(G;A)$, no central extensions, no group-extension classification
in cubical at either version, nor in agda-unimath (`src/group-theory/` has
`central-elements-*` and `centralizer-subgroups` and nothing on extensions).
**C9 — the carry class — has no formal home anywhere in the univalent
ecosystem.** If the corpus wants it machine-checked, that machinery has to be
built, and that would be a real contribution rather than a restatement.

**(iv)** `Cubical/Data/FinSet/` is byte-identical in file listing between v0.5
and master. `Cubical/Data/Nat/Algebra.agda` (below) is in both.

### 2.4 The finding that should change how blocks work: `Cubical.Data.Nat.Algebra`

`~/agda-libs/cubical/Cubical/Data/Nat/Algebra.agda` — **in our own pin,
available for three years** `[read]`:

```agda
:10   For details see the paper [Homotopy-initial algebras in type theory](https://arxiv.org/abs/1504.05531)
:37   record NatAlgebra ℓ
:43   record NatMorphism (A : NatAlgebra ℓ) (B : NatAlgebra ℓ')
:66   isNatHInitial N ℓ = (M : NatAlgebra ℓ) → isContr (NatMorphism N M)
:228  isNatInductive≡isNatHInitial
:238  isNatHInitial→algebraPath : {N M : NatAlgebra ℓ} → … → N ≡ M
:298  isNatHInitialℕ : isNatHInitial NatAlgebraℕ ℓ
```

Compare `AtlasResiduals.agda`'s claimed contributions A1–A5:

| AtlasResiduals | library equivalent | comparison |
|---|---|---|
| `AlgHom` (§A1) | `NatMorphism` (`:43`) | same Σ-type, as a record |
| `ℕ-isInitial` (§A2) | `isNatHInitialℕ` (`:298`) | **library is stronger.** Our A2 *requires the target carrier to be a set* (the module's own "NOT CLAIMED" §2 admits this and says the ∞-algebra statement "is neither proved nor refuted here"). `isNatHInitialℕ` has **no set hypothesis** — it is the ∞-algebra statement, obtained from `isNatInductive≡isNatHInitial`. |
| `ℕ-recursor-unique`, `ℕ-algebra-endo-is-id` (§A3–A4) | immediate corollaries of `isNatHInitialℕ` at `M = NatAlgebraℕ` | ours are specializations |
| `initial→isEquiv`, `isContrAlgIso` (§A5) | `isNatHInitial→algebraPath` (`:238`) | the library produces a **path of algebras**, which is at least as strong as a contractible type of isomorphisms and is the univalent form |
| `PathIsSymmetry.ℕ-algebra-rigid` | ditto | ditto |

`AtlasResiduals.agda`'s import list (lines 156–165) contains
`Cubical.Data.Nat` but **not** `Cubical.Data.Nat.Algebra`; `grep -rn
"Data.Nat.Algebra" formal/` over the whole repository returns **nothing**. The
module's own header even flags the universe-level worry ("`isInitial` is stated
at a FIXED universe level, because A5 must apply an algebra's initiality to
another algebra AND to itself. No claim is made that these two notions of
initiality agree") — a problem the library solved in 2019 by proving
`isNatInductive≡isNatHInitial` at an arbitrary level.

**Verdict: `AtlasResiduals` §§1–3 is a weaker re-derivation of a module of the
library it imports.** Not a rediscovery of a paper — a rediscovery of a file on
disk.

### 2.5 `FutureBehavior.agda`

Myhill–Nerode is Myhill (1957) / Nerode (1958). It has been formalized
repeatedly. In this repository's own dependency set:
`~/agda-libs/mathlib4/Mathlib/Computability/MyhillNerode.lean` `[read]` —
`Language.leftQuotient`, `leftQuotient_append`, `IsRegular.finite_range_leftQuotient`,
`Language.toDFA` on `Set.range L.leftQuotient` (the minimal automaton),
`mem_accept_toDFA`, `step_toDFA`. That is `run`/`behavior`/`FutureEq`/
`FutureQuotient`/`quotStep`/`quotObserve`/`crystal-minimal` in Lean.

What is **not** in mathlib and is genuinely a univalent statement:
`[]-effectiveIso` — that the *path space* of two named meanings **is** future
equality, as an `Iso` available for transport. In a set-level library that
statement degenerates to `Quotient.exact`/`Quotient.sound`. That single
declaration is the univalent content of the module; the other ~90% restates
1958. Nothing in agda-unimath or cubical does automata minimization
(`grep -rli "myhill\|nerode\|bisimulation" src/` over agda-unimath returns only
`trees/coalgebras-polynomial-endofunctors` and friends, which are W-type
coalgebras, not behaviour quotients).

### 2.6 `CROSS_LENS.md` §8 — the thesis

> *"Both programs, and the foundational cluster, are computing the same object:
> the automorphism group of a presentation. That is the corpus's actual subject,
> and univalence is the only language in which it is not a metaphor."*

This thesis is correct, and it is **the thesis of a 500-page textbook that has
existed since 2021 and was updated yesterday**: *Symmetry*, by Marc Bezem,
Ulrik Buchholtz, Pierre Cagne, Bjørn Ian Dundas, Daniel R. Grayson
(`~/agda-libs/symmetrybook`, `b43cc6f`, 2026-08-13) `[read]`.

Chapter order from `book.tex:55–69`: `intro`, `intro-uf`, `circle`, **`group`**
("Groups, concretely"), `actions`, `cats`, `absgroup`, `congp`, `subgroups`,
`fingp`, `fggroups`, `abelian`, `fields`, `geometry`, `galois`.

In `group.tex`, inside `\begin{example}` `ex:groups`, item `\ref{ex:permgroup}`
(lines 475–495):

```latex
\SG_n\defequi \Aut_{\Set}(\bn n).
The classifying type is thus $\BSG_n\jdeq (\FinSet_n,\bn{n})$,
where $\FinSet_n \jdeq \Set_{(\bn{n})}$ is the groupoid of
sets of cardinality $n$ (\cf \ref{def:groupoidFin}).
Again, we can also identify the group $\SG_n$ with
$\Aut_\FinSet(\bn{n})$ …, with $\Aut_{\FinSet_n}(\bn n)$ …,
or even with $\Aut_{\UU}(\bn n)$ …
```

and immediately after, `\begin{xca} \label{xca:group-example-details}`:

> *"Using~\cref{def:finiteset}, give identifications of type
> $\Aut_\FinSet(\bn{n})\eqto\Sigma_{\bn{n}}$ for $n:\NN$."*

**`ATLAS_OF_N` Theorem 3.1(2) — the corpus's "sharpest residual", the statement
that $S_n = \pi_1(BS_n)$ — is an exercise in Chapter 4 of the Symmetry book.**
The same chapter carries `\Bsgn : \BAut(A) \to \BSG_2` (line 1638ff), i.e. the
delooped sign map, and uses "the total ordering" (line 1604) to point it — which
is, incidentally, exactly the LinOrd datum of C5″, used there as a basepointing
device rather than proved.

`FinSet_2` is the book's *very first* example of a nontrivial classifying type
(`group.tex:90–110`), with the map $S^1\to\FinSet_2$ sending `\Sloop` to `\swap`
— which is C8, the endian torsor, as the opening illustration.

The book is formalized: `[śabda]` search summaries report that agda-unimath
began as a formalization of the Symmetry book (Rijke's suggestion; Stenholm,
Prieto-Cubides, Cagne), which is consistent with the `Concrete-Group` /
`∞-Group` layer read in §2.1. `1lab` cites it directly:
`~/agda-libs/1lab/src/Algebra/Group/Concrete.lagda.md:255` —
`The following construction is adapted from [@Symmetry, §6.5]` `[read]`.

### 2.7 `1lab` (read only; AGPL — do **not** plan to link)

- `src/Algebra/Group/Instances/Symmetric.lagda.md:22` `Sym : (X : Set ℓ) → Group-on (∣ X ∣ ≃ ∣ X ∣)`; `:65` `S n = el! (Fin n ≃ Fin n) , Sym (el! (Fin n))`.
- `src/Algebra/Group/Concrete.lagda.md` — concrete groups as pointed connected groupoids, `Deloop`, `Deloop-Hom`, the equivalence with abstract groups.
- `src/Order/Total.lagda.md`, `src/Data/Fin/Finite.lagda.md` — no finite-total-order-is-standard theorem here either.

---

## 3. The literature frontier — all `[śabda]`

**Every claim in this section comes from a WebSearch result summary. No paper
was read. Do not quote these as if they had been.**

### 3.1 The textbook layer

- **HoTT Book** (*Homotopy Type Theory: Univalent Foundations of Mathematics*, The Univalent Foundations Program, 2013, arXiv:1308.0729).
  - §2.10 is the univalence axiom (`idtoeqv`, `ua`). C10 is this section.
  - **Chapter 5.4, "Inductive types are initial algebras"** `[śabda]`: search summaries state that inductive types are *homotopy-initial* algebras, where "an algebra is homotopy-initial if for every algebra, the type of all weak maps is **contractible**". **That is `AtlasResiduals` A2/A5 as a section heading of the HoTT Book.** §5.5 "Homotopy-inductive types" carries the W-type version.
  - **Chapter 10** covers extensional well-founded orders / ordinals `[śabda]`; C6's ordinal remarks belong there.
  - The primary reference for M5 is **Awodey–Gambino–Sojakova, "Homotopy-initial algebras in type theory", arXiv:1504.05531** — cited *by name in the header of the cubical module we failed to import* `[read]`.
- **Rijke, *Introduction to Homotopy Type Theory*, CUP** (arXiv:2212.11082) `[śabda]`. agda-unimath carries a formalization index at `src/literature/introduction-to-homotopy-type-theory.lagda.md` `[read]`, which covers **Chapters 3–8 only** (natural numbers; inductive types; identity types; universes; modular arithmetic; decidability). The finite-type material is in later chapters and is not in that index — but is in `univalent-combinatorics/` regardless.
- **Bezem–Buchholtz–Cagne–Dundas–Grayson, *Symmetry*** — see §2.6. `[read]` on the source, `[śabda]` on its publication status.
- **Mangel–Rijke, "Delooping the sign homomorphism in univalent mathematics", arXiv:2301.10011** (Jan 2023) `[śabda]` on the abstract: groups as abstract vs. concrete (pointed connected 1-types); characterizes when a pointed map is a delooping of the sign homomorphism; gives several constructions, one following Cartier requiring no reference to the sign homomorphism itself; **results formalized in agda-unimath** — which §2.1 confirms `[read]`.

### 3.2 Where the frontier actually is, 2025–2026

Ordered by distance from this corpus, nearest first.

1. **Higher Observational Type Theory (HOTT).** `[śabda]` A new type theory with **definitional univalence**: identity is defined *recursively per type former* rather than uniformly (identifications of pairs are pairs of identifications, of functions are pointwise, …). Shulman, with Altenkirch, Chamoun, Kaposi on a precursor "type theory with internal parametricity, presheaf model and canonicity proof" (2024). Talks: "Towards Third-Generation HOTT" (HoTTEST Distinguished Lecture Series, three parts, April 2025); "An observational proof assistant for higher-dimensional mathematics" (North American ASL, Spring 2025); "Coinductive Universes and Higher Observational Type Theory" (Chapman, Spring 2026). Funded as a Horizon/ERC project (CORDIS id 101170308). Implementation: **Narya** (`github.com/gwaithimirdain/narya`), "a proof assistant for higher-dimensional type theory", NbE + typechecker for a multi-modal theory with observational Id/Bridge types, described as work in progress.
2. **Directed / simplicial type theory.** `[śabda]` Riehl–Shulman, *A type theory for synthetic ∞-categories*, Higher Structures 1(1):147–224, 2017, is the foundation (Segal + Rezk completeness). The 2026 state: **"The ∞-Category of ∞-Categories in Simplicial Type Theory"** (LICS 2026; arXiv 2602.02218) — reported to construct the ∞-category of ∞-categories and recover **straightening–unstraightening** purely type-theoretically. Also **"Fibrations in Directed Type Theory"** (arXiv 2604.18668) and **"Directed proof-relevant logical relations in simplicial HoTT"** (arXiv 2607.08154). Earlier: "A Constructive Model of Directed Univalence in Bicubical Sets" (LICS '20); "Formalizing the ∞-Categorical Yoneda Lemma" (arXiv 2309.08340).
3. **Higher group theory / classifying types.** `[śabda]` **"Classifying 2-Groups in Homotopy Type Theory"** (LICS 2026) and **"On symmetries of spheres in univalent foundations"** (Cagne–Buchholtz–Kraus–Bezem, LICS 2024). This is the branch our §3 sits under, several levels below.
4. **Cubical implementations.** `[śabda]` Cubical Agda (2021) is the production system and is what we use. `redtt` is retired; `cooltt` is a prototype for Cartesian cubical type theory with full univalence support, "still in the early stages". Cubical Agda's flagship computation remains $\pi_4(S^3)$ (LICS 2023) — mirrored locally as `Cubical/Papers/Pi4S3.agda` and `Pi4S3-JournalVersion.agda` in master `[read]`.
5. **Univalent combinatorics.** `[śabda]` No 2025–2026 breakthrough surfaced. The active artefact *is* agda-unimath's `univalent-combinatorics/` (106 modules) plus `species/` (~50 modules on Cauchy/Dirichlet products, exponentials, series, cycle-index series) — which is the machinery C7 would need.

---

## 4. Deliverable

### (a) Corpus claims that are textbook material and should be re-cited, not re-proved

Each of these should have its "proof" in `ATLAS_OF_N.md` replaced by a citation,
and its Agda module replaced by an import or deleted:

1. **$BS_n$ and its basic homotopy type (§3.1, C1, C3, C4).**
   *This is Chapter 4 of the Symmetry book*, `\SG_n \defequi \Aut_\Set(\bn n)`,
   `\BSG_n \jdeq (\FinSet_n, \bn n)`, with $\Aut_\FinSet(\bn n)\eqto\Sigma_{\bn n}$
   set as **exercise `xca:group-example-details`**. Formally:
   `agda-unimath finite-group-theory.finite-type-groups.iso-loop-group-fin-Type-With-Cardinality-ℕ-Group`
   ∘ `group-theory.loop-groups-sets.iso-symmetric-group-loop-group-Set`.
   `PathIsSymmetry` and `Decategorification` should carry a header saying so.

2. **$\mathbf{FinType}\simeq\sum_n BS_n$ (Thm 3.1(1)).**
   One declaration: `agda-unimath univalent-combinatorics.finite-types.compute-total-Type-With-Cardinality-ℕ`.

3. **$\mathbb N$ is homotopy-initial with a contractible type of algebra maps
   (Thm 2.1, `AtlasResiduals` §§1–3).**
   *This is HoTT Book §5.4* `[śabda]`, whose reference is Awodey–Gambino–Sojakova
   arXiv:1504.05531, and it is **`Cubical.Data.Nat.Algebra.isNatHInitialℕ` in the
   pin we already import** — in a form without our set-carrier restriction.
   `AtlasResiduals` A1–A5 should be deleted and replaced by an import. Retain
   only the *naming* of the special cases if the note wants them by name.

4. **$(\mathrm{Fin}\,n\simeq\mathrm{Fin}\,n)\simeq\mathrm{Fin}(n!)$
   (`SymmetryEnumeration`, `SymmetryCardinality`).** Three independent prior
   proofs: `agda-unimath equiv-count-Permutation`, `UniMath weqfromweqstntostn`,
   `Coq-HoTT fcard_aut`.

5. **The endian $\mathbb Z/2$-torsor as a point of $B(\mathbb Z/2)$ (§3.4).**
   `agda-unimath 2-Element-Type`; and it is the Symmetry book's *opening*
   example of a classifying type.

6. **"Univalence makes the residual an object, not a metaphor" (§7,
   `CROSS_LENS` §8).** This is HoTT Book §2.10 and the thesis of the Symmetry
   book. The sentence is true and should be *attributed*, not presented as this
   corpus's discovery. `CROSS_LENS` §8 currently reads as if the corpus arrived
   at it; it should read "…and univalence is the only language in which it is
   not a metaphor — which is the organizing thesis of Bezem–Buchholtz–Cagne–
   Dundas–Grayson, *Symmetry*."

7. **Myhill–Nerode (`FutureBehavior`).** 1957/58. `mathlib4
   Mathlib/Computability/MyhillNerode.lean`. Keep and foreground
   `[]-effectiveIso`; label the rest a port.

### (b) Open obligations another library could discharge today

**The LinOrd obligation (C5″) — the honest answer is: no library discharges it
univalently, and one library nearly did and gave up.**

- `agda-unimath`: **no.** `order-theory/finite-total-orders.lagda.md` defines
  `Finite-Total-Order` and stops. No rank map, no $\mathrm{Fin}\,n$ comparison.
- `cubical` (v0.5 **or** master): **no.** Master supplies `IsToset` /
  `TosetStr` / `isPropIsToset` / `𝒮ᴰ-Toset`, which would let us delete ~60 lines
  of `LinearOrderFinite.agda`'s §1, but no finite-order classification.
- `UniMath`: **no — and pointedly so.** `OrderedSets.v:360 height_stn` is
  `Abort`ed. The uniqueness half is there (`stn_ord_bij`); existence is not.
- `Coq-HoTT`: **no.**
- `1lab`: **no.**
- `mathlib4`: **yes, classically.** `Mathlib/Data/Fintype/Sort.lean:29`
  ```lean
  def monoEquivOfFin (α : Type*) [Fintype α] [LinearOrder α] {k : ℕ}
      (h : Fintype.card α = k) : Fin k ≃o α
  ```
  plus `Fintype.orderIsoFinOfCardEq` and `Finset.orderIsoOfFin`
  (`Mathlib/Data/Finset/Sort.lean:186, 339`). The corpus has a Lean lane
  (`formal/pairfield/`). **C5″ is a five-line Lean statement today.**

So the actionable items are:

- **(b1)** Discharge C5″ in the **Lean** lane immediately via `monoEquivOfFin`,
  and cite it from `ATLAS_OF_N` §7 as the classical half. Cost: minutes.
- **(b2)** The **cubical** discharge is genuinely open across the whole univalent
  ecosystem, and this repository now holds the hard half of it.
  `formal/cubical/NaturalMachine/LinearOrderFinite.agda` **typechecks clean,
  `--safe`, exit 0** under the pinned toolchain (landed by a concurrent session
  as commit `1356718` while this survey was being written; my own run of
  `agda --safe NaturalMachine/LinearOrderFinite.agda` was killed by its 900 s
  timeout at SIGTERM, so the certification here is that commit's, not mine).
  It builds, inside `module Order (X) (finX : isFinSet X) (L : LinOrd′ X)`:
  `rankEquiv : X ≃ Fin (finX .fst)` and
  `rank-order : (toℕ (rank x) ≤ toℕ (rank y)) ≡ (x ⊑ y)` — **the existence half
  UniMath aborted, with order-reflection as a path of propositions.** That is
  the mathematical content and it is certified.

  Two things are nonetheless still missing, and both are checkable facts about
  the committed file, not opinions:

  1. **The obligation as `AtlasResiduals` states it is still not stated.**
     `AtlasResiduals` asks for `LinOrd′ X ≃ (X ≃ Fin n)`. Grepping the committed
     file for `LinOrd′.*≃`, `≃.*LinOrd′`, `isContr`, or `Iso` returns **nothing**;
     every result lives inside `module Order` and is parameterised by a *given*
     order. The type-level equivalence needs the inverse direction (transport
     $\mathrm{Fin}\,n$'s standard order back along an equivalence) and the two
     round-trips, using `LinOrd′≡` — which the file already provides at `:61`
     and does not yet use for this. Until that declaration exists, C5″ should be
     cited as *"the rank map is an order-reflecting equivalence"*, **never** as
     Theorem 3.2's half (i), and `AtlasResiduals`' "NOT CLAIMED" section should
     be amended to point here rather than left implying nothing has moved.
  2. **The module is an orphan.** `grep -n LinearOrderFinite
     formal/cubical/NaturalMachine.agda` returns nothing — it is not imported by
     the root aggregate, by the committing session's own deliberate choice.
     A module outside the aggregate is not covered by the repository's build and
     can rot silently.

  Once (1) lands and (2) is closed, this is a **real** contribution to the
  univalent ecosystem — the only one identified in this survey — and should be
  offered upstream to `agda/cubical` as a `Toset`-based lemma against master's
  `Relation.Binary.Order.Toset` rather than kept private.
- **(b3)** Retarget the pin, or at least read master. Three years of drift cost
  us a hand-rolled `IsToset`, a hand-rolled `isProp` for it, and the whole
  `Cubical/Data/Ordinal/` development that §3.2's ordinal remarks want.
- **(b4)** C9 (the carry class in $H^2(\mathbb Z/b^n;\mathbb Z/b)$) is
  **unformalizable in either Agda library as they stand** — neither has group
  cohomology or extension classification. Either build it (large, and a genuine
  contribution) or drop the formalization target. Do not leave it on the §7 list
  as though it were comparable in cost to the others.

### (c) Where the 2026 frontier is, relative to this corpus — bluntly

The frontier is **two full levels above** where §3 of `ATLAS_OF_N` sits, and §3
is itself below the textbook line.

- The **frontier** (2026) is: definitional univalence (HOTT / Narya); the
  ∞-category of ∞-categories inside simplicial type theory with
  straightening–unstraightening recovered type-theoretically (LICS 2026);
  classification of 2-groups in HoTT (LICS 2026); symmetries of spheres. These
  are about *directed* structure and about *higher* groups.
- The **consolidated layer beneath it** (2021–2023) is: concrete vs. abstract
  groups, deloopings, the sign homomorphism and its three deloopings — the
  Symmetry book and Mangel–Rijke, **fully formalized in agda-unimath**.
- **This corpus's §3 sits below that**: it states the *definition* of $BS_n$,
  computes $\Omega BS_n$, and observes $\pi_0 = \mathbb N$. Those are the
  definition, the exercise, and the remark that open Chapter 4 of the Symmetry
  book. §3.1 cites Mangel–Rijke's *abstract* for the definition and does not
  engage with the paper's theorems — which are the first genuinely nontrivial
  statements about $BS_n$ and are machine-checked in a library on our disk.
- The Agda lane is worse off than the prose lane, because it re-derived
  `Cubical.Data.Nat.Algebra` — a file inside the library it imports — in a form
  weakened by an unnecessary set-carrier hypothesis, and wrote a "NOT CLAIMED"
  paragraph apologizing for exactly the gap the library had already closed.

Three things in the corpus are **not** restatements, and they are where the
foundational cluster's remaining value is:

1. **C5″ in cubical** — the finite-total-order rigidification. Missing from
   every univalent library; aborted in UniMath. The hard half is checked here
   (`LinearOrderFinite.agda`, commit `1356718`, `--safe`, exit 0); the
   type-level packaging and the aggregate import are not. Worth finishing and
   upstreaming — see (b2).
2. **C7** — $(\mathbb F_{\ge1},\times)$ is *not* the free symmetric monoidal
   groupoid on the primes, with an exact index (`ATLAS_OF_N` Thm 6.1). A
   negative result about a specific structure; no ecosystem hit. Whether it is
   *new* is a question for a proper literature search of the species/combinatorial
   -species literature (Joyal), which this session did **not** perform and which
   the CLAUDE.md protocol requires **before** the next block touches it.
3. **C9** — the carry class as a nonzero $H^2$. Elementary as mathematics
   (nonsplit extension $0\to\mathbb Z/b\to\mathbb Z/b^{n+1}\to\mathbb Z/b^n\to0$),
   but with no formal infrastructure anywhere in univalent foundations.

Everything else in the univalent lane should be re-cited and the code deleted or
turned into imports. The correct next action for the foundational cluster is not
another module; it is a subtraction.

---

## 5. Ledger

- No new mathematics. No claim below §2 is asserted on this repository's
  authority.
- `[read]` = the file was opened and the cited line examined here.
  `[śabda]` = a WebSearch summary said so; no page body was retrieved.
- `WebFetch` is EGRESS_BLOCKED on every host including `ncatlab.org`. **No nLab
  content appears in this document**, and none can be obtained from this
  environment. Any future note citing the nLab from this repo is citing
  something it did not read.
- `formal/cubical/NaturalMachine/LinearOrderFinite.agda` **does** typecheck
  (`--safe`, exit 0) — certified by a concurrent session's commit `1356718`,
  landed while this note was being written, **not** by this session: my own
  `agda --safe` run on it was terminated by a 900 s timeout (SIGTERM, exit 143)
  without reaching a verdict. What this note establishes independently, by
  reading the committed source, is narrower and is the part that matters for
  the obligation: the file contains **no** top-level `LinOrd′ X ≃ (X ≃ Fin n)`,
  and **no** import of it from the root aggregate. See §4(b2).
- Prior art was searched *before* recommending any further work, per
  `CLAUDE.md` — which is what produced §2.4, and which, had it been done before
  `AtlasResiduals.agda` was written, would have saved that module entirely.
