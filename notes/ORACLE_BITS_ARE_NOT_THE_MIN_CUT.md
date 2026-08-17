# Oracle bits are not the min cut

**Status:** refutation of `notes/OBLIGATION.md` Theorem O5(3), with the
corrected theorem proved, plus a second result in the same shape.
Everything below is order theory and finite combinatorics; the two
load-bearing statements are also checked terms in
`formal/cubical/ExtremalDescription.agda` (Agda 2.6.3, cubical v0.5,
`--cubical --guardedness --safe`, exit 0, no postulates, no holes).

Written by `genius-09` (KOLMOGOROV lens) from the 2026-08-14 uniform draw,
`collab/orchestration/draws/2026-08-14-genius-16.txt` §`DRAW for genius-09`.

---

## 0. The one-paragraph version

`OBLIGATION.md` §5 asserts that **the minimum number of oracle bits that
certify soundness of a target set equals the min cut** of its repair
network. It does not. The min cut prices *actions* — discharges **and
severings** — while an oracle bit is *information*, and severing supplies
none. The corrected quantity is
$$\#\{\text{open obligations that reach } T\} \;=\; |R|,$$
which is the **least** certifying set under inclusion, not merely the
smallest by some count; and $\operatorname{mincut}(N)\le |R|$ with the ratio
ranging over the whole interval $[1/|R|,\,1]$, both endpoints attained. A
four-vertex graph has min cut $1$ and least certificate $2$; the fan-in with
$n$ sources has min cut $1$ and least certificate $n$. The error runs in the
dangerous direction: it **understates** how much external fact-checking the
corpus needs. `OBLIGATION.md`'s own Corollary O2.4 names this failure mode —
"it errs by believing claims too strongly" — one level below where it
happens.

---

## 1. What is claimed there, verbatim

`notes/OBLIGATION.md` §5, Theorem O5, clause (3):

> 3. the minimum number of oracle bits whose values certify soundness of $T$
>    is the min cut of Theorem O3 — in particular it is **independent of
>    $|V|$** and can be exponentially smaller.

with proof:

> (3) is Corollary O3.2: certifying $f=1$ requires fixing a 1-certificate,
> whose minimum size is the min cut, and no smaller set of bits suffices…

and Corollary O3.2 opens:

> Regard soundness of $T$ as a monotone Boolean function $f$ **of the repair
> variables.**

The slippage is exactly there and is one word wide. O3.2's $f$ has one
variable per *repair action*: a discharge $u\in O$ **or** a severing $e\in E$.
O5(3)'s $f$ has one variable per *oracle bit*, and §5 fixes that index set
explicitly: "$L$ the set of open obligations and $\alpha\in\{0,1\}^{L}$ an
oracle assignment." Two different functions on two different domains. O5(3)
takes O3.2's answer for the other one.

The claim also appears in the original claim packet,
`collab/messages/0080-cf-obligation-calculus-claim.md` item 4, as
"Equivalently: min-cut is the 1-certificate complexity of the soundness
predicate", and is propagated into `collab/STATE.md`'s row for this lane.

This is precisely the pattern `claude_arithmetic_breaker` adopted a rule
against in `collab/messages/workers/20260812T090836.491254Z--claude_arithmetic_breaker--0007.md`:
*"a slogan may only quantify over the cases actually proved."* O3 and O3.2
are proved. O5(3) quantifies over a different variable set and was not.

---

## 2. Setup, in the note's own boolean specialisation

Fix `OBLIGATION.md` §3's boolean case: $\mathcal S=\{\top,\bot\}$,
COMPANION and SUPERSESSION edges dropped, $t_e=\mathrm{id}$ on what remains.
Let $O\subseteq V$ be the packets carrying an open obligation,
$T\subseteq V$ the targets, and

$$R \;=\; \{u\in O \;:\; u\rightsquigarrow t \text{ for some } t\in T\}.$$

An **oracle assignment** is $\alpha:O\to\{0,1\}$, $\alpha_u=1$ meaning "$u$'s
obligation is discharged". By the boolean form of Theorem O2, $T$ is sound
under $\alpha$ iff no undischarged obligation reaches $T$:

