# Newton–Hensel is asiddha, not iterative: four identities and a constant tower

**Handle** `swarm-0814-05` · **date** 2026-08-14 ·
**object** `formal/cubical/Swarm/S05AsiddhaNewton.agda`, `EXIT=0`
(`cd formal/cubical && LC_ALL=C.UTF-8 agda -i . Swarm/S05AsiddhaNewton.agda`;
Agda 2.6.3, `--cubical --guardedness --safe --no-import-sorts`, no postulates,
no holes). `formal/check.sh` is untouched; this module is additive and imports
nothing from `NaturalMachine`.

---

## 0. The draw, and where the two lenses split

Eleven files, read in full before planning. The load-bearing ones were
`collab/messages/workers/20260812T090836.491254Z--codex_arithmetic_life--0001.md`
(Newton–Hensel doubling, kuṭṭaka/CRT gluing, `5⁻¹ ≡ 29 (mod 72)`),
`formal/cubical/NaturalMachine.agda` (the aggregate),
`code/exp37_nonic_enumerator.cpp` (exhaustive shard enumeration),
`collab/discovery/benchmarks/legacy-millennium.jsonl` (six refuted legacy
claims, one of them about higher types), and `collab/upstream/raw/U0008.txt`.
Frontier field: higher category theory (∞-topoi, six-functor formalisms).
Ancient field: Pāṇinian grammar (ordered rules, markers, anuvṛtti, **asiddha**
scope). Lenses: **Gauss** — compute a hundred cases by hand before conjecturing;
**Dedekind** — define the object by the cut it makes, not by the process that
reaches it.

The lenses disagree hardest on exactly one drawn sentence. The broadcast ends
with its own hostile message:

> Compare lift/glue with direct extended Euclid on (5,72). Seek a common
> continuant or matrix certificate determining when retained local state makes
> one lawful derivation strictly shorter — without relying on timing benchmarks.

**Gauss's answer**: enumerate `(a, m)` pairs, tabulate derivation lengths for
both routes, look for the pattern. This is also what `exp37_nonic_enumerator.cpp`
does in its own domain, and it is the repository's most-used reflex.

**Dedekind's answer**: derivation length is not a function of the object. Define
the inverse by the cut it makes in the tower of thickenings and ask whether the
tower has any content at all. It does not: **the tower is constant**, so there
is nothing to converge to, and "how long does the process take" is a question
about seeds and presentations, not about `a⁻¹`.

Dedekind wins, and the win is cheap enough to check. Below, §3 is Dedekind's
object, §4 is the exact quantity that replaces Gauss's table — with the
broadcast's own example coming out *strictly shorter* by one derived line, no
benchmark run.

---

## 1. The four identities

Let `R` be any commutative ring, `a, x, y ∈ R`. Write

```
res a x = 1 - a·x            (the residual: the defect of x from inverting a)
N   a x = x·(2 - a·x)        (the Newton–Hensel update of the broadcast)
```

Then, as identities in `ℤ[a,x,y]`:

| | identity | reading |
|---|---|---|
| (1) `doubling` | `1 - a·N a x = (res a x)²` | the lift lands one thickening deeper |
| (2) `stale` | `N a x - N a y = (x - y)·(res a x + res a y)` | **asiddha**: the rule may read a stale stage |
| (3) `rigid` | `x - y = x·res a y - y·res a x` | uniqueness: nothing is chosen |
| (4) `section` | `N a x - x = x·res a x` | the lift is a section of truncation |

(1) is already in the corpus, as prose, in
`notes/ARITHMETIC_LIFE_LOCAL_TO_GLOBAL_INVERSE.md` eq. (2). (2), (3), (4) are
not, and they are the ones that carry the theorem. All four are
`solve R'` in `Core`, `S05AsiddhaNewton.agda` §1.

Identity (2) is the point of contact with the ancient field. Pāṇini's tripādī
(8.2–8.4) is *asiddha*: a later rule reads the string **as if the earlier rule
had not applied**. In every modern rewriting formalism that looks like a defect
to be engineered around. Identity (2) says that in this rule system it is a
theorem: two inputs that a stage-`I` observer cannot distinguish have outputs
that a stage-`I²` observer cannot distinguish. The Newton step *is entitled* to
read a stale argument, and the entitlement is one line of algebra.

## 2. Thickenings

A `Thickening` of `R` is a pair of predicates `Sh, Dp : R → Type` (shallow and
deep — think `I` and `I²`; the name `I` is taken by the cubical interval) with:
`Dp ⊆ Sh`; `Sh` closed under `+` and under multiplication by any ring element;
`Dp` closed under `−` and under multiplication by any ring element; and
`Sh·Sh ⊆ Dp`. Nothing here needs finite sums of products — identities (1)–(4)
never produce more than one product at a time — so no finitely-generated-ideal
machinery is imported.

