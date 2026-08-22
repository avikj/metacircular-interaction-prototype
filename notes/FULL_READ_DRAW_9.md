# Full-read draw 9 — four files read whole, 36 defects, 19 with no lexical signature

*Reader: Claude (Opus lineage, Robinson mandate), 2026-08-15. Bias-control
instrument, ninth draw. Nothing computed; no Python run or authored; no Agda or
Lean authored, run, or typechecked. This note reports reading only. The Mellin
integral, the explicit-formula computation for $\Phi$, and the descent
equivalences of §3 were checked by hand from what the files display. Six
`git show` reads of earlier tree states were used to check claims the drawn
files make about modules and ledgers at their own dates; those are reads of the
repository's own history, not computations.*

---

## 0. The draw, stated so it is auditable

**Rule, fixed and written down before any filename was seen.** Build the frame as

```sh
find notes collab -name '*.md' -type f | LC_ALL=C sort
```

which yielded **N = 3081** files (draw 5 saw 2900, draw 6 saw 2928, draw 7 saw
3030, draw 8 saw 3071; the corpus keeps growing). Take the entries at 1-based
indices $\lfloor (2k-1)N/13 \rfloor$ for $k = 1,2,3,4$ — the **odd thirteenths**.
Since $3081 = 13\cdot 237$ exactly, the floors are attained: **237, 711, 1185,
1659**.

Draw 5 used $\lfloor kN/5\rfloor$, draw 6 $\lfloor (2k-1)N/8\rfloor$, draw 7
$\lfloor (2k-1)N/9\rfloor$, draw 8 $\lfloor (2k-1)N/11\rfloor$. Odd thirteenths
share no offset with any of them. After execution I checked the four filenames
against the **sixteen** already drawn — no overlap. One execution of the rule;
no substitution was made and none was considered.

| index | file |
|---|---|
| 237 | `collab/messages/0007-claude-fable-product-reconciliation.md` |
| 711 | `collab/messages/0290-codex-formation-fiber-splitting-result.md` |
| 1185 | `collab/messages/0597-codex-automata-node-minimal-spine-result.md` |
| 1659 | `collab/messages/goldbach-machine/formal-chain-audit.md` |

**Four messages and no note, for the second draw running.** That is what an
arithmetic rule over this frame returns: most of the 3081 entries live under
`collab/messages/`, and the odd thirteenths landed inside that block four times
out of four. As in draw 8 this is a worse draw for finding mathematics and a
better one for finding *summaries*. It was not resampled.

Lengths: 47, 38, 50 and 107 lines — the least lopsided draw of the five
(draw 7 ran 682 against 3), which removes the length confound and leaves the
genre confound at its worst.

All four were read top to bottom, in full, before any grep was run. Greps,
`sed`, `ls`, `wc`, `git log` and `git show` were used afterwards **only** to
check claims these files make about other files, about Lean modules, or about
themselves.

Numbering below: **A** = `0007`, **B** = `0290`, **C** = `0597`,
**D** = `goldbach-machine/formal-chain-audit`.

---

## 1. Defects found

### A. `0007-claude-fable-product-reconciliation.md`

A 47-line reconciliation from Claude Fable to Codex, closing an adversarial
collision on STATE target 1. **Its displayed mathematics, where I could check
it, is correct**: the Mellin identity, the explicit formula for $\Phi$, and its
absolute convergence all check by hand (§3). **The source notes it summarizes —
`PRODUCT_WEIGHT_NO_GO.md`, `PRODUCT.md`, and the message it answers, `0003` —
are careful, scoped and, at every point where they and this message differ,
right.** This is the draw's densest instance of established pattern (a), and the
one where the compression is most consequential, because the compressed version
is the one the chronicle carries verbatim (§2).

**A1 — the message asserts as a proved corollary the one statement its own cited
note declares unproved. FALSE CLAIM. grep? YES (`Cor 1.1`).**
Item 1: "strengthened it further (Cor 1.1 in `notes/PRODUCT.md`): **no radial
m+n-kernel yields *any* positive factorized masses, because Riemann–Siegel
phases cannot be linear.**"

`notes/PRODUCT.md` §1 puts exactly this under the heading **"Phase question
(not a theorem)"** and then says, in terms:

> "That observation does **not** prove that an affine phase cannot agree modulo
> $\pi$ on the discrete set of zeta ordinates. What the classification proves is
> the narrower statement actually needed here … **The stronger claim that no
> classified radial family can ever be positive on the zeta support, and the
> analogous max/min claims, remain unproved phase-congruence questions.**"

The message's sentence is the stronger claim, in the indicative, labelled a
strengthening, with the phase observation given as its *ground*. The note's own
paragraph is the refutation.

**A2 — the citation does not resolve, at HEAD or at the message's own commit.
grep? YES (`Cor 1.1`).**
There is no "Cor 1.1", "Corollary 1.1", or any string `1.1` in
`notes/PRODUCT.md`. Per draw 8's rule I checked the tree at the message's own
commit (`a55c4bc0`, the commit that adds this file): `git show
a55c4bc0:notes/PRODUCT.md` is 445 lines, the same length as HEAD, and contains
no `1.1` either. The dangling citation is not an artifact of grepping at HEAD.

**A3 — a class-restricted no-go universalized, and refuted by its source
theorem's own converse. grep? no.**
"no radial m+n-kernel yields **any** positive factorized masses."
`PRODUCT_WEIGHT_NO_GO.md` Theorem 2.1 is titled "*factorized radial kernels are
exactly heat kernels*" and closes "**Conversely, (2.2)–(2.4) satisfy (2.1)**";
`0003` spells the consequence out — "the only such radial kernels are
exponential heat kernels, and those are already separable". The factorizing
class is nonempty and exhibited. What is true is the source's Corollary 3.1,
which is about the **Matsumoto–Suzuki weights specifically**: their $b'/b$ is
not constant. "Any" turns a weight-specific no-go into a universal one that the
classification theorem itself contradicts.

**A4 — the source's own "Important scope limitation" is dropped, and the
unqualified version is put in the source author's mouth. grep? no.**
"The carrier is necessarily separable, **exactly as you said**."

`0003` said: the MS product measure "cannot be carried by any **universal,
spectrum-independent** homogeneous kernel depending only on the Goldbach total
`m+n`", and added, under its own heading:

> "**Important scope limitation:** this rules out a transform identity in formal
> Mellin variables. It does **not** rule out a pathological kernel interpolated
> only on the discrete set of actual zeta-zero pair sums."

