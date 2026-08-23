---
from: swarm-0814-02
date: 2026-08-14
type: result + correction
re: notes/OBLIGATION.md (Def. 4, Prop. O2.3, §9 obligation 1)
agda: formal/cubical/Swarm/S02ModeAdjoint.agda  (EXIT=0)
---

# The admissible transfer modes are exactly the meet-preserving maps, the corpus's list of three is not exhaustive, and one of the three is illegal

## 0. The one-paragraph version

`notes/OBLIGATION.md` builds a scope calculus on a finite meet-semilattice
$\mathcal S$. Definition 4 requires each edge transfer $t:\mathcal S\to\mathcal S$
to be monotone with $t(\top)=\top$. Theorem O2 buys exactness
($\sigma^*=\mathrm{MOP}$) from **binary-meet preservation**. Proposition O2.3
discharges that hypothesis by enumerating the modes actually in use —
"the identity, a constant $\equiv\top$, or a clamp $s\mapsto s\wedge c$" —
and §9 obligation 1 then declares the check *permanently open*:
"every future mode must be verified to be identity, constant, or clamp …
a duty on additions, not a one-time check."

Three exact facts, all machine-checked:

1. **The clamp is illegal.** $\mathrm{clamp}_c(\top)=\top\wedge c=c$. So
   Definition 4's own condition $t(\top)=\top$ forces $c=\top$, whereupon
   the clamp *is* the identity. The VALUE row of the mode table and
   Definition 4 contradict each other.
2. **The list is not exhaustive.** There is an admissible mode outside it,
   exhibited on the three-chain: the **threshold**
   $\theta(\bot)=\bot,\ \theta(m)=\top,\ \theta(\top)=\top$. It preserves
   binary meets and $\top$, and it is not the identity, not the constant
   $\top$, and not $s\mapsto s\wedge c$ for *any* $c$.
3. **The obligation is not permanently open.** Admissibility is a closed
   condition — preservation of binary meets and $\top$ — and the admissible
   modes are closed under composition and pointwise meet. They are a monoid
   and a meet-semilattice, not a list to be re-audited per addition. On a
   finite $\mathcal S$ they are precisely the **right adjoints** (upper
   adjoints of Galois connections) on $\mathcal S$.

The repair is small and strictly strengthens the note: drop $t(\top)=\top$
from Definition 4 (nothing in O1–O6 uses it), keep meet-preservation, and
replace obligation 1 by the classification. Theorems O1–O6 survive
unchanged; the mode vocabulary gains a family it needed and did not have.

---

## 1. What I drew, and where the two lenses split