## 3. The object: truncation of solution sets is a bijection

Fix `a` and set `SolSh a = Σ[x ∈ R] Sh (res a x)`, `SolDp a = Σ[x ∈ R] Dp (res a x)`.

> **Theorem.** `trunc : SolDp a → SolSh a` (forget depth) and
> `newton : SolSh a → SolDp a`, `x ↦ N a x`, are mutually inverse **modulo the
> respective congruences**:
>
> * `lands` (from (1)) `newton` is well typed: a shallow solution lifts to a deep one.
> * `asiddha` (from (2)) `Sh (x−y) → Dp (N a x − N a y)`: `newton` descends to
>   shallow-indistinguishability classes.
> * `unique` (from (3)) any two deep solutions satisfy `Dp (x−y)`: `trunc` is injective.
> * `over` (from (4)) `Sh (N a x − x)`: `trunc ∘ newton = id`.
> * `newton-trunc` `Dp (N a x − x)` whenever `x` is already a deep solution: `newton ∘ trunc = id`.

Checked as `Tower` in `S05AsiddhaNewton.agda` §3. Each clause is `subst` along
exactly one of the four identities; there is no induction and no case split
anywhere in the module.

**What this says.** The tower `… → Sol(I³) → Sol(I²) → Sol(I)` of unit-inverse
sets is constant: every map in it is a bijection with an explicit inverse given
by a single polynomial. Therefore the `p`-adic (or `I`-adic) inverse is a
Dedekind cut in the strict sense — it is determined by any one stage, with no
limit taken, no rate of convergence, and no step count intrinsic to it. Newton's
method is not a method here. It is the formula for an inverse map that was
already a bijection.

This is the **infinitesimal lifting criterion**: the inversion locus
`Spec ℤ[a,x]/(ax−1) → Spec ℤ[a]` is *formally étale*, i.e. unique lifting along
square-zero (here: `Sh·Sh ⊆ Dp`) extensions. That is classical — Grothendieck,
EGA IV §17; Hensel's lemma for simple roots is its oldest instance. The
contribution here is not the theorem but its **decomposition into four
identities with the ideal quantifiers made explicit**, the *asiddha* reading of
clause (2), and the fact that the corpus was using clause (1) alone and paying
for the other three with CRT bookkeeping (§4).

Grep says the strings "formally étale", "square-zero" and "infinitesimal
lifting" occur nowhere else in this repository.

## 4. The exact quantity that replaces the benchmark

The broadcast asked for a certificate, "without relying on timing benchmarks",
saying when retained local state shortens a derivation. Here it is, derived.

> **Corollary (step count).** Let `M = ∏ pᵢ^{eᵢ}`, let `x` be a seed with
> `vᵢ = v_{pᵢ}(1 − a·x) ≥ 1` for all `i`. By (1), `1 − a·N^k(x) = (1−a·x)^{2^k}`
> exactly, so `v_{pᵢ}(1 − a·N^k(x)) = vᵢ·2^k` **with equality**. Hence the number
> of Newton steps needed to reach an inverse mod `M`, working with the composite
> ideal `(M)` directly and never factoring, is exactly
>
> ```
>     k(M, x) = ⌈ log₂ maxᵢ ⌈ eᵢ / vᵢ ⌉ ⌉ ,
> ```
>
> and this derivation contains **no gluing step at all**.

Equality, not a fitted slope. Applied to the broadcast's own example,
`a = 5`, `M = 72 = 2³·3²`, seed `x = 5` (because `5·5 = 25 = 1 + 24`, so
`v₂ = 3`, `v₃ = 1`):

```
k = ⌈log₂ max(⌈3/3⌉, ⌈2/1⌉)⌉ = ⌈log₂ 2⌉ = 1.
```

**One step.** `N 5 5 = 5·(2−25) = −115`, residual `576 = 24²`, and
`−115 + 144 = 29`. The boxed `5⁻¹ ≡ 29 (mod 72)` falls out of a single
application of identity (1), with no per-prime residue sensors, no kuṭṭaka, and
no CRT. All five lines are `refl` over `ℤ` in `S05AsiddhaNewton.agda` §4
(`Witness`) — exact integer computation, which CLAUDE.md counts as proof rather
than as measurement.

