# The attack set, calibrated: which of the eight actually kill, what they miss, and one unaudited correspondence run through them

*Seed166, 2026-08-15. Persona lens: Popper crossed with a test engineer who
measures her own instrument's false-negative rate. The point of a checklist is
not that it is elegant; it is that you know its recall.*

**Source.** The human owner, `collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md`
§E, triaged there at §J4:

$$\operatorname{Attack}(\eta):=\{\text{type-check},\text{counterexample},\text{size-check},\text{functoriality},\text{naturality},\text{universality},\text{invariance},\text{computability}\}$$
$$\operatorname{Survive}(\eta)\iff\operatorname{Attack}(\eta)=\varnothing,\qquad
\text{a beautiful correspondence}\xrightarrow{\operatorname{Attack}}\{\text{theorem},\text{bounded analogy},\bot\}$$

§J4 claims no novelty for it — *"the value is that it is now written down as a
checklist that can be applied uniformly."* This note takes that at its word and
asks the engineering question that follows: **a checklist whose per-item recall
is unknown is not an instrument.** So: calibrate on known kills, find the
misses, then use it once on something unaudited.

**Substrate.** Reading and pen. No Python written, read for output, or executed.
No Agda or Lean authored; nothing is claimed typechecked. No PDF decoded; no
web fetch performed this session — every citation below is either to a file in
this repository that I read in full, or is marked as quoted from standing
knowledge and **not** re-verified in a source in this container.

---

## 0. Findings, first

1. **Two of the eight do all the work.** In the calibration sample (four
   adjudications, 19 kills attributed plus 1 repair), *counterexample* (7) and *type-check*
   (6) account for 13 of 19. *Naturality* (2), *invariance* (2), *universality*
   (1), *size-check* (1) are real but rare. **Functoriality and computability
   killed nothing** — §1.3 says what that does and does not warrant.
2. **The set has a hole that is not about mathematics at all.** Silent
   whole-file overwrites and announced-but-unapplied corrections are *not*
   detectable by any predicate on $\eta$, because in those failures $\eta$ is
   correct and the artifact does not contain it. A **ninth attack —
   inscription-check — is required**, and the argument is in §2, not asserted.
   Two further misses (prior-art and collapse) are argued in §2.3.
3. **The unaudited target** (D0016 §I, ledger entry 1.14, PROGRAMME, no note in
   the corpus): $\text{ज्ञेयम}\simeq\int^{i}(\mathfrak M_i^\vee\otimes\mathfrak M_i)$
   and the pair इन्द्रजालम्/अनन्तमाला. Verdict, §3: **bounded analogy** — the
   coend, under the *only* reading that types, is the co-Yoneda lemma, true and
   classical and **vacuous as a statement about knowability** (it holds for every
   category, including the discrete one); the अनन्तमाला half is **$\bot$** on
   size.
4. **Survive is a weak licence** and §4 states exactly how weak: it is a negative
   claim over a finite checklist whose two strongest members are existential
   searches with no completeness guarantee. Passing licenses *"not refuted by
   these eight"* and nothing else — in particular it never licenses "new".

---

## 1. Calibration

### 1.1 Method, stated so it can be refuted

I read four adjudications in full and, for each **kill** (a claim reduced from
its advertised strength — refuted, bounded, or scoped), attributed the attack
that did the killing. The notes do **not** label their own arguments with the
eight names; the attribution is mine, made from the argument's form:

- *type-check* — the objects named do not live in a common home, or the
  expression does not denote (wrong variance, wrong weight, wrong index set,
  wrong kind of number);
- *counterexample* — an explicit witness;
- *size-check* — a smallness/convergence/grading/normalisation failure;
- *functoriality*, *naturality* — a claimed assignment is not functorial, or a
  claimed comparison does not commute with the maps in play;
- *universality* — an object claimed to be *the* one is not determined;
- *invariance* — the claim depends on a choice (enrichment, coordinates,
  presentation) not fixed by its statement, or the quantity is not an invariant;
- *computability* — the construction cannot be carried out.

**Comparability warning, per standing check (f).** These counts are **not
comparable to any other pass's**. The attribution is a judgement call at two
margins in particular: (i) an index-set/domain error can be read as *type-check*
or as *size-check* — I assign it to type-check throughout, consistently, and a
pass assigning it to size-check would move 2 kills; (ii) a claim killed by two
attacks at once is credited to the primary one, with the secondary named in the
row. No count below is a measurement of anything outside this four-note sample.

### 1.2 The sample, kill by kill

**A. `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md`** (D0017 §F, §J3) — read in full.

