# $\Phi_{\mathrm{refl}}$: the reflection factor, adjudicated

*Derived from the human owner's transmission
`collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md` §D, the
$\Phi_{\mathrm{refl}}$ bullet. The bullet is quoted here **verbatim and in full** —*

> **$\Phi_{\mathrm{refl}}$** — reflection: $T_\alpha\subsetneq T_{\alpha+1}$ if
> $T_{\alpha+1}\vdash\operatorname{Con}(T_\alpha)$.

*— and is not rewritten. Everything below is proof, refutation, or scope-fixing for it.*

Seed 171, 2026-08-15. No computation was run; no Python; no Agda or Lean authored. No PDF
was read: every source below arrived as HTML and is named with the page I read.

---

## 0. Verdict table

| # | item | verdict |
|---|---|---|
| 0 | the tasking's quoted definition `Φ_refl(T) := T + Ref(T)` | **REFUTED as a quotation.** It occurs nowhere in D0016, D0017, D0018 or D0019. §1.0 |
| 1 | which principle "reflection" names | **PARTIAL — split named, three inequivalent readings** (Con, local $\mathrm{Rfn}$, uniform $\mathrm{RFN}$). All three make the tower strictly increase; they differ in *what the tower converges to*, which is the only interesting question about it. §1 |
| 1′ | Con vs. uniform reflection are not interderivable | **PROVED**, witness $T=\mathsf{PA}+\neg\mathrm{Con}(\mathsf{PA})$ (Prop 1.3) |
| 2 | $T_{\alpha+1}\vdash\mathrm{Con}(T_\alpha)\Rightarrow T_\alpha\subsetneq T_{\alpha+1}$ | **PROVED under four hypotheses, of which D0016 states *none*** (Thm 2). Ledger §1.9 found one of the four; §2.3 adds three, one of them (intensionality) not previously recorded anywhere in this corpus |
| 2′ | the converse | **REFUTED**, witness $T+\neg G_T$ (Prop 2.4) — and this is not a pedantic point: it is why $\Phi_{\mathrm{refl}}$ is not a function. §2.5 |
| 2″ | $\Phi_{\mathrm{refl}}$ is an *operation* at all | **REFUTED as displayed.** The bullet is a one-directional *condition on a pair*, not a map $T\mapsto\Phi_{\mathrm{refl}}(T)$; a condition cannot be a factor of a composite. §2.5 |
| 3 | the tower has an ordinal length, canonically | **CLASSICAL, and the classical answer is no.** Turing 1939, Feferman 1962; the theories depend on the *computable presentation* of $\alpha$, not on its order type (§3.2, sources read) |
| 3′ | completeness of the tower | **CLASSICAL, and epistemically vacuous**: recognising the notation is at least as hard as recognising the truth (Rathjen–Sieg, read). §3.3 |
| 4 | $\Phi_{\mathrm{tr}}\circ\Phi_{\mathrm{ctr}}\circ\Phi_{\mathrm{refl}}\circ\Phi_{\mathrm{cut}}$ is well-typed | **REFUTED.** $T$ does not occur in $\Diamond_\alpha=(X,\mathcal F,\mathcal T,e,\rho,\Pi,\mathcal O)$; $\Pi$ is the only candidate and is disqualified by a note already in the corpus (§4.2). Same severity as the $\partial$/coend and adjoint-string type errors already adjudicated |
| 5 | what $\Phi_{\mathrm{refl}}$ adds to D0017's Gödel column | **one thing only**, and it is negative: it needs $T$ *presented*, which the column's Lawvere reading does not supply. §5 |

**Scope limits, stated up front.** Everything below concerns first-order theories in the
language of arithmetic and the standard Hilbert–Bernays–Löb (HBL) provability predicate.
Nothing here touches $\Phi_{\mathrm{tr}}$, $\Phi_{\mathrm{ctr}}$ (adjudicated separately in
`notes/CENTRE_AND_YANG_BAXTER_DEFECT.md`) or $\Phi_{\mathrm{cut}}$; nothing here decides
whether $\Phi_{\mathrm{refl}}$ *should* be a factor of $\Phi_\alpha$, only that as displayed
it cannot be one. I prove no ordinal-analytic result: §3 is reportage of read sources, not
new mathematics.

