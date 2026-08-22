---
id: 0755-seed154-advance-under-replacement
from: seed154
date: 2026-08-15
kind: proof + one strengthened no-go + one conditional-vacuity verdict; predecessor verified, two hypotheses named that it left implicit
subject: "Advance has FIVE conjuncts and EXACTLY ONE is a function of δ — SearchSep, and it is a function of the whole holonomy FAMILY, so Thm F (single-holonomy) does not reach it; Thm F′ does (every equivalence on X is ∼_S for one test, so any monotone function of resolving power is constant). Verify is a function of Π, disjoint from δ. PreserveProv, UsefulEscape, DeclaredBoundaryPreserved are UNDEFINED as written; their type-correct completions are (pair), (pair), and (comparison against a FIXED declaration) — the last is the only shape that can carry progress, and it is the hypothesis of F′ to drop: not δ, but RELATIVITY of the comparison base. Advance is NOT decidable from seed149 §8's datum — but the obstruction is missing definitions, not missing data, and §8 never claimed otherwise. Strengthening found: SearchSep(𝒯_α)=1 means ∼_α=Δ, the BOTTOM of the equivalence lattice, so every successor is comparable — INCOMPARABLE STEPS CANNOT OCCUR OUT OF AN ADVANCING STAGE (needs |X|≥3 even to exist). And if SearchSep holds at both ends then ∼=Δ at both, so δ is CONSTANT along Advancing runs: curvature is informationally inert on exactly the runs the framework certifies. Φ: under D0018 §D (𝔉=Φ∘Γ∘∂, 𝒪_α⊆𝒪_{α+1}) every step is Refine and the no-go is VACUOUS; under D0016 §E (𝔉 contains ∨, Φ_cut is a 'recut', §F says 'or not') it is not — after ∨ the successor test set is the old OBJECT set, so (H5) fails and comparability has no truth value at all. The no-go is CONDITIONALLY VACUOUS and the condition is a discrepancy between two owner artifacts."
predecessors:
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md
  - collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md
  - 0750-seed149-changing-tests
  - 0749-seed148-shrinking-tests-theorem
touches:
  - notes/ADVANCE_UNDER_REPLACEMENT.md (new)
---

# Which hypothesis of the no-go to drop

The framework, the $\operatorname{Advance}$ predicate and the widening-observable
clause are the **owner's** (D0016 §G, D0018 §D). Theorems A–F and the §8 proposal are
seed149's. I re-derived **Theorem C** (four lines: $\delta$ join-preserving ⇒
$\delta\dashv\delta^*$ ⇒ $\delta(S')\subseteq\delta(S)\iff S'\subseteq C_\sigma(S)$, no
comparability used) and **Theorem F** (orbit realisation + antisymmetry). Both correct
as written. Seed149's Cor. F.1 is correctly scoped — it says $\operatorname{Advance}$
cannot be *licensed by a comparison of $\delta$*, not that $\operatorname{Advance}$ is
refuted — and I did not upgrade its arrow.

## The conjuncts

| conjunct | function of δ? | type | verdict |
|---|---|---|---|
| $\operatorname{Verify}(\Pi_\alpha)$ | no — of $\Pi_\alpha$ | unary, disjoint component | F irrelevant; **undefined as written** |
| $\operatorname{SearchSep}(\mathcal T_\alpha)$ | **yes**, of the family | unary function of δ | **F does not apply, F′ does** |
| $\operatorname{PreserveProv}$ | no | **undefined**; only completion is pair | F silent |
| $\operatorname{UsefulEscape}>0$ | no as intended; **yes if ever defined via δ or ∼** | **undefined**; intended pair | F/F′ **fatal to any such definition** |
| $\operatorname{DeclaredBoundaryPreserved}$ | no | pair against a **fixed** declaration | F silent — the only progress-carrying shape |

The mandate's trichotomy (function of δ / function of the pair / undefined) is **not
exhaustive**: two further types occur, and naming them is the deliverable. Also, note
first that $\operatorname{Advance}$ is a predicate on **one stage**, not on a step — so
Theorem F does not refute it, it refutes one reading of it.

**Thm 2.** Under (H7) — the charted structure realises the transpositions —
$\operatorname{SearchSep}(S)=1\iff\forall\mathfrak h\ne1,\ \delta_{\mathfrak h}(S)\ne\emptyset$.
So it *is* a functional of the defect family. (H7) was implicit in seed149's Thm E
converse and is now named.

**Thm F′.** Every equivalence on $X$ is $\sim_{\{t\}}$ for a single test ($Q=X/E$,
$e(x,t)=[x]$ — the textbook kernel–partition correspondence). Hence any poset-valued
function of resolving power that is monotone under unrestricted replacement is
**constant**. This is what actually kills $\operatorname{SearchSep}$-as-progress;
Theorem F, being single-holonomy, could not.

## The strengthening

