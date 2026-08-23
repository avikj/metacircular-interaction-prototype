# 0785 — `formal/cubical/PolarityClosure.agda`: the polarity closure, and the vacuity of the Boolean gloss, as terms

**Author:** Claude (lattice-theory lane), 2026-08-15.
**Deliverable:** `formal/cubical/PolarityClosure.agda`,
`{-# OPTIONS --cubical --safe --no-import-sorts #-}`, no postulates, no holes.
**Formalises:** `notes/APOHA_AND_POLARITY.md` §§2, 4.1 (and, for the indexed
part, that note's flattening remark against
`notes/CHANGING_TESTS_VERSUS_SHRINKING.md` Def. B.3).

---

## 1. THE HONESTY ITEM, FIRST

**IT DOES NOT TYPECHECK, BECAUSE THERE IS NO AGDA IN THIS CONTAINER.**
`command -v agda` fails; there is no `~/.agda/libraries`, no `~/agda-libs`, no
`/usr/lib/agda`. `ghc` is present, Agda is not. The BUILD.md procedure
(`cd formal/cubical && agda Everything.agda`) could not be run, and neither
could `agda PolarityClosure.agda`.

Consequently:

- **No green claim is made for this module.** The proofs were written and
  checked by hand, not by the kernel. Every term is short and I traced the
  types of each, but that is exactly the standard this repository refuses to
  accept for a `--safe, exit 0` claim.
- **`Everything.agda` was NOT touched**, per the instruction and per BUILD.md's
  own rule that "an unchecked import is how a green claim becomes false rather
  than incomplete". Whoever has a toolchain should run `agda PolarityClosure.agda`,
  fix whatever the kernel objects to, and only then add the import line.
- Known toolchain risks, flagged so the next person does not hunt: (a) the
  module imports `rec` from `Cubical.Data.Empty` — if v0.9 spells it otherwise,
  that is the one name to repair; (b) `Cubical.Data.Sigma`'s `fst`/`snd`/`_,_`
  are taken from the `Prelude` re-export rather than imported again.

## 2. WHICH CLOSURE — the standing check the task asked for

`APOHA_AND_POLARITY.md` §3 records that D0020 §J3's original pointer was to the
**wrong** closure: `SHRINKING_TESTS_LOWER_CURVATURE.md` Rmk. 2.2, already
corrected by `CHANGING_TESTS_VERSUS_SHRINKING.md` §0.4 as *not* a polarity
(`Sep` is monotone), and §J3 then quotes Theorem B's $C_\sigma$, which is the
**monotone** redundancy closure. I read §0.4, Theorem B, Def. B.3 and Prop. 6.3
in full before writing.

**What is formalised is the ANTITONE one** — Prop. 6.3's
$A(S)=\{t:\ \sim_S\subseteq\ \sim_{\{t\}}\}$, the derivation closure of
$(X\times X,\mathcal T,R^c)$. The check that the right object is in hand is
mechanical and in the file: `perp⁺-anti` and `perp⁻-anti` **reverse**
inclusion, and the Galois connection is stated in antitone form
($\alpha\subseteq\beta^\perp\iff\beta\subseteq\alpha^\perp$). No monotone
adjoint appears anywhere in the module. $C_\sigma$, $\delta_\sigma$ and the
holonomy identity $A=\bigcap_{\mathfrak h}C_{\mathfrak h}$ are **not**
formalised — see §5.

## 3. What is stated (item by item against the task)

**(1) Galois connection + closure operator, general ε.** `module Polarity`,
for arbitrary `ε : A → B → Type ℓ` and arbitrary Type-valued subsets:
`perp⁺-anti`, `perp⁻-anti`, `galois-→`, `galois-←`, `unit⁺`, `unit⁻`,
`cl-ext`, `cl-mono`, `triple` ($\alpha^\perp=\alpha^{\perp\perp\perp}$),
`cl-idem`. **Idempotence is unconditional** — no hypothesis on `ε`, on `A`,
on `B`, or on the subsets; that is the note's answer to §J3 and it is the whole
reason the general module is worth having. The mirror closure `cl'` on the
$\chi^+$ side (which the note flags as never used by the repository) is
included, with the same three properties, at no cost.

**(2) THE SHARP FINDING — vacuity of the Boolean gloss.** `module BooleanGloss`,
$A=B=X$, $\varepsilon(\xi,\kappa)=\neg(\xi\equiv\kappa)$:

- `perp-is-complement` : $\alpha^\perp\ \doteq\ \neg\alpha$ — unconditional.
- `cl-is-¬¬` : $\alpha^{\perp\perp}\ \doteq\ \neg\neg\alpha$ — unconditional.
- `cl-identity-on-Dec` : $\alpha^{\perp\perp}\doteq\alpha$ for pointwise
  decidable $\alpha$; `boolean-gloss-vacuous` : the same for $\alpha$ given by
  a characteristic function $X\to\mathrm{Bool}$.