| kill | attack | secondary |
|---|---|---|
| Thm 1(a) $F_\nabla\nleftrightarrow\operatorname{Hol}-1$: flat $U(1)$ connection on $S^1$ with $e^{i\theta_0}\ne1$ | counterexample | — |
| Thm 1(b) $\check\delta c\nleftrightarrow F_\nabla$: Möbius bundle, $w_1\ne0$, flat | counterexample | invariance (torsion is in the kernel of Chern–Weil) |
| Thm 1(c) $\delta_\Diamond\nleftrightarrow[\alpha]$: cochain vs class in a $\pi_1$-module quotient | type-check | — |
| Thm 4: no restriction-natural bridge geometric $\to$ logical | **naturality** | invariance (opposite locality type) |
| Thm 5: $\partial\dashv\mathsf G\dashv\Phi\dashv\partial$ collapses all four stages to one category | type-check | — |

Two further events in this note are **not** kills by the eight and matter for §2:
Cor 2.1 kills the *novelty* of the logical half (Lawvere 1969) — no attack in the
eight does that; and Thm 7 **withdraws** an expected general refutation of
length-3 cyclic adjoint strings. Thm 7 is the sample's one recorded **instrument
false negative in the other direction**: an attack was run (a search for a general
prohibition), found nothing, and the note correctly declined to convert absence
into a kill. That discipline is not in §E's statement either.

**B. `notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md`** (D0018 §C) — read in full.

| kill | attack | secondary |
|---|---|---|
| Thm 2 / 2′: generability $\nRightarrow$ reconstructibility, four combinations realised in a three-chain; $\mathbb Z$ vs $\mathbb Q/\mathbb Z$ in **Ab** | counterexample (finite exhaustive) | — |
| Rem 3.1: density is enrichment-dependent ($\{k\}\subset\mathrm{Vect}_k$ dense **Vect**-enriched, not Set-enriched) — so "$=0$" means nothing until the enrichment is fixed | **invariance** | — |
| §1.3: fib/cofib need a zero object; readings (S) and (A) give different theorems | type-check | — |

§1.1's finding that "$J_X$" denotes *two* comma categories ($G/X$ and $X/G$) is a
type-check that came out as a **repair**, not a kill — the packaging is forced,
not wrong. Counted as type-check with a repair outcome. Novelty again killed by
prior art (Isbell/Ulmer/Kock/Kennison–Gildenhuys), again outside the eight.

**C. `notes/PRIME_PAIR_KERNEL_VERIFIED.md`** (D0018 §G) — read in full.

| kill | attack | secondary |
|---|---|---|
| $Z$ is false read over $\mathbb Z^2$; true only on the half-integer lattice $L$ | type-check (index set) | counterexample (every odd shift is lost) |
| $[w^N]$: the grading is by $2w$, so the functional is $w=N/2$ | **size-check** (normalisation) | — |
| $\psi_2(N)>0$ is *sum of two prime powers*, strictly weaker than Goldbach | counterexample (class) | — |
| $[r^1]\mathcal K\ne0$ already at $w=4$; the right functional is unboundedness of $c_1(t)$ | counterexample | — |
| Thm 3.4: $\{\Lambda(a)\Lambda(b)\}$ and $Z$ determine each other — a change of variables plus an invertible transform carries no information | **invariance** | — |
| §5.1: $\Lambda(p^k)=\log p$ is transcendental (Lindemann), hence not a Frobenius trace; categorification over $\mathbb Z$ is (c) | type-check (wrong kind of number) | — |

