# Generability versus reconstructibility: δ_◁ and δ_▷ are the density comonad and the codensity monad, and they are independent

**Status.** Identification proved; separation proved by finite exhaustive verification in a
three-object poset (all four combinations realised); the underlying mathematics is
**classical** (Isbell 1960; Ulmer; Kock, Appelgate–Tierney; Kennison–Gildenhuys 1971), and
this note says so plainly. Nothing here is new mathematics. What is new to *this corpus* is
that the identification has been made explicitly and the separation given witnesses.

**Source.** Repository owner, transmission `D0018` §C
(`collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md`, lines 83–105), triaged
at §J2 as "the first `PROVE` item created by this artifact". §D of the same transmission
(lines 106–110) supplies the definition of 𝔐_i used below. Owner artifact: this note derives
from it and does not rewrite it.

---

## 0. The transmission's statement, verbatim

From D0018 §C:

> δ_◁(X) := cofib( hocolim_{i∈J_X} 𝔐_i → X ),  δ_▷(X) := fib( X → holim_{i∈J_X} 𝔐_i )
>
> δ_◁ = 0 ⟺ complete generation by relations
> δ_▷ = 0 ⟺ complete reconstruction by relations
>
> **generability ≢ reconstructibility**

and from §D:

> 𝔐_i := ( Map(−,i), Map(i,−), ⟨−,−⟩_i ),  i ≃ j ⟺ Map(−,i) ≃ Map(−,j)

---

## 1. Reading the objects (§1 is the load-bearing part of this note)

### 1.1 The datum

Fix a category **C** and a functor **G : J → C** (in the transmission's notation, J is the
category of "relations" and i ↦ 𝔐_i is G). Everything below is about a *fixed* G; the
transmission's subscript J_X is unpacked in §1.2.

**Reading, stated explicitly and defended.** 𝔐_i is *not* a single representable. It is the
pair (Map(−,i), Map(i,−)) together with a pairing — i.e. the object G i presented through
both its contravariant and its covariant representable. I claim this pairing is exactly the
bookkeeping that makes δ_◁ and δ_▷ well-posed, and here is why.

The two maps in §C cannot be indexed by one and the same category. The canonical map *out of*
a colimit into X is indexed by maps **into** X; the canonical map *from* X into a limit is
indexed by maps **out of** X. So "J_X" in §C denotes two different comma categories:

- **left slice** G/X, objects (i, f : G i → X) — this is where Map(−, X) meets Map(G(−), −),
  i.e. the leg Map(i,−) evaluated at X;
- **right slice** X/G, objects (i, g : X → G i) — the leg Map(−, i) evaluated at X.

The pair structure on 𝔐_i is thus not decoration and not an obstacle: it is precisely the
statement that one family (i ↦ G i) supplies *both* index categories, one per leg. A reading
in which 𝔐_i were "simply a representable" would have to choose a variance and would lose one
of the two constructions. The pairing ⟨−,−⟩_i is left uninterpreted here; nothing below uses
it, and I do not claim it is discharged. **Ground of this reading:** the domain/codomain
bookkeeping of the two canonical maps, which is forced, plus the explicit two-leg definition
in §D line 109. It is not licensed by anything stronger.

### 1.2 The identification

**Theorem 1 (identification).** Let G : J → C with J small and let X ∈ C.

(a) If the pointwise left Kan extension Lan_G G exists, then
  (Lan_G G)(X) ≃ colim_{(i,f) ∈ G/X} G i,
and the canonical map colim_{G/X} G i → X is the counit ε_X of the density comonad
L_G := Lan_G G. Hence δ_◁(X) = cofib(ε_X).

(b) If the pointwise right Kan extension Ran_G G exists, then
  (Ran_G G)(X) ≃ lim_{(i,g) ∈ X/G} G i ≃ ∫_{i∈J} Map(X, G i) ⋔ G i,
and the canonical map X → lim_{X/G} G i is the unit η_X of the codensity monad
T^G := Ran_G G. Hence δ_▷(X) = fib(η_X).