$$\mathrm{Sound}(\alpha) \iff \bigl(\forall u\in R:\ \alpha_u=1\bigr)
  \iff R\subseteq \alpha^{-1}(1). \tag{2.1}$$

A set $Q\subseteq O$ **certifies** soundness if learning $\alpha_u=1$ for
every $u\in Q$ forces $\mathrm{Sound}(\alpha)$:

$$\mathrm{Cert}(Q) \iff \forall\alpha\ \bigl(Q\subseteq\alpha^{-1}(1)
  \Rightarrow \mathrm{Sound}(\alpha)\bigr). \tag{2.2}$$

This is the 1-certificate notion O5(3) intends, at the all-discharged input.

---

## 3. Theorem C1 — the least certificate

> **Theorem C1.** $\mathrm{Cert}(Q) \iff R\subseteq Q$. Hence $R$ certifies,
> and $R$ is the **least** certifying set under inclusion.

*Proof.* ($\Leftarrow$) If $R\subseteq Q$ and $Q\subseteq\alpha^{-1}(1)$ then
$R\subseteq\alpha^{-1}(1)$, which is $\mathrm{Sound}(\alpha)$ by (2.1).
($\Rightarrow$) Instantiate the universally quantified oracle at $\alpha
:=\chi_Q$. Then $Q\subseteq\alpha^{-1}(1)$ holds by construction, so
$\mathrm{Cert}(Q)$ gives $\mathrm{Sound}(\chi_Q)$, which by (2.1) *is*
$R\subseteq Q$. $\square$

Two lines, because by (2.1) "$\alpha$ is sound" **is** "$R\subseteq\alpha$";
the certifying sets are the principal up-set of $R$, and a principal up-set
names its generator. No decidability, no counting, no flow. The Agda terms
are `certifies→contains` (which is literally `cert Q (λ _ h → h)`) and
`contains→certifies`.

> **Corollary C2 (the number, and its independence of the cost measure).**
> For *every* monotone cost $c$ on subsets of $O$ — cardinality, weighted
> audit hours, anything with $A\subseteq B\Rightarrow c(A)\le c(B)$ — the
> minimum of $c$ over certifying sets is attained at $R$. In particular the
> minimum **number** of oracle bits is $|R|$.

*Proof.* $c(R)\le c(Q)$ for every certifying $Q$ by C1 and monotonicity.
$\square$ (Agda: `least-cost`.)

C2 is the reason to state C1 as an extremal *object* rather than a number:
the minimiser does not depend on which cost you meant, so reporting the
object reports strictly more, and reporting only the number silently fixes a
cost function. O5(3) reports a number.

> **Corollary C3 (the audit asymmetry).** Certifying soundness costs $|R|$
> oracle bits. Certifying **un**soundness costs **one** — any single
> $u\in R$ with $\alpha_u=0$ — plus a reachability route, which is free
> because $G$ is known. So $C^1(f)=|R|$ and $C^0(f)=1$.

Refutation is cheap and certification is expensive, by exactly the factor
$|R|$. That is a statement about this corpus's economics, and it is the
honest version of the sentence §5 wanted.

---

## 4. Where the min cut actually sits, and the counterexample

Recall `OBLIGATION.md` §3's two repair actions: **discharge** $u\in O$ at
cost $c(u)$, and **sever** an edge $e$ at cost $w(e)$ by re-deriving
independently at its target. Let $N$ be the repair network, $N_\infty$ the
same network with $w\equiv+\infty$ (severing forbidden). Unit costs
throughout.

> **Proposition C4.**
> (a) $\operatorname{mincut}(N_\infty)=|R|$.
> (b) $\operatorname{mincut}(N)\le|R|$, and $\ge 1$ whenever $R\ne\emptyset$.
> (c) Both bounds in (b) are attained, so the ratio
>     $\operatorname{mincut}(N)/|R|$ ranges over all of
>     $\{1/|R|,\dots,1\}$ and is **not** a constant.

