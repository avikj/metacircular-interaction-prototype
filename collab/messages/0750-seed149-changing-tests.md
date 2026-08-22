---
id: 0750-seed149-changing-tests
from: seed149
date: 2026-08-14
kind: proof + finite counterexamples + one negative structural theorem; predecessor verified and two grounds repaired
subject: "Replacement is not shrinking. δ_σ(−) is a COMPLETE JOIN-HOMOMORPHISM (δ(S∪S')=δ(S)∪δ(S'), exactly), hence the LEFT ADJOINT of a monotone Galois connection — not a closure operator, not a Birkhoff polarity. Its induced closure C_σ(S) = the tests redundant given S, and δ(S')⊆δ(S) IFF S'⊆C_σ(S) — the exact replacement criterion, of which Shrink is the special case. Meets FAIL: δ(S∩S')⊊δ(S)∩δ(S') exhibited, minimal at (|X|,|T|,|Q|)=(2,2,2) with 4 of 16 matrices in TWO isomorphism classes (the predecessor's E1 had one), and at (3,3,2) with the meet non-empty. The converse is IMPOSSIBLE by monotonicity. Uniformly in the holonomy, the ONLY order making δ monotone is the resolving-power preorder ∼_{S'}⊆∼_S, and it is the COARSEST such (proved by transpositions). Under UNRESTRICTED replacement there is NO monotone quantity whatever: every pair of h-invariant defect values is jointly realisable in one Chu space, so any uniformly monotone function of δ is constant. D0016 §G's slogan therefore does NOT extend to §F's 'or not' — the framework needs a comparison datum it lacks, and §8 of the note states the unique coarsest one and adds nothing else."
predecessors:
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md
  - collab/upstream/raw/D0017-owner-hieroglyphics-2026-08-14.md
  - 0749-seed148-shrinking-tests-theorem
touches:
  - notes/CHANGING_TESTS_VERSUS_SHRINKING.md (new)
---

# What happens to δ when the test set is *replaced* rather than shrunk

The question is the **owner's**: D0016 **§F**, *मापनक्षेत्रम् अपि परिवर्तते* — the
measurement domain itself changes, $\mathcal T_\alpha\subseteq\mathcal T_{\alpha+1}$
**or not** — read against §G's boxed $\operatorname{Shrink}(\mathcal T)\Rightarrow\delta\downarrow$.
`0749-seed148` named this as its own scope limit. It is now settled.

## Verification of the predecessor first

Read in full, proofs re-derived, Theorem 5's enumeration re-counted independently
(4 of 16, one isomorphism class — confirmed). **Theorems 1–5 and both
counterexamples stand.** Two grounds repaired, neither disturbing a verdict:

- **Rmk. 2.2 misnames the structure.** $(\operatorname{Sep},\sim)$ is *not* a
  Birkhoff polarity — a polarity has both maps antitone and $\operatorname{Sep}$ is
  monotone. What is true: $\sim_{(-)}$ is a polar for the *complementary* relation.
  Theorem 1 is proved from Def. 1.6 directly, so nothing collapses; the correct
  structure is the **monotone** adjunction supplied below.
- **Message `0749`'s subject line is refuted by its own body.** It says the drop is
  strict "iff some discarded test is the SOLE witness" — that is Cor. 3.1, the
  single-deletion case. Counterexample for $|S\setminus S'|\ge2$: two non-constant
  columns, $\mathfrak h=\mathrm{sw}$, $S=\mathcal T\to S'=\emptyset$ drops strictly
  with no sole witness anywhere. The body's Theorem 2 ("some point's *entire*
  detector set is discarded") is correct.

## The lattice structure

With $D_\sigma(x)=\{t:e(\mathfrak h_\sigma x,t)\ne e(x,t)\}$ and
$\delta_\sigma(S)=\{x:D_\sigma(x)\cap S\ne\emptyset\}$:

**Thm A.** $\delta_\sigma(\bigcup_j S_j)=\bigcup_j\delta_\sigma(S_j)$ — a complete
join-homomorphism, determined by singletons. Predecessor Thm 1 is a corollary.

**Thm B.** Hence $\delta_\sigma\dashv\delta^*_\sigma$, a **monotone Galois
connection**, $\delta^*_\sigma(A)=\{t:\delta_\sigma(\{t\})\subseteq A\}$, with
closure operator
$C_\sigma(S)=\{t:\forall x,\ t\in D_\sigma(x)\Rightarrow D_\sigma(x)\cap S\ne\emptyset\}$
— *the tests redundant given $S$* — and $C_\sigma(S)$ is the **largest** test set
with the same defect. So the mandate's trichotomy resolves as: $\operatorname{Ob}$
is neither a closure operator (wrong type) nor a polarity (wrong variance); it is a
left adjoint, and the closure lives downstairs.

