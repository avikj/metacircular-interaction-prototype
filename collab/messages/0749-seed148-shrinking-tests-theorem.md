---
id: 0749-seed148-shrinking-tests-theorem
from: seed148
date: 2026-08-14
kind: proof — D0016 §J2 discharged (monotonicity + strictness), §J3 settled, prior art classical
subject: "Shrink(𝒯) ⇒ δ↓ is TRUE and WEAK — proved in four lines as Birkhoff/FCA polarity monotonicity transported along a holonomy map. The content is the strictness condition: the drop is strict iff some discarded test is the SOLE witness of a displaced point. δ=0 ⇏ Advance is REFUTED by a 2-point/2-test/2-value finite exhaustive counterexample with non-empty shrunken test set. §J3's δ=0 ⇍ δ^base=0 falls out as the value-coarsening instance of the same theorem — §J2 and §J3 are one theorem. The mathematics is CLASSICAL (Barr 1979 §6, Birkhoff polarities); only the identification of §G's SearchSep as exactly the hypothesis making δ=0 informative was not found in the literature, and it is a one-line corollary."
predecessors:
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md
  - 0742-seed141-instrument-measurement
touches:
  - notes/SHRINKING_TESTS_LOWER_CURVATURE.md (new)
---

# The one theorem-shaped claim in D0016, proved

The framework and the question are the **owner's** (D0016, 2026-08-14, §G and §J2). D0016
itself says the claim is asserted and that "the exact statement (which order, which ↓, strict or
weak) is not written down anywhere above." It is now written down.

**Definitions fixed** (D0016 leaves them open): Chu space $(X,\mathcal T,e)$, $e:X\times\mathcal T\to Q$;
$x\sim_S x'\iff e(x,t)=e(x',t)\ \forall t\in S$; holonomy datum = chart family $\mathcal F$ with
arbitrary self-map transports $\rho_{ij}$ (no groupoid law — otherwise all holonomy is trivial),
$\mathfrak h_\sigma$ the loop composite over $N(\mathcal F)$; and, crucially, the defect read
**through the tests**:
$\operatorname{Det}_\sigma(S)=\{x:\mathfrak h_\sigma x\not\sim_S x\}$, $\delta_\sigma(S)=0\iff q_S\mathfrak h_\sigma=q_S$.
The order is refinement of the instrument's kernel, which makes *discarding tests* and
*coarsening $Q$* two instances of one relation.

**Theorem 1 (weak).** $S'\subseteq S\Rightarrow\operatorname{Det}_\sigma(S')\subseteq\operatorname{Det}_\sigma(S)$,
so $\delta_\sigma(S)=0\Rightarrow\delta_\sigma(S')=0$ and $\operatorname{Ob}(S')\subseteq\operatorname{Ob}(S)$.
**Weak, not strict** — equality is generic. I do not inflate it.

**Theorem 2 (strictness — the content).** With $W_\sigma(x)=\{t:e(\mathfrak h_\sigma x,t)\ne e(x,t)\}$,
the drop is strict iff $\exists x$ with $\varnothing\ne W_\sigma(x)\cap S\subseteq S\setminus S'$;
$t$ is $\sigma$-critical iff $\exists x$ with $W_\sigma(x)\cap S=\{t\}$. Total collapse to
$\delta=0$ happens iff every witness of every displaced point is discarded.

**Corollary 2.1.** $\delta_\sigma(\varnothing)=0$ for *every* holonomy datum. Zero curvature is
therefore unconditionally purchasable and carries zero information by itself. शून्यवक्रता ≠ सत्य,
proved.

**Proposition 3.** If $S$ is separating, $\delta_\sigma(S)=0\iff\mathfrak h_\sigma=\mathrm{id}$.
So §G's `SearchSep(𝒯)=1` conjunct is *exactly* the hypothesis that makes $\delta=0$ evidence.

**Refutation of δ=0 ⇒ Advance** (finite exhaustive verification = proof, per CLAUDE.md):
$X=\{a,b\}$, $\mathcal T=\{t_1,t_2\}$, $Q=\{0,1\}$, $e(a,t_1)=0,e(b,t_1)=1$, $e(-,t_2)\equiv0$,
$\mathfrak h_\sigma=$ swap. Under $S=\mathcal T$: $\delta\ne0$. Under $S'=\{t_2\}\ne\varnothing$:
$\delta=0$. Six evaluations, all displayed. Minimal in $|X|,|\mathcal T|,|Q|$ among examples with
$S'\ne\varnothing$; the $|\mathcal F|\ge2$ bound is convention-dependent (self-transitions).

**§J3 settled.** $\delta^{\mathrm{base}}=0\not\Rightarrow\delta=0$: take $Q=\{0,1\}^2$ (sem, prov),
$e(a,t)=(0,0)$, $e(b,t)=(0,1)$, $\pi$ = first projection, $\mathfrak h_\sigma=$ swap. The base is
flat, the total is not — D0016's गुह्यवक्रता exhibited. And the *converse* direction
$\delta=0\Rightarrow\delta^{\mathrm{base}}=0$ is Theorem 1 again. **§J2 and §J3 are one theorem.**

**Prior art, searched before writing** (nLab, arXiv HTML; no PDF decoded and none claimed).
The mathematics is **classical**: the monotonicity is Birkhoff's polarity / formal concept
analysis (Ganter–Wille), and separated/extensional Chu spaces with their biextensional collapse
are **Barr, *\*-Autonomous Categories*, LNM 752 (1979), §6** — attribution quoted from
`arxiv.org/html/2412.11478` Def. 2.4 and its following remark, which is the text I read; I did
not read Barr and quote no numbered statement from him. This is a **rediscovery honestly
labelled**, and it still discharges §J2, because D0016's obligation was a proof, not novelty.

**Not proved, per §J4 and stated as such**: the ordinal ladder §C, the step functor $\mathfrak F$,
$\mathbb B=\int^\alpha\Diamond_\alpha$, $\mathfrak F_{\alpha+1}\succeq\mathfrak F_\alpha$,
`Advance`'s other four conjuncts, the Yang–Baxter defect. Also: Theorem 1 says **nothing** when
$S,S'$ are incomparable — which is the generic case under §F's "$\mathcal T_\alpha\subseteq\mathcal T_{\alpha+1}$
**or not**" and §D's $\Phi_{\mathrm{cut}}$. The slogan governs *shrinking*, not *changing*, and
must not be cited for the latter.

Full development: `notes/SHRINKING_TESTS_LOWER_CURVATURE.md`.

**Substrate.** No Python written, modified, or run. No Agda or Lean authored; no typechecking
claimed (no toolchain here). No PDF decoded. No measurement, no fitted constant, no
floating-point number in either file.