**Thm 3.** $\operatorname{SearchSep}(\mathcal T_\alpha)=1$ means $\sim_\alpha=\Delta_X$,
the **bottom** of the equivalence lattice, and $\Delta_X\subseteq$ everything. So the
step is Blunt no matter what $\mathcal T_{\alpha+1}$ is: **no step out of an Advancing
stage is Incomparable.** (Dually $\sim_\alpha=\nabla_X$ forces Refine; incomparable
equivalences need $|X|\ge3$, by listing the two equivalences on a $2$-set.) §8.3's "on
Incomparable steps nothing follows" is therefore **true and its scope is empty** where
$\operatorname{Advance}$ lives. That is the honest reading — not a refutation of §8.3.

**Thm 5, the clean negative.** If $\operatorname{SearchSep}$ holds at $\alpha$ and
$\alpha+1$ then $\sim=\Delta$ at both, so $\delta_\sigma$ is **equal** at both, for every
holonomy. Along a run that Advances at every stage, the obstruction is **constant in
$\alpha$**. D0016 §G's own box says $\delta=0\not\Rightarrow\operatorname{Advance}$; this
says more — $\delta$ carries *no* progress information on precisely the certified runs,
so whatever progress $\operatorname{Advance}$ asserts must come from the four non-$\delta$
conjuncts, which are the four that are undefined.

## Is Advance decidable from §8's datum? No — but not for the reason expected.

Recording $\sim_{\mathcal T_\alpha}$ decides $\operatorname{SearchSep}$ **outright** (it
is the test $\sim=\Delta$), and decides the other four **not at all**, because they are
not functions of the test sets. No datum about $(\mathcal T_\alpha,\mathcal T_{\alpha+1})$
could. §8 claimed sufficiency for "$\delta$ moved monotonically uniformly in the
holonomy" and made no claim about $\operatorname{Advance}$; that claim stands.

## Does Φ produce comparable steps? — conditionally, and the condition is yours

Under **D0018 §D** ($\mathcal O_\alpha\subseteq\mathcal O_{\alpha+1}$, $\Phi$ object-preserving,
$\mathfrak F=\Phi\circ\Gamma\circ\partial$): $S\subseteq S'\Rightarrow\sim_{S'}\subseteq\sim_S$,
so **every step is Refine**, the unrestricted-replacement hypothesis is never met, and
**Theorem F is vacuous for the framework**. The owner's non-implication
$\operatorname{Obs}_{\mathcal O_\alpha}=0\not\Rightarrow\operatorname{Obs}_{\mathcal O_{\alpha+1}}=0$
is then exactly Refine $\Rightarrow\delta\uparrow$ — the **dual** of §G's
$\operatorname{Shrink}\Rightarrow\delta\downarrow$, one statement from its two sides.

Under **D0016 §E/§F** it fails three ways: (a) $\mathfrak F$ contains $\vee$, and after a
transposition the successor's *test* set is the predecessor's *object* set, so the common
universe (H5) is gone and comparability **has no truth value** — worse than incomparable;
(b) $\Phi_{\mathrm{cut}}$ is a *recut*, and its list contains $(-)^\vee$ and
$\operatorname{Quot}$; (c) §F says $\mathcal T_\alpha\subseteq\mathcal T_{\alpha+1}$ **or
not** in as many words. Also $\Gamma$ moves the carrier in *both* readings, so even
D0018's $\mathfrak F$ needs one extra hypothesis I state and do not assume: that old
observables are restrictions of new ones along $\iota:X_\alpha\to X_{\alpha+1}$
(Prop. 8).

**So: the no-go is neither fatal nor irrelevant — it is conditionally vacuous, and the
condition is a discrepancy between two of your transmissions.** The one decision this
puts to you: *is $\Phi_{\mathrm{cut}}$ an enlargement or a recut, and does the step
functor contain $\vee$?*

Two smaller flags, neither a rewrite: $\mathcal O_\alpha$ means the **obstruction**
$\int^\sigma\delta_\sigma$ in D0016 §B and an **observable collection** (with
$\mathcal O_\alpha\subseteq\mathcal O_{\alpha+1}$) in D0018 §D — different types; I worked
under the D0018 reading and the identification is yours to make or refuse. And
$\operatorname{PreserveProv}$ is written with no argument at all, unlike its two
neighbours; I did not supply one.

**D0018 §J5's $\chi_\alpha$:** untouched — one sentence in the note observes that
$\operatorname{UsefulEscape}$ has the same stage-difference-with-asserted-trichotomy
shape and is fenced by the same proposition; nothing measured, nothing rehabilitated.

**Discipline.** No Python. No experiment. No number. No Agda or Lean authored, no
typechecking claimed (no toolchain here). Prior art searched **before** writing (§9 of the
note): Lemma 1 is the textbook kernel–partition correspondence and I claim nothing for it;
Ellerman's partition logic and one arXiv item on questions-as-partitions were located and
are cited as located, one of them by title only, which I say.

*Full argument, hypotheses, and scope limits: `notes/ADVANCE_UNDER_REPLACEMENT.md`.*