**A CORRECTION TO THE NOTE, and it is not cosmetic.** §4.1 writes
$\alpha^{\perp\perp}=X\setminus(X\setminus\alpha)=\alpha$ flatly. That second
equality is **excluded middle**. What is constructively true for every subset is
$\alpha^{\perp\perp}=\neg\neg\alpha$, and the identity holds exactly on
decidable subsets. The note's conclusion survives intact — "a subset of a
pre-given universe" in the classical reading *is* a decidable subset, and the
Bool-valued corollary is that reading made precise — but the general statement
as written in the note is not provable in the repository's own `--safe` cubical
setting. This is the kind of thing formalisation is for, and it is the only
substantive change the file makes to the note.

**(3) THE CONTRAST — vacuity belongs to the gloss, not the construction.**
`module Contrast`: one point, the **total** relation $\varepsilon\equiv\top$.
Then $\emptyset^{\perp\perp}$ is the whole set, so `cl-not-identity` is a term
of type `¬ ((α : Sub Unit) → cl α ⊑ α)`. A one-point witness is smaller than
the `Fin 2`/`Fin 3` the task suggested and needs no finite search: it is the
minimal counterexample. Nothing about `Fin` is used.

**(4) THE OPEN EDGE, settled.** `module Indexed`, family
`ε : I → A → B → Type ℓ`, flattening `ε̂ a (ι,κ) = ε ι a κ`:

- `flatten` : $\alpha^{\hat\perp\hat\perp}\doteq\bigcap_\iota\alpha^{\perp_\iota\perp_\iota}$,
  both inclusions, which is Def. B.3's shape $C=\bigcap_\sigma C_\sigma$ in the
  polarity case. Σ-eta does all the work.
- `intersection-idem`, `intersection-ext`, `intersection-mono` : the
  intersection **is** a closure operator, idempotence included. This is the
  note's open remark discharged: idempotence does **not** come from
  "intersections of closure operators are idempotent" (false in general — Def.
  B.3 flags exactly this), it comes from the intersection *being itself a double
  polar*, so the general `cl-idem` applies to it verbatim. The note called this
  an explanation; in the file it is a proof, modulo §1.

## 4. Relation to `ExclusionScope.agda` — built on, not duplicated

`notes/EXCLUSION_IS_NOT_AN_OPERATOR.md` is checked as
`formal/cubical/ExclusionScope.agda` (genius-02, 2026-08-14) — I located it by
grep and read it. It works on **Eq(X)**, the lattice of equivalence relations,
and its T3 shows the relative-pseudo-complement repair *fails* for $|X|\ge3$;
T4a/T4b bound exclusion to a declared vocabulary. **`PolarityClosure` does not
restate any of that and imports none of it.** It works on the **powerset**, and
supplies the other half of `APOHA_AND_POLARITY` §4.1's pairing: on Eq(X) the
Boolean gloss is *unavailable* (ExclusionScope), on P(X) it is *available and
vacuous* (this module). No lattice of equivalence relations occurs below §0
here; there is no overlap to merge.

## 5. Scope limits

- **Not checked by a kernel** (§1). Until someone runs it this is a careful
  manuscript in Agda syntax, nothing more, and it should not be cited as a
  verified result.
- **Subset equality is bi-inclusion `_≐_`, never a path.** The subsets are
  arbitrary Type-valued predicates, not h-propositions; propositional
  extensionality is unavailable without a truncation the mathematics does not
  need. Every statement is an inclusion or a pair of them. A reader wanting
  genuine equality of `hProp`-valued subsets would add `Cubical.Functions.Logic`
  and propositional extensionality; that is a different (easy) module.
- **The dictionary is not formalised.** Prop. 6.3's $A(S)$, $\sim_S$,
  $\delta_\sigma$, $C_\sigma$ and the identity
  $A=\bigcap_{\mathfrak h}C_{\mathfrak h}$ do **not** appear in the Agda. What
  the file proves is the abstract polarity theory that Prop. 6.3 is an
  *instance* of, plus the two concrete instances (§2, §3) that carry the
  finding. Instantiating `Polarity` at $\varepsilon=R^c$ on
  $(X\times X,\mathcal T)$ and deriving Prop. 6.3 as a corollary is a natural
  next module and is **not** done here. Tag `PROVE` if anyone wants it.
- **The $\chi^+$-side content is still not analysed.** `cl'` exists and is a
  closure operator; whether it has content on the pair-context is exactly the
  question the note left open, and this module does not answer it.
- **Nothing doctrinal is claimed or verified.** No Sanskrit source was read;
  every claim about Dignāga is carried from the two corpus notes, as they
  themselves flag.
- **No Python, no computation, no measurement, no fitted anything.** §3's
  contrast is a closed term, not a search.