**A race, not a phantom — recorded exactly, because standing check (b) cuts both ways.** At
the moment I began, **neither** `notes/ORDINAL_LADDER_SMALLNESS.md` nor
`notes/BOUNDARY_OPERATOR_TYPING.md` existed on disk; both appeared during this pass (seed165
and seed170, commits within the hour). Had I written the verdict at first check I would have
recorded two phantoms and been wrong. I re-checked before committing and read both. What they
establish:

- `ORDINAL_LADDER_SMALLNESS.md` refutes §C/§E's ladder on prior grounds — $\mathfrak F$ is not
  a functor (three independent reasons), $\mathrm{Fix}(\mathfrak F)=\emptyset$ by rank, and
  its §7 states explicitly that it **did not treat**
  "$\Phi_{\mathrm{tr}}/\Phi_{\mathrm{ctr}}/\Phi_{\mathrm{refl}}$ individually". So §3 below is
  an extension, not a duplication: it adds the one obstruction to the ladder that comes from
  the reflection factor specifically (notation-dependence, §3.2), which that note does not
  raise and could not, since it does not treat $\Phi_{\mathrm{refl}}$.
- `BOUNDARY_OPERATOR_TYPING.md` confirms $\partial$ ill-typed **by arity** — each bound
  variable occurs once where a coend needs two. That is a third instance of the pattern §4.2
  Cor 3.1 names, and a sharper one than the two I had.

Neither changes a verdict below; both sharpen §4.

### 0.1 Prior state, verified by reading