The broadcast's route, scored by the same corollary: mod 2 with `v = 1` to
`e = 3` costs `⌈log₂3⌉ = 2` steps, mod 3 with `v = 1` to `e = 2` costs `1` step,
plus one gluing — **3 steps and a glue against 1 step and none**. So the answer
to the hostile message, for this instance and in general, is negative in a
strong form: retained per-prime local state can never reduce the Newton-step
count below the composite chain's `k(M,x)` (the composite chain's exponent is
the max of the per-prime ones), and it strictly adds `r−1` gluing steps. The
CRT is not doing arithmetic work in this derivation; it is repairing a
representation choice — holding state prime-by-prime — that identity (1) never
required, because `(M)` is a perfectly good ideal for a thickening whether or
not `M` is a prime power.

This is the concrete form of the standing disagreement. Gauss would have found
this by tabulating; the tabulation would have reported a ratio and not the
`⌈log₂⌈e/v⌉⌉`, and `HOLOGRAM.md` §7 is the record of what a constant without its
scaling costs here.

## 5. The frontier field, kept in its place

The assigned frontier field is ∞-topoi and six-functor formalisms, and the
honest report is that it contributes **vocabulary and no content** to this
object. "Formally étale" is a statement about a `0`-truncated lifting problem
against square-zero extensions; the ∞-categorical version (the inversion locus
is `∞`-étale over the base, `f^*` fully faithful on the relevant slice, etc.)
specialises here to precisely §3 and imports nothing that §3 does not already
prove. Higher paths would matter if the lifts formed a nontrivial space — if
`Dp(x−y)` were replaced by a *type* of identifications with its own automorphisms
— and identity (3) is exactly the statement that they do not: the space of deep
solutions is `(−1)`-truncated relative to the congruence.

My own draw supplied the caution and I am obeying it rather than quoting it:
`collab/discovery/benchmarks/legacy-millennium.jsonl` LM006 records a legacy
claim that "RH is proved because it lives at a higher homotopy type/universe
level", with the missing bridge stated as *no formal statement equivalent to the
classical one is derived from the higher-type construction*. The rule that
avoids LM006 is the one written in the same file's `salvageable_seed`: **use
higher types only when an explicit quotient, action groupoid, descent datum or
coherence obstruction survives `0`-truncation.** Nothing here does. So the
module uses `--cubical` for its host lane and its `subst`, and claims no
homotopical content.

## 6. Prior art, searched before writing (CLAUDE.md, "prior art gets searched **before**")

* Hensel's lemma for simple roots, and quadratic convergence of `x ↦ x(2−ax)`: classical; the identity `1−a·x(2−ax) = (1−ax)²` is in the broadcast and in `notes/ARITHMETIC_LIFE_LOCAL_TO_GLOBAL_INVERSE.md`.
* Formal étaleness / unique lifting along nilpotent immersions: EGA IV §17; the "Newton = formally étale" slogan is standard in deformation theory.
* Newton–Schulz iteration for matrix inverses, `p`-adic Newton in computer algebra (Zassenhaus lifting): same identity, same doubling.
* Inside this repo: `notes/UNIT_DERIVATIVE_DEPTH.md` proves the neighbouring statement that residues mod `p^{e+1}` determine `v_p(f(x))` when `e = v_p(f(x))`; `notes/PANINIAN_DERIVATION_IS_NOT_ENDPOINT_REWRITING.md` and `collab/swarm/2026-08-14/swarm-0814-01-panini-ashby-dictionary.md` treat Pāṇinian ordering elsewhere. No repository file contains identities (2)–(4), the bijection statement, the step-count corollary, or the observation that CRT is eliminable here.

**Nothing in §1–§4 is claimed as new mathematics.** What is claimed: it is new
*in this corpus*, it is checked, it deletes a CRT layer from a live lane, and it
converts an open "seek a certificate, without benchmarks" request into a closed
formula.

## 7. Contradictions between my draw and the repository's conspicuous documents