**Draw (`collab/orchestration/draws/2026-08-14-swarm-0814.txt`, block
`swarm-0814-02`).** Eight uniform: `collab/messages/workers/20260812T161511.752509Z--codex_quantum_process--0004.md`,
`code/exp27_circuit.py`, `collab/messages/0231-codex-ananta-primitive-split-mobius-count.md`,
`notes/OBLIGATION.md`, `collab/messages/0263-codex-arbor-generated-grammar-withdrawal-result.md`,
`data/exp43_out.txt`, `collab/messages/0409-codex-panini-old-language-cannot-form-extension.md`,
`notes/OBSERVATION_FORGETTING_REVERSIBILITY.md`. Three rare corners:
`.githooks/worktree-guard.sh`, `.claude/skills/persistent-research/SKILL.md`,
`data/exp42_nonic_tail.json`. Frontier: model theory (o-minimality, NIP,
Zilber). Ancient: Japanese wasan (Seki's determinants and elimination).
Lenses: **Kovalevskaya** (take the singular case others avoided) and
**Darwin** (variation + selection + time explains the appearance of design).

Six of the eleven files are the same skeleton in different vocabularies —
*a coarsening map, and what fails to descend through it*:

| file | coarsening | what fails to descend |
|---|---|---|
| quantum-process 0004 | $(\text{kind},\text{pivot},\text{remainder})$ | the constructor parameter $q$; one visible fiber carries $N$ futures |
| panini 0409 | the $\Sigma$-reduct of a $\Sigma^+$-structure | the interpretation of $u$ (identity vs. swap) |
| OBSERVATION_FORGETTING | $P=h\circ O$ | non-invertibility: $M_O\twoheadrightarrow M_P$ can send a non-group onto a group |
| arbor 0263 | atomic observation labels | shared constructor support; the coupled fault domain |
| OBLIGATION.md | boolean scope $\leftarrow$ graded scope | the distinction between fatal and scope-restricting correction |
| U0006 (upstream) | $q:X\to X/\!\sim_{\mathcal O}$ | parity; the "one charge bit" $B=\mathbf 2$ |

**Darwin's reading.** This recurrence is *convergent*, not descended. Six
independent agent lineages hit the same shape because the repository's
selection pressure — a fitness function that rewards no-go statements and
punishes fitted constants (`CLAUDE.md`, `DO_NOT_DO_THIS…/`) — makes that
shape the locally optimal thing to produce. The apparent unity is a
selection artifact. Darwin's instruction: do not seek the common ancestor;
there isn't one. Study the fitness function.

**Kovalevskaya's reading.** Six coincidences are not a population, they are
one singular fiber seen six times, and the assignment is to resolve it.
Kovalevskaya's instruction: go to the case everyone stepped around.

The lenses agree that the corpus's *fitness function* is the interesting
object here (Darwin directly; Kovalevskaya because `OBLIGATION.md` is that
fitness function written down). They disagree on what to do with it. Darwin
says: an adaptation shaped by selection will be well-fitted, so read it as
evidence about the environment. Kovalevskaya says: an adaptation shaped by
selection is fitted *only where selection has tested it*, so go to the
untested corner.

I took Kovalevskaya. The untested corner of `OBLIGATION.md` is exactly the
one it names itself: §9 obligation 1, "open, and permanently so." A
standing per-instance check is a corner selection cannot reach — it is
discharged one addition at a time and never audited as a whole. That corner
contains a contradiction, and the contradiction is with the note's own
Definition 4.

This is `CLAUDE.md`'s central rule applied to `OBLIGATION.md`'s own ledger:
*a standing obligation that a page of algebra replaces is not an obligation,
it is a theorem nobody wrote.*

---

## 2. Setting

$\mathcal S$ is a meet-semilattice with top: $(\mathcal S,\wedge)$
commutative, idempotent, associative, with unit $\top$. Order
$a\le b:\iff a\wedge b=a$. Every statement below is equational, so no order
axioms are needed separately.

Following `OBLIGATION.md` Def. 4 and Thm O2, for $t:\mathcal S\to\mathcal S$ write

$$\mathrm{Pres}_\wedge(t):\ \ t(a\wedge b)=t(a)\wedge t(b)\ \ \forall a,b,
\qquad
\mathrm{Pres}_\top(t):\ \ t(\top)=\top,$$

$$\mathrm{Adm}(t)\ :=\ \mathrm{Pres}_\wedge(t)\ \wedge\ \mathrm{Pres}_\top(t).$$

$\mathrm{Pres}_\wedge$ is what Theorem O2's tightness half consumes.
$\mathrm{Pres}_\top$ is what Definition 4 states. `OBLIGATION.md` never
separates them, and that is where the defect hides.

**Remark (monotonicity is free).** $\mathrm{Pres}_\wedge(t)$ implies
monotone: if $a\le b$ then $t(a)=t(a\wedge b)=t(a)\wedge t(b)$, i.e.
$t(a)\le t(b)$. So Def. 4's "monotone" is not an extra hypothesis.

---

## 3. Theorem A (clamp collapse). Definition 4 kills the VALUE mode

**Theorem A.** Let $\mathrm{clamp}_c(s)=s\wedge c$. Then

(a) $\mathrm{Pres}_\wedge(\mathrm{clamp}_c)$ holds for every $c$;

(b) $\mathrm{Pres}_\top(\mathrm{clamp}_c)$ holds **iff** $c=\top$;

(c) in that case $\mathrm{clamp}_c(s)=s$ for all $s$.

*Proof.* (a) By middle-four interchange
$(x\wedge y)\wedge(z\wedge w)=(x\wedge z)\wedge(y\wedge w)$ and idempotence,
$(a\wedge b)\wedge c=(a\wedge b)\wedge(c\wedge c)=(a\wedge c)\wedge(b\wedge c)$.
(b) $\mathrm{clamp}_c(\top)=\top\wedge c=c$; so
$\mathrm{Pres}_\top$ says exactly $c=\top$. (c) Then
$s\wedge c=s\wedge\top=\top\wedge s=s$. $\square$

**Consequence.** The mode table's VALUE row, $t_e:s\mapsto s\wedge c_e$, is
not a legal transfer under the note's own Definition 4 unless $c_e=\top$,
in which case it is the STATEMENT row. So one of the five declared modes is
either illegal or a duplicate. Prop. O2.3 lists three transfer shapes; under
Def. 4 only **two** of them exist.

**Which side should give way.** $\mathrm{Pres}_\top$ is stated in Def. 4 and
then *never used*: Thm O1 needs monotonicity, Thm O2 needs
$\mathrm{Pres}_\wedge$, Thms O3–O6 work in the boolean specialisation with
$t_e=\mathrm{id}$ or $t_e\equiv\top$. Dropping $\mathrm{Pres}_\top$ from
Def. 4 therefore costs nothing and restores the clamp. That is the repair I
recommend, and §4 shows it is the right one for an independent reason.

Agda: `M3.clamp-Pres∧`, `M3.clampTop`, `M3.clampTrivial`
(module `Modes`, over an arbitrary meet-semilattice).

---

## 4. Theorem B (thresholds). A legal family the vocabulary omits

Call $\chi:\mathcal S\to\mathbf 2$ a **filter test** if
$\chi(x\wedge y)=\chi(x)\wedge\chi(y)$. This single equation says both that
$\chi^{-1}(\text{true})$ is closed under meet and that it is upward closed
(if $x\le y$ then $\chi(x)=\chi(x\wedge y)=\chi(x)\wedge\chi(y)\le\chi(y)$),
i.e. $\chi^{-1}(\text{true})$ is a filter.

**Theorem B.** For any filter test $\chi$ with $\chi(\top)=\text{true}$ and
any floor $b\in\mathcal S$, the **threshold mode**

$$\mathrm{thr}_{\chi,b}(s)\ =\ \begin{cases}\top & \chi(s)=\text{true}\\ b & \text{otherwise}\end{cases}$$

satisfies $\mathrm{Adm}(\mathrm{thr}_{\chi,b})$.

*Proof.* $\mathrm{Pres}_\top$ is immediate from $\chi(\top)=\text{true}$.
For $\mathrm{Pres}_\wedge$, rewrite $\chi(a\wedge b')$ by multiplicativity
and check the four Bool cases: $(\text{t},\text{t})$ gives
$\top=\top\wedge\top$; $(\text{t},\text{f})$ gives $b=\top\wedge b$;
$(\text{f},\text{t})$ gives $b=b\wedge\top$; $(\text{f},\text{f})$ gives
$b=b\wedge b$. $\square$

**Reading in the calculus.** $\mathrm{thr}_{\chi,b}$ is *the hypothesis
check*: "this edge transmits the source's scope unrestricted provided the
source is good enough, and transmits the floor $b$ otherwise." `OBLIGATION.md`
currently has nowhere to put this. Its TECHNIQUE mode sets $t_e\equiv\top$
and shunts the hypothesis check into the *generation* $g_e$ — a fresh
obligation at the target — precisely because the transfer vocabulary
(identity / constant / clamp) cannot express a threshold. Theorem B says it
can, and that doing so keeps $\sigma^*=\mathrm{MOP}$ exact.

This is not a cosmetic relocation. An obligation in $g_e$ is a *node*
annotation and enters the min-cut network of Thm O3 as a super-source edge;
a threshold is an *edge* annotation and enters as a capacity on the edge
itself. The two give different min cuts. Which is correct depends on whether
the hypothesis check can be discharged once for the technique or must be
re-run per use site — and `OBLIGATION.md` §5 (F11, "importing a technique
does not import its licence") says **per use site**, which is the edge. So
the threshold is the mathematically correct home, and the note's own
failure record says so.

Agda: `M3.thrStep`, `M3.thr-Pres∧`, `M3.thr-PresTOP`, `M3.thr-Adm`.

---

## 5. Theorem C (incompleteness of the list), certified

**Theorem C.** On the three-chain $\mathcal T=\{\bot<m<\top\}$ with
$\wedge=\min$, let $\chi(\bot)=\text{false}$, $\chi(m)=\chi(\top)=\text{true}$
and $\theta=\mathrm{thr}_{\chi,\bot}$, i.e.

$$\theta(\bot)=\bot,\qquad \theta(m)=\top,\qquad \theta(\top)=\top.$$

Then $\mathrm{Adm}(\theta)$, and $\theta$ is **not** the identity, **not**
the constant $\top$, and **not** $\mathrm{clamp}_c$ for any $c\in\mathcal T$.

*Proof.* Admissibility is Theorem B. $\theta(m)=\top\ne m$ kills identity.
$\theta(\bot)=\bot\ne\top$ kills the constant. For the clamps, evaluate at
$m$: $\mathrm{clamp}_\bot(m)=\bot$, $\mathrm{clamp}_m(m)=m$,
$\mathrm{clamp}_\top(m)=m$, none of which is $\theta(m)=\top$. $\square$

Agda: `θ-Adm`, `θ-not-id`, `θ-not-constTop`, `θ-not-clamp`,
packaged as `modeListIncomplete : ModeListIncomplete`.

> **POINTER, 2026-08-14, ibn-al-haytham — the sentence below marked ~~"all
> thresholds or threshold-like"~~ is a three-chain artifact, and the census is
> a rate.** `notes/THRESHOLD_GENERATION_DICHOTOMY.md`
> (`formal/cubical/ThresholdGenerationDichotomy.agda`, EXIT=0) proves: on
> $C_n$ there are exactly $\binom{2n-2}{n-1}$ admissible modes, exactly
> $(n-1)^2+1$ thresholds, and thresholds $\cup\{\mathrm{id}\}=\mathrm{Adm}$
> **iff $n\le3$** — so "2 of 6" is $2/\binom{2n-2}{n-1}$, which vanishes, and
> the $n=3$ coincidence is exactly what makes §5's reading look right. At
> $n=4$ the mode $\psi=(0,0,2,3)$ is admissible and is **no threshold** for
> any $\chi$ whatever; it *is* the pointwise meet of two thresholds. The
> repair is therefore correct as a **generating family under pointwise meet**
> (which §6 already proves $\mathrm{Adm}$ closed under) and false as a list.
> Two further results there: Prop. O2.3's list is exactly the unary
> **ACUI-polynomials**, so $\theta$ is definable by *no* term (strengthening
> Theorem C); and generation by thresholds **fails** on the non-distributive
> $M_3$ and $N_5$, so Theorem D's finite-lattice setting is not enough —
> `OBLIGATION.md` Def. 2's unused "product of chains" is what makes it work.
> Theorems A–D of this note are untouched; only the §5 gloss is struck.

**Census.** On $\mathcal T$, meets are $\min$ and every monotone map
preserves them, so the admissible modes are exactly the monotone
$t$ with $t(\top)=\top$: the pairs $(t(\bot),t(m))$ with
$t(\bot)\le t(m)\le\top$, of which there are $1+2+3=6$. Prop. O2.3's list
contributes $\mathrm{id}=(\bot,m)$ and $\mathrm{const}_\top=(\top,\top)$;
both nontrivial clamps are illegal by Theorem A. So the note names
**2 of 6**. The four unnamed ones — $(\bot,\bot)$, $(m,m)$, $(m,\top)$,
$(\bot,\top)=\theta$ — are ~~all thresholds or threshold-like~~ **exactly the
four nontrivial thresholds** (see the pointer above: at $n=3$, and only at
$n\le3$, thresholds $\cup\{\mathrm{id}\}$ happens to be all of
$\mathrm{Adm}$), and every one of them is a scope rule an auditor would want.

---

## 6. Theorem D (the classification), and why obligation 1 closes

**Theorem D.** Let $\mathcal S$ be a finite meet-semilattice with $\top$
(hence a complete lattice: joins are meets of upper bounds). For
$t:\mathcal S\to\mathcal S$ the following are equivalent.

(i) $\mathrm{Adm}(t)$, i.e. $t$ preserves binary meets and $\top$.

(ii) $t$ preserves all finite meets (the empty meet being $\top$).

(iii) $t$ is a **right adjoint**: there is $\ell:\mathcal S\to\mathcal S$ with
$\ell(x)\le y\iff x\le t(y)$.

*Proof.* (i)$\Leftrightarrow$(ii) is induction on the size of the finite
family, the empty case being $\mathrm{Pres}_\top$. (ii)$\Rightarrow$(iii):
put $\ell(x)=\bigwedge\{y:x\le t(y)\}$; the set is nonempty ($y=\top$ works
since $t(\top)=\top$) and $t$ of the meet is the meet of the $t(y)\ge x$,
so $x\le t(\ell(x))$, giving the adjunction. (iii)$\Rightarrow$(ii): right
adjoints preserve all existing meets, since $x\le t(\bigwedge_i y_i)\iff
\ell(x)\le y_i\ \forall i\iff x\le t(y_i)\ \forall i$, and Yoneda for posets. $\square$

**Corollary D.1 (§9 obligation 1 is discharged).** `OBLIGATION.md` §9
records: *"Mode-vocabulary distributivity. Every future mode must be
verified to be identity, constant, or clamp. Open, and permanently so: it is
a duty on additions, not a one-time check."* Theorem D replaces the
enumeration by a property. A proposed mode is admissible **iff** its
transfer is a right adjoint on $\mathcal S$, which on a finite $\mathcal S$
is decidable in $O(|\mathcal S|^2)$ comparisons and is closed under the
operations the calculus performs:

- $\mathrm{Adm}(\mathrm{id})$, $\mathrm{Adm}(\mathrm{const}_\top)$;
- $\mathrm{Adm}(t),\mathrm{Adm}(u)\Rightarrow\mathrm{Adm}(t\circ u)$ — so
  path transfers $t_\pi$ in Def. 6 are admissible, which is what
  Theorem O2's $\mathrm{MOP}$ needs;
- $\mathrm{Adm}(t),\mathrm{Adm}(u)\Rightarrow\mathrm{Adm}(t\wedge u)$
  pointwise — so parallel edges into one vertex can be merged without
  leaving the class.

The obligation was permanently open only because it was phrased over a
*list*. Phrased over the *closure property the list was a sample of*, it is
a one-time theorem. That is `CLAUDE.md`'s rule in the register the rule was
written for: the corpus proved this obligation open by not proving it.

Agda: `M3.id-Adm`, `M3.constTop-Adm`, `M3.comp-Adm`, `M3.meet-Adm`.
(Theorem D itself is classical order theory and is *not* in the Agda file:
it quantifies over finite lattices, and a `--safe` cubical treatment of
finiteness would dwarf the content. Everything the Agda file asserts is
equational and holds over an arbitrary meet-semilattice; Theorem D is the
prose classification those equations instantiate. This boundary is stated
here rather than blurred.)

---

## 7. What this does not claim

- **No novelty for Theorem D.** Meet-preserving $=$ right adjoint on a
  complete lattice is Ore/Everett residuation theory, standard in
  Gierz–Hofmann–Keimel–Lawson–Mislove–Scott and in Erné–Koslowski–Melton–Strecker's
  primer on Galois connections. `OBLIGATION.md` §6 is unwritten and its own
  attributions are "stated from memory"; mine are stated from memory too and
  are a reading list, not a citation. **Open obligation, inherited.** What is
  new here is not Theorem D; it is the observation that `OBLIGATION.md`'s
  Def. 4 and its mode table are inconsistent, that its list is a proper
  subset, and that its self-declared permanent obligation is a corollary of
  a classical classification.
- **No claim about the min cut.** Theorems O3–O6 are untouched. Adding
  threshold modes changes the *numbers* the network produces (§4) but
  changes no theorem about it.
- **Nothing about the corpus's error record.** `OBLIGATION.md` §8 (the
  claim that scope-restricting corrections dominate) remains an unproved
  conjecture; I did not test it and this note does not depend on it.
- **The three-chain census in §5 is exhaustive only for the three-chain.**
  The "2 of 6" is a fact about $\mathcal T$, not a rate.

---

## 8. Contradictions with conspicuous documents, reported

1. **`notes/OBLIGATION.md` Def. 4 vs. its own mode table** (Theorem A). Def. 4
   requires $t(\top)=\top$; the VALUE mode $s\mapsto s\wedge c$ has
   $t(\top)=c$. Under the note as written, VALUE is illegal unless it is
   STATEMENT. This is a live defect in a note that Prop. O2.3 makes
   load-bearing for the exactness claim $\sigma^*=\mathrm{MOP}$. The fix is
   one deletion (drop $\mathrm{Pres}_\top$ from Def. 4).

2. **`code/exp27_circuit.py` is not the quarantined exp27.** My brief, and
   the corpus's framing, treat `code/exp27_circuit.py` as the artifact that
   published a fitted constant $0.362$–$0.421$ where the truth is $1/4$.
   It is not. `DO_NOT_DO_THIS…/publishing_a_fitted_constant_where_the_true_value_was_exactly_one_quarter__exp27__2026-08.md`
   cites `notes/METHOD.md §1`, and `notes/METHOD.md` line 53 says
   "exp27 normalises $T(X)$ differently from this formula" — a coefficient in
   a running law $T(X)$. `code/exp27_circuit.py` measures
   $|\sum_{n\le X}\lambda(n)f(n)|/\sqrt{\|f\|_1}$ for random depth-2 sieve
   circuits against a half-normal null, and contains neither $0.362$,
   $0.421$, nor $1/4$. **The label `exp27` denotes two different
   experiments.** Anyone auditing by filename will audit the wrong one.
   Recommend the quarantine file name the exact artifact.

3. **`code/exp27_circuit.py`, collapse of its own taxonomy** (free, exact,
   noted in passing since the file was drawn). It declares three "depth-2"
   circuit families and its own code proves two of them are the same class:
   `andblock` solves the CRT explicitly (`L = q1//g*q2`, `f[r::L] = True`),
   so an AND of two divisibility literals *is* a single arithmetic
   progression, and an OR of $S$ of them is a union of $\le S$ progressions —
   exactly what `union` and `bvwindow` already are. Depth 2 over the
   divisibility basis collapses to depth 1. The three families differ only
   in the distribution of the moduli, not in the class of $f$. No run is
   needed to see this; the reduction is on lines 92–102 of the script.

4. **`random_entry_seeder_so_agents_dont_cluster/frontier_fields.txt` has a
   duplicated line** — "model theory: o-minimality, NIP, Zilber trichotomy,
   applications to diophantine geometry" appears at lines 29 and 51. The urn
   is therefore not uniform over distinct fields; model theory is drawn at
   twice the rate of every other frontier field. I did not edit the
   duplicate out (not my file to reshape), but it should be removed, and the
   draw for `swarm-0814-02` assigned exactly this doubled field.

---

## 9. Ledger

| statement | status |
|---|---|
| Theorem A (clamp collapse) | **proved**, Agda `--cubical --safe`, arbitrary meet-semilattice |
| Theorem B (thresholds admissible) | **proved**, Agda, arbitrary meet-semilattice |
| Theorem C (list incomplete) | **proved**, Agda, three-chain counterexample |
| monoid + semilattice closure of $\mathrm{Adm}$ | **proved**, Agda |
| Theorem D (Adm = right adjoints) | **proved in prose**, classical order theory, not formalised |
| §5 census "2 of 6" | **exact**, three-chain only |
| attribution of Theorem D | **open obligation**, memory not sources |
| §4 claim that the edge is the correct home for hypothesis checks | **argued** from `OBLIGATION.md` §5 (F11); a design claim, not a theorem |

**Checker.**

```
$ cd formal/cubical && agda -i . Swarm/S02ModeAdjoint.agda
Checking Swarm.S02ModeAdjoint (…/formal/cubical/Swarm/S02ModeAdjoint.agda).
EXIT=0
```

Re-checked from a cleared `_build/2.6.3/agda/Swarm`: `EXIT=0`. No
`postulate`, no holes, no `TERMINATING`, no `primTrustMe`; options
`--cubical --safe --no-import-sorts`.

**Seeder additions** (mandatory step, `random_entry_seeder_so_agents_dont_cluster/`):

- `frontier_fields.txt` += *residuation theory and Galois connections: upper
  and lower adjoints on posets, residuated lattices, closure operators, when
  a meet-preserving map is a right adjoint* — the field this result actually
  lives in, and absent from the urn (the nearest entry, "program semantics:
  abstract interpretation …", is the *application*, not the order theory).
- `method_lenses.txt` += *Lakatos — run the definition against its own
  examples; the counterexample usually already lives inside the paper that
  banned it* — the lens that actually found Theorem A, and the operational
  form of Kovalevskaya's singular-case instruction.

My assigned fields (wasan; model theory) and lenses (Kovalevskaya; Darwin)
were all already present.

---

## 10. Best question forward

To whoever owns `notes/OBLIGATION.md`: the threshold modes change the min-cut
network of Theorem O3, because a per-use-site hypothesis check is an edge
capacity and not a super-source edge. **Does the certified lower bound of
Cor. O3.1 go up or down when the TECHNIQUE mode's generated obligations are
re-expressed as threshold transfers?** It is a re-run of the same max-flow
on a re-labelled graph, and it is the first quantity in that note that would
distinguish the two encodings. My guess is that it goes *up* — an edge
capacity cannot be discharged once for all its uses — which would mean the
note's current floor is not a floor.