`notes/OWNER_TRANSMISSIONS_LEDGER.md` §1.9 already adjudicates this bullet
**CLASSICAL, with a hypothesis the transmission omits**, the omission being
$T_\alpha\subseteq T_{\alpha+1}$ (repeated as ledger §4.12, which says explicitly "**No note
establishes this**"). That verdict is correct and is not disturbed here. This note is the
first to touch the bullet at note length, and it adds: the Ref-principle split (§1), three
further omitted hypotheses (§2.3), the non-functionality of the factor (§2.5), the
notation-dependence of the tower (§3), and the type verdict (§4). §1.9's "with **a**
hypothesis" — singular — is the one thing I correct: there are four, and the one §1.9 names
is the least dangerous of them.

---

## 1. Which principle is $\operatorname{Ref}$?

### 1.0 First, the quotation

The tasking asks me to adjudicate

$$\Phi_{\mathrm{refl}}(T) := T + \operatorname{Ref}(T)$$

as though it stood in D0016 §D beside the inclusion line, and to ask whether "the two lines
are consistent with each other". **There is no such line.** D0016 §D's
$\Phi_{\mathrm{refl}}$ bullet is a single clause, reproduced in full at the head of this
note. A grep of the four owner transmissions (`D0016`, `D0017`, `D0018`, `D0019`) for
`Ref(`, `refl`, `Con(T` returns the §D bullet and nothing else. Likewise the tasking's
"D0016 §E's universe tower $\mathcal U_0\to\mathcal U_1\to\mathcal U_2$" is not in §E — §E
has the quotation functor $\ulcorner-\urcorner_\alpha:\mathcal C_\alpha\to\mathcal
C_{\alpha+1}$; the $\mathcal U_n$ tower is **D0018 §F**, a different transmission.

So the "split rather than choose silently" instruction is well-aimed but misaddressed: the
owner did not write two lines that might disagree. He wrote one line, using $\mathrm{Con}$.
The ambiguity is entirely in the *name* "reflection" attached to a $\mathrm{Con}$ condition,
and that ambiguity is real and worth the section. **Verdict: REFUTED as a quotation; the
underlying question survives and is answered in §1.1–§1.3.** Per the owner-artifact rule I
adjudicate what D0016 says, not what the tasking says it says.

### 1.1 The three readings, and why the name matters

Fix an r.e. theory $T\supseteq\mathsf{EA}$ with a $\Sigma_1$ formula $\mathrm{Prov}_T$
satisfying HBL. The three principles that "reflection" is used for in the literature, in
increasing strength:

- **(R0) Consistency.** $\mathrm{Con}(T):\equiv\neg\mathrm{Prov}_T(\ulcorner\bot\urcorner)$.
  A single $\Pi^0_1$ sentence. *This is what D0016 §D actually writes.*
- **(R1) Local reflection.** $\mathrm{Rfn}(T):=\{\mathrm{Prov}_T(\ulcorner\varphi\urcorner)\to\varphi
  : \varphi\text{ a sentence}\}$. A schema.
- **(R2) Uniform reflection.** $\mathrm{RFN}(T):=\{\forall x\,(\mathrm{Prov}_T(\ulcorner\varphi(\dot
  x)\urcorner)\to\varphi(x))\}$, $\varphi$ arithmetical. Its $\Sigma_1$ fragment
  $\mathrm{RFN}_{\Sigma_1}(T)$ is 1-consistency.

**Proposition 1.2 (R1 $\Rightarrow$ R0; one line, and the only implication that is free).**
Instantiate the local schema at $\varphi=\bot$: $\mathrm{Prov}_T(\ulcorner\bot\urcorner)\to
\bot$, which is $\mathrm{Con}(T)$. Likewise $\mathrm{RFN}\vdash\mathrm{Rfn}$ by taking
$\varphi$ closed. $\square$

**Proposition 1.3 (the converse fails; the three are not interderivable).** Let
$T:=\mathsf{PA}+\neg\mathrm{Con}(\mathsf{PA})$. By Gödel's second theorem $T$ is consistent,
so $\mathrm{Con}(T)$ is **true**. But $T\vdash\neg\mathrm{Con}(\mathsf{PA})$, i.e. $T$ proves
$\exists x\,\mathrm{Prf}_{\mathsf{PA}}(x,\ulcorner\bot\urcorner)$, while for each numeral
$\bar n$ the true $\Sigma_1$-complete theory refutes $\mathrm{Prf}_{\mathsf{PA}}(\bar
n,\ulcorner\bot\urcorner)$. Hence $T$ is $\omega$-inconsistent and $\Sigma_1$-unsound, so
$\mathrm{RFN}_{\Sigma_1}(T)$ is **false**. A true $\mathrm{Con}$ with a false uniform
reflection: the two principles are not the same statement, and no schema derives one from
the other in general. $\square$
*(The $\omega$-inconsistency of $\mathsf{PA}+\neg\mathrm{Con}(\mathsf{PA})$ is the standard
example, given as such on `en.wikipedia.org/wiki/Ω-consistent_theory`, read.)*

### 1.4 What changes under each reading — the split, named

The *strict inclusion* of §D is insensitive to the choice: all of R0, R1, R2 prove
$\mathrm{Con}(T_\alpha)$ (Prop 1.2), so Thm 2 below applies verbatim to each and the tower
strictly increases in all three. **The reading is therefore free for §D's stated purpose and
is not free for anything else**, namely:

| reading | tower | completeness available |
|---|---|---|
| R0 $\mathrm{Con}$ | Turing's consistency progression | $\Pi^0_1$-complete along suitable notations (Turing 1939) |
| R1 local $\mathrm{Rfn}$ | Turing's reflection progression | $\Pi^0_1$; **not** known complete for $\Pi^0_2$ — the problem Turing left open |
| R2 uniform $\mathrm{RFN}$ | Feferman progression | complete for **all arithmetical sentences** (Feferman 1962) |

That is the whole content of the choice, and it is a large content: the difference between
R1 and R2 is the difference between Turing's open problem and Feferman's theorem. **Verdict:
PARTIAL — split named.** D0016 §D is committed to R0 by its own text and thereby to the
weakest of the three; if the framework wants the tower to *reach* anything, it must move to
R2 and say so.

---

## 2. Is the strict inclusion right as stated?

### 2.1 Theorem 2 (PROVED, with hypotheses)

> **Theorem 2.** Let $T_\alpha,T_{\alpha+1}$ be theories in the language of arithmetic such
> that
> **(H1)** $T_\alpha$ is consistent;
> **(H2)** $T_\alpha$ is recursively enumerable, *and a particular $\Sigma_1$ formula
> $\mathrm{Prov}_{T_\alpha}$ numerating it has been fixed*;
> **(H3)** $T_\alpha$ interprets enough arithmetic that $\mathrm{Prov}_{T_\alpha}$ satisfies
> the HBL derivability conditions (D1 provability, D2 distribution, D3 provable
> $\Sigma_1$-completeness);
> **(H4)** $T_\alpha\subseteq T_{\alpha+1}$.
> If $T_{\alpha+1}\vdash\mathrm{Con}(T_\alpha)$ then $T_\alpha\subsetneq T_{\alpha+1}$.

*Proof.* By (H1)–(H3), Gödel's second incompleteness theorem gives
$T_\alpha\nvdash\mathrm{Con}(T_\alpha)$. By hypothesis
$T_{\alpha+1}\vdash\mathrm{Con}(T_\alpha)$, so $\mathrm{Con}(T_\alpha)\in
T_{\alpha+1}\setminus T_\alpha$, whence $T_\alpha\ne T_{\alpha+1}$. With (H4),
$T_\alpha\subsetneq T_{\alpha+1}$. $\square$

The proof is one line from a theorem no reader disputes. That is the point: the content of
the bullet is entirely in its hypotheses, and it states none.

### 2.2 Each hypothesis is necessary — four counterexamples

- **(H1) drops $\Rightarrow$ false.** Take $T_\alpha$ inconsistent and
  $T_{\alpha+1}=T_\alpha$. Then $T_{\alpha+1}\vdash\mathrm{Con}(T_\alpha)$ (it proves
  everything) and $T_\alpha\not\subsetneq T_{\alpha+1}$. The hypothesis the framework most
  needs is the one an *ascending tower whose whole purpose is to certify consistency* can
  least afford to assume silently: if any $T_\beta$ goes inconsistent, every later stage
  "proves" every consistency statement and the ladder collapses to a point while continuing
  to look like it is climbing.
- **(H2) drops $\Rightarrow$ not even a statement.** If $T_\alpha$ is not r.e. there is no
  $\Sigma_1$ $\mathrm{Prov}$, and $\mathrm{Con}(T_\alpha)$ does not denote. The second
  conjunct of (H2) is discussed separately in §2.3 — it is the deepest omission.
- **(H3) drops $\Rightarrow$ vacuous or false.** Presburger arithmetic is consistent,
  recursively axiomatised, **complete and decidable**; it cannot express multiplication and
  so falls outside the incompleteness theorems entirely
  (`en.wikipedia.org/wiki/Gödel's_incompleteness_theorems`, read). For Robinson's $Q$ the
  same page records that systems of that strength "may not satisfy the Hilbert–Bernays
  provability conditions needed for the standard second theorem proof, though Peano
  arithmetic does". So the bullet's inference is not available at the bottom of the
  hierarchy, exactly where a tower must start. *(I make no claim about $Q\vdash\mathrm{Con}(Q)$
  one way or the other; the literature on that is delicate and I did not read it.)*
- **(H4) drops $\Rightarrow$ only $\ne$, not $\subsetneq$.** This is ledger §1.9's finding
  and it is correct: $T_{\alpha+1}=\{\mathrm{Con}(T_\alpha)\}$ alone proves
  $\mathrm{Con}(T_\alpha)$ and contains almost nothing of $T_\alpha$.

### 2.3 The omission the ledger did not record: intensionality

$\mathrm{Con}(T_\alpha)$ is **not a function of the theory $T_\alpha$.** It is a function of
the *formula chosen to numerate its axioms*. This is Feferman's intensionality point and it
is not a technicality here, because §D writes $\mathrm{Con}(-)$ as though applied to a
theory and §C then iterates the construction through the ordinals. Two consequences the
bullet does not survive without amendment:

1. Rosser-style and Feferman-style renumerations of the *same* axiom set yield consistency
   statements of different strength; for suitable numerations of $\mathsf{PA}$ the theory
   proves its own (so-numerated) consistency, and Thm 2's conclusion fails while its stated
   hypotheses appear to hold. Hence (H2)'s second conjunct: **a presentation, not a theory,
   is the argument of $\Phi_{\mathrm{refl}}$.**
2. Therefore $\Phi_{\mathrm{refl}}$ cannot act on $T_\alpha$ *qua* deductively closed set.
   Its domain is r.e. *presentations*. This is the same distinction §4 needs, and it is what
   makes the tower notation-dependent in §3 — the two are one phenomenon, not two.

**This is not recorded in `notes/OWNER_TRANSMISSIONS_LEDGER.md` §1.9, §4.12, or anywhere in
`notes/`** (a grep for `intension` over `notes/` and `collab/` returns hits, but every one of
them is about intensionally-given enumerations in the arithmetic lane; none concerns the
numeration of a provability predicate — checked line by line, not by counting).
It is this note's own, and it is the sharpest of the four omissions because unlike (H1)–(H4)
it is not repairable by adding a clause: it changes what kind of object the factor eats.

### 2.4 Proposition (the converse fails)

> **Proposition 2.4.** $T_\alpha\subsetneq T_{\alpha+1}$ does **not** imply
> $T_{\alpha+1}\vdash\mathrm{Con}(T_\alpha)$.

*Proof.* Let $T=\mathsf{PA}$ and $T_{\alpha+1}:=T+\neg G_T$ with $G_T$ the Gödel sentence.
By D0017's own line $T\nvdash G_T,\ T\nvdash\neg G_T$, so the extension is proper and (by
first incompleteness) consistent. Over $\mathsf{PA}$, $G_T\leftrightarrow\mathrm{Con}(T)$,
so $T_{\alpha+1}\vdash\neg\mathrm{Con}(T)$: it proves the *negation*. $\square$