**Thm C (the exact replacement criterion).** For arbitrary, possibly incomparable
$S,S'$: $\;\delta_\sigma(S')\subseteq\delta_\sigma(S)\iff S'\subseteq C_\sigma(S)$,
jointly $\operatorname{Ob}(S')\le\operatorname{Ob}(S)\iff S'\subseteq C(S)$.
Shrinking is the case $S'\subseteq S\subseteq C(S)$; the converse fails, so some
non-inclusions are harmless too.

**Thm D + E3, E4 (meets fail).** $\delta_\sigma(S\cap S')\subseteq\delta_\sigma(S)\cap\delta_\sigma(S')$
always, and strictly in general. **E3** (both columns non-constant,
$S=\{t_1\},S'=\{t_2\}$) is minimal at $(|X|,|\mathcal T|,|Q|)=(2,2,2)$ and the
exhaustive count is **4 of 16 matrices in TWO isomorphism classes**, separated by
whether $t_1\sim_{\mathcal T}t_2$ — a real difference from the predecessor's E1,
which had one class, and the reason I re-enumerated rather than cited. **E4**
($|X|=|\mathcal T|=3$, $\mathfrak h$ a $3$-cycle) shows the failure is not an
artefact of $S\cap S'=\emptyset$; $|X|\ge3,|\mathcal T|\ge3$ proved minimal there.
**The converse the mandate asks about — $\delta(S\cap S')\ne0$ with both
$\delta(S)=\delta(S')=0$ — is impossible**, by monotonicity alone.

## The consequential answer for §G

**Thm E.** For $|X|\ge2$, TFAE: (a) $\sim_{S'}\subseteq\sim_S$; (b)
$\delta_{\mathfrak h}(S)\subseteq\delta_{\mathfrak h}(S')$ for **every**
$\mathfrak h\in\operatorname{Aut}(X)$; (c) the same for transpositions only. Hence
the resolving-power preorder is the **coarsest** relation on test sets making
$\delta$ monotone uniformly in the holonomy — the converse is the content, and it
is proved by exhibiting the transposition that breaks any wider relation. Note the
direction: refining raises $\delta$; §G's $\downarrow$ is the blunting shadow.

**Thm F (the negative result).** Take $\mathfrak h$ a fixed-point-free involution,
$\mathcal T$ indexed by its orbits, $e(x,t_\omega)=[x=r_\omega]$. Then
$\delta_{\mathfrak h}$ is a **bijection** from $\mathcal P(\mathcal T)$ onto the
$\mathfrak h$-invariant subsets of $X$. So any two defect values are jointly
realisable in one and the same Chu space, and **any function of $\delta$ monotone
under unrestricted replacement is constant.** $\|\mathcal O\|$ included.

**Verdict.** $\operatorname{Shrink}(\mathcal T)\Rightarrow\delta\downarrow$ is true
and must **not** be cited across §F's "or not". Under replacement the framework has
no monotone quantity and needs one. §8 of the note proposes exactly one datum —
record $\sim_{\mathcal T_\alpha}$ and classify each step
$\operatorname{Refine}/\operatorname{Blunt}/\operatorname{Incomparable}$ — proves it
suffices (Thm E forward) and that **nothing weaker can** (Thm E converse), and adds
no metric, no norm, no progress measure; Thm F rules all of those out anyway. On
$\operatorname{Incomparable}$ steps the honest report is "nothing follows", unless a
specific $\rho$ is in hand, in which case Thm C's finite check decides it — as a
fact about $\rho$, not about the instrument. §G's $\operatorname{SearchSep}$ is the
top of this preorder, which is why it is the conjunct that makes $\delta=0$ mean
anything.

## Prior art, searched before writing

Read in HTML: nLab *Galois connection* and *relation*; Wikipedia *Galois connection*
and *Formal concept analysis*; `arxiv.org/html/2412.11478` Defs. 2.4, 2.8 (its
"restriction in the second sort" is exactly Shrink; it contains **no** resolving-power
order). **No PDF decoded and none claimed.** Thms A and B are classical — join-preservation
⟺ left adjoint, and closure-from-adjunction, attributed there to Ore 1944 with
Birkhoff 1940; the adjunction itself is the poset shadow of Jónsson–Tarski 1951.
Prop. 6.3's closure is the FCA attribute closure of the "does not separate" context
(Wille 1982; Ganter–Wille). **Rediscovery, labelled.** Plausibly new, and small:
Thm E's converse, Thm F with its orbit realisation, the two-class enumeration, and
the identity $A=\bigcap_{\mathfrak h}C_{\mathfrak h}$.

## Scope limits

Common test universe assumed — the fibred case (stages compared only through a Chu
transform) is **not** treated. $\operatorname{Aut}(X)$, not arbitrary endomaps:
Thm E's uniqueness clause is not claimed for non-invertible transports. The ordinal
ladder, $\mathfrak F$, the Yang–Baxter defect, the seven components, and the four
undefined conjuncts of $\operatorname{Advance}$ are untouched. **All of D0017 is
untouched**, including its §J2 question whether the geometric/logical bridge is a
theorem or a pun; per D0017 §J6 nothing has been relabelled in its vocabulary.

**Substrate.** No Python written, modified or run. No Agda or Lean authored; no
typechecking claimed (no toolchain here). No measurement, no fitted constant, no
floating-point number in either file.

Full development: `notes/CHANGING_TESTS_VERSUS_SHRINKING.md`.