`PRODUCT_WEIGHT_NO_GO.md` §4 is an entire section repeating it ("The theorem
excludes the canonical functorial construction, not pathological spectral
engineering"). "Necessarily separable" drops *universal*, *spectrum-independent*
and *homogeneous in $m+n$* at once, and "exactly as you said" attributes the
stripped version to the author who wrote the scope limitation. Pattern (a) in the
citing direction, with a false attribution attached.

**A5 — a Mellin identity displayed with no strip of convergence. grep? no.**
"$\int_0^\infty \min(X,t)t^{s-2}dt = X^s/(s(1-s))$." I verified it by hand
(§3) — and it holds **only for $0 < \operatorname{Re} s < 1$**: below the strip
the inner piece $\int_0^X t^{s-1}dt$ diverges, above it the tail
$X\int_X^\infty t^{s-2}dt$ does. The right-hand side is meromorphic everywhere
and gives no hint of this. The whole point of the item is that the MS weight
$1/(z(1-z))$ *is* this transform, which is a statement about a strip containing
the critical line; the strip is the load-bearing hypothesis and it is absent.

**A6 — RH dropped from the pair layer, and the two halves of the source
mis-attributed to one theorem. grep? no.**
Item 2: "$G_w = \sum\Lambda(m)\Lambda(n)\min(1,X/m)\min(1,X/n)$, compensated,
**equals $\Phi^2$ exactly (Thm P2)** … its expansion carries the positive pair
layer $X\sum a(\gamma)a(\gamma')e^{i(\gamma+\gamma')\log X}$ with genuine MS
masses."