Note that D0017's other option, $T\to T+\langle G_T\rangle$, *does* satisfy the antecedent
for the same reason — $G_T\leftrightarrow\mathrm{Con}(T)$ — so D0017's own successor step is
an instance of §D's condition only on one of its two branches. Standing check (e) applied:
D0016 writes "if", a single arrow, and I have not upgraded it; the point of Prop 2.4 is
precisely that it *cannot* be upgraded.

### 2.5 Hence: $\Phi_{\mathrm{refl}}$ is not an operation

Every other factor of $\Phi_\alpha$ is displayed as a map: $\Phi_{\mathrm{tr}}$ by an
equation on traces, $\Phi_{\mathrm{ctr}}$ by $Z(U)=\int_x\mathrm{HalfBraid}_U(x)$,
$\Phi_{\mathrm{cut}}$ by an adjunction of operations. $\Phi_{\mathrm{refl}}$ is displayed by
a **sufficient condition relating two theories that are both already given**. By Prop 2.4
the condition does not determine $T_{\alpha+1}$ from $T_\alpha$: uncountably many $T_{\alpha+1}$
satisfy it (add any consistent set of sentences to $T+\mathrm{Con}(T)$) and many proper
extensions fail it. **A binary condition is not a unary operation, and cannot be composed.**
$\Phi_\alpha=\Phi_{\mathrm{tr}}\circ\Phi_{\mathrm{ctr}}\circ\Phi_{\mathrm{refl}}\circ\Phi_{\mathrm{cut}}$
therefore fails to parse before one even asks what its argument is.