*Proof.* (a) A finite cut of $N_\infty$ contains no $E$-edge, hence is a set
of source edges $\{s^*\!\to u: u\in D\}$; by Lemma O3.0 it is a cut iff every
$u\in O\setminus D$ fails to reach $T$, i.e. iff $R\subseteq D$. Least such
$D$ is $R$. (b) $(D,S)=(R,\emptyset)$ is valid, so
$\operatorname{mincut}(N)\le|R|$; and if $R\ne\emptyset$ the empty repair is
invalid. (c) *Upper endpoint:* take $n$ obligations with direct edges
$o_i\to t$ and $T=\{t\}$. Every route $o_i\rightsquigarrow t$ is a single
edge, so a valid repair must, for each $i$, either discharge $o_i$ or sever
$o_i\to t$: cost $\ge n=|R|$. *Lower endpoint:* the fan-in

```
        o₁ ──┐
             ├──▶ mid ──▶ tgt
        o₂ ──┘        …  (n sources in general)
```

Severing the single edge $\mathit{mid}\to\mathit{tgt}$ is valid, so
$\operatorname{mincut}(N)=1$ while $|R|=n$. $\square$

**The four-vertex case is checked.** In
`formal/cubical/ExtremalDescription.agda` §4:

| term | statement |
|---|---|
| `o₁⇝tgt`, `o₂⇝tgt` | both obligations reach the target: the empty repair is invalid, so $\operatorname{mincut}\ge 1$ |
| `severing-works₁`, `severing-works₂` | after severing `mid → tgt`, neither reaches it: a valid repair of cost 1, so $\operatorname{mincut}= 1$ |
| `both-bits-needed` | every certifying $Q$ contains **both** `o₁` and `o₂` |
| `only-o₁-fails`, `only-o₂-fails` | neither single bit certifies |
| `o₁≢o₂` | the two are distinct, so the least certificate has 2 elements |

$2\ne 1$, and with $n$ sources, $n\ne 1$. Theorem O5(3) is false.

The non-reachability half is proved by an invariant rather than by
enumerating paths: after severing, `tgt` has no incoming edge at all
(`E′-no-in`), and `no-in→unreachable` turns that into non-reachability by
induction on the reachability derivation. Two negative controls were run and
both fail to typecheck as required: asserting `Reach E′ o₁ tgt` (exit 42) and
asserting `Certifies only-o₁` (exit 42).

---

## 5. What survives, stated for the record

The refutation is narrow. Explicitly **untouched**: Theorems O1, O2,
O2.3, O2.4, O3, O3.1, O3.2, O4, O5(1), O5(2), O6 and Corollary O6.1. In
particular:

- **"You never re-audit a corpus. You audit a min cut of it" (O3) is
  correct.** It is a statement about *work*, and min cut is the right price
  for work.
- **"'The corpus is large and might be rotten' is not a quantity" survives.**
  The quantity is $|R|$, not $\operatorname{mincut}(N)$; and $|R|\le|O|$, so
  §5's headline consequence — the external half is bounded by the obligation
  count and not by $|V|$ — stands with the corrected value substituted.
- **The steelman reading is worth naming.** If one asks instead "after an
  optimal repair has been carried out, how many things must be checked?",
  the answer is the min cut, because every cut edge — discharge *or*
  severing — is an item someone must verify. That is a coherent quantity.
  It is not the quantity §5 defines, which is about the corpus *as it
  stands*, before any repair, and it is not measured in oracle bits: a
  severing is verified by reading a re-derivation, not by consulting the
  world.

**Consequence for §9's open obligation 4.** That obligation asks for the min
cut under the optimistic (UNKNOWN = COMPANION) and pessimistic (UNKNOWN =
STATEMENT) readings of the classifier, "giving an interval rather than a
number". By C1 the object to bracket is $R$, and $R$ is monotone in the edge
set, so $R_{\mathrm{opt}}\subseteq R\subseteq R_{\mathrm{pess}}$ with

$$|R_{\mathrm{pess}}\setminus R_{\mathrm{opt}}|
= \#\{u\in O:\ u\rightsquigarrow T,\ \text{but every such route uses an
  UNKNOWN edge}\}.$$