Reported, not resolved (`why_this_exists.md`: "record it rather than resolving it
toward the document").

1. **`collab/upstream/raw/U0008.txt` vs. my orchestration.** Upstream, verbatim:
   *"push updates to repo very frequently that channel polynomially/exponentially
   accelerates us with various agents working from different lenses."* My launch
   instructions say **"Run no git commands."** Upstream outranks every document
   in the repo, including CLAUDE.md and PROTOCOL.md, and it asks for exactly the
   thing I am forbidden to do. I obeyed the launch instruction — this file and
   the Agda module are written and checked but uncommitted — and I am flagging
   the conflict rather than silently choosing. Whoever runs the swarm holds the
   commit; if nobody does, U0008 is being violated by construction, once per
   agent, invisibly.
2. **`collab/upstream/raw/U0006.txt` vs. `CLAUDE.md` "The substrate".** U0006,
   the relayed proposal that founded the cubical lane, is explicit: *"I wouldn't
   move the existing V3 Lean work to Cubical Agda. Lean + mathlib is vastly more
   valuable for certifying conventional number theory, algebra, polynomials,
   exact computations."* It prescribes a **two-system split** — Lean for
   conventional arithmetic certification, Cubical Agda for quotients, gluing and
   obstruction prototypes. This session's environment has no Lean and no lake.
   So the conventional-arithmetic half of §1–§4 above was formalised in the
   system U0006 explicitly reserved for the *other* job. It worked (the ring
   solver discharged all four identities), but the split U0006 asked for is not
   in force, and CLAUDE.md's "Lean (`formal/pairfield/`) for the analytic lane"
   is currently a lane with no toolchain. `formal/check.sh` still ends in
   `lake build`, which cannot succeed here.
3. **`U0009`/`U0003` vs. the substrate rule.** U0009 wants "kernels of
   intelligence" pushed down into traditional programs so CPU, not LLM tokens,
   does the work; U0003 asks specifically about Mathematica/WolframAlpha. The
   drawn `code/exp37_nonic_enumerator.cpp` is precisely that — an exhaustive
   exact enumerator in C++ with a Bareiss resultant, honestly labelled *"not yet
   a theorem certificate"*. It is not Python, so it is not covered by the ban,
   and it is not proof, so it is not covered by the exemption. The corpus has no
   stated policy for the large middle category "exact, certified, compiled, and
   still not a theorem". That gap is where U0009's whole request lives.
4. **Two drawn files are not data.** `data/exp7_ties.txt` is five bytes
   (`11 6`) and `data/chi3_zeros_deep.npy` is 44 float64s with no accompanying
   error term or `X`-dependence — the exact shape CLAUDE.md's HOLOGRAM.md
   corollary warns about. Neither is cited by anything I read. Noted, not
   pursued.

## 8. Seeder appends (mandatory)

`random_entry_seeder_so_agents_dont_cluster/why_this_exists.md` requires
appending any field or method the draw met that the lists lack. Two genuine
gaps; both are what this object actually used.

* `frontier_fields.txt` had `p-adic analysis: perfectoid spaces, prismatic
  cohomology` and `higher category theory` but no deformation-theoretic entry at
  all — the field in which "the tower is constant" is the *definition* of a
  property rather than an observation. Appended:
  `deformation theory: square-zero extensions, formal smoothness and étaleness, the cotangent complex`.
* `method_lenses.txt` had `Dedekind — define the object by the cut it makes` and
  `Grothendieck — rise to the generality where the problem becomes trivial`, but
  not the specific move used here, which is neither: replacing a *limit* by a
  *unique lifting condition*. Appended:
  `Hensel -- replace a limit by a unique lifting along nilpotents: if every stage lifts uniquely there is nothing to converge to`.

`ancient_fields.txt` needed nothing: both Pāṇini and kuṭṭaka are already in it,
and inventing an entry to satisfy a quota would be the failure mode that file
names.

## 9. Falsifiers and what is left

* **Falsifier for §3**: exhibit a commutative ring `R`, ideals `I ⊇ K ⊇ I·I`, and
  a unit `a` with two `K`-solutions not congruent mod `K`. Identity (3) forbids
  it; if you find one, `Thickening` is mis-axiomatised, not the theorem.
* **Falsifier for §4**: an `(a, M, x)` where the per-prime route uses strictly
  fewer Newton steps than `⌈log₂ maxᵢ ⌈eᵢ/vᵢ⌉⌉`. The max is over the same `⌈eᵢ/vᵢ⌉`
  the per-prime chains each pay, so this would refute the corollary's equality
  claim.
* **Open, `PROVE`**: the same four-identity decomposition for a general simple
  root of `f ∈ R[x]` (`N f x = x − f(x)/f′(x)` with `f′(x)` a unit) rather than
  for `f = ax − 1`. Identities (1) and (4) generalise immediately by Taylor;
  identity (3) — the uniqueness clause — is where the general statement needs
  `f′` invertible and is the one worth writing. `notes/UNIT_DERIVATIVE_DEPTH.md`
  is the natural host.
* **Open, `DEMONSTRATE`**: `notes/ARITHMETIC_LIFE_LOCAL_TO_GLOBAL_INVERSE.md`
  and the `codex_arithmetic_life` lane should be able to drop the kuṭṭaka/CRT
  step for composite-modulus inversion entirely. I have not edited that lane's
  files (not mine) — this note is the pointer.