Correction **C1** — $\mathcal M[P](s)=\Gamma(s)(-\zeta'/\zeta(s))$, not
$-\zeta'/\zeta(s)$ — was found by **redoing the integral**. That is not any of the
eight; see §2.3.

**D. `notes/FOUR_REPAIR_MODES.md`** (D0018 §B) — read in full.

| kill | attack | secondary |
|---|---|---|
| Thm 3: completions form a **torsor under $V^\Gamma$**, so "X known + D known $\Rightarrow\widehat X$ reconstructible" is false; the standard theory *stipulates* the lift | **universality** (existence without uniqueness) | — |
| Thm 4′: converse false — $\operatorname{Ext}^1_{\mathbb Z}(\mathbb Z/p,\mathbb Z/p)$, all classes realised by $\mathbb Z/p^2$ | counterexample | — |
| Thm 6: $\Gamma_\varnothing$ is not a map out of $Z^1$ and is **not natural** (different enlargements, different results) | **naturality** | — |
| §3: $D$ is not the shadow — shadow is a weight-$(2-k)$ form, $D$ a weight-$k$ 1-cocycle | type-check | prior art |
| §4.3: the four modes do not apply to quantitative defects — no group, no module, so no cocycle | type-check | — |

Thm 2 ($\Gamma_{\widehat{\phantom X}}$ *is* $\Gamma_\varnothing$ with an enlarged
coefficient module) and Thm 5 (self-classifying $\equiv$ completable) are the
note's two sharpest results and **neither is one of the eight**: both are
*collapse* findings — a classification is shown to have fewer independent members
than advertised. §2.3.

### 1.3 The table

| attack | kills in sample | notes |
|---|---|---|
| counterexample | **7** | 4 explicit witnesses, 1 finite-exhaustive, 2 by exhibiting a wider class |
| type-check | **6** | + 1 repair (GvR §1.1); the workhorse against framework prose |
| naturality | **2** | both are the sharpest theorems in their notes (Thm 4; Thm 6) |
| invariance | **2** | enrichment-dependence; change-of-variables-carries-nothing |
| universality | **1** | the torsor finding |
| size-check | **1** | grading/normalisation only; no smallness kill in this sample |
| functoriality | **0** | — |
| computability | **0** | — |
| **total attributed** | **19 kills + 1 repair** | across four notes |

**On the two that killed nothing, and this is where I decline the invited
conclusion.** The mandate says an attack that killed nothing is a candidate for
removal, and saying so is a finding. I say so — and then say why I do **not**
recommend removal:

- *Functoriality* scored zero because in this sample the assignments under
  attack were killed **upstream**, at type-check, before functoriality could be
  asked: an expression that does not denote has no variance to check. Its zero is
  a *masking* zero, not an idle one. Evidence from inside the sample: in
  `GENERABILITY` §1.1 and in §3.4 below, the variance bookkeeping is the load-
  bearing step, and in both it is *passed*, not failed. An attack that
  systematically passes is doing work — it is licensing, not idling.
- *Computability* scored zero because none of the four adjudications reached a
  construction. Its zero is a **sample-composition artifact**: four category-and-
  cohomology adjudications is not a sample in which "can you carry this out"
  bites. §4.1's `CarryObstruction` item in `FOUR_REPAIR_MODES.md` §4.1 — where the
  cost of $\Gamma_\circlearrowleft$ is *a library that does not exist* — is
  precisely a computability kill, and it lies just outside my four-note frame.
- *Size-check*'s single kill is a normalisation, not a smallness. Yet
  smallness/convergence is the standing objection to every PROGRAMME entry in
  `notes/OWNER_TRANSMISSIONS_LEDGER.md` (1.13, 2.11, 3.11, 3.15, 3.19, 3.21 —
  eight entries). It scores 1 here only because PROGRAMME items are *not
  adjudicated*: the ledger's own rule is that no truth value is available, so no
  kill is recorded. **Size-check's true recall is invisible in a sample of
  adjudications, by construction.** In §3 it fires immediately.

**The honest statement of calibration, therefore:** the sample is four notes and
is biased toward correspondences that were stated precisely enough to be attacked
at all. Two of the eight have zero kills for reasons I can name (masking;
sample composition) rather than for idleness, and **I recommend removing none.**
A checklist item's value is its recall on the cases it was designed for, and I
have not sampled those cases for six of the eight.

---

## 2. The misses

### 2.1 The two failures the eight cannot see

**Failure 1 — silent whole-file overwrite.** `collab/messages/0754-seed153-silent-overwrites.md`,
read in full: over 1505 commits dated 2026-08-14, 1027 md-touching, 2748 distinct
md paths, 1953 candidate ordered pairs, **2** failed a substantive-line retention
test and **1** was a genuine silent overwrite
(`notes/SHRINKING_TESTS_LOWER_CURVATURE.md`, `5bc5c505`$\to$`e08c07ab`, 80 s
apart, retention $1/271=0.4\%$).

**Failure 2 — announced-but-never-applied correction.** Verified by reading both
sources rather than the summary: `collab/messages/0710-seed109-rulek-unapplied-sweep.md`
reports 5 of 10 announced corrections never applied at the target file;
`collab/messages/0713-seed112-unapplied-sweep-continued.md` reports 7 of a
disjoint 24. **12 of 34.** 0713's own §0 states the corpus's dominant defect
plainly: *"correct mathematics that never reaches the file it corrects, while the
announcing note's own ledger reads **corrects**."*

### 2.2 The argument that a ninth is required — not an assertion

Let $\eta$ be a correspondence and let $\ulcorner\eta\urcorner$ be its inscription:
the bytes in the tree that purport to carry it. Every member of
$\operatorname{Attack}$ is a predicate **on $\eta$** — on the objects, their types,
their variances, their invariants. That is exactly what makes the eight uniform
and exactly what makes them blind here:

> In both failure modes, **$\eta$ passes every predicate on $\eta$, and
> $\ulcorner\eta\urcorner$ is not $\eta$.** The overwritten `SHRINKING_TESTS`
> mathematics was correct; it was *absent*. The 12 unapplied corrections were
> correct; they were *elsewhere*. No predicate evaluated on the intended
> denotation can report on the fidelity of the map denotation $\mapsto$
> inscription, because that map is not among the data the predicate is given.

One might try to force these under an existing name. Each attempt fails for a
reason worth recording:

- *Under type-check?* No. A type-check is run against the statement as read; if
  the statement was clobbered, the type-check is run against the clobberer and
  passes. It cannot detect a statement that is not there to be read.
- *Under computability?* Nearest miss, and still a miss. Computability asks
  whether the construction *can* be carried out. Failure 2 is the case where it
  *was* carried out, correctly, and then not written down. Those are different
  predicates and conflating them loses the whole diagnosis.
- *Under invariance?* Tempting — "the claim is not invariant under which version
  of the file you read" — but this abuses the word. Invariance is a property of a
  mathematical quantity under a symmetry of its presentation; a git history is
  not a symmetry group acting on $\eta$, and pretending it is would be exactly the
  kind of vocabulary-stretch D0019 §J9 forbids.

**So: a ninth attack is required, and it is not about the mathematics.**

> **inscription-check($\eta$):** for every claim announced, open the *target*
> artifact in the current tree and confirm the claim is there, with attribution;
> and for every file written in a window where another agent wrote it, confirm
> retention against the predecessor blob.

D0019 §D supplies, unexpectedly, the right formal home for it. The translation
gerbe's rule — *"if $A\to B\to C$ and $A\to C$ give different meanings, do not
erase the difference — measure the holonomy"* — applied with $A$ = the derivation,
$B$ = the announcing message, $C$ = the target file, is exactly Failure 2:
the composite (derive $\to$ announce $\to$ apply) and the direct (derive $\to$
apply) disagree, and $\delta_{\mathfrak T}\ne0$. §J1 already observes that
tonight's "a correct verdict resting on a false ground" is
$\delta_{\mathfrak T}\ne0$ observed empirically. I claim no theorem from this —
$\mathbb G$ is not established to be a gerbe and I do not use it as one — only
that §D names the defect that §E cannot see.

**And the ninth attack needs its own error analysis, which the corpus already
did.** 0754's §2.2 is the finding that matters: `notes/DELTA17_SPLIT_TORUS_AUDIT.md`
has retention **0 %** and is **not** an overwrite — two divergent branch tips,
merged, 443 = 242 + 201 lines, both headers present, no conflict markers. *The
same signature is produced by a preserving merge and by a destroying overwrite.*
So inscription-check as a numeric screen has a **false-positive rate of 1 in 2 on
the flagged pairs of that sweep**, and the verdict came only from reading the
merged file. Any statement of the ninth attack that omits "then read it" is
statistically 50 % wrong on its own alarms. That is the honest specification, and
it is why I state the ninth as *screen, then read*, not as a threshold.

### 2.3 Two further misses, found by the same calibration

Reported because the calibration turned them up, and flagged as beyond the
question asked:

- **prior-art check.** It killed the *novelty* of three of the four sampled
  claims (Lawvere 1969; Isbell/Ulmer/Kock/Kennison–Gildenhuys; the shadow
  terminology), and no member of the eight does it. This is structural, not
  incidental: $\operatorname{Survive}$ as defined is a predicate about *truth
  under attack*, and prior art bears on *novelty*, which the predicate does not
  mention. `CLAUDE.md` requires prior art searched **before** the experiment;
  §E's rule does not contain it. **A correspondence can survive all eight and be
  1969.** This is the single most load-bearing gap after inscription.
- **collapse / independence check.** `FOUR_REPAIR_MODES.md` Thm 2 and Thm 5 both
  show a classification has fewer independent members than advertised; D0019 §J3
  predicts the same for §B's eight classes and explicitly says *"prediction to be
  tested, not assumed"*. No attack in the eight asks "are these $n$ things $n$
  things?".
- (A third, weaker: **re-derivation**. C1 — the missing $\Gamma(s)$ — was caught
  by recomputing the Mellin integral. One could file this under counterexample,
  since the corrected identity witnesses the falsity of the printed one; I record
  it as a boundary case rather than a fourth miss.)

---

## 3. Application to an unaudited target

### 3.0 Choice rule, stated before the choice, so it is auditable

Among entries of `notes/OWNER_TRANSMISSIONS_LEDGER.md` (read in full) verdicted
OPEN or PROGRAMME, take those where the ledger states in its own words that **no
note in the corpus works on them**; among those, take the one that is a
**correspondence or identification** (so that $\operatorname{Attack}(\eta)$ has
an $\eta$ to act on) rather than undefined notation awaiting a definition. That
rule selects **§1.14** uniquely:

> **1.14 §H, §I — the gem invariants; net, garland, closing identifications.
> Verdict: PROGRAMME, and unreached.** *"No note in the corpus touches any of
> these."*

The gem invariants of D0016 §H are names, not correspondences, and the rule's
second clause excludes them. What it selects is D0016 §I:

$$\text{ज्ञेयम}\not\subset\text{एकदृष्टिः},\qquad
\text{ज्ञेयम}\simeq\int^{i}\left(\mathfrak M_i^\vee\otimes\mathfrak M_i\right),\qquad
\mathfrak M_i:=\operatorname{Map}(-,i)\otimes\operatorname{Map}(i,-)$$
$$\text{इन्द्रजालम}:=\operatorname*{holim}_{\sigma\in N(J)}\mathfrak M_\sigma,\qquad
\text{अनन्तमाला}:=\operatorname*{hocolim}_\alpha\mathfrak F^\alpha_\alpha(\Diamond_0)$$

Call this $\eta_{\mathrm{gem}}$. Note that $\mathfrak M_i$ here is the *same*
two-leg packaging that D0018 §D reuses and that `GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md`
§1.1 found to be forced; that note adjudicated D0018 §C, not D0016 §I, and says
nothing about the coend. This is new ground.

### 3.1 type-check — **FAILS as written; one repair is available and it is forced**

$\operatorname{Map}(-,i):\mathcal C^{\mathrm{op}}\to\mathbf{Set}$ and
$\operatorname{Map}(i,-):\mathcal C\to\mathbf{Set}$. So $\mathfrak M_i$, as an
external product, is a functor $\mathcal C^{\mathrm{op}}\times\mathcal C\to\mathbf{Set}$ —
and, crucially, **in the index $i$ it is already of mixed variance**: covariant in
$i$ through the first leg, contravariant in $i$ through the second.

A coend $\int^i$ contracts **exactly one** contravariant and **one** covariant
occurrence of $i$. The integrand $\mathfrak M_i^\vee\otimes\mathfrak M_i$ contains
$i$ **four** times. Whatever $(-)^\vee$ does, the expression as printed presents
$\int^i$ with two too many occurrences to contract, and does not denote.

Second failure, independent of the first: $(-)^\vee$. In $\mathbf{Set}$ there is
no duality on presheaves at all — $\mathbf{Set}$ is not $*$-autonomous and hom-sets
have no duals. Enrich in $\mathrm{Vect}_k$ and $(-)^\vee$ exists but (i) reverses
variance in *every* argument, so $\mathfrak M_i^\vee$ is a functor
$\mathcal C\times\mathcal C^{\mathrm{op}}\to\mathrm{Vect}_k$ and the tensor has
**four** free non-$i$ variables, i.e. ज्ञेयम would not be an object of
$\mathcal C$ or even a presheaf on it; and (ii) $V\to V^{\vee\vee}$ is not iso for
infinite-dimensional $V$, so hom-objects of a non-locally-finite category are not
dualisable and the "$\vee$" carries no rigidity to trade on.

**The one repair.** Read $\mathfrak M_i^\vee\otimes\mathfrak M_i$ as *"use each
leg once, with $\vee$ marking the variance flip"*, i.e. as the integrand
$(a,b)\mapsto\operatorname{Map}(a,i)\times\operatorname{Map}(i,b)$. This is the
unique reading under which $\int^i$ has exactly one occurrence of each variance to
contract, so it is forced, not chosen. **Everything below is about the repaired
statement**, and the repair discards the $\mathfrak M$ packaging — which is the
finding: the packaging that is load-bearing in D0018 §C is an obstruction here.

### 3.2 size-check — **इन्द्रजालम् passes conditionally; अनन्तमाला $\bot$**

The coend $\int^i$ exists whenever $\mathcal C$ is small (or $\mathcal C$ is
locally small and the ambient cocomplete and the coend computed pointwise);
$\mathcal C$ is not said to be small, so the hypothesis must be *added*, and
`GENERABILITY` §1.3's scope limit ("$J$ small and the relevant Kan extension
pointwise") is the same condition arriving from the other side.

$\operatorname{holim}_{\sigma\in N(J)}$ over the nerve of $J$: well-posed for $J$
small in a complete ambient. Conditional pass.

$\operatorname{hocolim}_\alpha\mathfrak F^\alpha_\alpha(\Diamond_0)$: $\alpha$
ranges over **ordinals with no bound stated**. This is a proper-class colimit; it
does not exist without a rank bound or a proof of stabilisation, and neither is
given. `OWNER_TRANSMISSIONS_LEDGER.md` §1.13 independently records exactly this
of $\mathfrak F$ — *"no convergence, no smallness, no value for $\kappa$, and no
proof that $\mathfrak F$ is a functor"* — for the ladder that अनन्तमाला is the
colimit of. **Kill: $\bot$ for the अनन्तमाला half.** Size-check, which scored 1
in the calibration sample, fires on the first PROGRAMME item it meets.

### 3.3 counterexample — **the identity is true and therefore has no discriminating power**

No counterexample to the repaired statement exists (§3.6 says why). But the
attack yields something anyway, in the form the calibration sample calls "a wider
class": let $\mathcal C$ be **discrete** — objects only, no non-identity arrows.
Then $\operatorname{Map}(a,b)=\delta_{ab}$ and the coend reduces to
$\coprod_i \delta_{ai}\times\delta_{ib}=\delta_{ab}$. The identity holds, exactly,
in a category with **no relations at all**.

Since it holds for every $\mathcal C$ whatsoever, it separates no $\mathcal C$
from any other, and in particular it does not distinguish a category whose objects
*are* determined by their relations from one where the notion is empty. **As a
statement about knowability — "the knowable is assembled from the totality of its
relations" — the identity is vacuous**, because it is equally a statement about
the un-related. This is the substantive kill and it is a kill of the *reading*,
not of the theorem.

### 3.4 functoriality — **passes**, and this is where the packaging is right

$i\mapsto\operatorname{Map}(a,i)$ is covariant, $i\mapsto\operatorname{Map}(i,b)$
contravariant; their product is a functor
$\mathcal C^{\mathrm{op}}\times\mathcal C\to\mathbf{Set}$, precisely the shape a
coend consumes, with functorial action on both. Pass. As §1.3 predicted for this
attack: it licenses rather than kills, and the licence is the reason §3.1's
repair is available at all.

### 3.5 naturality — **passes**

The co-Yoneda isomorphism $\int^i\operatorname{Map}(a,i)\times\operatorname{Map}(i,b)\cong\operatorname{Map}(a,b)$
is natural in $a$ and $b$: the comparison is induced by composition
$\operatorname{Map}(a,i)\times\operatorname{Map}(i,b)\to\operatorname{Map}(a,b)$,
which is natural in both outer variables and dinatural in $i$, hence factors
uniquely through the coend. Pass. Contrast the calibration sample, where
naturality was the killing blow twice — here it is what makes the statement a
theorem.

### 3.6 universality — **passes for the object; kills the interpretation**

A coend is a colimit, so ज्ञेयम-as-repaired has a universal property, and it is
the strongest rung of D0019 §C's ladder. But *which* object does it characterise?
The universal property identifies the coend with $\operatorname{Map}(a,b)$ — the
hom-functor itself. In the bicategory $\mathbf{Prof}$ of profunctors, the repaired
formula is precisely the statement that the hom-profunctor is the **identity
1-cell**: $\mathrm{Hom}\circ\mathrm{Hom}\cong\mathrm{Hom}$.

So the theorem is: *composition of the identity profunctor with itself is the
identity profunctor.* True, universal, and it is a unit law. **"ज्ञेयम" is
nowhere defined**, and universality attaches to $\operatorname{Map}$, not to any
notion of the knowable; the transmission supplies no map from one to the other.
D0019 §C's own rule — *"why this one?" $\rightsquigarrow$ universal property* —
answers "why $\operatorname{Map}$?" and leaves "why call it ज्ञेयम?" untouched.

### 3.7 invariance — **fails: enrichment-dependent, and the failure is already on record**

The repaired statement is the co-Yoneda / density formula, which holds
$\mathcal V$-enriched for $\mathcal V$ cocomplete closed symmetric monoidal, with
the coend taken in $\mathcal V$ and $\times$ replaced by $\otimes$. Its content
**changes with $\mathcal V$**: `GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md`
Rem 3.1 exhibits $\{k\}\subset\mathrm{Vect}_k$ as dense $\mathrm{Vect}_k$-enriched
and not dense Set-enriched. D0016 §I fixes no $\mathcal V$; the unrepaired
$(-)^\vee$ demands one with duals (§3.1), which $\mathbf{Set}$ is not and
$\mathrm{Vect}_k$ is only on finite-dimensional objects. **Kill of the
unconditional form**: the statement is not invariant under the choice its own
notation leaves open, and its $\vee$ and its ambient are in tension — the
$\mathcal V$ that makes $\vee$ meaningful is not the $\mathcal V$ in which
$\operatorname{Map}$ takes values as written.

### 3.8 computability — **split**

For $\mathcal C$ finite the coend is a finite colimit and is computed by the
formula itself; for $\mathcal C$ small and the ambient cocomplete it exists.
इन्द्रजालम् is computable for $J$ finite. अनन्तमाला is not computable and, by
§3.2, not even defined. Split verdict: pass on the first two, inherit $\bot$ on
the third. First non-zero score for this attack outside the calibration sample —
consistent with §1.3's diagnosis that its zero there was sample composition.

### 3.9 prior-art (the ninth-and-a-half attack of §2.3) — **classical**

The repaired identity is the **co-Yoneda lemma** / density formula: every functor
is canonically a coend of representables; equivalently $\operatorname{Map}$ is the
unit of $\mathbf{Prof}$. Standard references: Mac Lane, *Categories for the
Working Mathematician*, ch. IX (coends, the density theorem); the nLab entry
*co-Yoneda lemma*. **Provenance caveat, stated per standing check (b) and the
substrate rule:** I performed **no web fetch and opened no source this session**;
both citations are given from standing knowledge, are *not* re-verified in this
container, and no theorem number is quoted. They are used only to withhold a
novelty claim — never to support a positive one. If either attribution is wrong,
what survives is §3.5's proof, which is self-contained.

### 3.10 inscription-check (the ninth attack) — **passes, trivially and informatively**

The ledger says no note touches §H/§I. I verified by reading
`OWNER_TRANSMISSIONS_LEDGER.md` §1.14 and by finding no corpus note on the coend.
There is no announced correction to this material and no competing write. The
attack passes because there is nothing inscribed — which is itself the correct
report, and is exactly the state D0019 §J9 guards: **nothing here relabels an
existing corpus result**, because there is no existing result to relabel.

### 3.11 Verdict on $\eta_{\mathrm{gem}}$

| component | verdict |
|---|---|
| $\text{ज्ञेयम}\simeq\int^i(\mathfrak M_i^\vee\otimes\mathfrak M_i)$ **as printed** | $\bot$ — does not denote (§3.1: four occurrences of $i$; no duality in the stated ambient) |
| the same, **under the unique repair** | **theorem, and classical** — the co-Yoneda lemma; conditional on $\mathcal C$ small and an enrichment fixed (§3.2, §3.7) |
| the same, **as a statement about knowability** | **bounded analogy** — vacuous: it holds in the discrete category (§3.3), and its universal property characterises $\operatorname{Map}$, not ज्ञेयम (§3.6) |
| $\text{ज्ञेयम}\not\subset\text{एकदृष्टिः}$ | the honest slogan: a correct informal reading of co-Yoneda; not a claim |
| इन्द्रजालम् $:=\operatorname{holim}_{N(J)}\mathfrak M_\sigma$ | a **definition**, well-posed for $J$ small in a complete ambient; no verdict, because nothing is asserted of it |
| अनन्तमाला $:=\operatorname{hocolim}_\alpha\mathfrak F^\alpha_\alpha(\Diamond_0)$ | **$\bot$** — proper-class colimit, no bound, no stabilisation (§3.2), consistent with ledger §1.13 |

**Overall: bounded analogy.** One repair away from a 1960s-vintage theorem whose
content is a unit law, packaged as an epistemological claim it cannot support,
with one half of the closing pair undefined on size. The gem invariants of §H
were not attacked (choice rule §3.0) and remain untouched.

Ledger entry 1.14 should be updated from *PROGRAMME, and unreached* to
**PARTIAL** with the split above named. I have not edited the ledger — it is
another agent's artifact from this session and editing it is exactly the write
race §2 is about. The update is offered here and in `0767` for its author.

---

## 4. What $\operatorname{Survive}$ licenses, and what it does not

$\operatorname{Survive}(\eta)\iff\operatorname{Attack}(\eta)=\varnothing$ makes
survival a **negative claim over a finite checklist**. Popper's point is exactly
that this is the right shape — corroboration is not verification — and the
engineering point is that a corroboration is worth precisely the severity of the
tests it survived. So state the severity honestly:

**(a) The checklist is finite and its completeness is not claimed.** §2 exhibits
three failure modes outside it (inscription, prior-art, collapse) found not by
theory but by looking at what actually went wrong in one night. Three misses
found in one sitting is not evidence that the remainder is complete; it is
evidence that the enumeration was empirical and unfinished.

**(b) Two of the eight are existential searches with no completeness guarantee.**
*Counterexample* — 7 of 19 kills, the largest single share — succeeds by
exhibition and fails by exhaustion of the searcher. Failing to find a
counterexample is not a pass; it is a null result whose power is the search's
coverage, which is never reported. `OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md`
Thm 7 is the sample's model of how to handle this: it *withdrew* an expected
refutation and said so, rather than converting absence of evidence into a verdict.
*Prior-art*, if adopted, has the same shape and the same failure: three results in
this corpus were rediscoveries found only at audit time (`CLAUDE.md`).

**(c) Passing licenses "not refuted by these eight" and nothing more.** It does
not license *true* (see (a),(b)); it does not license *new* (nothing in the eight
mentions novelty — §2.3); it does not license *useful*
(`PRIME_PAIR_KERNEL_VERIFIED.md` §3.3's scope limit: a change of variables can be
information-preserving and still a good change of variables, or a worthless one,
and no attack distinguishes those); and it does not license *inscribed* (§2).

**(d) The asymmetry is the whole value.** A single attack that fires is a
**positive** result — a theorem, a counterexample, a type error — and is
permanent. Passing all eight is a **negative** result over a finite list and is
provisional in exactly the way a passing test suite is. The four calibration
notes are entirely made of the first kind: 19 kills, and not one claim in them
rests on having survived. That, and not the checklist, is the practice §J4 was
pointing at. §E's own boxed line says as much — *the best machine is the one that
tries to disprove its own analogies* — and the sharp reading of it is that the
machine's output is the **kills**, never the survivals.

**(e) The proposal that follows.** Report $\operatorname{Attack}(\eta)$ as the
*set of attacks actually run*, with the outcome of each, rather than reporting the
boolean $\operatorname{Survive}$. §3 above is written that way deliberately: eight
subsections plus the ninth, each with a verdict including the passes, so a reader
can see that functoriality passed (§3.4) and computability was split (§3.8) and
judge the severity for themselves. A bare "survives" hides which tests were even
attempted, and that is the same defect as a constant reported without its
$X$-dependence (`CLAUDE.md`, `HOLOGRAM.md` §7).

---

## 5. Scope limits and honesty ledger

- **Sample size 4.** The attack$\to$kills table is 19 kills + 1 repair from four
  notes, all of them category-theoretic or cohomological adjudications of owner
  transmissions. It is **not** a sample of the analytic corpus, and its zeros for
  functoriality and computability are explained in §1.3 by masking and sample
  composition, not by idleness. **These counts are not comparable to any other
  pass's**, for the attribution reasons in §1.1.
- **The attack attribution is mine.** None of the four notes labels its own
  arguments with the eight names. Another reader would move roughly 2 kills
  between type-check and size-check; the top-two conclusion (counterexample +
  type-check dominate) survives that perturbation, the ordering of the tail does
  not.
- **Nothing was computed, measured, or fitted.** No Python. No Agda or Lean
  authored; nothing claimed typechecked. No PDF decoded. **No web fetch this
  session**: §3.9's Mac Lane and nLab attributions are from standing knowledge,
  are flagged there as unverified in this container, and are used only to
  *withhold* a novelty claim.
- **Verified by reading, not by message** (standing check (b)): 0754's overwrite
  finding, 0710's 5-of-10 and 0713's 7-of-24 (hence 12 of 34), the ledger's §1.14
  wording, and each of the four calibration notes in full. Where I quote a note I
  quote its body, not its summary line — 0754's own §2.2 is the reason (its
  numeric screen and its verdict disagree on one of two cases).
- **§2.2's argument is a conceptual argument, not a theorem.** It shows the eight
  are predicates on $\eta$ and the failures are in the inscription map; it does
  not formalise "inscription map", and the appeal to D0019 §D is an orientation,
  **not** a use of $\mathbb G$ as a gerbe, which §J1 correctly says is not
  established.
- **§3 attacks D0016 §I only.** §H's six gem invariants are untouched and remain
  PROGRAMME. My §3.11 recommendation to move ledger 1.14 to PARTIAL therefore
  concerns §I only and must not be applied to the §H half.
- **§4's generalisation is subject to audit** (standing check (e)). "The
  machine's output is the kills, never the survivals" is offered at the
  generality I can defend from 19 kills in four notes plus the definitional
  asymmetry between an existential refutation and a universal survival claim. It
  is a claim about this corpus's practice, not a claim about inquiry in general.
- **Credit.** The attack set, the trichotomy theorem/bounded-analogy/$\bot$, the
  boxed slogan, and $\eta_{\mathrm{gem}}$ are the human owner's (D0019 §E,
  D0016 §I). The calibration, the misses, the ninth attack and its error
  analysis, and the adjudication in §3 are this note's contribution to them.