*Proof.* Both are the pointwise formulas for Kan extension along G evaluated at X, together
with the standard fact that Lan_G G carries a comonad structure with counit the canonical map
(the comultiplication from the universal property of Lan), and Ran_G G a monad structure with
unit the canonical map. The end formula in (b) is the standard rewriting of the limit over
X/G. In the ∞-categorical setting replace colim/lim by hocolim/holim and Kan extension by
left/right Kan extension of ∞-functors; the statements are unchanged. ∎

**Remark 1.1 (the presheaf-level reading agrees).** One may also read "hocolim_i 𝔐_i" at the
level of presheaves: the restricted Yoneda embedding Ñ_G : C → [J^op, S], X ↦ Map(G(−), X),
has left adjoint the realization |−|_G = Lan_y G, and the counit of |−|_G ⊣ Ñ_G at X is
exactly the map colim_{G/X} G i → X of Theorem 1(a). So the presheaf-level and object-level
readings of §C give the same δ_◁; dually for δ_▷ with corepresentables. **Ground:** the
nerve–realization adjunction, standard.

### 1.3 What "= 0" means — and this is a genuine fork

fib and cofib require a zero object. Two settings, both defensible, give two different
theorems, and I state both rather than silently choosing.

- **(S) Stable/pointed setting.** In a stable ∞-category (or triangulated category),
  fib(f) ≃ 0 ⟺ f is an equivalence ⟺ cofib(f) ≃ 0. Then
  **δ_◁ ≡ 0 ⟺ G is dense** (ε iso), **δ_▷ ≡ 0 ⟺ G is codense** (η iso).
  This is the transmission's literal reading and the one matching "complete".
- **(A) Abelian setting**, fib = ker, cofib = coker. Then δ_◁(X) = 0 ⟺ ε_X is **epi**, and
  δ_▷(X) = 0 ⟺ η_X is **mono**. For a discrete family {G_i} these say exactly:
  {G_i} is a **generating** family, resp. a **cogenerating** family. This reading matches the
  transmission's *words* ("complete generation", "complete reconstruction") better than its
  symbols do, since generation is naturally a surjectivity condition.

Both readings are treated below. They are not equivalent and I do not claim they are.

**Scope limit.** Everything above assumes J small and the relevant Kan extension pointwise.
Without pointwiseness the comma-category formulas fail and §C has no evident meaning.

---

## 2. The separation

### 2.1 Finite exhaustive witnesses (reading (S)) — four subsets of a three-chain

Let **P** = {0 < 1 < 2}, the three-element chain regarded as a category, and for S ⊆ P let
G_S : S ↪ P be the inclusion of the full subcategory. P has an initial object 0 and a terminal
object 2, so empty colimits and limits exist.

In a poset, all diagrams are computed by sup and inf, and Theorem 1 specialises to:

  (Lan_{G_S} G_S)(x) = sup(S ∩ ↓x),  (Ran_{G_S} G_S)(x) = inf(S ∩ ↑x),

with the canonical maps sup(S∩↓x) ≤ x and x ≤ inf(S∩↑x). Reading (S): the canonical map is
"0-defect" iff it is an isomorphism, i.e. iff equality holds. Write
**δ_◁(x) = 0 ⟺ x = sup(S ∩ ↓x)** (S join-dense at x) and
**δ_▷(x) = 0 ⟺ x = inf(S ∩ ↑x)** (S meet-dense at x), with sup ∅ = 0 and inf ∅ = 2.

**Theorem 2 (four-fold independence).** All four combinations of (δ_◁ ≡ 0?, δ_▷ ≡ 0?) occur
for full subcategories of P. Specifically:

| S | δ_◁ (join-dense) | δ_▷ (meet-dense) |
|---|---|---|
| {0,1,2} | ≡ 0 | ≡ 0 |
| {1,2} | ≡ 0 | ≠ 0 at x=0 |
| {0,1} | ≠ 0 at x=2 | ≡ 0 |
| {1} | ≠ 0 at x=2 | ≠ 0 at x=0 |

*Proof — finite exhaustive verification.* Twelve object-checks (four subsets × three objects)
per column; here they are.

