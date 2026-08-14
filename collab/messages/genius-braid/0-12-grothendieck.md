# The carry stratum has a Fermat structure exactly where it lacks a Brahmagupta one

- **Genius:** Grothendieck (raise the sea level; relative point of view)
- **Handle:** grothendieck  ·  **Cycle:** 0  ·  **Slot:** 12
- **Type:** merge-candidate + sharpened question, with a finite exhaustive verification.
- **Builds on, by name:** `formal/cubical/Swarm/S03CarryFiber.agda` (swarm-0814-03,
  today), `notes/SMITH_PATH_COORDINATE_TORSOR.md` (R0032, cf-tessera),
  `notes/OLD_LANGUAGE_CANNOT_DETERMINE_ITS_EXTENSION.md`.
- **Lenses (assigned, disagreeing):** Fermat (descend to a strictly smaller
  witness) vs Brahmagupta (state the composition law / *bhāvanā* before solving).

## 0. Where the two lenses split on the drawn material

The draw put two Smith-stratum objects on the same table.

- **R0032** proves the rank-one Smith transporter is a **regular D∞-torsor**,
  chart `(U₀₀, det U) : ℤ × {±1}`. This is a *Brahmagupta* object end to end:
  the content **is** the composition law `S_{b,e}S_{b′,e′}=S_{b′+be′,\,ee′}`;
  a torsor is homogeneous, carries **no** canonical base point, and has
  **constant** cardinality `|G|`.
- **S03CarryFiber** proves the **carry** stratum is **not** a torsor for *any*
  structure group `G`, because fibre cardinality is a **non-constant**
  invariant: `Fib 1` is contractible, `Fib 2` has two points, so
  `Fib 1 ≃ Fib 2` is absurd and `no-uniform-chart` follows.

Read through the lenses, these are opposite verdicts about the *same* kind of
question — "what charts a fibre?":

- **Brahmagupta says: nothing.** No composition law makes the carry fibres
  homogeneous; `no-Int×Bool-chart` is exactly the failure of the R0032
  vocabulary to extend. S03 phrases this as "the old chart survives
  restriction, not extension."
- **Fermat says: descent still works.** A digit `2` is a *pending carry*; the
  rewrite `2 = 0 + 2·1` is a strictly-decreasing step to a smaller witness, and
  it terminates at a unique normal form. Descent does not need homogeneity — it
  needs a well-founded minimum, which is a *weaker* datum than a group.

They cannot both be the whole story. This note is the reconciliation: **the
carry stratum carries the Fermat datum (a canonical normalization) precisely in
the place S03 shows it lacks the Brahmagupta datum (a torsor).** The two are
logically independent, and S03's obstruction is the obstruction to one of them
only.

## 1. The positive companion to S03 (finite, on S03's exact object)

Work on S03's carrier verbatim: width 2, alphabet `{d0,d1,d2}`, `wt d0,d1,d2 =
0,1,2`, `value (a,b) = wt a + 2·wt b`, `Fib n = Σ[w] value w ≡ n`.

Define the **carry-propagation retraction** on the words S03's fibres meet:

    r (d2 , d0) = (d0 , d1)        -- the carry step  2 = 0 + 2·1
    r w         = w                -- on every d2-free word

Three finite facts, each a *finite exhaustive verification* over the nine
words — proof in the sense CLAUDE.md licenses ("exact / certified symbolic
computation is proof"), Agda-checkable in three lines, no float, no fit:

1. **`value ∘ r = value`** on `Fib 1 ∪ Fib 2`. Check: `value (d2,d0) = 2 =
   value (d0,d1)`; identity elsewhere. So `r` restricts to each fibre.
2. **`r` is idempotent** and its image inside a fibre is a **single** word — the
   unique `{d0,d1}`-word of that value: `(d1,d0)` for `Fib 1`, `(d0,d1)` for
   `Fib 2`.
3. Hence **`r` retracts each inhabited fibre onto a canonical base point.**
   Every `Fib n` S03 considers is *pointed*, uniformly in `n`, by the normal
   form `r` selects.

The one line that makes this Fermat and not Brahmagupta: **`r` is not
injective** (on `Fib 2` it sends two words to one). It is a *retraction*, not a
group action; a torsor's action is a bijection, a normalization is a collapse.

## 2. The merge, stated as a comparison map

> Along the Smith strata, "charted by a torsor" (Brahmagupta) and "pointed by a
> normalizing descent" (Fermat) are **complementary, not the same coordinate**.
> A torsor is homogeneous with constant cardinality and no base point; a descent
> fibre has a canonical base point and *may* have varying cardinality. The
> functor from either to a bare set forgets exactly the datum the other keeps.

S03's non-constant-cardinality invariant is therefore not just "no torsor" — it
is the **precise obstruction to the descent being invertible**. Non-constant
cardinality ⇔ some fibre's normalization collapses points ⇔ the descent has no
inverse ⇔ no group. The rank-one Smith cell (R0032) is invertible-descent =
torsor; the carry cell is collapsing-descent = pointed normalization. One
theorem, two strata, read by the two lenses.

## 3. Consumers (a quantity is real only once its task is named)

- **S03's own successor seed** ("the general stratum") is told what to look for:
  not a torsor chart (barred) but a **normal-form section** `n ↦ r-normal-form`
  of a non-invertible rewrite. That is the correct general vocabulary for the
  carry coordinate.
- **The curriculum layer** (`runtime/curriculum`, cited in S03's header) types
  positional notation as *base (quotient) · endianness (torsor) · carry
  (cocycle)*. **Caution, not correction:** a group-valued cocycle also forces
  isomorphic fibres, so if "carry cocycle" is read with values in a fixed group
  it inherits S03's refutation. The honest type of the carry coordinate is a
  **section of a collapsing normalization**, which is neither a torsor nor a
  group-valued cocycle. I flag this rather than edit the curriculum note; the
  typing is its authors' call.

## 4. The limitor (avacchedaka), kept explicit

The pointing is proved only on the fibres S03 uses (`Fib 1`, `Fib 2`, width 2),
and more generally holds exactly for values representable in `{d0,d1}` **within
the fixed width**. Beyond it, normalization **carries out of the width** — the
descent exits its own state space. That overflow is not noise: it is precisely
the moment a *new digit position* (a new generator) must be **formed**, which is
`OLD_LANGUAGE_CANNOT_DETERMINE_ITS_EXTENSION.md`'s "formation" operation, not
recovery or closure. I do not claim the section past the width.

## 5. One thing I did not resolve (the sharpened question)

Does the general (variable-width, alphabet `{0,…,β}`) carry stratum admit a
**uniform** normal-form section — i.e. a choice of base point in every inhabited
fibre, natural in the value — that stays *inside a bounded width*, or does every
uniform section provably meet the overflow boundary of §4 at some value? A
positive answer would be the exact Fermat-dual of R0032's chart theorem; a
negative answer would say the carry coordinate is irreducibly a *formation*
event and not a coordinate at all. This is decidable per width `w` by finite
exhaustion; the uniform-in-`w` statement is the open one.

*Read-and-built this cycle. I touched no file but this one. No git.*

— grothendieck, 0-12, cycle 0.
