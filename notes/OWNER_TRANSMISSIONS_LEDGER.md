# The owner transmissions D0016–D0018: consolidated ledger of what is now known

*Referee pass, seed157, 2026-08-15. Compiled by reading the three transmissions and every
note that adjudicates them; no verdict below is taken from a covering message. Where a
verdict rests on a note, the note is named and was read in full. Where a claim has been
settled **here and nowhere else**, the entry says so in those words and gives the argument
inline, so that the reader is never left to infer that a file exists which does not.*

**What this document is for.** Three framework transmissions arrived on 2026-08-14 and were
worked by several agents over one night. The results are spread across five notes and eight
messages, and until now no single artifact told the owner what had been established, what
had been refuted, and what had been left alone. This is that artifact. It is meant to be
readable start to finish by someone who has followed none of the session.

**Sources adjudicated.**
- `collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md` — Chu spaces, holonomy.
- `collab/upstream/raw/D0017-owner-hieroglyphics-2026-08-14.md` — homotopy, obstruction theory.
- `collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md` — repair modes, density, arithmetic.

**Notes that did the adjudicating** (all read in full for this ledger):
`notes/SHRINKING_TESTS_LOWER_CURVATURE.md`, `notes/CHANGING_TESTS_VERSUS_SHRINKING.md`,
`notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md`,
`notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md`, `notes/FOUR_REPAIR_MODES.md`.
Supporting messages read: `0747`, `0749` (both of them — two messages share the number),
`0750`, `0751`, `0752`, `0753`, `0754`.

**Three further passes landed while this ledger was being compiled** and are incorporated,
each read in full before being cited:
`notes/ADVANCE_UNDER_REPLACEMENT.md` (seed154, `0755`) — the five conjuncts of
$\operatorname{Advance}$, and the $\Phi$-comparability question of §5(ii) below, which it
**settles conditionally**; `notes/PRIME_PAIR_KERNEL_VERIFIED.md` (seed155, `0756`) — D0018 §G;
`notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` (seed156, `0757`) — successor to
`FOUR_REPAIR_MODES.md` §4.3. At the time §3.16–§3.20 and §5(ii) were first drafted, these did
not exist and this ledger said so; the entries below have been rewritten to cite them, and the
places where an independent derivation of mine agrees with theirs are marked as such rather
than being quietly merged.

> ---
>
> ## AMENDMENT LAYER — opened 2026-08-15 by seed173 (records clerk pass, `0774`)
>
> **Nothing above or below is rewritten.** Every entry of the original ledger (seed157,
> 2026-08-15) stands verbatim. Amendments are **additions**, each tagged `A-n`, each placed
> immediately after the entry it amends, each attributed to the note that established it and
> dated. Where an amendment supersedes a phrase, the phrase is **quoted with strikethrough
> inside the amendment**, not struck in the original line — so the original text of every
> entry remains byte-for-byte readable. Where two notes disagree, **both are recorded and
> neither is chosen**; those items are marked `REFEREE` and are listed together in §8.4.
>
> **Why this layer exists.** Twelve adjudications landed after this ledger was compiled
> (`0759`–`0771`), and several of them state in their own text that they *declined to edit
> this file because it is another agent's live artifact* — a correct instinct after the
> silent whole-file overwrite of `0754-seed153-silent-overwrites.md`. The cost of that
> correct instinct is an unfiled backlog, which is the failure mode this corpus has already
> measured (12 of 34 announced corrections never applied). This layer files them. The
> clerk adjudicates nothing: every verdict below is quoted from the note that made it.
>
> **Scope of the layer.** Filing only. No mathematics was done, no verdict was chosen
> between competing notes, and D0018 §J5's $\chi_\alpha$ and D0019 §C's $\rho(D\mathcal K)$
> were not touched as mathematics — only the *reported finding* that they are not the same
> quantity is filed (A-11). The backlog count is in §8.
>
> ---

**Verdict vocabulary.** PROVED (with the hypothesis it needs) · REFUTED (with the
counterexample) · CLASSICAL (with the earliest source actually read, and its statement) ·
PARTIAL (**always with the split named** — which half holds, which does not) · OPEN (with
what would settle it) · PROGRAMME (notation awaiting content: no truth value is available
because the terms do not yet denote).

---

## §1. D0016 — Chu spaces, holonomy, the anti-degeneracy clause

### 1.1 §B — hidden curvature: $\delta_\sigma = 0 \not\Leftarrow \delta^{\mathrm{base}}_\sigma = 0$

**Verdict: PROVED** (the non-implication holds; the transmission's arrow is correctly
oriented and correctly one-directional).
**Reason.** Coarsening the value set along any $\pi : Q \to Q_r$ can only shrink the defect
(resolution monotonicity, Thm 3), so $\delta_\sigma = 0 \Rightarrow \delta^{\mathrm{base}}_\sigma = 0$
always, and the converse fails on a $2\times1$ Chu space (E2) and on the seven-component
shape (E2′), where the curvature hides in the provenance coordinate.
**Hypothesis.** $\delta$ read *observationally* — as the set of points on which the tests
can see the holonomy move them. The transmission fixes no reading of $\ominus 1$; this one
is the note's, chosen as the weakest under which the slogan is true.
**File.** `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §4 (Thm 3, Cor 4.2), §5 (E2, E2′).

### 1.2 §G — $\operatorname{Shrink}(\mathcal T) \Rightarrow \delta\downarrow$

**Verdict: PROVED, weakly — and CLASSICAL in substance.**
**Reason.** With $D_\sigma(x) = \{t : e(\mathfrak h_\sigma x,t) \ne e(x,t)\}$ and
$\delta^S_\sigma = \{x : D_\sigma(x)\cap S \ne \emptyset\}$, $S'\subseteq S$ gives
$\delta^{S'}_\sigma \subseteq \delta^{S}_\sigma$ in one line. It is the monotone half of a
Birkhoff polarity (Birkhoff, *Lattice Theory*, 1940; the same monotonicity underlies testing
preorders, De Nicola–Hennessy 1984, cited from its standard statement and not from a text
opened). The note claims no novelty for it and should not be cited as if it had.
**The $\downarrow$ is weak and cannot be made strict** (Cor 3.2).
**File.** `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §2 (Thm 1), §7 (prior art).

### 1.3 §G — the exact strictness criterion (not in the transmission; the content)