S = {1,2}: join side — x=0: S∩↓0 = ∅, sup ∅ = 0 = x ✓; x=1: S∩↓1 = {1}, sup = 1 ✓;
x=2: S∩↓2 = {1,2}, sup = 2 ✓. So δ_◁ ≡ 0. Meet side — x=0: S∩↑0 = {1,2}, inf = 1 ≠ 0 ✗
(δ_▷(0) ≠ 0); x=1: {1,2}, inf = 1 ✓; x=2: {2}, inf = 2 ✓.

S = {0,1}: join side — x=0: {0}, sup = 0 ✓; x=1: {0,1}, sup = 1 ✓; x=2: {0,1}, sup = 1 ≠ 2 ✗
(δ_◁(2) ≠ 0). Meet side — x=0: {0,1}, inf = 0 ✓; x=1: {1}, inf = 1 ✓; x=2: S∩↑2 = ∅,
inf ∅ = 2 ✓. So δ_▷ ≡ 0.

S = {1}: join side — x=0: ∅, sup = 0 ✓; x=1: {1} ✓; x=2: {1}, sup = 1 ≠ 2 ✗. Meet side —
x=0: {1}, inf = 1 ≠ 0 ✗; x=1: {1} ✓; x=2: ∅, inf = 2 ✓.

S = P: G = id, Lan_id id = id = Ran_id id, both counit and unit are identities ✓ (or check
the six cases directly: x = sup(↓x) = inf(↑x) in any poset).

The verification is finite and complete; by CLAUDE.md this is a proof, not a measurement. ∎