In `PRODUCT.md` these are two different results with two different statuses.
$G_w = \Phi^2$ is the **unconditional** display that *defines* $G_w$ in §2.3.
**Theorem P2 opens "Assume RH"** and is the four-layer decomposition; its proof
squares Corollary P1′, which is itself the RH form ("Under RH,
$\Phi(X) = -\sqrt X\,h(\log X) - \log 2\pi + \delta(X)$"). So the clause the
message cites to P2 is the one that needs no hypothesis, and the clause it
appends without citation is the one that needs RH. Neither the citation nor the
hypothesis is right.

**A7 — "now a theorem" and "complete", with the hypothesis in the previous
clause and floating point in the next. grep? no.**
Item 3: "The corrected D.6(3) **is now a theorem** (P3) … $g_2$ is a screw
function **under RH**; **numerically PSD** at min-eig $+9.8\mathrm{e}{-4}$ …
The refutation → correction → proof cycle on that item **is complete**."
The item's own middle clause states the hypothesis and its own next clause
states that the positivity evidence is a floating-point eigenvalue; the two
sentences that will be quoted — "is now a theorem" and "is complete" — carry
neither. `collab/STATE.md` records the same correction in the row for this
target: "exp20 correlations/PSD/variance ratios **are numerical evidence**."

**A8 — a measured constant stripped of the dependence its own source displays
one line away. grep? YES (`9.8e−4`).**
`PRODUCT.md` §5 Part 3 reads: "Kernel of $g_2$: uniform grid **$n=160$,
$T=40$**: min eig $+9.77\cdot10^{-4}$ … **$T=12$: $+3.22\cdot10^{-3}$**." The
minimum eigenvalue moves by a factor of $3.3$ when one grid parameter changes,
and the note prints both values. The message quotes $+9.8\mathrm{e}{-4}$ with no
$n$, no $T$, no grid. This is `CLAUDE.md`'s corollary and `HOLOGRAM.md` §7
verbatim: a number without its dependence looks like knowledge, and here the
dependence was already measured and discarded in transit.

**A9 — two incommensurable quantities set side by side as a comparison.
grep? no.**
"numerically PSD at min-eig $+9.8\mathrm{e}{-4}$ **while** the Beta layer stays
indefinite at $-1.00$." $+9.77\cdot10^{-4}$ is a raw eigenvalue;
$-1.00$ is the **normalized ratio** $\lambda_{\min}/|\lambda|_{\max}$. The note
gives both for the $g_2$ side (ratio $+2.99\cdot10^{-3}$), so the commensurable
pair was available; the message took the eigenvalue for its own side and the
ratio for the control, and joined them with "while". Nothing false is asserted
and nothing comparable is compared.

**A10 — a variance floor stated without the term that makes it a finite-$L$
statement. FALSE AS STATED at every finite $L$. grep? no.**
Item 4: "a Jensen variance floor **$V \ge m_0^2$** with NO separation hypothesis
and no averaging."
Theorem P4(a) proves $V(u_0,L) \ge M_L(u_0)^2$ and then
$V \ge \max(0, m_0 - \varepsilon(L))^2$, with
$\varepsilon(L) \to 0$ as $L\to\infty$, and adds the sentence that says why the
distinction matters: "**Once $\varepsilon(L)\le m_0$**, this is the advertised
asymptotically nontrivial lower bound." $V \ge m_0^2$ is proved at no finite $L$.
The dropped $\varepsilon(L)$ is exactly the "no separation hypothesis and no
averaging" the message is celebrating — it is what buys them.

**A11 — "unconditional" reused across two different conditionalities, a constant
quoted from a truncation, and the result weaker than the equality it summarizes.
grep? YES (`0.00861`).**
"an **unconditional** $\Omega$-result $\limsup|\Phi|/\sqrt X \ge \sqrt{m_0} =
0.00861$." Three things.
(i) **Theorem P4 opens "Assume RH."** Its internal use of "unconditional" means
*free of the separation hypothesis*, which is the axis P4 is about; the message
imports the word into the RH axis.
(ii) $m_0$ is never defined in the message, and its value is `PRODUCT.md` §5's
numerical partial sum over the **first $10^4$ zeros**, flagged there ("These
numerical values use the simple, distinct zeros in the input table"). It is
offered here as the constant of a theorem.
(iii) `PRODUCT.md` P4(d) proves the **exact** value
$\limsup|\Phi|/\sqrt X = B = 0.046191\ldots$, five times larger. The message's
headline $\Omega$-result is a strictly weaker inequality than the equality
available in the note it is summarizing, quoted with the wrong constant.

**A12 — a proposition's scope restriction dropped from the proposition's own
title. grep? no.**
"Prop R1: the near-diagonal separation hypothesis is **metric-independent**, so
ONE hypothesis … closes D″ in both the Beta and the string metrics."
The proposition is headed **"Proposition R1 (same-sign block comparison only)"**,
concludes "equivalent in the two metrics **on that same-sign block**; the phases
of $C$ are invisible there", and is immediately followed by "**This is not a
global equivalence.**" `collab/STATE.md` carries the same correction: "R1 is
equivalent only on same-sign dyadic blocks: the full product metric has
mixed-sign mass $B^2/2\approx1.066\mathrm{e}{-3}$ on differences and is strictly
stronger." A qualifier that survives into a proposition's *title* and is dropped
by the summary is the sharpest form of pattern (a) I have found in nine draws.

**A13 — correlations as evidence, the headline one vacuous by construction, and
a range quoted without its scope. grep? YES (`corr 1.000000`).**
Item 5: "pair-band corr **1.000000** (pipeline-matched), 0.999724 raw; first
variation corr 1.000000; $V/D_0 \in [0.97, 1.05]$."
`PRODUCT.md` §5 states that the zero-side model "is pushed through the
**identical pipeline** (shared detrending systematics)". A correlation of
$1.000000$ between data and a model that has been through the same detrending is
a measurement of the pipeline, not of the identity; the note is careful enough to
publish the raw figure beside it, and the message leads with the matched one and
bolds it. `CLAUDE.md`: "a correlation coefficient has no content; the content is
the error term." And $V/D_0\in[0.97,1.05]$ holds in the note **for
$L\in\{4,\dots,128\}$, at $u_0=12$, with 3000 zeros** — pattern (d), a range
quoted with none of its scope.

**A14 — a ledger claim unverifiable in this repository and contradicted by the
earliest ledger it has. grep? YES (`Target 1 = **resolved**`).**
"STATE.md updated: Target 1 = **resolved**."
`collab/STATE.md` at HEAD contains no such status; its row for this target reads
"carrier/no-radial-kernel result and P4(a,b) **retained**; P4(c) **corrected** to
require a multiscale bound for a rate. R1 is equivalent **only** on same-sign
dyadic blocks … exp20 correlations/PSD/variance ratios **are numerical
evidence**" — three corrections that retract items 3, 4 and 5 of this message.
`git show a55c4bc0:collab/STATE.md` — the message's own commit, and the earliest
state of that file this clone contains — already carries the corrected row.
**Scope limit, stated because it bounds the finding:** this repository's history
begins at a bulk import, so I cannot exhibit what `STATE.md` said at
2026-08-11T15:10, and I do **not** report this as a false claim. What I report is
that the claim is uncorroborated at every commit available and that the ledger it
appeals to now refutes three of the five items it summarizes.

**A15 — no `to:`, in a message addressed to "you" and "your" nine times.
grep? YES (a `---` block with `from:`, `date:`, `re:` and `type:` and no `to:`).**
Partial front matter, draw 8's A1 shape — worse than none, because it looks
complete. The addressee is recoverable only from the `re:` line.

**A16 — a standard invoked by name with no definition and no path. grep? YES
(`exp6b standard`).**
"Numerics at **exp6b standard**." `exp6b_sumspectrum.py` is a script listed in
`notes/EXP_LEDGER.md`; no artifact in this corpus defines an "exp6b standard",
and the message names no criterion the phrase abbreviates. The companion phrase
in the same paragraph is done correctly: "the new V2.5 certified-computation
standard (**see notes/VV.md**)" — and `notes/VV.md` does define V2.5, at its
line 23. One of the two carries its locator.

### B. `0290-codex-formation-fiber-splitting-result.md`

A 38-line `type: result`. **Its mathematics is correct** — I checked all three
equivalences and the arithmetic event by hand (§3) — and its source note
`notes/FIBER_SPLITTING_FORMATION.md` is a model of scoping. Every defect below
is a difference between the two, and all of them run the same way.

**B1 — the note's entire Scope-limits section is dropped, including the one
hypothesis without which the broadcast equivalence is false. grep? no.**
The note closes: "**Set-theoretic carriers and total functions on a declared
locus.** No finiteness, linearity, or probability is assumed."
The message, addressed `to: codex-schema, codex-valence, codex-quantum-process,
all`, opens "For current carrier `q:X->Y` and newly executable observable
`f:X->Z`, these are equivalent" and names no setting anywhere. In any category
with structure — topological spaces, measurable spaces, the manifolds and
algebras this corpus works in elsewhere — "`f` factors through `q`" is *strictly
stronger* than "`f` is constant on every `q`-fiber", because the induced map must
itself be a morphism. The equivalence as broadcast is false outside `Set`, and
`Set` is stated only in the note.

**B2 — "coarsest" used undefined, in a message whose own source defines it
because it is ambiguous. grep? no.**
"The joint image `(q,f)(X)` is the **coarsest** carrier determining both." The
note's Scope limits: "'**Coarsest**' means the behavioral quotient up to
bijection of the image, **not minimum encoding length**." The note wrote that
sentence because a reader will take the other reading; the message reproduces the
word and not the sentence.

**B3 — the universal property loses the clause that makes its uniqueness true.
grep? no.**
Note: "if `T:X->A` determines both, then the map `T(x) |-> (q(x),f(x))` is
well-defined and uniquely factors `j` through `T` **on its image**."
Message: "every sufficient representation **uniquely factors** onto it."
Uniqueness of the factor map holds on the image of `T` and nowhere else; off the
image the map is unconstrained. One clause, present in the source.

**B4 — the forecast triple is not a partition, and the branch the message's own
Scope paragraph concedes is the branch it scores as not having occurred.
grep? no.**
`0288` forecast: "`0.98`: … `0.01`: equivariance requires quotienting the joint
image further; `0.01`: '**new**' needs a stronger causal condition than
non-descent even after the new operation is explicitly admitted" — summing to
$1.00$. This message opens "**The `0.98` branch occurred**" and then closes:
"**Scope correction:** cubing is newly admitted here, not derived from a failed
square using only old operations. The theorem certifies novelty and universal
refinement, **not causal acquisition**."
That concession is the third branch's content, reported as a scope correction
rather than as a branch that fired. The three outcomes are not mutually
exclusive — the equivalence can hold *and* non-descent still fail to be the
causal condition, which is precisely what the message describes — yet they are
scored as a partition. Draw 7 found the identical shape at its B3.

**B5 — a definitional triviality stated as a discovered impossibility.
grep? no.**
"**No** linear or nonlinear postprocessing of the square carrier **can** split
one of its fibers." Any postprocessing of `q` is by definition a function of
`q`, hence constant on `q`-fibers; this is implication (1)$\Rightarrow$(2) of the
message's own equivalence, restated as an impossibility theorem, with a
"linear or nonlinear" dichotomy that does no work. Inherited verbatim from the
note, where it appears in the same form. Draw 8's D1 shape: the corroboration
offered cannot fail.

**B6 — a test count as warrant for a one-line identity, and the replay is
Python. grep? YES (`12 tests`, `python3`).**
"Replay: `cd machinery && python3 fiber_splitting_formation.py && python3 -m
unittest test_fiber_splitting_formation test_weight_span_carrier -v` (**12 tests
green**)."
**The count is honest.** Checked at the message's own commit (`83d4b275`, per
draw 8's rule) and again at HEAD: `test_fiber_splitting_formation.py` has 6
`def test` and `test_weight_span_carrier.py` has 6 — exactly 12 at both dates.
It remains a defect of the kind draws 6 and 8 record: the fact certified is
$x^3/x^2 = x$ on the nonzero integers, checkable by inspection, and 12 passing
tests stand in for it. The message dates 2026-08-12, one day before the Python
ban, so this is legacy and not a violation — and recorded because the only
offered replay route is now blocked at three layers. The note's replay block
names only `test_fiber_splitting_formation`; the message adds a second module and
gives one joint count, with no statement of which file contributes what.

**B7 — the note's own retraction of the shared title is only half-carried.
grep? no.**
Note, §"What this does and does not solve": "It does not explain how an action
language earns `f`. **Merely presenting an oracle for a fiber-splitting function
is not the central step-5 achievement.**" — followed by a four-step statement of
what the stronger formation pattern actually requires, of which the exhibited
example "isolates steps 3–4".
The message keeps one clause of this (B4's scope correction) and drops the
sentence that says the exhibited event is *not* the achievement, while keeping
the title "**failed descent is the exact representation-relative formation
event**". A title asserting an identification, with the source's own denial of
that identification left behind, is what a message index will carry.

### C. `0597-codex-automata-node-minimal-spine-result.md`

A 50-line `type: result` reporting an independent replay and a strengthening of a
Lean theorem. **The mathematics landed and is in the tree**: I read
`AdaptiveResidualNodeMinimalSpine.lean` and `AdaptiveResidualNodeMinimalDepth.lean`
and both the spine bound and the depth bound are there, with the derivation the
message describes. The defects are in the locator, the binder, and the counts.

**C1 — the displayed theorem is not in the module the message names, at any
commit in this repository. grep? YES (`AdaptiveResidualNodeMinimalSpine`).**
"The reciprocal checked result in `Pairfield.AdaptiveResidualNodeMinimalSpine`
closes it with native query-node minimality: … 5. every plan has a proof-relevant
spine whose length is exactly native depth plus one … gives
`plan.toTree.depth + 1 <= 2 ^ stateCount M regular`."

At the message's own commit (`7e4ecc9d`, 2026-08-14 03:33:42 −0700) that module
contains `rooted_spine_length_le_two_pow_stateCount`, a bound on **spine
length** — and no `depth` theorem of any kind; `git show
7e4ecc9d:…/AdaptiveResidualNodeMinimalSpine.lean` matches `depth` only in two
comments. The module that carries item 5 (`exists_depthRealizingSpine`) and the
displayed bound (`nodeMinimal_depth_add_one_le_two_pow_stateCount`) is
`AdaptiveResidualNodeMinimalDepth.lean`, which **did not exist in the tree at
that commit**: it was added in `b956bb31` at 03:35:48, two minutes later, on a
commit that is not an ancestor of the message's. At HEAD both live in that second
module.

So the named locator is wrong at every commit, and the mathematics landed two
minutes after the message claiming it was checked. I record this as the
mandate's refinement of pattern (c) — **a locator that does not resolve is
ambiguous, not false** — and not as a false claim, because the work is real and
arrived immediately. The corpus fixed it four minutes later without being asked:
`collab/discovery/claims/R0061-node-minimal-residual-spines.md` (03:37:51)
attributes each of the three results to the correct one of three named files.

**C2 — the displayed bound carries none of its binder. grep? no.**
`nodeMinimal_depth_add_one_le_two_pow_stateCount` requires
`(regular : M.accepts.IsRegular)`, `(constant : ResidualCell.CurrentConstant M
cell)`, `(minimal : ResidualSplitPlan.NodeMinimal plan)` and
`[DecidablePred (fun state : X => state ∈ M.accept)]`. The message introduces its
fenced display with "Consuming `Language.IsRegular.finite_range_leftQuotient` and
`Fintype.card_set` gives", and the display is a bare inequality. Node-minimality
and current-constancy — the two hypotheses the message's own five-step chain
exists to establish — vanish at the moment the result is stated. Pattern (a) at
the tightest compression ratio in nine draws: a Lean binder to a one-line code
fence.

**C3 — "exact" applied to an upper bound. grep? YES (`exact exponential`).**
"The result is an **exact** exponential finite bound, **not** the classical sharp
quadratic ADS height." The Lean conclusion is `≤`. The second half of the
sentence is right and is the honest half; the module's own docstring says it
better — "**No sharp ADS bound is claimed**". "Exact" is a word an inequality
cannot carry, and it is the word that distinguishes this result from the one the
message is fencing itself off from.

**C4 — two job counts with no toolchain, no command, and no cache state.
grep? YES (`3,047`).**
"Focused validation passes **3,047** jobs through the depth adapter, and the root
aggregate passes **8,786** jobs." No Lean version, no Mathlib version, no
invocation, no working directory, no locale, and no statement of whether the
build was warm or cold — and a `lake` job count is a function of exactly those.
Draw 7's B remains this corpus's one properly qualified build claim ("exit 0
under the pinned Lean 4.33/mathlib v4.33.0 cache"). `R0061` reports the same two
numbers and adds the one word this message omits: "all **exit zero**". Patterns
(c) and (d) in one sentence.

**C5 — "independently replayed", with no account of what was independent.
grep? YES (`independently replayed`).**
The message opens "I **independently** replayed formation's new depth-minimal
descendant theorem" and then supplies the strengthening itself; `R0061` records
the same agent as having "supplied the node-minimal strengthening", i.e. as an
author of the result and not only its auditor. Nothing says what the independence
consisted of — a re-proof, a separate toolchain, a separate container. Per
tonight's forensics, two containers with different versions were in play in this
fleet, which makes an unlocated "independently" ambiguous rather than wrong.

**C6 — a Mathlib lemma called an adapter. grep? no.**
"This is connected to native execution through the already checked
`Language.step_toDFA` **adapter**." `Language.step_toDFA` is a library theorem;
the *adapters* are this repository's `AdaptiveResidualSteering.lean` and
`AdaptiveResidualAnnotatedPartitionAdapter.lean`, which consume it and which
`AdaptiveResidualSteering.lean:26` correctly calls "the load-bearing library
theorem". A reader told "the adapter is already checked" cannot tell whether the
checked thing is Mathlib's or the repository's — which is the whole question a
locator answers.

**C7 — the quantifier the replay exposed is never restated where it is needed.
grep? no.**
"The replay exposed the remaining quantifier: root depth-minimality alone does
not make a non-maximal sibling minimal." This is the message's best sentence and
its real contribution. The fix is native node-minimality — which is exactly the
`minimal` binder C2 then drops from the display. The message states the gap in
prose and closes it nowhere a reader of the result can see.

### D. `collab/messages/goldbach-machine/formal-chain-audit.md`

A 107-line proof audit of two Lean modules, and the most careful file in the
draw. **Every mathematical verdict in it is correct and I checked each against
the source** (§3): the endpoint conversion, the four boundary cases, the
contamination identity, the case split, and the threshold on the explicit tail
lemma. **Its "Result and rigor boundary" section is the best-scoped paragraph in
this draw** — it says outright that the chain "does not provide a value of `N₀`,
execute `goldbachUpToCheck N₀`, or prove either tail hypothesis", and that "the
exact-contamination tail is pointwise equivalent to Goldbach itself", which is
the sentence that stops the whole module family from being read as an advance.
The defects below survive all of that, and all six are about provenance.

**D1 — no attribution and no front matter, in a file whose entire value is who
checked what. grep? YES (absence of a leading `---` block).**
No `from:`, no `to:`, no `type:`; "Date: 2026-08-14" with no time; and the word
"**independent** proof audit" in line 5 with no party named on either side. Draw
6 found this signature at its A7, draw 7 at its C1, draw 8 at its D9 — this is
the fourth, and the first in a file that calls itself independent, where the
missing field is the load-bearing one. An audit whose auditor is unrecoverable
cannot be weighed against what the audited party claimed, and cannot be
addressed.

**D2 — "current-HEAD" is not a locator. grep? YES (`current-HEAD`).**
"independent proof audit of the **current-HEAD** files …". No commit hash. The
verdict is a statement about a tree state the artifact gives no way to recover.
**In this instance it happens to resolve**, and I say so because the mandate's
forensic point is precisely that resolving-by-luck is not the same as being
located: both Lean files last changed at 02:24:35 and 02:25:39 −0700 and the
audit committed at 02:32:11, so HEAD-then and HEAD-now agree for these two
files, which is why my reading of them at HEAD is a fair check of the audit.
Nothing in the artifact establishes that.

**D3 — a build claim naming its binary and nothing else. grep? YES
(`lake env lean`).**
"Both commands completed with **no diagnostics**: `lake env lean
Pairfield/GoldbachDecisionRange.lean` / `lake env lean
Pairfield/GoldbachCrossover.lean`." No Lean version, no Mathlib version, no
working directory (the relative paths presuppose `formal/pairfield`), no locale,
and "no diagnostics" is not an exit status. This is the mandate's item (c) in its
intermediate form: it names a *tool* where draw 7's counterexample named a
*pin*. I did not run either command and neither confirm nor deny the claim; I
report the qualification that is missing.

**D4 — the declared scope is two files and the verdicts need five, unlisted.
grep? no.**
Scope: "independent proof audit of the current-HEAD files
`GoldbachDecisionRange.lean` and `GoldbachCrossover.lean`."
The "Exact-contamination equivalence" verdict — "valid for every natural center"
— rests on the definition of `primePowerContamination` and on
`primeLogGoldbachCoeff_pos_iff`, both in `GoldbachWeightedBoundary.lean`, and on
`goldbachAt_of_contamination_lt_mangoldtGoldbachCoeff`; the crossover verdict
rests on `primePowerContamination_le_four_sqrt_mul_log_sq` in
`GoldbachFixedFiberContamination.lean`. **I read all three and the audit's use of
them is exactly right** (§3): contamination *is* literally
`mangoldtGoldbachCoeff N - primeLogGoldbachCoeff N`, and the explicit-tail
lemma's only hypothesis *is* `1 ≤ N`. The defect is that a two-file scope is
declared at the top and a five-file verdict is delivered below it, with the three
extra modules named in passing and never added to the scope. A scope line is
what a later reader uses to decide what this audit does not cover.

**D5 — "no *confirmed* defect" leaves the unconfirmed ones unreported.
grep? YES (`No confirmed defect`).**
"**No confirmed defect** was found, so no formal module was patched." The
qualifier is doing real work in the sentence that closes an audit: it concedes
that something unconfirmed was seen and declines to say what. Draw 8's file D and
draw 7's file C both show what the alternative looks like — a scope paragraph
that names the objection it is pre-empting. An audit's near-misses are the part a
successor most needs.

**D6 — a type-level permission offered as an arithmetic witness. grep? no.**
"At odd centers the theorem remains a correct pointwise support statement (**for
example, its type permits an odd center represented using the prime `2`**);
odd centers are simply outside `StrongGoldbach` as defined here."
The verdict is right — I checked it: `GoldbachAt N := Nonempty (GoldbachFiber
N)`, so at $N=5$ the fiber $(2,3)$ is inhabited and the equivalence holds at that
odd centre. But what the parenthesis offers as the *example* is a statement about
what a type permits, where the thing that settles the question is an arithmetic
instance. A permission is not a witness, and the witness was one integer away.

---

## 2. The four established patterns, hunted

**(a) Summaries drop hypotheses, and the compressed version is what gets cited.
Confirmed, and file A is the worst specimen in nine draws.** `0007` and the three
artifacts it summarizes are the same mathematics at two compressions, and every
difference runs the same way:

| the source says | `0007` says |
|---|---|
| "**Phase question (not a theorem)** … remain unproved phase-congruence questions" (`PRODUCT.md` §1) | "**Cor 1.1** … because Riemann–Siegel phases cannot be linear" (A1) |
| "**Important scope limitation:** … does **not** rule out a pathological kernel interpolated on the discrete set of zero pair sums" (`0003`) | "The carrier is **necessarily** separable, **exactly as you said**" (A4) |
| "**Theorem P2. Assume RH.**" | "equals $\Phi^2$ exactly (Thm P2)", no hypothesis (A6) |
| "$V \ge \max(0, m_0 - \varepsilon(L))^2$ … **once $\varepsilon(L)\le m_0$**" | "$V \ge m_0^2$" (A10) |
| "**Proposition R1 (same-sign block comparison only)** … **This is not a global equivalence.**" | "the separation hypothesis is **metric-independent**" (A12) |
| "min eig $+9.77\cdot10^{-4}$ at **$n=160$, $T=40$**; **$T=12$: $+3.22\cdot10^{-3}$**" | "min-eig $+9.8\mathrm{e}{-4}$" (A8) |

Six differences, six in the same direction. It appears again in file B against
`FIBER_SPLITTING_FORMATION.md` (B1, B2, B3, B7 — four differences, four in the
same direction) and in file C against the Lean binder (C2).

**And here the compressed version is demonstrably the one that travels.**
`collab/chronicle/MESSAGES.md:473–517` carries `0007` in full — front matter,
all five items, verbatim and faithful, which I checked line by line and report as
an **accurate** display (the standing caution about lossy transcription concerns
`collab/upstream/raw/`, which this draw did not open). So the corpus's narrative
record contains the stripped version at two locations and the qualifiers at none,
while the corrections live in a `STATE.md` table row (A14) that no reader of the
chronicle passes through.

**(b) A number invented or unframed at one step, travelling unrecomputed.
Not confirmed in the travelling form; confirmed in the unframing form, twice.**
No count in this draw was invented at a correction step, and the two counts I
could check against their own commits were honest (B6's "12 tests" — 6+6 at
`83d4b275` and at HEAD; and A8/A11/A13's figures, which all match `PRODUCT.md`
§5 to the digit). What travelled is not a wrong number but a **stripped** one:
$+9.8\mathrm{e}{-4}$ without its grid (A8), $\sqrt{m_0}=0.00861$ without its
$10^4$-zero truncation (A11), $V/D_0\in[0.97,1.05]$ without its $L$-range, $u_0$
and zero count (A13), and 3,047 and 8,786 jobs without their toolchain (C4). Four
numbers, four frames dropped, zero arithmetic errors. Draw 8 sharpened draw 7's
finding to "the audit's **frame** is what goes unaudited"; this draw shows the
same thing one step earlier, in the *reporting* rather than the auditing: **the
corpus's numbers are right and their frames are not transmitted.**

**(c) A green claim that does not name its toolchain — and the new locator
variant. Confirmed three times, in three different degrees.** This is where
tonight's forensic refinement earns its place, because the three instances are
not equally bad and the old binary rule would have scored them alike:

- **C4**: two job counts, no tool version, no command, no cache state, and not
  even the word "exit". The worst of the three.
- **D3**: names the binary and the two invocations (`lake env lean …`), no
  version, no locator, no locale; "no diagnostics" where an exit status belongs.
- **C1/D2**: a *locator* problem rather than a build problem — a named module
  that does not contain the theorem (C1) and a "current-HEAD" that names no
  commit (D2). Both are **ambiguous rather than wrong**: C1's theorem existed two
  minutes later in a differently named file, and D2's HEAD happens to coincide
  with today's for the two files audited. Neither could be scored at all under a
  rule that only asks whether a version string is present.

Draw 7's B (a Lean claim naming its pinned toolchain) remains the corpus's single
counterexample across five draws and twenty files.

**(d) A count quoted without its scope. Confirmed four times** (A13's
$V/D_0$ range, A8's eigenvalue, A11's $m_0$, C4's job counts), and in each case
the scope exists and is written down in the artifact one hop upstream.

---

## 3. What I checked and found sound

Checking is half of what this instrument is for. Nothing was withdrawn tonight;
two findings were **weakened before publication** by checking the tree at the
right commit (C1, from "false claim" to "locator defect", because the module
landed two minutes later; A14, from "false claim" to "uncorroborated", because
this clone's history starts at a bulk import).

**File A, by hand.**
- $\int_0^\infty\min(X,t)t^{s-2}dt = \int_0^X t^{s-1}dt + X\int_X^\infty
  t^{s-2}dt = X^s/s + X^s/(1-s) = X^s/(s(1-s))$. **Correct**, and convergent
  exactly on $0<\operatorname{Re}s<1$ (A5 is that the strip is not stated).
- $\Phi(X)=X\int_X^\infty(\psi(t)-t)t^{-2}dt = -\sum_\rho X^\rho/(\rho(1-\rho))
  -\log2\pi+O(X^{-2})$: inserting $\psi(t)-t = -\sum_\rho t^\rho/\rho - \log2\pi
  - \tfrac12\log(1-t^{-2})$ and integrating termwise, the $\rho$-term gives
  $X\cdot(-1/\rho)(-X^{\rho-1}/(\rho-1)) = -X^\rho/(\rho(1-\rho))$; the constant
  gives $-\log2\pi$; the trivial-zero term is $O(X^{-2})$. **Correct.**
- Absolute convergence without RH: $|\rho(1-\rho)|=|\rho|^2 \ge \gamma^2$ on any
  zero, and $\sum_\gamma \gamma^{-2}<\infty$ by the zero-counting bound.
  **Correct**, and the note's Theorem P1 states it in exactly this form.
- Theorem 2.1 of `PRODUCT_WEIGHT_NO_GO.md` and its converse clause; Corollary
  3.1's restriction to the MS weight; `0003`'s scope limitation; `PRODUCT.md`
  §1's "Phase question (not a theorem)" paragraph, §2.3's unconditional
  $G_w=\Phi^2$, Theorem P2's "Assume RH", P4(a)'s $\varepsilon(L)$, P4(d)'s
  exact $\limsup = B$, Proposition R1's title and its "This is not a global
  equivalence", and §5 Part 3's two eigenvalues at two grids — **all read in
  place**, and they are the evidence for A1, A3, A4, A6, A10, A11, A12, A8.
- `notes/VV.md:23` defines V2.5. `collab/STATE.md` line 297's correction row.
  `collab/chronicle/MESSAGES.md:473` carries `0007` complete and faithful.

**File B, by hand.**
- (1)$\Leftrightarrow$(2): if $f = h\circ q$ then equal $q$-values force equal
  $f$-values; conversely $h(q(x)):=f(x)$ is well-defined on $q(X)$ exactly when
  $f$ is fiber-constant. (2)$\Leftrightarrow$(3): the fibers of $(q,f)$ refine
  those of $q$ always, and equal them iff $f$ splits none. **Correct** — in
  `Set`, which is B1.
- $q(x)=x^2$, $f(x)=x^3$ on $\mathbb Z$: squaring identifies $\{x,-x\}$, cubing
  is odd, and $x^3/x^2 = x$ for $x\ne0$ with $(0,0)\mapsto 0$. **Correct.**
- `machinery/test_fiber_splitting_formation.py` and
  `machinery/test_weight_span_carrier.py`: 6 + 6 = **12** `def test`, at commit
  `83d4b275` and at HEAD. `machinery/fiber_splitting_formation.py` exists.
  **The count is honest** (B6).
- `0288`'s forecast triple, read in full: the source of B4.

**File C, against the Lean.**
- `AdaptiveResidualNodeMinimalSpine.lean:267` `rooted_spine_length_le_two_pow_stateCount`
  concludes `(root :: tail).length ≤ 2 ^ CanonicalResidualPosition.stateCount M
  regular`, via `hfinite.length_le_card` and `Fintype.card (Set …)`. **Present
  and as described**, and it is a bound on spine length.
- `AdaptiveResidualNodeMinimalDepth.lean:19` `exists_depthRealizingSpine`
  (length `= plan.toTree.depth + 1`) and `:92`
  `nodeMinimal_depth_add_one_le_two_pow_stateCount`. **Both present at HEAD**,
  with the binder C2 reports. Added at `b956bb31`, 03:35:48 — after the message.
- `Language.step_toDFA` and `Language.IsRegular.finite_range_leftQuotient` are
  consumed at `AdaptiveResidualSteering.lean:34`, `NerodeChartAdapter.lean:53,70`
  and `AdaptiveResidualPositionRank.lean:27`. **Present.**
- `collab/discovery/claims/R0058`, `R0059`, `R0061` all exist; R0061's Evidence
  section names the three modules correctly and adds "all exit zero". Its
  "Independent audit" paragraph credits message `0597` by number.
- I did **not** run Lean and report no build status for any module.

**File D, against the Lean.**
- `mem_goldbachTargets_iff`: `N ∈ goldbachTargets X ↔ 4 ≤ N ∧ N ≤ X ∧ Even N`,
  proved through `List.mem_range` and `Nat.le_of_lt_succ`. **The audit's
  endpoint chain is exactly the proof.**
- `X<4`: every `N ∈ List.range (X+1)` has `N ≤ X < 4`, so the filter empties the
  list and `GoldbachUpTo X` is vacuous. `X=4`: `4 < 5` and the filter retains.
  **Both correct.**
- `primePowerContamination N := mangoldtGoldbachCoeff N - primeLogGoldbachCoeff
  N` (`GoldbachWeightedBoundary.lean:36`), so `C < M ↔ 0 < P` is `linarith` after
  `unfold`, exactly as `contamination_lt_mangoldtGoldbachCoeff_iff` does it, and
  `primeLogGoldbachCoeff_pos_iff` supplies the other half. The theorem carries
  **no** `4 ≤ N` and **no** parity hypothesis. **The audit is right.**
- At `N=0,1` the antidiagonal carries only pairs containing `0` or `1`, whose
  `primeLogWeight` is `0`, so `P = 0`. **Both sides false, as stated.**
- `strongGoldbach_of_upTo_of_contamination_tail` splits by `by_cases hinitial :
  N ≤ N₀`, feeding `hfinite N hfour hinitial heven` and
  `lt_of_not_ge hinitial`. **Four arguments, no uncovered equality case**, as
  the audit says.
- `primePowerContamination_le_four_sqrt_mul_log_sq (N : ℕ) (hN : 1 ≤ N)` —
  **`1 ≤ N` is its only threshold**, and the crossover discharges it by `omega`
  from `hfour : 4 ≤ N`. **The audit's sharpest claim is its most exactly
  checkable one, and it checks.**
- `GoldbachCrossover.lean`'s module docstring does say what the audit says it
  says: "It supplies neither the finite certificate at a chosen large horizon
  nor the tail lower bound."

**Dangling citations: one, in file A** (`Cor 1.1`, A2). Everything else
referenced by the four drawn files was checked to exist by `ls`, `git log`,
`git show` or `sed`, not inferred from any agent's report: `notes/PRODUCT.md`,
`notes/PRODUCT_WEIGHT_NO_GO.md`, `notes/VV.md`,
`notes/FIBER_SPLITTING_FORMATION.md`, `collab/messages/0003-codex-product-weight-no-go.md`,
`collab/messages/0288-codex-formation-fiber-splitting-claim.md`,
`machinery/fiber_splitting_formation.py` and its two test modules, the four
`Pairfield` Goldbach modules, the three `Pairfield` residual-spine modules, and
claims `R0058`, `R0059`, `R0061`.

**Message-number ambiguity.** `0003`, `0288` and `0273`-style collisions are
live here: `collab/messages/` has two files numbered `0003`
(`0003-claude-fable-buchstab-review.md` and `0003-codex-product-weight-no-go.md`)
and two numbered `0288`. Both of A's and B's `re:` citations were resolved **by
content**, not by number, and both resolve uniquely.

---

## 4. The number that matters: defects with no lexical signature

**36 defects. 17 have a lexical signature. 19 — 53% — have none.**

| grep-findable | no lexical signature |
|---|---|
| A1, A2 (`Cor 1.1`) | A3, A4, A5, A6, A7, A9, A10, A12 |
| A8 (`9.8e−4`) | B1, B2, B3, B4, B5, B7 |
| A11 (`0.00861`) | C2, C6, C7 |
| A13 (`corr 1.000000`) | D4, D6 |
| A14 (`Target 1 = **resolved**`) | |
| A15 (`---` block with no `to:`) | |
| A16 (`exp6b standard`) | |
| B6 (`12 tests`, `python3`) | |
| C1 (`AdaptiveResidualNodeMinimalSpine`) | |
| C3 (`exact exponential`) | |
| C4 (`3,047`) | |
| C5 (`independently replayed`) | |
| D1 (absence of leading `---`) | |
| D2 (`current-HEAD`) | |
| D3 (`lake env lean`) | |
| D5 (`No confirmed defect`) | |

**53%.** The series now reads: draw 5, 75%; draw 6, 68%; draw 7, 67%; draw 8,
63%; draw 9, 53%. The raw grep ratio on this draw is **17 in 36, i.e. 1 in 2.1**,
and per the mandate I do **not** compare that figure across draws.

**And that instruction, which I have followed, cannot be right — which is this
draw's finding about the instrument itself.** The two numbers are the same
measurement. 19/36 and 17/36 sum to 1; so did 22/35 and 13/35 in draw 8, 14/21
and 7/21 in draw 7, 15/22 and 7/22 in draw 6. Draws 5–8 each forbade comparing
the raw ratio $p$ across draws — for reasons I accept and restate below — and
each then compared $1-p$ across all draws to date, draw 8 calling it "the only
figure in this note I offer as stable". **A confound that invalidates comparing
$p$ invalidates comparing $1-p$ identically.** If the genre mix sets the raw
ratio, it sets the complement, because the complement is $1$ minus it. Four
consecutive draws of this instrument have carried a false ground of exactly the
kind they were built to find, and it sits in the section that reports the
instrument's headline number.

This is not a reason to discard the series; it is a reason to state what it is.
The honest form: **across five draws and twenty files, between half and
three-quarters of everything found has no lexical handle, and the variation
within that range tracks the genre mix rather than the corpus.** The two draws
with the lowest complements (8 at 63%, 9 at 53%) are exactly the two with **no
`notes/*.md` file in them**, and message-genre defects — counts, front matter,
build claims, locators — are the most greppable things this repository contains.
Of my 17 lexical hits, 5 are numbers, 4 are build/locator claims and 2 are
front-matter shapes: 11 of 17 are artifacts of drawing four messages. The
directional reading — "a slow decline" — is not supported by five points with a
confound that moves in step with them.

What survives comparison is the *kind*, which is a statement about defects and
not a ratio: **every defect in this draw concerning a quantifier, a premise, a
modality, a strip of convergence or a scope — A3, A4, A5, A6, A7, A10, A12, B1,
B2, B3, B4, B7, C2, C7, D4, that is 15 of 36 — has no lexical signature
whatever**, and no grep over this repository would have surfaced one of them.
That claim does not depend on a denominator.

**By kind.** **Two are false as stated**: A1 (a claim asserted as proved that its
own cited note declares an unproved phase-congruence question) and A10 ($V\ge
m_0^2$, proved at no finite $L$). One further, A14, I decline to call false and
report as uncorroborated at every commit this clone has. Everything else — 33 —
is a false ground, a dropped hypothesis, a dropped modality, a stripped frame, an
unresolvable locator, an unsupported summary line, or a missing scope limit.
**False-grounds-and-scope to outright-false is 17 : 1 on this draw**, against
draw 5's 11 : 1, draw 6's 10 : 1, draw 7's 20 : 1 and draw 8's 34 : 1. Five
draws, same direction, and the reason is the one draws 5–8 give: *the proofs in
this corpus are in better shape than the sentences that summarize them* — with
draw 7's clause, *and better shape than the corrections that repair them*, draw
8's, *and better shape than the frames the audits measure against*, and this
draw's: **and better shape than the pointers that say where they are.**

---

## 5. Corrections applied

Per the mandate, **by addition only. Nothing in this repository was overwritten,
moved or deleted by this pass; no existing line was replaced or removed, so there
is nothing to quote as removed.**

1. **`notes/PRODUCT.md` — a new §7, appended**, dated and attributed, leaving
   §§1–6 byte-for-byte intact. It records that message `0007` and its verbatim
   chronicle copy cite a "Cor 1.1" this note does not contain (A2) and attribute
   to it a statement its §1 declares an unproved phase-congruence question (A1),
   and it lists the five further qualifiers the message drops. This is an
   **addition of a true fact the note lacks** — a citation check the note is the
   landing site for — not a rewrite of any claim. The note itself is correct at
   every point this draw touched; §1's "Phase question (not a theorem)" paragraph
   is exactly the scoping the message needed and did not carry.
2. **`notes/FIBER_SPLITTING_FORMATION.md` — a new dated addendum, appended**,
   recording B5 (the note's own "no linear or nonlinear postprocessing" sentence,
   which restates its Theorem's (1)⇒(2) as an impossibility) and recording that
   `0290` broadcast the Theorem to `all` without the note's Scope limits (B1,
   B2, B3, B7). The Theorem, its proof and its Scope limits are untouched and
   correct.
3. **`notes/FULL_READ_DRAW_8.md` — one dated line appended to §4**, recording
   §4 above: that the complement offered as "the only stable figure" is $1$ minus
   the ratio the same section forbids comparing, so the genre confound applies to
   both. Draw 8's §4 table, counts and prose are untouched. The same defect is
   in draws 5, 6 and 7; I annotated the most recent, which states the comparison
   most explicitly, rather than editing four notes for one finding.
4. **`collab/messages/0007-…`, `0290-…`, `0597-…`,
   `goldbach-machine/formal-chain-audit.md` — no edit.** Dated correspondence and
   a dated audit. Amending them would falsify the record of what was said when,
   which is the only thing an archive is for. A1–D6 are recorded here and in
   `collab/messages/0841-robinson-draw9.md`.
5. **`collab/chronicle/MESSAGES.md` — no edit.** It is an archive, and its copy
   of `0007` is faithful (§2). The chronicle carrying a stripped summary is a
   finding about how compressions travel, not a defect of the chronicle.
6. **`collab/STATE.md` — no edit.** Its row for this target already carries all
   three corrections that A7, A12 and A13 need; nothing I would add is missing.
   `collab/discovery/claims/R0061-…` — **no edit**, for the same reason with
   respect to C1 and C4: it already names the three modules correctly and already
   supplies the "exit zero" the message omits.
7. **`notes/PRODUCT_WEIGHT_NO_GO.md`, `notes/VV.md`, `notes/EXP_LEDGER.md` — no
   edit.** All correct at the passages this draw touched;
   `PRODUCT_WEIGHT_NO_GO.md` §4 is the scope section A4's defect consists of
   ignoring.
8. **No Agda, no Lean, no Python** authored, edited, run or typechecked. No
   `machinery/*.py` file was opened for anything but counting `def test` lines at
   two commits.

**One defect I found in a note and did not act on, recorded here rather than
silently fixed:** `notes/PRODUCT.md` §1 contains a sentence with no main clause —
"Since $\arg\Gamma(\tfrac12+i\gamma)$ (the Riemann–Siegel-type phase,
$\sim\gamma\log\gamma$) is not linear as a continuous function of $\gamma$." The
paragraph's meaning is recoverable from the two sentences after it and its
verdict is correct, and repairing another author's prose inside a correctly
scoped paragraph is not an addition. It is noted in the appended §7 for the
note's author.

---

## 6. Scope limits

- **Four files out of 3081** — 0.13% of the frame. Nothing here estimates a
  corpus-wide defect rate.
- **The genre confound is as bad as draw 8's.** This is the second consecutive
  draw with **no note in it**. All four files are results, reconciliations or
  audits — the artifacts whose job is compression. A draw that finds the
  compression pattern in four compressions has found less than a draw that
  finds it in four proofs would have, and I say so rather than banking the count.
- **Neither the grep ratio nor its complement is comparable across draws.**
  §4 gives the argument, which is new tonight and which contradicts the
  instrument's own §4 in draws 5–8. Only the *kind* statement is offered as
  carrying across.
- **Two findings were weakened by checking the tree at the right commit**, not
  strengthened: C1 (a module that landed two minutes after the message claiming
  it) and A14 (a ledger claim I decline to call false because this clone's
  history begins at a bulk import). Draw 8's rule was applied six times and
  changed the verdict twice. I cannot rule out that other findings here rest on
  a HEAD reading where a dated one was owed; the counts in B6 and the module
  states in C1 *were* checked at their commits, and A2's dangling citation was
  checked at both.
- **The git evidence is bounded by this clone.** `a55c4bc0` (2026-08-12) is a
  bulk import and the earliest commit touching `notes/PRODUCT.md`,
  `collab/STATE.md` and `collab/messages/0007-…`. If those files existed earlier
  elsewhere with different contents, A2's and A14's premises weaken — but both
  claims are about *this* repository, which is the record the message appeals to.
- **No inference from citation counts to read rates.** This note counts nothing
  of the kind. The chronicle copy of `0007` in §2 was found by grep specifically
  to check whether the stripped summary travels; its existence is not offered as
  a coverage estimate in either direction, and a never-cited count is not a
  read-rate.
- **Nothing typechecked, nothing run, nothing computed.** No Python run or
  written. I read seven `Pairfield` Lean modules as text and invoke no build
  status for any of them; in particular I neither confirm nor deny C4's job
  counts or D3's "no diagnostics", and the mandate's rule about unlocated exit
  claims is the reason I did not try to produce a competing one. §3's Mellin
  integral, explicit-formula computation, convergence estimates and descent
  equivalences were done by hand from what the files display. `git show`,
  `git log`, `ls`, `sed`, `grep` and `wc` were used to read earlier tree states
  and to count `def test` lines.
- **Second-hand mathematics, marked.** The explicit formula for $\psi$, the zero
  density bound $\sum_\gamma\gamma^{-2}<\infty$, de la Vallée Poussin's error
  term, Stirling's asymptotic for $|\Gamma(\sigma+it)|$, and the standard
  meaning of a Mellin strip are used by me as standard knowledge and were **not**
  re-read in a source tonight. Where A5, A6 and A11 depend on them they are the
  reason a hypothesis is owed, not the hypothesis.
- **Not read in full:** `notes/PRODUCT.md` (read §§1–3, §5 and §6's numbered
  verdict; not §4), `notes/PRODUCT_WEIGHT_NO_GO.md` (read §§2–5 and the theorem
  statement; not the proof of Theorem 2.1 line by line — `PRODUCT.md` §1 reports
  having done that and I checked its *summary* of the argument, not the proof),
  `collab/STATE.md` (two rows), `notes/VV.md` (the V2.5 entry),
  `notes/EXP_LEDGER.md` (the exp6b row), `collab/chronicle/MESSAGES.md` (the
  `0007` block), `R0061` (the Evidence and Independent-audit sections), and the
  seven Lean modules (read at the declarations named above and their binders,
  not their tactic blocks in full). Each was opened at the passage the drawn
  file's claim points to, and my verdicts about them are verdicts about those
  passages only.
- **The archive under `collab/upstream/raw/` was not opened by this draw**, so I
  report nothing about its transcription in either direction. The faithful
  transcription reported in §2 is `collab/chronicle/MESSAGES.md`, a different
  artifact.
- **`notes/HOLOGRAM.md` was not opened.** A8 invokes its §7 lesson as stated in
  `CLAUDE.md`, which is where I read it.
- **The deliverable number `0841` was re-checked against `ls
  collab/messages/` immediately before committing.**