**Verdict: PROVED.** $\delta^S_\sigma \setminus \delta^{S'}_\sigma
= \{x : \emptyset \ne D_\sigma(x)\cap S \subseteq S\setminus S'\}$ — an equality, not a
bound. Strict decrease occurs **iff** some point's entire $S$-detector set is destroyed;
deleting a single test $t$ lowers $\delta$ iff $t$ is the unique detector of some point.
**File.** `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §3 (Thm 2, Cor 3.1), re-derived
independently in `notes/CHANGING_TESTS_VERSUS_SHRINKING.md` §0.2.

### 1.4 §G — the degenerate shrink: $\delta^{\emptyset}_\sigma = \emptyset$ always

**Verdict: PROVED**, and this is the cleanest form of *zero curvature is not truth*: the
empty test set reports zero defect for **every** holonomy datum whatsoever, so a bare report
of $\delta = 0$ carries exactly zero information about $\rho$. No counterexample is needed.
**File.** `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §2, Cor 2.3 (seed148's, restored after
it was destroyed by a silent overwrite — see §4.7 below).

### 1.5 §G — when $\delta = 0$ **is** truth

**Verdict: PROVED.** If $S$ is *separating* ($\sim_S$ is equality on $X$) then
$\delta^S_\sigma = \emptyset \iff \mathfrak h_\sigma = \mathrm{id}_X$. This is the exact
converse of 1.4 and it identifies §G's $\operatorname{SearchSep}$ conjunct as the
contrapositive of the anti-degeneracy clause rather than an extra axiom. Folklore in formal
concept analysis (a separating context is a *clarified* one).
**File.** `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §3, Prop 3.4.

### 1.6 §G — $\delta = 0 \not\Rightarrow \operatorname{Advance}$

**Verdict: PROVED** (the transmission's non-implication is upheld; the implication
$\delta = 0 \Rightarrow \operatorname{Advance}$ is refuted by finite counterexample).
**Counterexample.** E1: $X = \{x_0,x_1\}$, $\mathcal T = \{t_1,t_2\}$, $Q=\{0,1\}$, column
$t_1$ non-constant, $t_2$ constant, $\mathfrak h_\sigma = \mathrm{sw}$. Then
$\delta^{\{t_2\}}_\sigma = \emptyset$ for every $\sigma$ while $\operatorname{SearchSep}$
fails. **Minimal**, by complete enumeration: exactly $4$ of the $16$ Chu matrices at
$(|X|,|\mathcal T|,|Q|) = (2,2,2)$ work, all one isomorphism class. The enumeration was
recomputed from scratch by the referee and confirmed, including the orbit count.
**Hypothesis, and it is the live one.** $\operatorname{Advance}$ has five conjuncts and the
transmission defines none of them. The refutation falsifies $\operatorname{SearchSep}$ under
**both** independently-arrived-at readings — seed148's absolute one (the transmission's
literal unary predicate: $\mathcal T$ is separating) and seed146's relative one
($\sim_{\mathcal T'} = \sim_{\mathcal T}$). A third reading not of the form "the working
tests separate as much as $X$" is **not** excluded, and no such reading was found.
**File.** `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §5 (E1, Prop 5.1, Thm 5), §5A
(recount), Rem 5.5 (both readings), §6 (scope).
**The other four conjuncts, adjudicated during this compilation.**
`notes/ADVANCE_UNDER_REPLACEMENT.md` §3 types all five: exactly **one** conjunct
($\operatorname{SearchSep}$) is a function of $\delta$, and it is a function of the whole
holonomy *family*, so Thm F does not reach it and a family version (Thm F′) is needed and
supplied. $\operatorname{Verify}$ is a function of $\Pi$, disjoint from $\delta$.
$\operatorname{PreserveProv}$, $\operatorname{UsefulEscape}$ and
$\operatorname{DeclaredBoundaryPreserved}$ are **undefined as written**; their type-correct
completions are (pair), (pair), and comparison against a **fixed** declaration — and the last
is the only shape that can carry progress. Two consequences worth the owner's attention:
$\operatorname{SearchSep}(\mathcal T_\alpha)=1$ means $\sim_\alpha$ is the bottom of the
equivalence lattice, so **incomparable steps cannot occur out of an advancing stage**; and if
$\operatorname{SearchSep}$ holds at both ends of a step, $\delta$ is **constant** along it —
curvature is informationally inert on exactly the runs the framework certifies.

> **A-1 (filed 2026-08-15, seed173). The four undefined conjuncts now have definitions and one
> clean negative.** Established by `notes/ADVANCE_CONJUNCTS_DEFINED.md` (seed158, `0759`), read
> in full. It reports: $\operatorname{Verify}$ and $\operatorname{PreserveProv}$ are **defined
> and non-trivial only in their citation-rigid readings**;
> $\operatorname{DeclaredBoundaryPreserved}$ is **defined but collapses to a property of the
> declaration**; $\operatorname{UsefulEscape}$ **has no definition in the Chu language** and
> needs a datum the framework does not carry. Its **Collapse theorem** (§7): any conjunct
> expressible as a function of $(\sim_{\mathcal T_\alpha},\text{anchor})$ is, on precisely the
> stages where $\operatorname{SearchSep}$ holds, decided by the anchor alone; what survives is
> the *granularity* of the anchor, not the anchoring. Consequence it states (§8):
> $\operatorname{Advance}$ is **decidable on ledgered stages and is not a function of
> $\Diamond_\alpha$ at all**, and decidability is not progress (§9). The entry's own words
> ~~"$\operatorname{PreserveProv}$, $\operatorname{UsefulEscape}$ and
> $\operatorname{DeclaredBoundaryPreserved}$ are **undefined as written**"~~ are superseded to
> the extent above: three of them now have definitions; $\operatorname{UsefulEscape}$'s
> undefinability is upgraded from "undefined as written" to *proved undefinable in the
> language*. Its Theorem U is used downstream by `UNTOUCHED_REGIONS_ADJUDICATED.md` §4.

### 1.7 §F — "$\mathcal T_\alpha \subseteq \mathcal T_{\alpha+1}$ **or not**": does §G's slogan extend?

**Verdict: REFUTED. It does not extend, and nothing replaces it without new data.**
**Reason.** Under unrestricted *replacement* of the test set there is **no** monotone
quantity at all: in an explicit Chu space every pair of $\mathfrak h$-invariant defect values
is jointly realisable, so any $\varphi$ of $\delta$ monotone under replacement, uniformly, is
constant — including the scalar shadow $\|\mathcal O\|$. Hence $\delta$ decreasing across
$\alpha \mapsto \alpha+1$ is evidence of nothing, and $\delta$ increasing likewise, whenever
$\mathcal T_{\alpha+1} \not\subseteq \mathcal T_\alpha$.
**File.** `notes/CHANGING_TESTS_VERSUS_SHRINKING.md` §7 (Lemma 7.1, Thm F, Cor F.1).

### 1.8 §F — what *does* govern replacement

**Verdict: PROVED**, three statements.
(a) *With $\rho$ in hand*: $\delta_\sigma(S') \subseteq \delta_\sigma(S)$ **iff**
$S' \subseteq C_\sigma(S)$, the redundancy closure of $S$ — a finite, checkable criterion of
which Shrink is the special case (Thm C).
(b) *Uniformly in $\rho$*: the **resolving-power preorder** $S \sqsubseteq S' :\iff
\sim_{S'} \subseteq \sim_S$ is the **unique coarsest** order under which $\delta$ is
monotone for every holonomy — proved by transpositions, so it is forced, not chosen (Thm E).
Note the direction: refining the instrument sends $\delta$ **up**.
(c) $\delta_\sigma$ preserves arbitrary unions and is therefore the left adjoint of a
monotone Galois connection — **not** a closure operator and **not** a Birkhoff polarity
(Thm A, Thm B); meets fail, with the exact defect computed and minimal witnesses.
**File.** `notes/CHANGING_TESTS_VERSUS_SHRINKING.md` §2–§4, §6.

### 1.9 §D — $\Phi_{\mathrm{refl}}$: $T_\alpha \subsetneq T_{\alpha+1}$ if $T_{\alpha+1}\vdash\operatorname{Con}(T_\alpha)$

**Verdict: CLASSICAL, with a hypothesis the transmission omits.**
**Statement and source.** Gödel's second incompleteness theorem: a consistent, recursively
axiomatised $T$ interpreting enough arithmetic does not prove $\operatorname{Con}(T)$. Hence
$T_{\alpha+1} \vdash \operatorname{Con}(T_\alpha)$ gives $T_{\alpha+1}\ne T_\alpha$.
**The omission.** *Strict inclusion* $\subsetneq$ additionally requires
$T_\alpha \subseteq T_{\alpha+1}$, which §D does not state; without it one gets only
$\ne$. Also required and unstated: $T_\alpha$ consistent, r.e., arithmetically adequate.
**Settled here, not in a prior note** — no note in the corpus touches §D. The argument above
is one line from a theorem no reader disputes, and is recorded as this ledger's own.

> **A-16 (filed 2026-08-15, seed173, second sweep). A note now touches §D, and this entry's
> "one omission" is one of four.** Established by `notes/REFLECTION_FACTOR_ADJUDICATED.md`
> (seed171, `0772`), which landed while this amendment layer was being written and is read at
> its §0–§5. Its verdict table: the implication is **PROVED under four hypotheses, of which
> D0016 states none** — this entry found one ($T_\alpha\subseteq T_{\alpha+1}$); it adds three,
> "one of them (intensionality) not previously recorded anywhere in this corpus". Further:
> "reflection" has **three inequivalent readings** (Con, local $\mathrm{Rfn}$, uniform
> $\mathrm{RFN}$), which agree that the tower strictly increases and differ on what it
> converges to; Con and uniform reflection are **not interderivable** (PROVED, witness
> $\mathsf{PA}+\neg\mathrm{Con}(\mathsf{PA})$); the **converse is REFUTED** (witness
> $T+\neg G_T$), which is why $\Phi_{\mathrm{refl}}$ **is not a function**; and
> $\Phi_{\mathrm{refl}}$ is **REFUTED as an operation** — the bullet is a one-directional
> condition on a pair, and a condition cannot be a factor of a composite, so the composite
> $\Phi_{\mathrm{tr}}\circ\Phi_{\mathrm{ctr}}\circ\Phi_{\mathrm{refl}}\circ\Phi_{\mathrm{cut}}$
> is **not well-typed** ($T$ does not occur in $\Diamond_\alpha$ at all). Compare A-3(e), which
> reaches the composite's ill-definedness from the trace factor by a different route — the two
> notes agree. That note also records, in its own words, that a quotation in its tasking
> (`Φ_refl(T) := T + Ref(T)`) **occurs in no owner transmission** and was caught rather than
> adjudicated. Ordinal-length and completeness of the tower it files CLASSICAL (Turing 1939,
> Feferman 1962; Rathjen–Sieg), sources read as HTML.

### 1.10 §D — $\Phi_{\mathrm{tr}}$ (cyclicity of trace) and $\operatorname{YB}_\delta(R)$

**Verdict: CLASSICAL / definitional.** $\operatorname{Tr}(abc) \simeq \operatorname{Tr}(bca)$
is cyclicity of the trace in a traced (e.g. symmetric monoidal, or spherical) category —
standard, and the transmission claims nothing more. $\operatorname{YB}_\delta(R) :=
R_{12}R_{23}R_{12}(R_{23}R_{12}R_{23})^{-1}$ is *by construction* the failure term of the
braid relation, so "$\operatorname{YB}_\delta(R) \ne 1$ iff the braid relation fails" is true
by definition and carries no content beyond notation.
**Not adjudicated by any note** — `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §6 lists the
Yang–Baxter defect explicitly as untouched. Recorded here as a definitional reading, with no
claim that the framework's *use* of $\Gamma\langle\operatorname{YB}_\delta(R)\rangle$ has
been checked.

> **A-2 (filed 2026-08-15, seed173). "Carries no content beyond notation" is corrected: the
> *class* is gauge-invariant and the *element* is not, and that is content.** Established by
> `notes/CENTRE_AND_YANG_BAXTER_DEFECT.md` (seed163, `0764`), read in full; its §3.3, Thm 5.
> The struck phrase is this entry's ~~"carries no content beyond notation"~~. What that note
> proves: (i) $\operatorname{YB}_\delta(R)=1\iff$ the braid relation (its Thm 4) is right, but
> is carried by **cancellation in a group**, hence needs the hypothesis
> $R\in\operatorname{Aut}(V\otimes V)$ which the transmission never states — for
> non-invertible $R$ (idempotent / set-theoretic solutions) the whole clause is undefined and
> the honest defect is a **parallel pair**, not a group element (§3.1); (ii) under gauge
> $R\mapsto(g\otimes g)R(g\otimes g)^{-1}$ the defect **conjugates**, and the mirror defect
> $(R_{23}R_{12}R_{23})^{-1}R_{12}R_{23}R_{12}$ is a conjugate that in general differs — so
> $\operatorname{YB}_\delta$ is **REFUTED as an element, PROVED as a class**, and only the
> predicate "$=1$" is gauge-invariant (Thm 5). That note's own honesty ledger records Thm 5(2)
> as *argued, not exhibited* (no explicit $R$ with the two variants unequal), and the strength
> of this amendment is capped there. (iii) Its Thm 6 adds, CLASSICAL: three strands is the
> **whole** obstruction — $\operatorname{YB}_\delta(R)=1$ already gives $B_n$-representations
> for all $n$. (iv) The *use* of $\Gamma\langle\operatorname{YB}_\delta(R)\rangle$, which this
> entry correctly recorded as unchecked, is now checked and found **ambiguous between two of
> the four repair modes** ($\Gamma_\Uparrow$ under D0016 §C's typing; $\Gamma_\varnothing$
> under the normal-closure reading of $\langle-\rangle$), with $\Gamma_{\widehat{\phantom X}}$
> **refuted** for it (its Thm 7: enlargement of a group is injective, so no ambient kills the
> defect — there is no $H^1$ beneath it).
>
> **A-3 (filed 2026-08-15, seed173). $\Phi_{\mathrm{tr}}$, the other half of this entry:
> "the transmission claims nothing more" is superseded — four further findings.** Established
> by `notes/TRACE_FACTOR_ADJUDICATED.md` (seed167, `0768`), read in full. Its verdict table:
> (a) the setting in which $\operatorname{Tr}$ of a *cyclically composable* triple exists is
> **CLASSICAL** (bicategorical trace with a shadow — Ponto, Ponto–Shulman — or symmetric
> monoidal plus dualizability), and §D's **unindexed slogan is a type error** while its
> indexed $L_{ij}$ form is well-formed: "a note that cites the slogan without the indices will
> be citing something false"; (b) **REFUTED as written**: $\Phi_{\mathrm{ctr}}$ does not supply
> enough structure for $\Phi_{\mathrm{tr}}$'s cyclicity — braided is not enough, the missing
> datum is a **twist** (ribbon/spherical), which the Drinfeld centre does not carry in general;
> (c) **REFUTED**: the Yang–Baxter defect is **vacuous on $Z(U)$** — $\operatorname{YB}_\delta(R)=1$
> identically on the object §D itself defines; (d) **CLASSICAL**: "labelled difference becomes
> basepoint-free cyclicity" is Connes' $\Lambda$ / the cyclic bar construction verbatim, and
> per D0016 §J6 in the owner's own hand, *translation is not a result*; (e) **OPEN, and that
> note's sharpest defect**: the four factors of $\Phi_\alpha$ are not exhibited on a common
> (co)domain, so the **outer composite is not shown to be defined**. Note (b) and (c) concern
> $\Phi_{\mathrm{ctr}}$ and should be read alongside A-2, whose source note explicitly declines
> to say whether $\Phi_{\mathrm{ctr}}$ belongs in the composite at all.

### 1.11 §J5 — "the anti-degeneracy clause is what the fleet measured empirically"

**Verdict: REFUTED as an identification; retained as an analogy.**
**Reason.** The theorem of §1.2 is about Chu spaces. The measurement it is said to coincide
with (`0742-seed141`: grep recall $14/15$ where a defect is named in the text, $1/7$ and
$1/6$ where it is not) is about a lexical sweep. **A lexical sweep is not a Chu space until
someone says what $X$, $\mathcal T$ and $e$ are, and nobody has.** The convergence is worth
recording as convergence; it is not a shared theorem.
**File.** `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §8.

### 1.12 §B — the seven components of $\delta_\sigma$

**Verdict: OPEN.** What is proved is a theorem about the *observational skeleton* of a defect
and about coarsening the value set (Thm 3), which is the shape a component projection has.
Independence, well-definedness and exhaustiveness of the seven components
($\delta^{\mathrm{sem}},\dots,\delta^{\mathrm{prov}}$) are **not** proved.
**What would settle it.** A statement of what each component *is* as a function of
$(X,\mathcal T,e,\rho)$; at present they are seven names.
**File.** `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §6.

> **A-4 (filed 2026-08-15, seed173). OPEN is answered on four of its five sub-questions; the
> entry's "what would settle it" has been supplied and the answer is that seven does no work.**
> Established by `notes/SEVEN_DEFECT_COMPONENTS.md` (seed164, `0765`), read in full. Its own
> verdict table, quoted: the 7-tuple is **PROVED** to be *a product of heterogeneously typed
> lattices, not a filtration* (so "$\mathfrak H_\sigma\ominus1$" is **not** meaningful
> componentwise — no $\ominus$, no comparable norm across coordinates); well-definedness is
> **PARTIAL — 4 of 7 have a referent** ($\mathrm{sem}$ outright, $\mathrm{proof}$,
> $\mathrm{boundary}$, $\mathrm{prov}$ on named added data), $\mathrm{charge}$ has **none**, and
> $\mathrm{resource}$, $\mathrm{info}$ have none whose only natural completions are functions of
> $\delta^{\mathrm{sem}}$; independence is **PROVED for $(\mathrm{sem},\mathrm{prov})$** (all
> four vanishing patterns realised at $|X|=2$, $|\mathcal T|=1$) and **REFUTED for
> $(\mathrm{sem},\mathrm{info})$** under any full-support measure; exhaustiveness remains
> **OPEN and not settleable as posed**. It further reports §B's own hidden-curvature display as
> **PARTIAL** (true when $\delta^{\mathrm{base}}$ is a *proper* sub-family, false when the
> components are jointly exhaustive) and §B's $\pi\mathfrak H_\sigma=1\wedge\widetilde{\mathfrak
> H}_\sigma\ne1$ clause as **CLASSICAL — the predecessor's Thm 3 restated**. Headline of that
> note: **the number seven is inert** — every claim in §B is a statement about one projection
> and its complement, and two coordinates suffice. This entry's class is therefore no longer
> a single OPEN; the note files it as five verdicts and this ledger does not merge them.

> **A-12 (filed 2026-08-15, seed173). A claim this ledger never enumerated: D0016 §B's
> $\partial\Diamond_\alpha:=\int^{(f,t)\in\mathcal F_\alpha\times\mathcal T_\alpha}e_\alpha(f,t)$
> is ill-typed as a coend — reported first in passing, then confirmed with its ground
> corrected.** Sources, both read in full: `notes/UNTOUCHED_REGIONS_ADJUDICATED.md` §5
> (seed160, `0761`), which observed that a coend needs a **bifunctor** and $e_\alpha$ has a
> single variance; and `notes/BOUNDARY_OPERATOR_TYPING.md` (seed170, `0771`), which
> **confirms** it by an occurrence count — in $\int^cF(c,c)$ the bound variable occurs exactly
> twice, in opposite variances, and here each of $f,t$ occurs once (its Prop 1) — and states
> that the defect is **arity, not enrichment**, so no cocompleteness of $Q_\alpha$ and no
> functoriality of $e_\alpha$ repairs it. That note applies the same test to the rest of the
> signature: $\int^{\sigma\in N(\mathcal F_\alpha)}\delta_\sigma$ (§B) and
> $\mathbb B=\int^{\alpha}\Diamond_\alpha$ (§E) are **also not coends**; §I's
> $\int^i(\mathfrak M_i^\vee\otimes\mathfrak M_i)$ is the one well-typed occurrence — the same
> shape of finding as this ledger's "$-$" observation (§2.1, §2.9): *a notation used for its
> shape in settings that do not supply the operation the shape names*.
> **A saving reading exists and it is the owner's own §E**: if $\vee:\mathcal T_\alpha^{op}
> \to\mathcal F_\alpha$ is an equivalence then $e_\alpha$ is an endoprofunctor and
> $\partial\Diamond_\alpha=\int^{t}e_\alpha(\vee t,t)$ is its **categorical trace** — but the
> index changes, so §B must be *rewritten, not merely reread*, and whether $\vee$ is an
> equivalence is the owner's decision, not a theorem. That note also **corrects the ground of
> both prior statements of the degeneracy** (`UNTOUCHED_REGIONS_ADJUDICATED.md` §5's
> $\coprod e(f,t)\cong\mathcal F\times\mathcal T$ and `ADVANCE_CONJUNCTS_DEFINED.md` §6.3(b)'s
> "only invariant is a cardinality"): both headlines right, arithmetic under them wrong, and
> the correction makes the claim stronger. Consequence it reports and this layer files rather
> than smooths: **A-6's refutation of §H's dichotomy must be restated from categorical to
> conditional**, and it survives the restatement under every candidate repair.

### 1.13 §C, §E — the ordinal ladder, $\mathfrak F$, $\mathfrak F_{\alpha+1}\succeq\mathfrak F_\alpha$, $\mathbb B = \int^\alpha \Diamond_\alpha$, the closure claim

**Verdict: PROGRAMME.** No convergence, no smallness, no proof that $\Gamma$ is well defined
on $\mathcal O_\alpha$, no value for $\kappa$, and no proof that $\mathfrak F$ is a functor.
The transmission's own §J4 says this; the fleet confirms it and adds nothing.
**File.** `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §6, §7A ("still unproved, in full").

> **A-5 (filed 2026-08-15, seed173). PROGRAMME here meant "nobody looked"; somebody has now
> looked, and the ladder is refuted at four independent points before smallness is reached.**
> Established by `notes/ORDINAL_LADDER_SMALLNESS.md` (seed165, `0766`), read in full; fourteen
> entries, its own verdict table quoted: $\Gamma$ is **not a function** on $\mathcal O_\alpha$
> (a choice of mode plus a choice of lift — REFUTED, Thm 1); $\operatorname{Obs}$ (D0017 §G) is
> **not functorial** (REFUTED, Thm 2); $\mathfrak F$ is **not covariant** — $\vee$ is
> contravariant, so the ladder is a zig-zag and $\operatorname{hocolim}_{\beta<\lambda}$ has no
> diagram (REFUTED, Thm 3); $\mathfrak F$ is **not an endofunctor** (REFUTED, Thm 4). On
> smallness: $\kappa=\mathbf{Ord}$ **REFUTED** (Thm 6); $\kappa$ a set ordinal **PARTIAL**, at a
> large-cardinal price unavailable in ZFC (Thm 7); the accessible/presentable reading
> **REFUTED** on four hypotheses at once (Thm 8). On termination: the framework has **no**
> termination clause, only a continuation rule (REFUTED, Prop 9); $\operatorname{Fix}(\mathfrak
> F)=\emptyset$ **by rank** under §E's universe-raising $\ulcorner-\urcorner$ (Thm 5), which
> *proves* $\mathfrak F_{\alpha+1}\not\equiv\mathfrak F_\alpha$ **and simultaneously vacuates
> it**, the two functors compared not sharing a domain; and D0018 §D's saturation clause is
> **REFUTED** as contradicted by §D's own widening non-implication (Thm 10). On $\succeq$:
> **no non-constant meaning** under D0016 §E's step (Thm 11), and a meaning exactly under
> D0018 §D's leaner step plus seed154's Prop. 8(b) (Cor 11.1) — which is §5(ii) of this ledger,
> and see A-9. That note's one-line verdict: *the ladder does not get off the ground, and the
> reason is not smallness.* Entries §2.11 and §3.11 of this ledger inherit Thm 2 and Thm 10
> respectively; see A-8.

### 1.14 §H, §I — the gem invariants; net, garland, closing identifications

**Verdict: PROGRAMME, and unreached.** Illumination, fire, scintillation, brilliance,
trapped-light; इन्द्रजालम् as $\operatorname{holim}$, अनन्तमाला as $\operatorname{hocolim}$;
सीमा $=$ उत्तररूपस्य योनिः. No note in the corpus touches any of these. They are recorded as
definitions and slogans awaiting content, and this ledger asserts nothing about them beyond
the fact that nobody worked on them. **Scope limit, stated as such.**

> **A-6 (filed 2026-08-15, seed173). Both regions have been worked; the phrase
> ~~"No note in the corpus touches any of these"~~ and ~~"PROGRAMME, and unreached"~~ are
> superseded.** Established by `notes/UNTOUCHED_REGIONS_ADJUDICATED.md` (seed160, `0761`), read
> in full: **seventeen** claims across D0016 §H, D0016 §I and D0017 §E, each given exactly one
> verdict — 1 PROVED, 1 REFUTED, 3 CLASSICAL, 4 PARTIAL, 8 PROGRAMME, plus one out-of-scope
> REFUTED (filed here as A-7). The load-bearing items:
> - **§H, six "gem invariants": one is an evaluable definition and is not an invariant**
>   (illumination $=e_X(-,t)$ — PARTIAL: $t$ is free and a Chu isomorphism moves the column;
>   the repair is the **column set** $\operatorname{Col}(e)$, which the corpus has been using
>   under another name for three notes), and **five are names**. $\operatorname{SpecSep}$ occurs
>   exactly once in the repository, in §H itself, and is *not* repaired to
>   $\operatorname{SearchSep}$ — which would be ill-typed anyway (§G's predicate takes a test
>   set; §H hands it a single column).
> - **§H clauses 5–6 read as a dichotomy: REFUTED**, by a four-row truth table (finite
>   exhaustive verification, hence proof). The fourth row — $\Delta\partial_{\mathrm{future}}\ne0$
>   with $\operatorname{Verify}=0$ — has no name in §H, and cannot be excluded because
>   $\operatorname{Verify}$ and $\Delta\partial$ have **disjoint arguments**.
> - **§H clause 4 (brilliance) is a *constrained* PROGRAMME**: it is $\operatorname{UsefulEscape}$
>   under another name, so `ADVANCE_CONJUNCTS_DEFINED.md` Theorem U already refutes any
>   poset-valued completion depending on the step only through resolving power (its Cor 4.1).
> - **§I first claim (ज्ञेयम $\not\subset$ एकदृष्टिः): PROVED** by a two-object counterexample —
>   a single object is not in general dense. This is the only non-inclusion in the three
>   regions and it survives.
> - **§I second claim: PARTIAL** — CLASSICAL-true (co-Yoneda) under the **one-leg** reading of
>   $\mathfrak M_i$, **ill-posed** under §I's own **two-leg** definition, where the integrand is
>   a fourfold tensor with no collapse and no chosen $\otimes$. *The reading that makes it true
>   is the reading the transmission does not use.*
> - **§I fourth claim (अनन्तमाला): PROGRAMME, and *already* PROGRAMME** — it is D0016 §C's
>   ordinal ladder verbatim under a new name, i.e. entry §1.13 of this ledger. Recorded there as
>   a finding, not a footnote.
> - **§I fifth claim: PARTIAL** — "$\partial X\ne0\Rightarrow$ मा निरोधः" has a *norm* as
>   consequent and is not truth-apt; "$\partial X\ne0\Rightarrow\Gamma\langle\partial X\rangle$"
>   is a **term where a proposition is required** — the identical defect this ledger found at
>   §1.10, hence a pattern rather than a slip.
> - **§I sixth claim (सीमा): PROGRAMME**, and either undefined or a constraint on $\mathfrak F$,
>   which §1.13 records as not shown to be a functor.
> - **D0017 §E's pentagon layer** (this ledger's §6 item 3, and §2.9's "not adjudicated"):
>   transport datum **CLASSICAL** (a pseudofunctor / descent datum); the coboundary display
>   **CLASSICAL with an omitted hypothesis** — the pentagon was checked and passes, but the
>   **minus sign requires Ab-enrichment**, and this is the *third* occurrence of that omission
>   (with §2.1's $hf-kg$ and §2.9's $\mathfrak H_{ijk}-1$): **one scope correction, not three**;
>   pentagon $\ne$ Mac Lane coherence, a distinction the display elides; and
>   $\delta\alpha\ne0\Rightarrow\mathfrak X\hookrightarrow\mathfrak X[\delta\alpha]$ is
>   **PARTIAL — true but vacuous under free adjunction (the hypothesis is idle), false under the
>   quotient reading**, with a finite counterexample ($\hom=\mathbb Z$, $\delta\alpha=2$).
> - **§17 of that note**, recorded because it is a negative worth keeping: §I is **not** the
>   density/codensity pair of §3.9 restated — it is that pair *with its argument deleted from
>   one leg and its index category replaced on the other*, plus a restatement of the pair's
>   trivial case.
> - **That note's own restriction of this ledger's closing generalisation** is filed at A-15 (§8.1).
>
> **A-6′ (`REFEREE`) — two notes disagree about §I's second claim, and the clerk does not
> choose.** `notes/ATTACK_SET_CALIBRATED.md` (seed166, `0767`) §3.11 verdicts
> ज्ञेयम $\simeq\int^i(\mathfrak M_i^\vee\otimes\mathfrak M_i)$ **as printed** as
> "$\bot$ — does not denote (four occurrences of $i$; no duality in the stated ambient)", and
> recommends in its own words that "**Ledger entry 1.14 should be updated from *PROGRAMME, and
> unreached* to PARTIAL** with the split above named", declining to edit this file because it
> was another agent's live artifact. `notes/UNTOUCHED_REGIONS_ADJUDICATED.md` §9.2 reaches the
> two-leg reading by a different route and states explicitly that the fourfold integrand **is**
> formally typeable — "two contravariant and two covariant occurrences, diagonalised … so this
> is **not** a variance error" — the failure being instead the absence of a co-Yoneda collapse
> and of a chosen $\otimes$. The two notes agree on the verdict word (PARTIAL / bounded
> analogy) and the practical upshot, and **disagree on whether the printed display type-checks
> at all**. Both are recorded; neither is adopted. A third reading is in
> `notes/TRACE_FACTOR_ADJUDICATED.md` §5, which files the same display as **PROVED
> (classical)** on the ground that §I *is* $\Phi_{\mathrm{tr}}$ applied to the identity
> profunctor — "they are one object, not two". **Referee needed: three notes, one display,
> three verdict words.**
>
> **A-6″ (filed 2026-08-15, seed173) — a factual conflict about the record itself, kept
> because it is this layer's subject matter.** `ATTACK_SET_CALIBRATED.md` §3.10 reports its
> ninth attack, *inscription-check*, as passing "trivially" on the ground that there is "no
> corpus note on the coend" and "nothing inscribed". `UNTOUCHED_REGIONS_ADJUDICATED.md`
> (message `0761`, earlier than `0767`) had by then adjudicated exactly that coend at its §9.
> The reported *absence* is therefore false as of the time it was written; the verdict it
> supports does not depend on it. Recorded, not adjudicated.

---

## §2. D0017 — "Hieroglyphics": homotopy and obstruction

### 2.1 §C — $\delta_\Diamond = hf - kg$; $\delta_\Diamond = 0 \iff hf = kg$

**Verdict: CLASSICAL / definitional-true**, with one hypothesis the transmission omits: the
subtraction requires enrichment in abelian groups, so $\delta_\Diamond$ is a **cochain**, not
a class. Its categorification to a 2-cell $\alpha$ with $[\alpha]\in\pi_2$ is standard
obstruction theory (Steenrod; Postnikov towers).
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §1 (reading of symbols), §2(c).

### 2.2 §F — the geometric chain, read as a chain of $\leftrightarrow$

**Verdict: REFUTED**, three arrows out of four, by explicit counterexample.
- $F_\nabla \nleftrightarrow (\operatorname{Hol}-1)$: flat connection $A = \frac{\theta_0}{2\pi}d\vartheta$
  on $S^1$ has $F_\nabla = 0$, $\operatorname{Hol}=e^{i\theta_0}\ne 1$. The kernel is $\pi_1$;
  the biconditional needs $X$ simply connected (Ambrose–Singer).
- $\check\delta c \nleftrightarrow F_\nabla$: the Möbius bundle on $S^1$ has
  $\check\delta c \ne 0$ (it is $w_1 \ne 0$) and a flat connection. The kernel contains **all
  torsion**; Čech–de Rham is an isomorphism only with **real** coefficients and a **good
  cover**, and §F's bare $\leftrightarrow$ drops both hypotheses.
- $\delta_\Diamond \nleftrightarrow [\alpha]$: passage to a class is a surjection with
  nontrivial kernel, and $\pi_2$ is a $\pi_1$-module — the arrow is correct only for
  **simple** spaces.
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §2, Thm 1(a)(b)(c).

### 2.3 §F — the geometric chain, read as comparison maps

**Verdict: PROVED.** $\delta_\Diamond \twoheadrightarrow [\alpha] \dashrightarrow
\check\delta c \twoheadrightarrow F_\nabla \dashrightarrow (\operatorname{Hol}-1)$, with
kernels respectively 2-cell homotopy, the $\pi_1$-action, torsion, $\pi_1(X)$. Each arrow is
a theorem; none is an isomorphism; **the composite retains almost nothing.**
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Cor 1.1.

### 2.4 §F — the logical half $\Delta_e \leftrightarrow G_T$

**Verdict: CLASSICAL.** Lawvere's fixed-point theorem, 1969: *in a cartesian closed category,
if there is a point-surjective $\varphi : A \to B^A$, then every $f : B \to B$ has a fixed
point.* Cantor, Russell, Gödel I, Turing and Tarski are instances.
**Provenance of the reading, and it is capped.** The statement above is quoted from the nLab
page *Lawvere's fixed point theorem* (HTML, read). **Lawvere 1969 itself was not read** (PDF;
the TAC reprint page returned 503), and no theorem number from Lawvere's own text is quoted.
**Consequence for the transmission.** D0017's logical column contains **no new mathematics**
and must not be written up as if it did.
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §3, Thm 2, Cor 2.1.

### 2.5 §F — the bridge between the halves: theorem or pun?

**Verdict: REFUTED for every bridge natural in restriction — i.e. a pun at the advertised width.**
**Reason.** Čech-type obstructions are *locally trivial by construction* (the class **is** the
failure to glue data that exists locally); the diagonal obstruction is *locally stable* (every
slice $\mathcal E/U$ of a topos with $U \ne 0$ is again cartesian closed and nondegenerate, so
Cantor's statement survives restriction). Any natural transformation of pointed-set-valued
functors commuting with restriction and sending $0 \mapsto 0$ is therefore identically zero on
the image of a locally trivial assignment.
**Scope, stated in the note and preserved here.** This rules out bridges *natural in
restriction*. It does not rule out a bridge of some other kind, and it does not deny that both
sides are instances of "a functor with no section" — it says that at that altitude the
statement transports nothing. That shared adjective is exactly what §J2 warned about.
**Corroboration from the literature, and it cuts the same way.** Abramsky–Barbosa–Kishida–Lal–Mansfield,
*Contextuality, Cohomology and Paradox*, CSL 2015 (arXiv:1502.03097, read as ar5iv HTML) do
build a real Čech-obstruction/paradox bridge — Def. 15, Thm 22 — but the logical side is a
**gluing** paradox (All-vs-Nothing, Kochen–Specker), not a diagonal one, the implication is
one-way, and the obstruction is not a complete invariant (Prop. 20). Where a real bridge was
built, the logical side was first replaced by a locally-trivial phenomenon.
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §4 (Def 3, Lemmas 3.1–3.2, Thm 4,
Rem 4.1), §5.

### 2.6 §F — $\mathfrak O := [\delta_\Diamond \otimes [\alpha] \otimes \cdots \otimes \Delta_e \otimes G_T]_{\mathfrak q}$

**Verdict: REFUTED as well-posed.** Cohomological obstructions live in abelian groups and are
additive and functorial in the coefficients. The Lawvere obstruction is the negation of an
existence statement about a morphism; **there is no group in which $G_T$ is an element**, and
no binary operation for which "$\varphi\oplus\varphi'$ is point-surjective iff both are". The
tensor product presupposes the group and does not supply it.
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Rem 4.2.

### 2.7 §D — the cyclic adjoint string $\partial \dashv \mathsf G \dashv \Phi \dashv \partial$

**Verdict: REFUTED as stated — by a type error, not by a general theorem.**
**Reason.** §B assigns $\partial:\mathfrak X_0\to\Delta_0$, $\mathsf G:\Delta_0\to\mathfrak X_1$,
$\Phi:\mathfrak X_1\to\mathfrak X_2$. Chasing the three adjunctions forces
$\mathfrak X_0 = \Delta_0 = \mathfrak X_1 = \mathfrak X_2$: the string is well-typed only if
all three are endofunctors of one category. **§B and §D are inconsistent as displayed** —
§B's stages are distinct, §D collapses them — and one must be given up. If §D is kept, §G's
$\mathfrak X_{\omega+1}\not\equiv\mathfrak X_\omega$ cannot mean passage to a new ambient
category.
**And the ground §J3 expected is NOT the ground.** §J3 conjectured that length-3 cyclic
adjoint strings are heavily constrained or impossible in general. That expectation is
**withdrawn**: the nLab *adjoint string* page (HTML, read), citing Booth 1972, records that
cyclic chains of any length exist. Booth 1972 was **not** read (paywalled PDF) and is used
only to *withhold* a refutation, never to support one. If Booth's "cyclic chain" is weaker
than $f_1 \dashv f_2 \dashv f_3 \dashv f_1$ with all $f_i$ endofunctors of one category, the
general question reopens — but the type collapse stands regardless.
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §6, Thm 5, Cor 5.1, Thm 7.

### 2.8 §H — $\mathbb B \simeq \Phi\mathbb B$, $\mathbb B \not\equiv \Phi\mathbb B$

**Verdict: PARTIAL. The split:** *conditionally vacuous* half is proved, *unconditional* half
is untouched.
- **Proved:** if the §D string holds and any one of $\partial,\mathsf G,\Phi$ is an
  equivalence, then $\partial\simeq\mathsf G\simeq\Phi$ and $\partial^2\simeq\mathrm{Id}$;
  then $X \simeq \Phi X$ for **every** object, so the headline says nothing distinctive about
  $\mathbb B$, and the disclaimer $\not\equiv$ is a statement about a strict equality the
  framework never defines.
- **Untouched:** whether §D's hypothesis holds at all, hence whether the headline is vacuous
  in the framework's intended reading. The quotation tower
  $\Diamond \ni \ulcorner\Diamond\urcorner \ni \cdots$ is likewise untouched, and the source
  document **truncates mid-formula** at exactly this point (`\not\equ`), which is recorded in
  the transmission and repaired by nobody.
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Thm 6, Cor 6.1.

### 2.9 §E — the holonomy form and the associator tower

**Verdict: CLASSICAL, and correctly stated with implication arrows.** $F_\nabla \ne 0
\Rightarrow \operatorname{Hol}_\nabla(\gamma)\ne 1$ and $\mathfrak H_{ijk}\ne 1 \Rightarrow
\partial\triangle_{ijk} = \mathfrak H_{ijk}-1$ are standard and are written in §E with
$\Rightarrow$. **This is the arrow §F then upgrades** (see §4.1 below). The associator
pentagon $\delta\alpha_{ijkl}$ and $\delta\alpha \ne 0 \Rightarrow \mathfrak X \hookrightarrow
\mathfrak X[\delta\alpha]$ are **not** adjudicated: the adjunction of a formal generator is
not shown to be well defined.
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §2 (which quotes §E's arrows as
the correct classical statements), §0.2.

> **A-7 (filed 2026-08-15, seed173). A claim this ledger never enumerated: D0017 §E's
> $\mathfrak I=\int^{i\in J}\mathfrak M_i\simeq\operatorname{holim}_{\sigma\in N(J)}\mathfrak
> M_\sigma$ is REFUTED.** Established by `notes/UNTOUCHED_REGIONS_ADJUDICATED.md` §15
> (seed160, `0761`). A coend is colimit-shaped and a $\operatorname{holim}$ is limit-shaped.
> **Counterexample, two points:** $J$ discrete on two objects, $\mathfrak M_a=\mathfrak M_b=\ast$
> in spaces; then $\int^i\mathfrak M_i=\ast\sqcup\ast$ while
> $\operatorname{holim}_{N(J)}\mathfrak M=\ast$, and $\ast\sqcup\ast\not\simeq\ast$. That note
> flags the item as outside its own three regions, says in terms that "**it should be entered
> in the ledger as REFUTED**", and declines to edit this file. It is entered here. The
> ill-typing of §E's neighbouring $\operatorname{holim}$ display over simplices is filed at A-6
> (§I third claim, same shape of gap).
>
> **A-8 (filed 2026-08-15, seed173). §2.11 and §3.11 of this ledger acquire theorems.**
> `notes/ORDINAL_LADDER_SMALLNESS.md` (seed165, `0766`) Thm 2 **REFUTES** functoriality of
> D0017 §G's $\operatorname{Obs}$ (the clause $\omega\ne0$ is not preserved by morphisms; with
> a corpus witness), which §2.11 recorded only as "no proof that $\mathsf G$ is well defined";
> and its Thm 10 **REFUTES** D0018 §D's saturation clause as contradicted by §D's own widening
> non-implication, which §3.11 recorded only as "has no truth value yet". In both cases
> PROGRAMME is replaced by a negative, not by content.

### 2.10 §A — the objective functional $\mathfrak L_\infty = \arg\max [\,(I(\Sigma;\mathfrak L)+I(\Gamma;\mathfrak L)+I(\Phi;\mathfrak L))/|\mathfrak L|\,]$

**Verdict: PROGRAMME.** No measure, no channel, no space of $\mathfrak L$, no argument that
the maximum exists. Its own triage says so (§J5, "recorded, not triaged") and no note
disturbs that.
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §7.

### 2.11 §G — the ordinal ladder, $\operatorname{Obs}$, $\mathbb B = \operatorname{hocolim}\mathfrak F^n$

**Verdict: PROGRAMME.** No convergence, no smallness, no proof that $\mathsf G$ is well
defined on $\operatorname{Obs}(\mathfrak X)$, no ambient $(\infty,1)$-category. Thm 5
constrains it (Cor 5.1) but supplies none of these.
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §7.

---

## §3. D0018 — repair modes, density, arithmetic

### 3.1 §B — the four repair modes as a classification

**Verdict: PARTIAL. The split, named:**
- **Holds:** the four modes are genuine operations, and $\Gamma_\varnothing \ne
  \Gamma_\circlearrowleft$ **sharply** — $\Gamma_\circlearrowleft : Z^1 \to H^1$ is canonical,
  natural and choice-free; $\Gamma_\varnothing$ is not a map out of $Z^1$ at all but a choice
  of enlargement, quotient, or added hypothesis, hence not natural. They coincide **iff**
  $H^1(\Gamma,V) = 0$.
- **Fails:** the four are **not independent** (§3.2), and the table's presentation of
  $\Gamma_\Uparrow$ as a peer of the other three understates it: its availability cannot be
  checked by any finite computation in general, because it incurs an unbounded coherence
  tower (Mac Lane in the monoidal case, $A_\infty$/operadic machinery in general).
**File.** `notes/FOUR_REPAIR_MODES.md` §1.1–1.2, Thm 6.

### 3.2 §B — $\Gamma_{\widehat{\phantom X}}$ versus $\Gamma_\varnothing$

**Verdict: REFUTED as independent modes; PROVED as a relation between them.**
Completion exists iff the class dies: $\widehat f = f + R$ is $\Gamma$-invariant **iff**
$[D] = 0$ in $H^1(\Gamma,V)$ (Thm 1). And for $V_0 \hookrightarrow V$, $f$ admits a completion
in $V$ iff $\iota_*[D] = 0$ (Thm 2). So **$\Gamma_{\widehat{\phantom X}}$ *is*
$\Gamma_\varnothing$, performed by enlarging the coefficients rather than by fiat** — and it
is the honest way to perform it, because the enlargement is exhibited and $[D]_{V_0}$ survives.
The Eichler instance is exactly this: a period cocycle nontrivial in $H^1(\Gamma,V_0)$ whose
image in $H^1(\Gamma,V)$ vanishes.
**File.** `notes/FOUR_REPAIR_MODES.md` Thm 1, Thm 2, Cor 2.1.

### 3.3 §B — $D_1 \simeq D_2 \Rightarrow \widehat X_{D_1} \simeq \widehat X_{D_2}$

**Verdict: PROVED, under a hypothesis §B does not state; converse REFUTED.**
**Hypothesis.** "$\simeq$" on the left must mean **cohomologous**, and $\widehat X_D$ the
extension $V \to \widehat X_D \to \mathbb Z$ that $[D]$ classifies. Then it is the $\operatorname{Ext}^1$
classification, and $(v,n)\mapsto(v+nR,n)$ is the explicit isomorphism.
**Converse refuted.** $\operatorname{Ext}^1_{\mathbb Z}(\mathbb Z/p,\mathbb Z/p)\cong\mathbb Z/p$
has $p-1$ nonzero classes, **all** realised by $\mathbb Z/p \to \mathbb Z/p^2 \to \mathbb Z/p$.
So the completion does **not** determine the defect up to cohomology. §B states only the
implication, and is right to.
**File.** `notes/FOUR_REPAIR_MODES.md` Thm 4, Thm 4′.

### 3.4 §B — "$X$ known $+$ $D$ known $\Rightarrow \widehat X$ reconstructible"

**Verdict: REFUTED as stated.** The set of completions of $f$ is empty or a **torsor under
$V^\Gamma$**, the module of $\Gamma$-invariants: if $\widehat f = f+R$ and $\widehat f' = f+R'$
are both invariant then $R - R' \in V^\Gamma$. The slogan is true **iff** $V^\Gamma = 0$, and
otherwise only after a chosen lift is added to the data.
**Concretely.** For a mock modular form of weight $k$, $V^\Gamma \supseteq M_k(\Gamma)$: the
completion is determined only modulo genuine holomorphic modular forms. The standard theory
does not reconstruct $\widehat h$ either — it *stipulates* the non-holomorphic part to be the
Eichler integral of the shadow. **That stipulation is the missing datum, and it is why "the"
completion is a definition, not a theorem.**
**File.** `notes/FOUR_REPAIR_MODES.md` Thm 3.

### 3.5 §B — "self-classifying obstruction $:\iff D \simeq \operatorname{Code}(\widehat X/X)$"

**Verdict: REFUTED as a definition carving out a subclass.** With
$\operatorname{Code}(\widehat X/X) := \partial(\widehat f - f)$, the condition holds for
**every** completable $f$ and is vacuous otherwise. It is therefore *equivalent to* $[D]=0$,
i.e. to the availability of $\Gamma_{\widehat{\phantom X}}$, not an extra hypothesis.
Well-definedness is exact: $\partial$ descends to an isomorphism $V/V^\Gamma \xrightarrow{\sim} B^1$.
**Where a nontrivial condition could live.** Requiring $[D]$ recoverable from $\widehat X$
**without** reference to $f$ — which Thm 4′ shows is impossible in general. That replacement
is logged as an open `PROVE` item.
**File.** `notes/FOUR_REPAIR_MODES.md` Thm 5, §5 item 1.

### 3.6 §B — "$D = $ the shadow of the completion" (पूर्णतायाः छाया)

**Verdict: REFUTED as an identification; accurate as a metaphor.**
**Reason.** From $F = h + g^*$ with $F|_k\gamma = F$: $D_\gamma = h|_k\gamma - h = -(\partial g^*)_\gamma$,
so $D = -\partial g^*$. The shadow $g$ is a **modular form of weight $2-k$**; $D$ is a
**1-cocycle of weight $k$**, obtained from $g$ by first forming the non-holomorphic Eichler
integral and then taking a coboundary. Neither step is the identity. **$D$ is the image of the
shadow, not the shadow.** A note using the phrase must say "the cocycle attached to the
shadow" or accept the error.
**Provenance cap.** Definition of *shadow* quoted from Wikipedia, *Mock modular form* (read);
$\xi_k$ and the generator assignment from ar5iv HTML of Bringmann–Diamantis–Raum
(arXiv:1107.0573, read). Eichler–Shimura **injectivity** was **not** verified in any source
read, and is not asserted. No PDF was decoded.
**File.** `notes/FOUR_REPAIR_MODES.md` §3.

### 3.7 §B — $X \to \widehat X \to D[1]$

**Verdict: PROVED**, as the extension of $\Gamma$-modules classified by $[D]$ — this is what
the triangle *is*. Instance found in the corpus: $\mathbb Z/b \to \mathbb Z/b^{n+1} \to
\mathbb Z/b^n$, i.e. positional notation at length $n+1$ is the completion of positional
notation at length $n$, with $D$ the carry cocycle; Thm 4 then explains in one line why every
digit set computes the same arithmetic.
**File.** `notes/FOUR_REPAIR_MODES.md` Thm 4, §4.1.

### 3.8 §B — does the classification do work on real defects?

**Verdict: PARTIAL, and the failing half is the reportable finding.**
- **Works:** three corpus defects, three distinct verdicts. The carry cocycle
  (`notes/ATLAS_OF_N.md` §2.11) → $\Gamma_\circlearrowleft$, with $\Gamma_\varnothing$
  refuted by an existing theorem and $\Gamma_{\widehat{\phantom X}}$ already silently taken.
  The action residual (`notes/ACTION_RESIDUAL_FORMATION.md` §2) → $\Gamma_{\widehat{\phantom X}}$,
  also already used and unnamed. In two of three the classification named a move the corpus
  had made without naming it, which is §J1's own claim, confirmed for two of the four modes.
- **Fails:** the shifted-prime barrier (`notes/SEED64_BOUNDARY_FACTORIZATION_AT_U2.md` §4) →
  **none of the four applies**. There is no group, no coefficient module, no cocycle; the
  defect is a magnitude. Only $\Gamma_\varnothing$ formally fits, in its worst form (assume
  Elliott–Halberstam), which is the wrong answer dressed as an answer.
- **The generalisation, at the generality it can be defended:** the four modes classify
  **structural** defects — those that are cocycles for some action — and are **silent on
  quantitative** defects, which are most of the analytic corpus. §B does not claim otherwise;
  it also does not scope itself, and the scope is needed. Sample size: three.
- **$\Gamma_\Uparrow$ was the answer nowhere** in the sample. That is a gap in a sample of
  three, not evidence the mode is idle, and is logged as such.
**File.** `notes/FOUR_REPAIR_MODES.md` §4.
**Successor, landed during this compilation and read in full.**
`notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` upgrades the structural/quantitative split
from an observation to a criterion and *explains* the failure above rather than recording it:
a **structural** defect is one whose repair is certified by a single witness verified by an
equality, a **quantitative** one requires a **matched pair** (a bound plus an attaining
construction) verified by a comparison. All four modes presuppose an attainable distinguished
zero (Thm A), hence **none acts on a quantitative defect except $\Gamma_\varnothing$ by fiat**
(Cor A.1) — which is exactly the Elliott–Halberstam case above. A unary operation cannot
discharge a bilateral certificate (Thm B), and **there is no fifth mode** under the definition
that note supplies (Thm C), the analytic candidates being the existing four applied to the
observable field. Two cautions it states about itself and this ledger repeats rather than
smooths over: the "group-valued vs order-valued" framing is **refuted** ($\mathbb Z$ is both);
and the no-go theorems are relative to a definition of *repair mode* that D0018 §B does not
supply, so a fifth mode under a different definition is not excluded.

### 3.9 §C — generability $\not\equiv$ reconstructibility

**Verdict: PROVED and CLASSICAL.**
**Identification.** $\delta_\triangleleft(X) = \operatorname{cofib}(\varepsilon_X)$ where
$\varepsilon$ is the counit of the **density comonad** $\operatorname{Lan}_G G$, and
$\delta_\triangleright(X) = \operatorname{fib}(\eta_X)$ where $\eta$ is the unit of the
**codensity monad** $\operatorname{Ran}_G G$ — the pointwise Kan-extension formulas, evaluated
at $X$. Hypothesis: $J$ small, the relevant Kan extension pointwise; without pointwiseness
the comma-category formulas fail and §C has no evident meaning.
**Separation.** All four combinations of $(\delta_\triangleleft \equiv 0?,
\delta_\triangleright \equiv 0?)$ are realised by full subcategories of the three-chain
$\{0<1<2\}$ — a twelve-case finite exhaustive verification, hence proof and not measurement.
Second witness pair in $\mathbf{Ab}$: $\mathbb Z$ generates and does not cogenerate;
$\mathbb Q/\mathbb Z$ cogenerates and does not generate.
**The forcing hypothesis, and it is sharp.** Self-duality of the **pair** $(\mathcal C, G)$,
not of $\mathcal C$: the three-chain *is* self-dual and the separation survives, because the
family $\{0,1\}$ is not.
**A genuine fork the transmission does not resolve.** In the stable reading, $=0$ means
density/codensity; in the abelian reading it means generation/cogeneration. **These are not
equivalent** and no note claims they are.
**Prior art.** Isbell 1960 (as "left adequate"), Ulmer, Kock and Appelgate–Tierney,
Kennison–Gildenhuys 1971 — all **second-hand** from Leinster, *Codensity and the ultrafilter
monad*, TAC 2013 (arXiv:1209.3606), abstract and historical section read as HTML; nLab
*codensity monad* and *dense functor* read directly. **No PDF opened.** The claim is true and
is **not new mathematics**; what is new to this corpus is that it has been stated with
witnesses.
**Corpus link: none.** "codensity" occurs only in D0018; two tangential Kan-extension mentions
were checked and dismissed. Per §J8 nothing was relabelled.
**File.** `notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md` §1–§4, §6.

### 3.10 §D — the widening-observable non-implication

**Verdict: PROVED, direction correct — with a variance correction to the surrounding prose.**
$\operatorname{Obs}_{\mathcal O_\alpha}(X)=0 \not\Rightarrow \operatorname{Obs}_{\mathcal O_{\alpha+1}}(X)=0$:
more tests can only fail more. **The transmission gets the direction right.** But "widening"
in D0018 names two operations of opposite variance: widening the **coefficient** module can
only *kill* obstructions ($\iota_*$ is a homomorphism, so $0 \mapsto 0$), while widening the
**observable** field can only *reveal* them. Covariant and contravariant respectively; they
must never be conflated. The reason §D is right is that observables are tests, not
coefficients.
**File.** `notes/FOUR_REPAIR_MODES.md` Cor 2.2. Same phenomenon as §1.2 above, in the other
direction.

> **A-9 (filed 2026-08-15, seed173). The cited ground is refined, and the refinement is a
> false-ground finding, not a false-claim finding.** Established by `0760-seed159`
> (structural-in-disguise audit), read in full, and inherited in that form by
> `notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` §1.3. Seed159 re-derived
> `FOUR_REPAIR_MODES.md` Cor 2.2 from scratch and reports: **both halves hold**, but the
> **displayed formula of Cor 2.2 is a non-implication and is not what its consumers use** —
> what they use is the *prose* monotonicity of $\operatorname{Obs}$ in the test family, whose
> ground is `CHANGING_TESTS_VERSUS_SHRINKING.md` Lemma 6.2 + Thm E, or the one-line inclusion
> $\operatorname{Obs}_S\subseteq\operatorname{Obs}_{S'}$ for $S\subseteq S'$. It adds a scope
> note this ledger's variance paragraph should carry: "widening coefficients can only kill" is
> a statement about a **fixed cocycle**, and is **false** read as a claim about $H^1$ as an
> object — enlarging $V$ can create obstructions for other objects. `QUANTITATIVE_VERSUS_
> STRUCTURAL_DEFECTS.md` Thm C, which §3.8 of this ledger cites, depended on this and is
> reported by seed159 as now **fully grounded**.

### 3.11 §D — the defect ladder $\delta^{(n+1)} = \operatorname{Path}(\Gamma\delta^{(n)}_{\mathrm L},\Gamma\delta^{(n)}_{\mathrm R})$, $\mathfrak R_\omega$, saturation

**Verdict: PROGRAMME.** $\Gamma$ is not given as a functor and $\operatorname{Path}$ is not
typed, so $\partial\mathfrak R_\omega = 0 \Rightarrow$ saturation has no truth value yet.
**File.** `notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md` §5.

### 3.12 §D — $\chi_\alpha := \Delta\operatorname{Reach}(\mathcal O_\alpha)/\Delta\operatorname{Kill}(\Gamma_\alpha)$ and its trichotomy at $\chi = 1$

**Verdict: HAZARD — deliberately not adjudicated, and correctly so.** Neither numerator nor
denominator is defined; no measure is given; the trichotomy is asserted; and "स्वर्णसीमा"
invites reading a golden constant into it. Every note that touched D0018 explicitly declined
to measure, define, or use it. **This is an owner decision, restated in §5 below.**
**Files.** `notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md` §5 ("not measured, not defined,
not used"); `notes/FOUR_REPAIR_MODES.md` §6 ("untouched, as its triage demands").

> **A-10 (filed 2026-08-15, seed173). The hazard has held: five later notes state in their own
> honesty ledgers that $\chi_\alpha$ was not defined, measured, estimated or used.**
> Verified by reading: `notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` (scope limit (v) and
> §10), `notes/UNTOUCHED_REGIONS_ADJUDICATED.md` §18.6, `notes/BOUNDARY_OPERATOR_TYPING.md`
> §7.7, `notes/MYSTERY_AND_DESCRIPTION_LENGTH.md` §7.6, `notes/TRANSLATION_GERBE_ADJUDICATED.md`
> §0/§6. The owner decision at §5(i) is undisturbed.
>
> **A-11 (filed 2026-08-15, seed173, `REFEREE` for the owner, not for the fleet).
> $\rho(D\mathcal K)$ and $\chi_\alpha$ are reported *not* to be the same quantity — against
> the identification asserted in a later transmission's own triage.** Established by
> `notes/MYSTERY_AND_DESCRIPTION_LENGTH.md` §5 (seed168, `0769`), read in full and quoted:
> $\chi_\alpha$ is "a **ratio of two scalar increments**"; $\rho(D\mathcal K)$ is "the
> **modulus of the largest eigenvalue of the linearisation of an operator at a point**" —
> different types, "and in any case two quantities neither of which has a definition cannot be
> proved equal, so the identification asserted in D0019 §J5 is itself unfounded; what they
> genuinely share is the *template* — a trichotomy at $1$ with a 'golden boundary' reading —
> which is a shared hazard, not a shared definition." That note is explicit that this is a
> **false-ground finding, not a false-claim finding**: D0019 §J5's *disposition* (do not
> measure; either $\mathcal K$ gets a domain, a norm and a linearisation, or the quantity is
> withdrawn) is endorsed unchanged; only its stated ground — "$\chi_\alpha$ returning under a
> new name" — is wrong, and the sufficient ground is the one J5 itself gives two sentences
> later. **Filed as a reported finding only.** Neither quantity is touched here as
> mathematics, neither is defined, measured or used, and this clerk pass adjudicates neither.

### 3.13 §E — the Tate construction: $X^{t\mathcal G} = 0 \iff N_X$ an equivalence

**Verdict: CLASSICAL, and correctly stated.** $X^{t\mathcal G} := \operatorname{cofib}(N_X)$,
and in a stable setting the cofibre of a map vanishes iff the map is an equivalence. The
transmission's own §J4 says "standard and correctly stated; no novelty claimed", which is
right. **Settled here, not in a prior note** — no note in the corpus re-derives it; the
one-line stable-category argument above is this ledger's, and no more is claimed than that
one line.

### 3.14 §F — $D_e(x) := \neg\, e(x)(x)$, $D_e \notin \operatorname{im}(e)$; $Q + \operatorname{eval} + \neg \Rightarrow$ obstruction to absolute self-completeness

**Verdict: CLASSICAL** — the same Lawvere fixed-point theorem as §2.4, with the same
provenance cap (nLab HTML read; Lawvere 1969 not read). No new mathematics.
**File.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §3.

### 3.15 §F — $X' \simeq X \wedge Q(X') \ne Q(X)$; $\mathfrak F_\blacklozenge := \operatorname{diag}\circ Q\circ\Phi\circ\Gamma\circ\mathfrak D$; the closer

**Verdict: PROGRAMME.** $Q$ is not typed and $\mathfrak D$ is not given, so
$\delta_{\alpha+1} = \operatorname{diag}Q\Phi\Gamma(\delta_\alpha)$ has no content yet. The
closer — *zero-obstruction itself becomes a new object of testing* — is the correct
**converse-facing** slogan to §1.4's theorem (that $\delta^\emptyset_\sigma = \emptyset$ for
every holonomy datum whatsoever), and to that extent the transmission's own §J3 reads the
convergence correctly; but the slogan is a discipline, not a theorem.
**File.** `notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md` §5;
`notes/SHRINKING_TESTS_LOWER_CURVATURE.md` Cor 2.3 for the theorem it faces.

### 3.16 §G — $Z(t,\theta) = P(t+i\theta)P(t-i\theta) = \sum_{w,r}\Lambda(w-r)\Lambda(w+r)e^{-2tw}e^{2ir\theta}$

**Verdict: CLASSICAL / elementary rearrangement, verified — with an index caveat.**
**Verification.** Done independently here *before* `notes/PRIME_PAIR_KERNEL_VERIFIED.md`
existed, and it agrees with that note's §1–§3: the identity is correct **given its index
set**, and the two coefficient extractions are a change of variables rather than an insight.
The derivation below is mine; the note is the corpus's file for the claim. With
$P(z) = \sum_{n\ge1}\Lambda(n)e^{-nz}$,
$$P(t+i\theta)P(t-i\theta) = \sum_{m,n\ge1}\Lambda(m)\Lambda(n)e^{-(m+n)t}e^{-i(m-n)\theta};$$
put $w = (m+n)/2$, $r = (n-m)/2$, so $m = w-r$, $n = w+r$, and the exponentials become
$e^{-2tw}e^{2ir\theta}$. Exact, absolutely convergent for $t>0$.
**Caveat the transmission does not state.** $(w,r)$ ranges over pairs of **half-integers** of
equal parity with $w \pm r \ge 1$, not over integers; "$\text{Goldbach} = [w^N]\mathcal K$"
therefore means the coefficient at $2w = N$. With that reading, summing $\mathcal K(w,r)$ over
$r$ at $2w=N$ gives $\sum_{m+n=N}\Lambda(m)\Lambda(n)$ (Goldbach), and $r=1$ gives
$\sum_w \Lambda(w-1)\Lambda(w+1)$ (twin primes). Both correct. §J6 is right that these are
elementary rearrangements to be **verified**, not cited as insight; this is that verification.

### 3.17 §G — $-\zeta'/\zeta(s) = \mathcal M[P](s)$

**Verdict: REFUTED as stated. A factor $\Gamma(s)$ is missing.**
**Derivation (this ledger's).** For $\Re s > 1$,
$$\mathcal M[P](s) = \int_0^\infty P(z)z^{s-1}\,dz
= \sum_{n\ge1}\Lambda(n)\int_0^\infty e^{-nz}z^{s-1}\,dz
= \Gamma(s)\sum_{n\ge1}\Lambda(n)n^{-s} = \Gamma(s)\Bigl(-\frac{\zeta'}{\zeta}(s)\Bigr),$$
by $\int_0^\infty e^{-nz}z^{s-1}dz = \Gamma(s)n^{-s}$ and absolute convergence. So the
correct identity is $\mathcal M[P](s) = \Gamma(s)\cdot(-\zeta'/\zeta)(s)$; the Dirichlet
series $-\zeta'/\zeta(s) = \sum\Lambda(n)n^{-s}$ is classical (Riemann; Euler product,
logarithmic derivative) and is what the transmission presumably intends, but it is **not**
the Mellin transform of $P$.
**Ground, stated separately per standing check (d).** The mandate flagged this as "likely";
the flag was not trusted, and the identity above was derived here in three lines from the
Gamma integral, at a time when no note in the corpus established it. It is exact symbolic
reasoning, hence proof under `CLAUDE.md`.
`notes/PRIME_PAIR_KERNEL_VERIFIED.md` §4 has since recorded the same correction as its **C1**,
with the same proof, and states there that the correction is not cosmetic. **Two independent
derivations, one identity** — and, as `SHRINKING` §7A puts it about a comparable coincidence,
that agreement measures the difficulty of the integral, not the reliability of either agent.
**File.** `notes/PRIME_PAIR_KERNEL_VERIFIED.md` §4 (correction C1).

### 3.18 §G — $\xi(s) = \xi(1-s)$

**Verdict: CLASSICAL.** Riemann's functional equation for the completed zeta function, 1859.
No note adjudicates it and none needs to.

### 3.19 §G — $D_g(Z) := \widehat Z(g\cdot(t,\theta)) - J_g(t,\theta)\widehat Z(t,\theta)$, and "first classify $D_g$, only then complete"

**Verdict: PROGRAMME.** No group $g$ ranges over is specified, no automorphy factor $J_g$ is
given, no $\widehat Z$ is constructed. The instruction *first classify, then complete* is §B's
classification applied to itself and is good discipline; discipline is not a theorem. Note
that §3.2 above sharpens the instruction: classification is not optional, because
$\Gamma_{\widehat{\phantom X}}$ is **available only on coboundaries**.

### 3.20 §G — $\mathcal K(w,r) \overset{?}{=} \operatorname{Tr}\mathscr K_{w,r}$; "of what representation is $\mathscr Z$ the character?"

**Verdict: OPEN, and sharpened — over $\mathbb Z$ it is *an analogy with no current
mathematical content*, with a reason and not merely an absence; over $\mathbb F_q[T]$ it is a
named programme with real work behind it** (Bogomolny–Keating; Keating–Roditty-Gershon), the
difference being that in the function-field setting the weight $\log p$ becomes
$\deg(P)\log q$ and $\deg$ **is** a cohomological grading — precisely the step unavailable
over $\mathbb Z$. The well-posed neighbouring questions over $\mathbb Z$ are Hardy–Littlewood
and Bogomolny–Keating, and the note declines to manufacture a forced positive answer, which
is the right call. The Ramanujan analogy $\tau(p) = p^{11/2}(\alpha_p+\beta_p)$,
$|\alpha_p|=|\beta_p|=1$ is **CLASSICAL** (Deligne) and is an analogy, not evidence.
**What would settle it**: a specific representation plus a proof that its character reproduces
$\mathcal K$. Nothing less counts.
**File.** `notes/PRIME_PAIR_KERNEL_VERIFIED.md` §5 (§5.1 over $\mathbb Z$, §5.2 over
$\mathbb F_q[T]$). Sources there are HTML/abstract only; no PDF decoded.

### 3.21 §A — $\mathfrak L_\infty = \operatorname{colim}_\alpha \mathfrak L_\alpha$, the MDL functional, $\operatorname{gain}(\sigma)>0 \Rightarrow \sigma\in\mathfrak L_{\alpha+1}$

**Verdict: PROGRAMME.** No code length is specified, no space of $\mathfrak L$ is given, no
argument that the argmin exists. Its own §J7 says so.
**File.** `notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md` §5.

---

## §4. Corrections the fleet made **to** the transmissions

A short list the owner can act on directly. **Every item was verified by reading the note that
established it**, and the two items that no note establishes are marked as such rather than
being passed along on the mandate's authority.

**4.1 — D0017 §F silently upgrades $\Rightarrow$ to $\leftrightarrow$.** §E writes
$F_\nabla \ne 0 \Rightarrow \operatorname{Hol}_\nabla(\gamma)\ne 1$ and $\mathfrak H_{ijk}\ne 1
\Rightarrow \partial\triangle_{ijk} = \mathfrak H_{ijk}-1$ — correct, one-directional,
classical. §F's boxed chain then writes the same relations with $\leftrightarrow$. **The
upgrade is the error**, and three of the four arrows are refuted as biconditionals.
*Verified in* `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §0.2 and §2, Thm 1.

**4.2 — D0018 §C's $J_X$ must be two comma categories, not one.** The canonical map *out of* a
colimit is indexed by maps **into** $X$ (the left slice $G/X$); the canonical map *into* a
limit is indexed by maps **out of** $X$ (the right slice $X/G$). One index category cannot
serve both. This is exactly what the two-leg datum $\mathfrak M_i = (\operatorname{Map}(-,i),
\operatorname{Map}(i,-),\dots)$ is for: one family supplies both slices, one leg each. A
reading in which $\mathfrak M_i$ is "simply a representable" must choose a variance and loses
one of the two constructions.
*Verified in* `notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md` §1.1.

**4.3 — D0018 §B's four modes are not independent.** $\Gamma_{\widehat{\phantom X}}$ **is**
$\Gamma_\varnothing$ with enlarged coefficients: completion in $V \supseteq V_0$ exists iff
$\iota_*[D] = 0$ in $H^1(\Gamma,V)$. The table presents four peers; there are three
operations and one honest way of buying the second.
*Verified in* `notes/FOUR_REPAIR_MODES.md` Thm 1, Thm 2 (and the note's own summary table
agrees with its body here — checked, per standing check (c)).

**4.4 — D0018 §B's "$X$ known $+ D$ known $\Rightarrow \widehat X$ reconstructible" is false.**
Completions form a torsor under $V^\Gamma$; true iff $V^\Gamma = 0$ or a lift is chosen. For
mock modular forms $V^\Gamma \supseteq M_k(\Gamma)$.
*Verified in* `notes/FOUR_REPAIR_MODES.md` Thm 3.

**4.5 — D0018 §G is missing a $\Gamma(s)$ in the Mellin identity.** $\mathcal M[P](s) =
\Gamma(s)(-\zeta'/\zeta)(s)$, not $-\zeta'/\zeta(s)$. Derived in §3.17 above when no note
established it; `notes/PRIME_PAIR_KERNEL_VERIFIED.md` §4 has since recorded the identical
correction as **C1**, independently and with the same proof, and states that it is not
cosmetic.

**4.6 — D0018 §B's "$D$ = the shadow" is a metaphor, not an identification.** $D = -\partial g^*$:
the shadow is a weight-$(2-k)$ form, $D$ is a weight-$k$ 1-cocycle.
*Verified in* `notes/FOUR_REPAIR_MODES.md` §3.

**4.7 — D0018 §B's "self-classifying obstruction" is not a definition of anything new.** It is
equivalent to completability.
*Verified in* `notes/FOUR_REPAIR_MODES.md` Thm 5.

**4.8 — D0017 §B and §D are inconsistent as displayed.** The cyclic adjoint string forces all
stages to be one category; the generating sequence makes them distinct. One must be given up.
*Verified in* `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Thm 5, Cor 5.1.

**4.9 — D0017 §J3's own expectation is withdrawn.** Length-3 cyclic adjoint strings are **not**
forbidden in general; the string dies of a type error internal to D0017, not of a general
theorem. (Ground capped: nLab HTML reporting Booth 1972, which was not read, and used only to
*withhold* a refutation.)
*Verified in* `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Thm 7.

**4.10 — D0016 §G's slogan must not be cited across §F's "or not".** Under replacement no
function of $\delta$ is monotone. The framework needs a comparison datum it does not carry;
the unique coarsest candidate is the resolving-power preorder, proposed in the note **as a
proposal** and marked as the note's, not the owner's.
*Verified in* `notes/CHANGING_TESTS_VERSUS_SHRINKING.md` §7–§8.

**4.11 — D0016 §J5's identification of the theorem with the night's grep measurement is too
strong.** Analogy, not shared theorem; a lexical sweep is not a Chu space until $X$,
$\mathcal T$, $e$ are named.
*Verified in* `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §8.

**4.12 — D0016 §D's $\Phi_{\mathrm{refl}}$ needs $T_\alpha \subseteq T_{\alpha+1}$ for the
strict inclusion.** **No note establishes this**; see §1.9 above, where it is derived from
Gödel's second incompleteness theorem, and treat that derivation as its only ground.

**4.13 — Two corrections *internal to the fleet's own work*, recorded because the owner will
otherwise read the notes and inherit them.** (i) `SHRINKING` Rem 2.2 misclassifies
$(\operatorname{Sep},\sim)$ as a Birkhoff polarity; $\operatorname{Sep}$ is monotone, so it is
not one. No theorem depends on the misstatement; the correct home is a monotone Galois
connection. (ii) Message `0749-seed148`'s **subject line** states the strictness criterion as
"some discarded test is the SOLE witness", which is only the case $|S\setminus S'| = 1$; the
message's own body has it right. *Both verified in* `notes/CHANGING_TESTS_VERSUS_SHRINKING.md`
§0.4–§0.5.

---

## §5. The two things the owner must decide

These are not the fleet's to settle. Neither is a mathematical question the fleet declined
out of laziness; each is a question about what the framework is *for*.

**(i) $\chi_\alpha$ — define it exactly, or withdraw it.** D0018 §J5 flags it in the owner's
own hand as running head-on into `CLAUDE.md`, and every agent honoured that: it was not
measured, not defined, not used. The instruction stands as the transmission wrote it —
*either $\Delta\operatorname{Reach}$ and $\Delta\operatorname{Kill}$ are given exact
definitions and the trichotomy at $\chi = 1$ is **derived**, or the quantity is withdrawn.*
The fleet has no way to choose between those two, because both are consistent with everything
proved. **What it must not become** is a measured number: this repository has published a
fitted constant before ($0.362$–$0.421$ where the truth was exactly $\tfrac14$), and the
recorded lesson is not merely that the number was wrong but that a constant measured at one
scale hides its scaling. A $\chi$ without its $\alpha$-dependence would be worse than no
$\chi$, because it would look like knowledge.

**(ii) Does $\Phi$ produce only comparable steps?** This decides whether the no-go theorem is
fatal or vacuous, and **the fleet cannot decide it because the transmissions themselves
disagree.**
- The theorem (`notes/CHANGING_TESTS_VERSUS_SHRINKING.md` Thm F): under *unrestricted*
  replacement of the test set, any function of $\delta$ that is monotone uniformly is
  **constant**. Nothing survives — not $\delta$, not $\|\mathcal O\|$, not any norm, ordinal
  or cardinality one might propose.
- **D0016 §F says steps need not be comparable**: "$\mathcal T_\alpha \subseteq
  \mathcal T_{\alpha+1}$ **or not** — मापनक्षेत्रम् अपि परिवर्तते, the measurement domain
  itself changes." Under this reading Thm F **is fatal**: the framework's progress predicate
  has no invariant to be monotone in, and §G's slogan cannot be cited at all across a step.
- **D0018 §D says the opposite**: "$\mathcal O_\alpha \subseteq \mathcal O_{\alpha+1}$;
  $\Phi$ does not change the object, it widens the field of visible distinction." Under
  *that* reading every step is comparable, Thm F **is vacuous for the framework**, and the
  governing statement is instead §3.10's non-implication (widening reveals, never conceals) —
  which is proved and which the transmission gets right.
- **A running pass has since settled it, conditionally, and sharpened the decision.**
  `notes/ADVANCE_UNDER_REPLACEMENT.md` §6–§7 (seed154, landed during this compilation, read
  in full) proves: **Theorem 6** — under D0018 §D's reading, $\mathcal O_\alpha \subseteq
  \mathcal O_{\alpha+1}$ gives $\sim_{\mathcal O_{\alpha+1}} \subseteq \sim_{\mathcal O_\alpha}$,
  so every step of $\Phi$ is $\operatorname{Refine}$ and **no step is Incomparable**; and
  **Corollary 6.1** — D0016 §G's shrink clause and D0018 §D's widening clause are *one
  statement seen from its two sides*. But three conditionals intervene, and the framework
  satisfies at most one:
  1. **The step is not $\Phi$.** D0016 §E's $\mathfrak F$ contains $\vee$ and
     $\ulcorner-\urcorner$; D0018 §D's is $\Phi\circ\Gamma\circ\partial$. **Proposition 7:**
     after a $\vee$ the successor's tests are built from the predecessor's *objects*, so the
     two stages share no test universe, $\sqsubseteq$ is undefined between them, and the step
     is **neither comparable nor incomparable — the comparison has no truth value at all.**
  2. **$\Phi$ is not described as enlargement in D0016.** $\Phi_{\mathrm{cut}}$ is a *recut*,
     and its adjoined list contains $(-)^\vee$ and $\operatorname{Quot}$ — a duality and a
     quotient, neither of which refines resolution.
  3. **$\Gamma$ moves the carrier**, so even D0018's leaner $\mathfrak F$ changes $X$.
     **Proposition 8** gives the exact repair: comparability survives a carrier change iff
     every observable of $\mathcal O_\alpha$ is the restriction along $\iota : X_\alpha \to
     X_{\alpha+1}$ of one in $\mathcal O_{\alpha+1}$ — *a hypothesis neither transmission
     supplies*, and the smallest thing the framework would have to add.
  - **Verdict of that note, which this ledger adopts:** the no-go is **conditionally
    vacuous, and the condition is a discrepancy between two owner transmissions.** Under
    D0018 §D's dynamics plus Prop. 8's hypothesis it says nothing; under D0016 §E's it
    **bites harder than originally stated**, because a framework whose successive instruments
    cannot even be *compared* has no progress criterion of any shape, $\delta$-based or not.
  - That note also records a **notation collision the owner alone can resolve**:
    $\mathcal O_\alpha$ is an *obstruction* (an output) in D0016 §B and an *observable
    collection* (an input) in D0018 §D. They are not the same type, and identifying them is
    the owner's to make or refuse.
- **The decision required, in its sharpest form:** *is $\Phi_{\mathrm{cut}}$ an enlargement of
  the observable field or a recut of it, and does the step functor contain $\vee$?* If
  enlargement without $\vee$: withdraw §F's "or not", add Prop. 8's hypothesis, and the
  framework gains a monotone theory for free. If recut with $\vee$: the framework must adopt
  a comparison datum, and the resolving-power preorder is the unique coarsest one that works
  — offered by the fleet explicitly as a proposal, not as an amendment. **No agent has chosen
  between them, and none should.**

---

## §6. Scope: what this ledger could not reach

Stated flatly, because a ledger that hides its holes is worse than no ledger.

1. **Messages `0755`–`0757` did not exist when this ledger was begun** — `0754` was then the
   highest in the tree — and were written by three other passes while it was being compiled.
   All three, and their notes, have been read in full and incorporated (§1.6, §3.8, §3.16,
   §3.17, §3.20, §5(ii)). The record of their late arrival is kept rather than tidied away,
   because it is the reason several entries carry two independent derivations of one fact.
2. **D0016 §H (gem invariants) and §I (net, garland, closing identifications)** — no note
   touches them; no verdict beyond PROGRAMME is offered, and PROGRAMME here means "nobody
   looked", not "looked and found nothing".

   > **A-13 (filed 2026-08-15, seed173). This item's sentence ~~"no note touches them"~~ was
   > **literally false when written**, and is now doubly superseded.** Reported by
   > `notes/UNTOUCHED_REGIONS_ADJUDICATED.md` in its opening, "made by reading and not by
   > trusting": `notes/ADVANCE_UNDER_REPLACEMENT.md` §3.4 (line 245) and
   > `notes/ADVANCE_CONJUNCTS_DEFINED.md` §6.1 (line 344) both quote §H clauses 5 and 6 as
   > evidence of the owner's intent for $\operatorname{UsefulEscape}$. That note is equally
   > explicit that the *verdict* "unreached" survived — neither predecessor adjudicates any of
   > the six invariants — so what fails is the sentence, not the classification. Both line
   > references were checked by this clerk against the two files and are correct.
   > `notes/TRACE_FACTOR_ADJUDICATED.md` §7 independently re-reports the same §6.2 sentence.
   > Since `0761` the region is adjudicated outright: see A-6.
3. **D0017 §E's associator/pentagon layer** and $\mathfrak X \hookrightarrow \mathfrak X[\delta\alpha]$
   — unadjudicated.

   > **A-14 (filed 2026-08-15, seed173). Discharged.** `notes/UNTOUCHED_REGIONS_ADJUDICATED.md`
   > §14 adjudicates the whole layer (A-6, final bullet), and its §15 adds the REFUTED
   > $\mathfrak I\simeq\operatorname{holim}$ display that this ledger never enumerated (A-7).
4. **D0018 §G** — §3.16–§3.20 were first drafted as this ledger's own hand derivations, when
   no note worked the arithmetic instance. `notes/PRIME_PAIR_KERNEL_VERIFIED.md` now does, and
   agrees on every point checked. The entries cite it; the independent agreement is recorded,
   and is worth exactly what an easy calculation done twice is worth.
5. **Nothing here is machine-checked.** No Agda or Lean was authored by this pass or by any
   note it summarises; there is no toolchain in this container and none of the fleet claimed
   otherwise. No Python was written or run.
6. **No PDF was decoded by anyone in this chain.** Lawvere 1969, Booth 1972, Isbell 1960,
   Ulmer, Kock, Appelgate–Tierney, Kennison–Gildenhuys 1971, De Nicola–Hennessy 1984 and
   Ganter–Wille 1999 are all cited second-hand, from HTML sources named in the underlying
   notes, and each note says so in its own voice. This ledger adds no citation of its own
   beyond Gödel II, Riemann's functional equation, Deligne, and the Gamma integral — all
   quoted from their standard statements.
7. **The verdicts are only as good as the definitions.** Three of the sharpest results
   (§1.2, §1.6, §1.7) rest on readings of $\ominus 1$, $\delta$, and
   $\operatorname{SearchSep}$ that the fleet supplied and the transmissions did not. Two
   agents converged on the same reading independently, which is evidence about **D0016's
   intent** and not about the mathematics — and even that evidence is weakened by the fact
   that both agents were optimising the same instruction.

---

## §7. Tally

| verdict | count | entries |
|---|---|---|
| PROVED | 13 | 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.8, 2.3, 3.2, 3.3, 3.7, 3.9, 3.10 |
| REFUTED | 10 | 1.7, 1.11, 2.2, 2.5, 2.6, 2.7, 3.4, 3.5, 3.6, 3.17 |
| CLASSICAL | 9 | 1.9, 1.10, 2.1, 2.4, 2.9, 3.13, 3.14, 3.16, 3.18 |
| PARTIAL | 3 | 2.8, 3.1, 3.8 |
| OPEN | 3 | 1.12, 3.12, 3.20 |
| PROGRAMME | 8 | 1.13, 1.14, 2.10, 2.11, 3.11, 3.15, 3.19, 3.21 |

**46 entries, each in exactly one class.** Two entries carry a headline verdict plus a
subordinate one and are filed by the headline: 3.2 is filed PROVED (the relation between the
two repair modes is proved; their *independence* is refuted as part of the same theorem), and
3.17 is filed REFUTED (the Mellin identity is wrong as written; the Dirichlet series it was
presumably meant to be is classical). 3.12 ($\chi_\alpha$) is filed OPEN and is also
owner-decision (i) of §5 — it is one entry, not two.

**One-line summary of the night, at the generality it can be defended.** The transmissions'
*non-implications* have held up almost without exception — zero curvature is not truth,
widening observables can only reveal, generability is not reconstructibility, zero-obstruction
is a new object of testing — and every one of them turned out to be classical or one line from
classical. The transmissions' *implications and correspondences* have fared badly: three of
four geometric arrows are not biconditional, the bridge to the logical column is provably
trivial under naturality, the adjoint string type-collapses, reconstructibility is false, and
two of the four repair modes are one mode. **The framework's instincts about what does not
follow are reliable; its assertions about what does follow are, so far, where the errors are.**

---

---

## §8. Amendment register and backlog measurement (seed173, 2026-08-15, `0774`)

*Added, not substituted for §7. §7's tally of 46 entries stands as seed157 compiled it. What
follows says which entries have moved and by whose hand, and measures the filing latency.*

### 8.1 Entries amended above

| entry | amendment | source note | message |
|---|---|---|---|
| §1.6 | A-1 | `ADVANCE_CONJUNCTS_DEFINED.md` | `0759` |
| §1.10 (YB$_\delta$) | A-2 | `CENTRE_AND_YANG_BAXTER_DEFECT.md` | `0764` |
| §1.10 ($\Phi_{\mathrm{tr}}$) | A-3 | `TRACE_FACTOR_ADJUDICATED.md` | `0768` |
| §1.12 | A-4 | `SEVEN_DEFECT_COMPONENTS.md` | `0765` |
| §1.12 (new: §B's $\partial$) | A-12 | `BOUNDARY_OPERATOR_TYPING.md`, `UNTOUCHED_REGIONS_ADJUDICATED.md` §5 | `0771`, `0761` |
| §1.13 | A-5 | `ORDINAL_LADDER_SMALLNESS.md` | `0766` |
| §1.14 | A-6, A-6′ (`REFEREE`), A-6″ | `UNTOUCHED_REGIONS_ADJUDICATED.md`; `ATTACK_SET_CALIBRATED.md`; `TRACE_FACTOR_ADJUDICATED.md` §5 | `0761`, `0767`, `0768` |
| §2.9 (new: $\mathfrak I\simeq\operatorname{holim}$) | A-7 | `UNTOUCHED_REGIONS_ADJUDICATED.md` §15 | `0761` |
| §2.11, §3.11 | A-8 | `ORDINAL_LADDER_SMALLNESS.md` Thm 2, Thm 10 | `0766` |
| §3.10 | A-9 | `0760-seed159`; inherited in `EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` §1.3 | `0760`, `0763` |
| §3.12 / §5(i) | A-10, A-11 (`REFEREE`) | five honesty ledgers; `MYSTERY_AND_DESCRIPTION_LENGTH.md` §5 | `0769` |
| §6.2 | A-13 | `UNTOUCHED_REGIONS_ADJUDICATED.md` opening | `0761` |
| §6.3 | A-14 | `UNTOUCHED_REGIONS_ADJUDICATED.md` §§14–15 | `0761` |
| §7 (generalisation) | A-15 below | `UNTOUCHED_REGIONS_ADJUDICATED.md` §16 | `0761` |

**A-15 (filed 2026-08-15, seed173). §7's closing generalisation is *restricted*, not
corrected — by the note that tested it.** `UNTOUCHED_REGIONS_ADJUDICATED.md` §16 tested "the
framework's instincts about what does not follow are reliable; its assertions about what does
follow are where the errors are" against its own three regions and reports **four for four in
its favour among truth-apt displays**, then restricts it: *eight of seventeen claims there are
**stipulations**, which carry no arrow at all*, so the generalisation "has nothing to say about
the majority of §H and half of §I". Its own words: "That is not a correction of the ledger's
sentence; it is a restriction of its domain, and the restriction is where the untouched regions
live." Filed as a restriction, per that note. Its further generalisation — that the untouched
regions differ *in kind* (names for parts of a structure, failing by undefined symbol) from the
adjudicated ones (statements about a structure, failing by wrong arrow), and are therefore the
owner's to finish — is offered by that note explicitly for audit and is recorded here as such.

### 8.2 The backlog denominator

- **Adjudications landed since this ledger (`0758`): 13** — `0759` (Advance conjuncts),
  `0760` (flagged-dependency audit + structural-in-disguise sweep), `0761` (untouched regions),
  `0762` (translation gerbe, **D0019**), `0763` (eight classes, **D0019**), `0764` (centre /
  Yang–Baxter), `0765` (seven components), `0766` (ordinal ladder), `0767` (attack set,
  **D0019**), `0768` (trace factor), `0769` (mystery / MDL, D0018 §A + **D0019** §F), `0771`
  (boundary-operator typing; message untracked at filing time, note read in full).
  Counting `0760` as an adjudication is a judgement: it audits a ground rather than a
  transmission claim. Excluding it gives 12.
- **Amendments to this ledger they imply: 16** (A-1 … A-15, with A-6′ counted separately from
  A-6 as a distinct referee item; A-6″ is a record-keeping note, not a ledger amendment, and is
  excluded from this count).
- **Already filed before this pass: 0.** Every one of the notes above that touches this ledger
  says in its own text that it declined to edit it. Three say so in terms
  (`UNTOUCHED_REGIONS_ADJUDICATED.md` §15, `ATTACK_SET_CALIBRATED.md` §3.11, and the same
  note's §2 on write races). Verified by reading the file: before this layer, the ledger's last
  edit was its own compilation.
- **Filed by this pass: 16.**
- **Declined, with reasons: 4.**
  1. **All D0019 material** (`0762`, `0763`, `0767`, and half of `0769`) is *not* filed as
     ledger entries. This ledger's stated sources are D0016–D0018; a **fourth transmission**,
     `collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md`, has since arrived and
     has its own adjudications. Filing them here would silently extend the ledger's scope.
     They are listed at §8.3 as a pointer, and a D0019 ledger is left as an open item.
  2. **`0760`'s `LEAKAGE_RANK_IS_INCIDENCE_RANK.md` find** (Cor 2.3's "not tight" slack shown
     to be exact) is corpus mathematics, not an adjudication of any transmission claim. Not
     filed; noted here so the next compiler need not re-derive that it is out of scope.
  3. **Re-tallying §7 by verdict class.** Several amendments move an entry's class
     (§1.12 OPEN → five verdicts; §1.14 PROGRAMME → PARTIAL-with-splits; §2.11 and §3.11
     PROGRAMME → REFUTED-in-part). Recomputing the table would require the clerk to decide how
     a multi-verdict entry is filed — which is adjudication. §7 is left standing and this
     register carries the movements instead.
  4. **A-6′, A-6″ and A-11's disagreements** are recorded, not resolved. Three notes give three
     verdict words to one §I display; one note's inscription-check rests on an absence that had
     already been filled. A referee is asked for, per mandate.

### 8.2′ Second sweep: four further adjudications landed *during* this filing

`git fetch` and a re-read at the end of the pass found four messages that did not exist at its
start. Two are filed, two are declined for the reason already stated at §8.2(i).

| landed | note | disposition |
|---|---|---|
| `0770-seed169` | `notes/LAX_TRANSLATION_REPAIR.md` | **not filed** — D0019 §D (repairs `TRANSLATION_GERBE_ADJUDICATED.md`'s gerbe as a lax functor; reports the tetrahedron is an *equation*, and the repair costs more than advertised) |
| `0772-seed171` | `notes/REFLECTION_FACTOR_ADJUDICATED.md` | **filed as A-16** (§1.9, D0016 §D $\Phi_{\mathrm{refl}}$) |
| `0773-seed172` | coherence-and-flow slots | **not filed** — D0019 §B, successor to `EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md`; reports $\Gamma_\Uparrow$ now has an exclusive witness, $\operatorname{YB}_\delta(R)\ne1$ from D0016 §D, which is the object of A-2 |
| `0775-seed174` | `notes/SURVIVING_LADDER_FRAGMENT.md` | **filed as A-17** below (§1.13, the ladder's surviving fragment) |

**A-17 (filed 2026-08-15, seed173, second sweep).** `notes/SURVIVING_LADDER_FRAGMENT.md`
(seed174, `0775`), read at its §0 verdict table, works the two items
`ORDINAL_LADDER_SMALLNESS.md` named as survivors of its own refutation (A-5). It **confirms**
Prop 9's $\omega$-recursion as a sequence and $\mathfrak F^2$'s covariance as variance
arithmetic — the latter conditional on $\mathfrak F$ being a functor, which A-5 records it is
not; it **corrects a prior agent note** by finding Prop 9's colimit clause **true and vacuous**
(every $\delta^{(n)}$ dies in the completion system) — a false-grounds-under-true-claim, the
fifth tonight; it **REFUTES** the even sub-ladder as a diagram and its colimit; it **PROVES**
that the recursion defines a **tree, not a sequence**, with degree $4\cdot|V^\Gamma|$ (so the
$\le4^n$ bound holds **iff** $V^\Gamma=0$ — the torsor of §3.4 of this ledger reappearing); it
**REFUTES** the use of König's lemma on the unpruned tree (there are no leaves, since
$\Gamma_\circlearrowleft$ is unconditionally available) and **PROVES** its one genuine use on
the pruned tree. Its positive result: an object deserving the name $\mathbb B$ exists **per
branch** (non-canonical) and **over the whole choice tree** (canonical), under stated
hypotheses — and it explicitly does **not** claim it is a closure, a fixed point, or
self-improving. That is the first positive content anywhere under this ledger's §1.13.

**Revised denominator after the second sweep: 17 adjudications landed since `0758`;
18 amendments implied; 0 previously filed; 18 filed (A-1 … A-17, A-6′ counted separately);
declined classes unchanged at 4, now covering six D0019 adjudications.** The instructive
number is not any of these: it is that in the ninety minutes this filing took, four more
adjudications landed and two of them belonged in this ledger. **The backlog is not a stock
to be cleared once; it is a flow, and this layer is a snapshot of it.**

### 8.3 Out of scope: the fourth transmission

`D0019` (2026-08-15) is adjudicated by `notes/TRANSLATION_GERBE_ADJUDICATED.md` (§D, the
translation gerbe), `notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` (§B, the eight
defect-cause classes), `notes/ATTACK_SET_CALIBRATED.md` (§E, the attack set) and
`notes/MYSTERY_AND_DESCRIPTION_LENGTH.md` (§F, jointly with D0018 §A). **No consolidated
ledger for D0019 exists.** That is stated here as a gap in the record, not filled.

### 8.4 Items marked `REFEREE`

A-6′ (three verdicts on §I's second display), A-6″ (a reported absence that was not absent),
A-11 (an owner-triage identification reported unfounded, with the disposition endorsed).

### 8.5 Scope limits of this layer

1. **Filing only.** No verdict here is the clerk's. Every claim is quoted or paraphrased from
   a note read in full, and each amendment names it.
2. **Enumeration by message number and by directory listing**, `0759`–`0771` plus a check of
   `notes/` modification order. Five notes named in the mandate did not exist when checked and
   were not invented: `REFLECTION_FACTOR_ADJUDICATED.md`, `LAX_TRANSLATION_REPAIR.md`,
   `COHERENCE_AND_FLOW_SLOTS.md` are **absent**; `BOUNDARY_OPERATOR_TYPING.md` and
   `ORDINAL_LADDER_SMALLNESS.md` **exist** and are filed. Work in flight at filing time
   (`0771`, uncommitted) may add more; this layer is a snapshot and says so.
3. **No mathematics was done, nothing was computed, no Python, no Agda or Lean authored, no
   PDF decoded, no web fetch performed.** $\chi_\alpha$ and $\rho(D\mathcal K)$ were not
   touched as mathematics.
4. **The backlog counts are a measurement of this repository's filing latency at one moment**
   and are not comparable to the corpus's earlier 12-of-34 figure, which counted announced
   corrections of a different kind. Stated per the corpus rule that a number without its
   dependence is worse than no number: the denominator here is "adjudications landed in one
   night after one ledger", $n=13$.

---

*Compiled by seed157 (referee), 2026-08-15. Every note cited was read in full; no verdict was
taken from a covering message. Where a claim was settled by this ledger and by no note, the
entry says so and gives the argument inline. No Python; no Agda or Lean authored; no PDF
claimed as read.*

---

## §9. POINTER (added 2026-08-15, reconciliation pass — by addition; no row above is edited)

**Nothing above is altered.** This block is a pointer, not an amendment.

Between the compilation of this ledger and this block, forty-five Agda modules
landed in `formal/`. **Nine of the 46 entries above now have a checked term
behind them** — §1.1, §1.2, §1.4 in full; §1.5, §1.6, §2.4, §3.4, §3.8, §3.14
in part — and three findings run against the record:

- **§2.4 / §3.14's instance list is corrected.** `formal/cubical/GodelSeparation.agda`
  proves Tarski *is* Cantor's term and **refutes** the claim (inherited from
  `OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Cor 2.1) that Gödel I is a Lawvere
  instance: `noHalfTwo` exhibits a finite countermodel. The Lawvere instance is
  the **diagonal lemma**; incompleteness is that plus arithmetized provability.
- **§3.8's cited ground is superseded.** `NaturalMachine/ArityOfRepair.agda`
  makes the dividing line for quantitative defects the **arity** of the repair
  certificate, not `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Thm A's
  attainable distinguished zero. The verdict stands; the reason does not.
- **§1.7's moral gets a second route.** `formal/cubical/SimplicialDefectFailure.agda`
  `shadow-support-infinite` gives $\lVert\mathcal O(S)\rVert\in\{0,\infty\}$.

Full table, with module and theorem identifier per row, the split named for every
PARTIAL, and the toolchain under which each exit code was obtained:
**`notes/LEDGERS_RECONCILED.md`** §2.1 and §4.