**Corollary 2.1 (the transmission's claim, §C).** generability ≢ reconstructibility: rows 2
and 3 give δ_◁ = 0 ≠ δ_▷ and δ_▷ = 0 ≠ δ_◁ respectively. Neither condition implies the other,
and row 4 shows they do not jointly exhaust the failure modes. ∎

**Remark 2.2.** The two separating witnesses are exchanged by the order-reversing
automorphism x ↦ 2−x of P, which carries {0,1} to {1,2}. This is not a defect of the example;
it is the content of Theorem 3 below.

### 2.2 Witnesses in reading (A), in Ab

**Theorem 2′.** In C = Ab, with G a one-object discrete family:

(a) G = {ℤ}: δ_◁(A) = 0 for every A, while δ_▷(ℤ/2) ≠ 0.
(b) G = {ℚ/ℤ}: δ_▷(A) = 0 for every A, while δ_◁(ℤ) ≠ 0.

*Proof.* (a) The counit colim_{ℤ/A} ℤ → A has image the subgroup generated by
{f(1) : f ∈ Hom(ℤ,A)} = A, so it is epi and coker = 0: ℤ generates. For δ_▷: Hom(ℤ/2, ℤ) = 0
since ℤ is torsion-free, so X/G is empty and the limit is the terminal object 0; the unit is
ℤ/2 → 0, whose kernel is ℤ/2 ≠ 0.
(b) ℚ/ℤ is a cogenerator of Ab: for 0 ≠ a ∈ A, the cyclic subgroup ⟨a⟩ admits a nonzero
homomorphism to ℚ/ℤ (send a generator of ⟨a⟩ ≅ ℤ/n to 1/n, or ⟨a⟩ ≅ ℤ to any nonzero element),
which extends to A since ℚ/ℤ is divisible hence injective (Baer). So η_A : A → ∏_{A→ℚ/ℤ} ℚ/ℤ
is mono, ker = 0. For δ_◁: Hom(ℚ/ℤ, ℤ) = 0 (ℤ has no nonzero divisible subgroup), so the
colimit is 0 and coker(0 → ℤ) = ℤ ≠ 0. ∎

So in reading (A) the separation is the classical, entirely standard fact that a generating
family need not cogenerate and conversely. **Ground:** injectivity of ℚ/ℤ (Baer's criterion)
and torsion-freeness of ℤ; nothing sharper is claimed.

### 2.3 A hypothesis that does force the implication

**Theorem 3 (self-duality forces the exchange).** Let D : C^op → C be an equivalence, and
suppose the family is self-dual: D ∘ G^op ≃ G (up to reindexing J^op ≃ J). Then for all X,
δ_◁(X) = 0 ⟺ δ_▷(D X) = 0. In particular G is dense iff G is codense.

*Proof.* D carries colimits to limits and induces an isomorphism of comma categories
G/X ≃ (D X / G)^op (an object (i, f : G i → X) goes to (i, D f : D X → D G i ≃ G i)). Hence
D applied to the counit ε_X : colim_{G/X} G i → X is the unit η_{DX} : DX → lim_{DX/G} G i up
to the identifications, and an equivalence is carried to an equivalence in both directions. ∎

**This is the hypothesis, and it is sharp in the following sense.** In Theorem 2 the *ambient*
category P is self-dual (x ↦ 2−x), yet the separation holds — because the *family* S = {0,1}
is not self-dual (its image is {1,2}). So self-duality of C alone is insufficient; the
hypothesis must be on the pair (C, G). Theorem 2 rows 2 and 3, exchanged by exactly that
duality, is the witness. Reading (A) has the same shape: Ab is not self-dual, and ℤ ↔ ℚ/ℤ is
the Pontryagin-flavoured exchange that Theorem 2′ separates.

**Remark 3.1 (enrichment is not a side condition).** Density is sensitive to the enrichment:
{k} ⊂ Vect_k is dense as a **Vect_k**-enriched subcategory but not as an ordinary
(Set-enriched) one, since the restricted Yoneda functor V ↦ Hom_{Set}(k,V) is not full. Any
use of §C must fix the enrichment before "= 0" means anything. I do not develop this; it is
recorded as a hypothesis that §C leaves unstated.

---

## 3. Prior art — the claim is classical

Sources I actually read (nLab pages and the ar5iv HTML rendering; **no PDF was opened**):

1. **Isbell, 1960** — density first isolated, under the name *left adequate* full subcategory.
   Reported in Leinster's historical section (read at
   `ar5iv.labs.arxiv.org/html/1209.3606`). I have **not** read Isbell directly and quote him
   only at second hand.
2. **Ulmer** — generalised adequacy from full-subcategory inclusions to arbitrary functors and
   introduced the word "dense" (same second-hand source).
3. **Kock; Appelgate–Tierney** (independently) — the codensity monad of a functor; further
   early sources Linton, Dubuc (same second-hand source).
4. **Kennison–Gildenhuys, 1971** — the codensity monad of FinSet ↪ Set is the **ultrafilter
   monad**. Quoted from Leinster's abstract and historical section, which I read at
   `arxiv.org/abs/1209.3606` and `ar5iv.labs.arxiv.org/html/1209.3606`. I did not open the
   1971 paper.
5. **nLab, "codensity monad"** (read directly): "The codensity monad reduces to the identity
   monad iff G : ℬ → 𝒜 is a codense functor. Thus, in general, the codensity monad 'measures
   the failure of G to be codense'." Carrier: T^G(A) = ∫_{B∈ℬ} 𝒜(A, GB) ⋔ GB.
6. **nLab, "dense functor"** (read directly): a functor is dense precisely when Lan_i i exists,
   is pointwise, and equals the identity; equivalently the restricted Yoneda embedding
   C → [S^op, Set] is fully faithful. The page also records that dense functors are **not**
   closed under composition, and that Top has no small dense subcategory.
7. **Leinster, "Codensity and the ultrafilter monad"**, TAC 2013 (arXiv:1209.3606), abstract
   and historical section read in HTML.

**Verdict on novelty.** The identification (Theorem 1) is the definition of the density
comonad and the codensity monad. The independence (Theorem 2, Cor 2.1) is implicit in the
classical literature the moment both notions are defined separately — nLab states each
triviality criterion independently, and no implication between them is asserted anywhere I
read. **The transmission's boxed claim is true and classical.** It is not a rediscovery of a
*named theorem* so much as a correct reading of standard definitions; but it is not new
mathematics and must not be cited as such.

**What, if anything, is new in the framing.** Two presentational choices, neither a theorem:
(i) packaging the two legs Map(−,i) and Map(i,−) into a single datum 𝔐_i, so that one family
indexes both slices (§1.1) — convenient bookkeeping, no content; (ii) writing the two defects
as cofib and fib in a stable setting rather than as "ε is iso"/"η is iso", which is a genuine
strengthening of expressiveness only in the abelian reading (A), where δ_◁ = 0 and δ_▷ = 0
become *generation* and *cogeneration* rather than density and codensity — and those are also
classical. I claim no novelty for either.

---

## 4. Corpus link — a considered "no"

I searched `notes/`, `papers/`, and `collab/` for *codensity*, *density comonad*,
*ultrafilter monad*, *cogenerator*, *dense subcategor*, and *Kan extension*.

- "codensity" occurs **only** in D0018 itself.
- "density comonad", "ultrafilter monad", "cogenerator": **zero** hits.
- `notes/OPERATIONAL_SITE_CRYSTAL.md` line 230 lists "dense subcategories, and the
  nerve/density theorem" in a paragraph disclaiming novelty for the Grothendieck-site
  framework; it uses density as background, not as a defect measure, and its Theorem 4.1 is
  about a finite powerset site. No bearing.
- `notes/OPTIMIZATION_THROUGH_FORGETTING.md` lines 65–67 use a left Kan extension of a cost
  function along a candidate map, and correctly note the comma-category indexing. That is Lan
  along a *different* functor than its own target, so it is not a density comonad. No bearing.

**Conclusion: the generability/reconstructibility distinction bears on nothing currently in
the corpus.** Per D0018 §J8 I have not relabelled any existing result in this vocabulary, and
I do not recommend doing so.

---

## 5. What I did not prove

Stated so no later reader upgrades it:

- **§D's ordinal defect ladder** δ^{(n+1)} = Path(Γδ^{(n)}_L, Γδ^{(n)}_R), 𝔯_ω, the saturation
  criterion ∂𝔯_ω = 0: untouched. Γ is not given as a functor and Path is not typed.
- **𝔉_♦ = diag ∘ Q ∘ Φ ∘ Γ ∘ 𝔇** (§F) and **𝔅_∞ = ∫^α**: untouched. D0018 §J7 already lists
  these as notation awaiting content; nothing here discharges them.
- **The MDL functional §A**: untouched. No code length, no space of 𝔏, no existence argument
  for the argmin — as §J7 says.
- **χ_α (§D)**: not measured, not defined, not used. §J5's hazard ruling stands.
- **The pairing ⟨−,−⟩_i** in 𝔐_i is not interpreted here; §1.1 uses only the two legs.
- **Enrichment** (Remark 3.1): I exhibited that density is enrichment-dependent but did not
  develop the enriched theory or state which enrichment §C intends.
- **The relation between readings (S) and (A)** beyond noting they differ: not developed. No
  claim that one implies the other.
- I did **not** read Isbell 1960, Ulmer, Kock, Appelgate–Tierney, Linton, Dubuc, or
  Kennison–Gildenhuys 1971 directly; those attributions are second-hand from Leinster's HTML
  and from nLab, and are labelled as such in §3.
- Numbers and witnesses here are not comparable to any other pass's: nothing in this note is
  numerical, and there is no prior pass on this material in the corpus (§4).

---

## 6. Verdict

**Separated, with witnesses; and classical.**

- Separation: Theorem 2 (finite exhaustive, three-object poset, all four combinations) and
  Theorem 2′ (Ab, ℤ vs ℚ/ℤ).
- Forcing hypothesis: Theorem 3 — self-duality of the *pair* (C, G), not of C alone.
- Prior art: density comonad / codensity monad, Isbell 1960 → Ulmer → Kock,
  Appelgate–Tierney; Kennison–Gildenhuys 1971 (FinSet ↪ Set gives the ultrafilter monad);
  nLab and Leinster (TAC 2013) read directly.

The transmission's boxed claim is **true**, and it is **not new**. Credit for posing it as a
`PROVE` item in this corpus: the repository owner, D0018 §C, triaged §J2.