The minimal repair, and the one the tasking's phantom line was reaching for, is to *choose*
$\Phi_{\mathrm{refl}}(T):=T+\mathrm{Con}(T)$ (or $T+\mathrm{RFN}(T)$, per §1.4) and demote
the displayed line to its **corollary**, which is exactly Thm 2. I flag that as a repair
available to the owner, not as what he wrote.

---

## 3. Does the tower have an ordinal length, and is it well-defined?

**Verdict: CLASSICAL, and the classical answer is: it has a length only relative to a chosen
system of notations, and it is not canonical.** Sources below were read as HTML.

### 3.1 What is classical

- **Turing 1939**, *Systems of Logic based on Ordinals* (Princeton thesis 1938). Progressions
  of theories indexed by Kleene notations, each stage adding a consistency (or local
  reflection) axiom. Turing proved: for every true $\Pi^0_1$ sentence $\varphi$ there is a
  notation $a_\varphi$ **of ordinal rank $\omega+1$** with $T_{a_\varphi}\vdash\varphi$
  (Rathjen–Sieg, *Proof Theory* SEP appendix B, read).
- **Feferman 1962**, *Transfinite recursive progressions of axiomatic theories*, JSL 27,
  259–316. Replacing local by **uniform** reflection, the progression is complete for **all**
  arithmetical sentences, with $\omega^{\omega^{\omega+1}}$ an upper bound on the order type
  along which one must iterate (SEP appendix B; arXiv:2405.09275 HTML via ar5iv, read).

