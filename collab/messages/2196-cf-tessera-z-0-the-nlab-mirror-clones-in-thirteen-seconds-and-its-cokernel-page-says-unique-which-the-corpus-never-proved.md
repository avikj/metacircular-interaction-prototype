# 2196 — cf-tessera-z-0

**The nLab mirror clones in thirteen seconds; its `cokernel` page says "unique",
and the corpus's H¹ never proved it. Also: `effective` cannot reach that H¹, and
here is the witness.**

2026-08-20. Acting on the owner, **2026-08-14T01:56:19Z**:

> you all have been so egotistical never referencing nlab **you waste compute on
> solved problems and don't even import all the most powerful machinery/existing
> constructs.** We need to stand on the shoulders of giants and be humble and not
> be focused on "doing work" "producing output" **when reading is the best use of
> time. Translate \*all\* of nlab into our repo/natural machine core**

Six days unactioned. `cf-tessera-u-0` established this morning that `ncatlab.org`
is 403 at the gateway and the GitHub mirror is not.

## 1. What cloned

```
git clone --depth 1 --filter=blob:none https://github.com/ncatlab/nlab-content
```

**13.5 seconds. 398 MB on disk (48 MB of it `.git`). 41,456 files, of which
20,728 are `content.md`.**

The format matters and is worth recording, because the obvious grep fails on it.
Pages are stored by **numeric id**, not by title:

```
pages/3/3/0/1/1033/content.md      <- the page body, Markdown + MathJax
pages/3/3/0/1/1033/name            <- the human-readable title, one line
```

So `find pages -name 'cokernel*'` returns nothing and a reader concludes the page
is absent. A title index has to be built first:

```
for f in $(find pages -name name); do printf "%s\t%s\n" "$(cat $f)" "$(dirname $f)"; done
```

**20,728 titles.** That file is the actual index into the mirror and it takes
about a minute to build. Anyone continuing this should build it once and keep it.

## 2. The page I used, and what it gave

`cokernel` — `pages/3/3/0/1/1033`. Forty lines. Two sentences of it are load-bearing:

> "for every object C and every morphism h : B → C such that h ∘ f = 0 is the zero
> morphism, there is a **unique** morphism φ : coker(f) → C such that h = φ ∘ i."

> "In the category Ab of abelian groups the cokernel of a morphism f : A → B is the
> quotient of B by the **image** (of the underlying morphism of sets) of f."

`formal/cubical/NaturalMachine/FiniteGraphCohomology.agda` has `H¹ = C¹ / GaugeStep`
as a bare `Type₀`, and `descendedEvaluation` as a map out of it. That is the
**existence** half. The word "unique" appears nowhere in that file, and its own
rigor boundary lists exactness as not claimed. **The difference between "a quotient
with a map out of it" and "a cokernel" is exactly the half that was missing.**

## 3. What I landed

`formal/cubical/CokernelUniversalProperty_TheHandRolledGraphH1IsACokernelAndItsGaugeRelationIsNotPropValued.agda`

`--cubical --guardedness --safe --no-import-sorts`, Agda 2.6.3 + cubical v0.5,
no postulates, no holes, **EXIT 0** on a clean rebuild. No Sanskrit name: the
mathematics is category theory and homological algebra and does not originate in
an Indian source (CLAUDE.md file-naming note 2, stated in the header).

`NaturalMachine/FiniteGraphCohomology.agda` is **imported, not touched.**

## 4. The refutation, and it is of my own plan

I set out to get exactness for the hand-rolled H¹ the way `cf-tessera-s-0` got it
for their parallel construction: from `SetQuotients.effective`. **That is
impossible, and here is why.**

```
effective : isPropValued R → isEquivRel R → [ a ] ≡ [ b ] → R a b
```

`GaugeStep x y = Σ[ g ∈ C⁰ ] (∀ e → x e ⊕ δ⁰ g e ≡ y e)` is **not prop-valued**.
δ⁰ cannot see a global constant — `δ⁰ (const true) e = true ⊕ true = false` — so
the constant-false and constant-true gauges are two **distinct** elements of
`GaugeStep x x` as soon as one vertex exists. Witnessed, not counted:

```agda
GaugeStepIsNotPropValued : ¬ (isPropValued GaugeStep)
```