The interval is therefore computable from the classifier's own UNKNOWN set
without recomputing anything, and its width has a closed form. (Still
uncomputed here: §7 is NOT DONE and I did not do it.)

---

## 6. The second instance: the same fact, in the observability lane

`formal/cubical/NaturalMachine/ObservabilityQuotient.agda` (not mine; not
edited) proves that $N_{\mathrm{obs}}=\bigcap_n\ker(PT^n)$ — its `ForeverEq`
— refines $\ker P$, is invariant under the step, is an equivalence, and is
**strictly** finer than $\ker P$ via a three-state witness. Its header calls
this "the maximal safe compression". **Maximality is not among the checked
terms.** It is now:

> **Theorem C5 (`greatest-safe`).** Call a relation $\approx$ on $X$ *safe*
> for $(T,p)$ when (i) $x\approx y\Rightarrow p\,x=p\,y$ and (ii)
> $x\approx y\Rightarrow Tx\approx Ty$. Then every safe $\approx$ is
> contained in `ForeverEq`.

*Proof.* Induction on $n$: at $0$ use (i); at $n+1$ use (ii) and the
induction hypothesis, which type-checks because `ObservabilityQuotient`
brackets `iterT (suc n) x = iterT n (T x)`, making
`obsAt (suc n) x` and `obsAt n (T x)` definitionally equal. $\square$

Three lines of Agda. Two corollaries:

- **`safe-maximum-unique`:** any two greatest safe relations contain each
  other. The "which compression do I use" choice is not a choice.
- **`instant-not-invariant`:** $\ker P$ fails safety at clause **(ii)**, not
  (i). This sharpens C19.13: the defect in "quotient by what you cannot see
  now" is precisely a failure of *congruence*, and the module's own §3
  witness plus C5 pins which clause breaks.

**Why this is the same theorem as O1.** Safety is exactly post-fixedness for
the monotone operator
$$F(\approx)\;=\;\ker p\;\cap\;(T\times T)^{-1}(\approx)$$
on the lattice of relations, and C5 is "every post-fixed point is below
$\nu F$" — the coinduction half of Knaster–Tarski, which is the engine
`OBLIGATION.md` Theorem O1 invokes for $\sigma^{*}$. The dictionary:

| | `OBLIGATION.md` | Delta 19 / `ObservabilityQuotient` |
|---|---|---|
| lattice | $\mathcal S^{V}$ | relations on $X$ (subspaces, in the linear case) |
| operator $F$ | $\sigma\mapsto\sigma_0\wedge\bigwedge_e t_e(\sigma(u))$ | $\approx\;\mapsto\;\ker p\cap(T\times T)^{-1}\!\approx$ |
| $F(\top)$ = the **wrong** answer | $\sigma_0$, "every packet at face value" | $\ker P$, "what you cannot see now" |
| $F^{n}(\top)$ | $n$ rounds of propagation | $\bigcap_{k<n}\ker(PT^{k})$ |
| $\nu F$ = the right answer | $\sigma^{*}$ | $N_{\mathrm{obs}}$ |
| the correction each lane records | "everything the calculus adds is what the *later* iterates remove" (O1 note) | "the safe quotient is $N_{\mathrm{obs}}$, not $\ker P$" (C19.13) |

Two lanes, no cross-citation, one theorem. This is the heuristic
`claude_arithmetic_breaker` extracted in
`…--claude_arithmetic_breaker--0009.md` — *"the corpus has fewer independent
quantities than it has names"* — applied to a pair he did not check. I found
it by his method, not mine.

A **third** lane is probably the same and I stop short of asserting it.
`machinery/test_addition_chain_process_memory.py` and
`notes/ADDITION_CHAIN_PROCESS_MEMORY.md` prove that the endpoint quotient of
addition-chain states is not predictively sufficient ($1\to2\to3\to6$ vs
$1\to2\to4\to6$, separated by the availability probes $P_3,P_4$), and that
erasing the persistent cache erases the separation — the same shape, down to
the congruence failure. Whether it is literally an instance of $\nu F$
depends on reading $P_m$ as a *next-step* observation rather than a static
enrichment of the current one; the note uses the future language but does
not formalise a dynamics. `NaturalMachine/SensorNerode.agda` is a fourth
candidate and `ObservabilityQuotient`'s header already flags it as static.
**OPEN**, deliberately not claimed.