### 3.2 The key fact: notation-dependence

Quoted from `ar5iv.labs.arxiv.org/html/2405.09275` (*Feferman's completeness theorem*), read:

> "at each step of the inductive definition, one has to pick a c.e. axiomatization of
> $\mathsf{Rfn}^\alpha(T)$. Thus $\alpha$ has to be a computable ordinal with a fixed
> computable presentation, hence the theories $\mathsf{Rfn}^\alpha(T)$ depend not only on
> the order-type of $\alpha$ but also on the particular computable presentation."

and

> "the construction of theories $\mathsf{Rfn}^\alpha(\mathsf{PA})$ has an intensional
> character: their consequences depend not only on the order type of $\alpha$ but also on the
> choice of a particular computable presentation."

This is §2.3's intensionality, iterated. Three consequences for D0016:

1. **"$T_\alpha$" is not well-defined by $\alpha$.** D0016 §C indexes the whole ladder by
   ordinals and §E takes $\mathrm{hocolim}_{\beta<\lambda}$ at limits. For the reflection
   factor that colimit is not a function of $\lambda$; it is a function of a path through
   Kleene's $\mathcal O$. Different paths of the same order type give incomparable theories.
2. **The index set is not an ordinal.** $\mathcal O$ is a partial order, not linear, and is
   $\Pi^1_1$-complete; a *path* must be chosen and choosing one is not an arithmetical act.
   D0016 §E's "$\mathbf{Ord}_{<\kappa}$" with $\kappa$ unspecified (§J4 already flags $\kappa$)
   is doing work here that the notation hides.
3. **Turing's completeness is bought with the notation, not with the height.** The
   $\Pi^0_1$-completeness sits at rank $\omega+1$ — the height is trivial; the pathology is
   entirely in which notation of that rank is used.

### 3.3 And the completeness is epistemically empty

Rathjen–Sieg, SEP *Proof Theory* appendix B, read:

> "recognizing an $a\in\mathcal O$ with $T_a\vdash\psi$ is at least as hard as recognizing
> that $\psi$ is true."

So the tower does not convert unprovability into provability at any usable cost; it relocates
the difficulty into notation selection. Any use of $\Phi_{\mathrm{refl}}$ in this framework
as a *mechanism of advance* — §G's $\mathrm{UsefulEscape}>0$ — has to face this: the escape is
real and its price is exactly the thing escaped from. **This is the reflection-factor analogue
of §G's own anti-degeneracy slogan**, and I record the parallel as an analogy only, not as a
shared theorem — following ledger §1.11, which refuted precisely that kind of identification
when it was made too strongly for §J5.

### 3.4 Relation to `ORDINAL_LADDER_SMALLNESS.md` (seed165, read)

That note refutes the ladder for reasons *upstream* of everything here: $\mathfrak F$ is not a
functor, so there is no direct system to index at all, and $\mathrm{Fix}(\mathfrak F)=\emptyset$
by rank. Its §7 records $\Phi_{\mathrm{refl}}$ as untreated. **The addition here is
independent of all of that and survives every repair it proposes:** even granting a functorial
$\mathfrak F$ and a set-sized $\kappa$, §3.2 says the reflection factor still does not give
$T_\alpha$ as a function of $\alpha$, because it imports Kleene's $\mathcal O$ — a
$\Pi^1_1$-complete partial order, not an ordinal — into the index. Two obstructions of
different kinds at the same place; neither implies the other. Smallness of $\kappa$ is that
note's question and is untouched here.

---

## 4. Is the composite well-typed?

### 4.1 The question

$\Phi_\alpha$ acts on the stage $\Diamond_\alpha=(X_\alpha,\mathcal F_\alpha,\mathcal
T_\alpha,e_\alpha,\rho_\alpha,\Pi_\alpha,\mathcal O_\alpha)$ (D0016 §A), and appears in
$\mathfrak F_\alpha=\ulcorner-\urcorner\circ\vee\circ\Phi_\alpha\circ\Gamma\circ\delta\circ\partial$
(§E). $\Phi_{\mathrm{refl}}$'s argument is a formal theory $T_\alpha$. **Where in the
septuple is $T_\alpha$?**

### 4.2 Theorem 3 (type error)

> **Theorem 3.** Under the only typing of $\Pi_\alpha$ that has been given in this corpus,
> no component of $\Diamond_\alpha$ is an r.e. presentation of a first-order theory. Hence
> $\Phi_{\mathrm{refl}}$ has no argument in the object $\Phi_\alpha$ acts on, and the
> composite $\Phi_{\mathrm{tr}}\circ\Phi_{\mathrm{ctr}}\circ\Phi_{\mathrm{refl}}\circ\Phi_{\mathrm{cut}}$
> is ill-typed.

*Proof.* $X,\mathcal F,\mathcal T$ are sets (points, features, tests); $e:\mathcal
F\times\mathcal T\to Q$ is a Chu matrix; $\rho$ is the transition/holonomy datum of §B;
$\mathcal O_\alpha=\int^{\sigma}\delta_\sigma$ is an obstruction, a coend of defects. None of
these is a set of sentences. $\Pi_\alpha$ is the only candidate, being called an argument or
proof datum, and `notes/ADVANCE_CONJUNCTS_DEFINED.md` §4.1 Def 1 fixes it — under the
explicit finding that "D0016 supplies no type for $\Pi_\alpha$" — as a **finite** set of
proof records $\pi=(c_\pi,S_\pi)$, where $c_\pi$ is a *separation or identification claim*
$\mathrm{sep}(x,x')$ or $\mathrm{id}(x,x')$ about points of $X_\alpha$ and $S_\pi\subseteq
\mathcal T_\alpha$ is a citation. Three obstructions to reading this as a theory, any one
sufficient: (i) it is finite, so it has no nontrivial deductive closure and, being finite and
consistent, is trivially certified — $\mathrm{Con}(\Pi_\alpha)$ is decidable, not
independent, and Gödel's second theorem does not apply; (ii) its claims are Chu-separation
statements, not arithmetic, so it does not interpret $Q$ and (H3) fails; (iii)
$\mathrm{Verify}(\Pi_\alpha)$ is defined semantically against $e_\alpha$, not by derivation
from axioms, so there is no $\mathrm{Prov}_{\Pi_\alpha}$ to numerate and (H2) fails. $\square$

**Corollary 3.1.** The failure is at the same level as the three type errors already
adjudicated in this corpus — the coend $\int_{x\in U}\mathrm{HalfBraid}_U(x)$ over a
non-functorial variable (`CENTRE_AND_YANG_BAXTER_DEFECT.md` Thm 1), the cyclic adjoint string
(`OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Thm 5), and $\partial\Diamond_\alpha:=\int^{(f,t)}
e_\alpha(f,t)$, whose bound variables occur once where a coend requires two
(`BOUNDARY_OPERATOR_TYPING.md`, read after it appeared mid-pass). In all four the displayed
formula names an operation whose argument does not exist in the stated type. That is now four
independent instances in D0016–D0017, which is a pattern rather than a slip, and I say so as a claim
subject to audit (standing check (f)): **the transmissions' composites are written by naming
plausible operations and juxtaposing them, and the juxtapositions have not been type-checked.**

**Corollary 3.2 (a second mismatch, independent of $T$).** Even granting a theory component,
the composite's internal order fails: $\Phi_{\mathrm{cut}}$ outputs a recut Chu datum
$(\mathcal F,\mathcal T,e)$, $\Phi_{\mathrm{ctr}}$ consumes a monoidal category with a chosen
$R$, and $\Phi_{\mathrm{refl}}$ sits between them. No coercion between these is given.

### 4.3 The one place a theory could live

§E's quotation functor $\ulcorner-\urcorner_\alpha:\mathcal C_\alpha\to\mathcal C_{\alpha+1}$
is the framework's only syntax-producing operation, and D0018 §F's
$Q_n:\mathcal U_n\to\mathrm{Code}_{n+1}(\mathcal U_n)$ with $E_{n+1}Q_n(X)\simeq X$ is the
same idea with a universe tower attached. If $T_\alpha$ is to be anything, it is the image of
a stage under $\ulcorner-\urcorner$. **D0016 never makes that identification**, and until it
is made, §4.2 stands. Making it is a live repair and I do not make it here: it would require
saying which sentences $\ulcorner\Diamond_\alpha\urcorner$ consists of, whether that set is
r.e., and whether it interprets $Q$ — the three hypotheses of Thm 2 again, now as design
constraints on the quotation functor rather than as omissions. **OPEN, and that is what would
settle it.**

---

## 5. What $\Phi_{\mathrm{refl}}$ adds to D0017's Gödel column

`notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` (read) settles: the logical half
$\Delta_e\leftrightarrow G_T$ **is** a theorem and is Lawvere 1969; the geometric half is a
chain of one-way maps; the bridge is provably trivial (any bridge natural in restriction is
the zero map). I do not reopen any of that.

$\Phi_{\mathrm{refl}}$ adds exactly one thing to that column, and it is a constraint rather
than a result. Lawvere's fixed-point theorem is *extensional*: it needs a cartesian closed
category and a point-surjection, and it produces $G_T$ without any reference to how the axioms
of $T$ are numerated. $\Phi_{\mathrm{refl}}$, by §2.3 and §3.2, cannot be stated at all
without a fixed r.e. presentation. **So the Gödel column's own bridge — already trivial in the
restriction-natural sense — cannot even be attempted for $\Phi_{\mathrm{refl}}$: the diagonal
half is presentation-free and the reflection half is presentation-bound.** The tower is
strictly more intensional than the fixed-point theorem that motivates it, which is the precise
sense in which "$T\to T+\langle G_T\rangle$" (D0017) and "$T_\alpha\subsetneq T_{\alpha+1}$"
(D0016 §D) are *not* the same step, though the transmissions place them side by side.

---

## 6. Summary of what the owner must decide

1. **Which principle** (§1.4): R0 as written buys the weakest tower; R2 is the one with
   Feferman's theorem behind it. The bullet should name one.
2. **Whether $\Phi_{\mathrm{refl}}$ is a map or a corollary** (§2.5). If a map, define
   $T\mapsto T+\mathrm{Con}(T)$ (or $+\mathrm{RFN}(T)$) and let the displayed line be its
   consequence.
3. **What $T_\alpha$ is inside $\Diamond_\alpha$** (§4.3). Until this is answered the
   four-factor recut of §D is not a composite.

None of these is a computation, and none was performed.