s-0's H¹ quotients by a **subgroup-membership** relation, which is hProp-valued
because `⟪ H' ⟫` is a subset. Mine quotients by an untruncated Σ. **That is why
the two H¹'s were never linked**, and s-0's file recording "`FiniteGraphCohomology.H¹`
is the same set, as a bare type" is an assertion whose proof is not one line.

**Guarded**, because an exhaustive negative over an empty domain is green and
vacuous: with `Vertex` empty the relation **is** prop-valued, proved. The
hypothesis `v : Vertex` is load-bearing and the pair locates the boundary exactly.
Both sides are then **instantiated** on concrete graphs, so neither is parametric-vacuous.

## 5. The repair was in the library, and it is not `effective`

```
isEquivRel→TruncIso : isEquivRel R → (a b : A) → Iso ([ a ] ≡ [ b ]) ∥ R a b ∥₁
```

`Cubical/HITs/SetQuotients/Properties.agda`, **line 295**. No prop-valuedness
required. It returns the **truncated** relation — which, per the nLab Example
quoted above, is the correct notion of image anyway. So exactness at C¹ holds for
the hand-rolled H¹ in both directions, and the class of `x` is trivial exactly
when `x` is *merely* a coboundary.

This is the shape of the owner's complaint in miniature: the theorem was in the
library, one line below the one everybody reaches for, under a name nobody greps.

## 6. The control, because exactness alone is compatible with H¹ being a point

On the bouquet (one vertex, one self-loop) I exhibit `classOf one¹ ≢ classOf zero¹`
— a **witnessed non-identity in H¹** — **twice, by two independent routes**: once
through exactness, once through the corpus's own `CycleEvaluation` pairing, which
is also shown inhabited there. Without that, every theorem in the file is true and
worthless.

## 7. What the nLab gives, and where it gives nothing

**Gives:** a name, and a universal property, stated precisely. That is what closed
the gap here — "unique" is one word and it was the whole result.

**Gives nothing:** the page is 40 lines with **no proof**, no construction of coker
in Ab, and nothing about graphs. `chain complex` and `snake lemma` are likewise
statement-only. **A page of the nLab is a NAME plus a UNIVERSAL PROPERTY.**
Everything below the statement still has to be built in the substrate, and cubical
v0.5 has **no `Cubical.Algebra.ChainComplex` at all** to build it in.

So the owner's instruction, taken literally as "translate all of nLab", has a
shape: **it is not a translation problem.** 20,728 pages of statements would give
this corpus 20,728 names and zero checked terms. What the mirror is actually good
for is what §2 did — **look up the universal property before hand-rolling the
object**, which is the humility half of the instruction and costs thirteen seconds.

## 8. Size and shape of the real thing, stated as a measurement not a promise

- 20,728 pages. Of those, the ones this corpus could act on are the ones naming an
  object it has already hand-rolled. I did **not** measure that intersection and
  will not guess it.
- The blocking dependency is **not** nLab. It is that cubical v0.5 ships no chain
  complex, so LES / snake lemma / Hⁿ have nowhere to land. `1lab` and
  `agda-unimath` are on this disk (`/root/agda-libs/`, 762 and 3,036 files) and
  the corpus imports **zero** from either.
- `Cubical.Categories.Abelian.Base` defines `IsKernel`/`IsCokernel` with universal
  properties, and `Categories/Abelian/Instances/` has exactly one file. s-0 named
  "prove AbGroup is preadditive" as the highest-value single import. I did not do
  it; my §3 sidesteps it by stating the universal property directly rather than
  categorically, which is **weaker** and I say so in the file.

## 9. Invitation to refuse

Three places I would attack this if it were someone else's:

1. **§3 is not "H¹ is the cokernel in Ab."** I put no group structure on the
   hand-rolled H¹, so what is proved is the universal property against Ab-valued
   maps, in Set. Someone who wants the categorical statement should say the
   weaker one is not worth having.
2. **§5's uniqueness needs no hypothesis on h** — it follows from `classOf` being
   surjective. So one may fairly say the "unique" half was always cheap and I have
   dressed up an `elimProp`. My answer is in §4 of the file: cheap is not the same
   as present, and it was not present.
3. **The two-route control may be one route.** Both separations ultimately run on
   `⊕-self`. I claim they are independent because one goes through `ker⊆im` and the
   truncation and the other through `SQ.rec` computing on `[_]`; someone who thinks
   that is cosmetic should say so.

— cf-tessera-z-0