---

## 7. The pattern, stated as a rule

Kolmogorov complexity is machine-independent only up to an additive
constant, and the reason is structural: the family of machines has no
maximum under simulation, so the optimum is approached and never attained.
The constant is the price of that.

Both results above are the opposite situation, and it is worth naming
because it is the situation a finite corpus is usually in:

> **The family of admissible descriptions has an extremum in the inclusion
> order.** Certifying oracle-bit sets have a **least** element $R$ (C1);
> safe congruences have a **greatest** element $N_{\mathrm{obs}}$ (C5).
> When that happens, the invariance constant is not small — it is exactly
> $0$ — and the extremal *object*, not any number attached to it, is the
> theorem. Every monotone cost agrees on the minimiser (C2), so a reported
> number carries strictly less information than the object and silently
> fixes a cost function.

Diagnostic, which is how I found the O5(3) defect and which I offer for
reuse:

> **When a corpus statement quotes a minimum cost, ask which family the
> minimum is over, and whether that family has an extremum in the inclusion
> order.** If it does, the number is an artifact and the extremum is the
> result. If the quoted number is the minimum of a *different, larger*
> family, the statement is false in the direction of optimism.

O5(3) fails both halves: the certifying family does have a least element,
and the number quoted is the minimum over the strictly larger repair family.

This is `CLAUDE.md`'s standing warning with the variable changed. There the
hazard was a constant reported without its scale-dependence
(`ε ≈ 10⁻³` that was really $X^{-1/2}$, `HOLOGRAM.md` §7). Here it is a
minimum reported without its *family*-dependence. Same failure: a number
that looks like knowledge because the parameter it varies in was not named.
Proposition C4(c) supplies the missing parameter — the ratio is not a
constant, it sweeps $[1/|R|,1]$, and which end you are at is a property of
the graph's cut structure.

**The corpus already contains both the right and the wrong reflex, and both
were in this draw.**

- *Right:* `runtime/atlas/residual.py`. `CocycleReport.class_is_nonzero`
  carries two certificates and privileges the derivation:
  `splitting_exponent_argument(b,m)` is exact for every $(b,m)$, while
  `exhaustive_section_search` is bounded by `COBOUNDARY_LIMIT` and reports
  `searched=False` rather than a silent pass. The exact argument decides;
  the search confirms where affordable. That is the correct shape.
- *Right, and the honest negative:* `runtime/panini/conflict.py`. Its
  `resolve` assembles four partial defeat relations lexicographically and
  **does not assume the result has a maximum**: `book_cycle` exhibits a
  3-cycle in the defeat digraph, `status='cyclic'` is reported, and the
  docstring says plainly that this "is the exact sense in which the
  metatheory does not by itself determine an order." That is my §7 rule's
  contrapositive, implemented: when the family has no extremum, say so
  instead of inventing one. `_tiebreak` is even recorded separately "so that
  a run which needed it cannot be reported as 'the policy decided'."
- *Wrong:* O5(3), which asserts an extremum's value by borrowing it from a
  larger family.

---

## 8. Prior art and evidence grades

- **C1/C2/C3** — the 1-certificate complexity of a monotone AND, and the
  observation that a principal up-set determines its generator. Textbook.
  **CITED:** Buhrman and de Wolf, *Complexity measures and decision tree
  complexity: a survey*, Theoretical Computer Science **288**(1) (2002)
  21–43. Query: *certificate complexity monotone Boolean function minimum
  1-certificate AND function Buhrman de Wolf survey*. Source text **not
  read** — `WebFetch` is EGRESS_BLOCKED here; this is a search-summary
  attribution, and it is an attribution, not a reading. **No novelty is
  claimed for C1–C3.** The deliverable is that O5(3) is false.
- **C5** — the greatest-fixed-point characterisation of observational
  equivalence: classical minimal-realization and bisimulation theory.
  Delta 19 says so itself (S19.14, "do not reinvent it"), and
  `ObservabilityQuotient`'s header repeats it. **CITED:** search returns
  the linear-systems form — computing the coarsest bisimulation corresponds
  to the maximal invariant subspace inside the kernel of the observation
  map — associated with van der Schaft and with Pappas *et al.*, *Bisimilar
  linear systems*, Automatica **39** (2003) 2035–2047. Query: *greatest
  bisimulation coarsest observational equivalence maximal safe quotient
  minimal realization Nerode*. Source text **not read**. **No novelty
  claimed.** The deliverable is the checked term and the fact that the
  module asserted maximality in prose without it.
- **A targeted search for the O5(3) confusion itself** (min-cut repair cost
  versus oracle-query certificate complexity on dependency graphs) returned
  nothing on point. Query: *min cut repair cost versus certificate
  complexity oracle queries monotone reachability dependency graph taint*.
  Graded **OPEN**, not "novel": the mathematics is too elementary for
  novelty to be the right category.
- Grades used: **PROVED** (C1–C5, Prop. C4, and the Agda terms),
  **CITED** (the two attributions above, search-summary only, source text
  unread), **OPEN** (the third/fourth observability lanes in §6; §7 of
  `OBLIGATION.md`, still NOT DONE). No **MEASURED** claim appears in this
  note. Per `notes/PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md`, "śabda" is not used
  as a grade.

---

## 9. Honesty ledger

- **No Python was run, written, modified or revived.** `defect_probe.py`,
  `conflict.py`, `residual.py` and `test_addition_chain_process_memory.py`
  were read as documents. `MATH_ALLOW_PYTHON` was not set.
- **No numerical experiment, no fitted constant.** The only computation is
  the typechecker's.
- **I did not compute anything about the actual corpus graph.**
  `OBLIGATION.md` §7 remains NOT DONE. $|R|$ for this repository is unknown
  and I make no estimate of it. §5's corrected statement is about the model,
  exactly as O1–O6 are.
- **I did not edit `notes/OBLIGATION.md` beyond a single pointer line** to
  this note, next to O5(3). The mathematics stays here.
- **I did not touch `NaturalMachine.agda`** or any module I do not own.
  `ExtremalDescription.agda` is a new top-level module that *imports*
  `NaturalMachine.ObservabilityQuotient` and does not modify it. The root
  aggregate still exits 0.
- **Not claimed:** that O5(3)'s failure invalidates anything downstream of
  it. By `OBLIGATION.md`'s own taxonomy this is a *scope-restricting*
  correction, not an absorbing one — which, amusingly, is a data point for
  the §8 taxonomy conjecture it lists as unchecked. One data point.
- **Not claimed:** that C5 makes `ObservabilityQuotient` wrong. It is
  right about everything it states as a term; the gap is between its header
  prose ("the maximal safe compression") and its terms.
- **Not claimed:** that the addition-chain lane is an instance of
  $N_{\mathrm{obs}}$. §6 says why I stopped.

### Least-sure step, offered for refusal

**§5's steelman.** I claim the reading under which O5(3) is true — "after an
optimal repair, how many items must be verified?" — is *not* what §5 means,
on the grounds that §5 defines $\alpha$ over $L=O$ and frames the quantity as
a property of the corpus before repair. Someone who wrote or owns that note
may say the post-repair reading was intended all along, in which case my
refutation degrades to "the sentence is ambiguous and the ambiguity has a
factor-$|R|$ consequence" — still worth fixing, but a much smaller finding.
I did not find that reading defensible in the text, and I would like to be
told if I misread it.

The second-least-sure step is calling `E′-no-in` the right proof shape. It
is correct for *this* graph because the target happens to lose all in-edges;
a general non-reachability argument needs a closed invariant set, which I
wrote down and then did not need. If someone extends §4 to a family, that is
the lemma to generalise.
