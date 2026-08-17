# The three untouched regions adjudicated: D0016 §H, D0016 §I, D0017 §E's pentagon layer

**Status.** Seventeen claims, each given exactly one verdict. One PROVED (finite
counterexample), one REFUTED (finite counterexample), three CLASSICAL, four PARTIAL (each
with its split named), eight PROGRAMME (each said to be notation, and said so explicitly
rather than by default). One out-of-scope refutation found in passing and flagged as such.

**Source.** Repository owner, transmissions `D0016` §§H, I
(`collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md`, lines 150–200) and
`D0017` §E (`collab/upstream/raw/D0017-owner-hieroglyphics-2026-08-14.md`, lines 62–88).
Owner artifacts: this note derives from them and does not rewrite them. Every display below
is quoted, not paraphrased.

**Mandate.** `notes/OWNER_TRANSMISSIONS_LEDGER.md` §6 items 2 and 3 name these three regions
as the ledger's own scope limit, with the words "PROGRAMME here means *nobody looked*, not
*looked and found nothing*". This note looks.

**Correction to the ledger, made by reading and not by trusting.** The ledger §6.2 says "no
note touches them". Two notes touch §H in passing, and I read both:
`notes/ADVANCE_UNDER_REPLACEMENT.md` §3.4 (line 245) and
`notes/ADVANCE_CONJUNCTS_DEFINED.md` §6.1 (line 344) both quote §H clauses 5 and 6 as
*evidence of the owner's intent* for the `UsefulEscape` conjunct. Neither adjudicates any of
the six invariants, and neither claims to. The ledger's verdict of "unreached" survives; its
literal sentence does not, and the difference matters because §6 below inherits a real
theorem from `ADVANCE_CONJUNCTS_DEFINED` that constrains what §H clause 4 can ever become.

**No Python was written or run. No Agda or Lean was authored. No PDF was decoded.** Mac Lane
1963/1971, Bénabou 1967, Grothendieck's descent, Isbell 1960 and the co-Yoneda lemma are
cited from their standard statements, which I write out in full where used so that the reader
can check the use against the statement without taking my word for either. No book was opened
in this container; where a source is named, that is what the naming means.

---

## 0. The standard the ledger set, restated so I can be held to it

PROVED (with the hypothesis it needs) · REFUTED (with the counterexample) · CLASSICAL (with
the statement, written out) · PARTIAL (**always with the split named**) · OPEN (with what
would settle it) · PROGRAMME (notation awaiting content: no truth value is available because
the terms do not denote).

One addition, forced by the material and declared here rather than smuggled in later. Several
displays in §H and §I are **stipulative definitions** (`:=`, or `⟺` introducing a new name).
A stipulation cannot be PROVED or REFUTED; it can only be *well-formed* or not. I therefore
class a stipulation as PROGRAMME when a symbol in its definiens does not denote, and I say
which symbol. Where a stipulation nonetheless carries a smuggled assertion — an exhaustiveness
claim, a type — I split that assertion out as its own entry and give it a real verdict. Entry
H7 below is exactly such a split, and it is the only REFUTED in §H.

---

## 1. §H, clause 1 — illumination $= e_X(-,t)$

**Verdict: PARTIAL. The split: it is a well-formed and evaluable definition; it is not an
invariant.**

*Evaluable half.* Given a concrete Chu space $(X,\mathcal T,e:X\times\mathcal T\to Q)$ and a
test $t\in\mathcal T$, the expression $e_X(-,t)$ denotes the function $x\mapsto e(x,t)$, an
element of $Q^X$ — the $t$-column of the matrix. Nothing is missing. On the $2\times2$
Boolean space $e(x_0,t_1)=0$, $e(x_1,t_1)=1$, $e(-,t_2)\equiv 0$ of
`SHRINKING_TESTS_LOWER_CURVATURE.md` §5 (E1), illumination at $t_1$ is $(0,1)$ and at $t_2$
is $(0,0)$. This is the **only one of the six that can be evaluated on a concrete Chu space
as written**, and it is worth saying plainly that one of six is not zero.

*Non-invariant half.* An invariant of a Chu space must be a function of the space alone. Two
things go wrong. (i) $t$ is free: the display fixes no quantifier, so "illumination" names a
$\mathcal T$-indexed family of values, not a value. (ii) Even with $t$ fixed, a Chu
isomorphism $(\varphi:X\to X',\psi:\mathcal T'\to\mathcal T)$ with
$e'(\varphi x,t')=e(x,\psi t')$ moves the column, so $e_X(-,t)$ is not preserved: on
$X=\{x_0,x_1\}$, swapping the two points is an automorphism of the *space*
$\{(0,1),(1,0)\}$ as a set of columns while sending the column $(0,1)$ to $(1,0)$.

*What it needs to become an invariant, exactly.* Quantify: the **column set**
$\operatorname{Col}(e):=\{e(-,t) : t\in\mathcal T\}\subseteq Q^X$, taken up to the induced
bijection on $X$ — equivalently the kernel partition family. This is a Chu-isomorphism
invariant by construction, and it is the object every theorem in
`SHRINKING_TESTS_LOWER_CURVATURE.md` and `CHANGING_TESTS_VERSUS_SHRINKING.md` actually uses
(the relation $\sim_S$ is a function of $\operatorname{Col}$ restricted to $S$). So the repair
is not merely available; the corpus has already been using the repaired object under another
name for three notes.

**Ground.** Direct inspection of the definition against the definition of Chu morphism in
D0016 §F. No prior note; settled here.

---

## 2. §H, clause 2 — fire $=\operatorname{SpecSep}(e_X(-,t))$

**Verdict: PROGRAMME, and genuinely so: $\operatorname{SpecSep}$ is a name that occurs
exactly once in the corpus, namely here.**

**Ground, and it is a search, so I state its extent.** A case-sensitive scan of every `.md`
in the repository for `SpecSep` returns one line: D0016 §H itself. The transmission's §G
defines $\operatorname{SearchSep}$ — one letter and one syllable away — and §G's
$\operatorname{SearchSep}$ *is* adjudicated (ledger §1.5, §1.6). **I do not repair the string.**
The provenance rule in `ADVANCE_UNDER_REPLACEMENT.md` §3.3 is the right precedent: a
missing argument is "not a transcription slip to be repaired by an agent; it is the state of
the artifact". So too here. I record only that if $\operatorname{SpecSep}$ were
$\operatorname{SearchSep}$, the display would still be ill-typed: §G's
$\operatorname{SearchSep}$ takes a **test set** $\mathcal T_\alpha$, and §H hands it a
**single column** $e_X(-,t)$, which is not a test set. So the two readings available are
(a) a genuinely new undefined predicate, or (b) $\operatorname{SearchSep}$ applied to an
argument of the wrong type. Both are PROGRAMME; neither is a slip that fixes itself.

*What it would need.* A predicate on $Q^X$. The natural completion is
$\operatorname{SepPower}(c):=\ker(c)$, the partition of $X$ induced by the column $c$, ordered
by refinement; then "fire" is *how much a single test resolves*, and clause 2 becomes the
one-test case of the resolving-power preorder of `CHANGING_TESTS_VERSUS_SHRINKING.md` Thm E.
That completion is evaluable, invariant in the sense of §1 above, and already has theorems.
I offer it as a completion and claim nothing about the owner's intent.

---

## 3. §H, clause 3 — scintillation $=\Delta_\rho\operatorname{Spec}(e_X)$

**Verdict: PROGRAMME.** Two undefined symbols in one display: $\operatorname{Spec}$ and
$\Delta_\rho$. $\operatorname{Spec}$ appears nowhere else in D0016; $\Delta$ appears only in
clauses 5–6 of this same section, and $\Delta_\rho$ nowhere. $\rho$ is a component of
$\Diamond_\alpha$ (§A) and is the holonomy datum, so the intended shape is legible — *the
change in the spectrum induced by transport* — but legible intent is not denotation.

*What it would need.* A definition of $\operatorname{Spec}$ on a $Q$-valued matrix. The
honest observation is that there are at least three inequivalent candidates already live in
this corpus and the transmission chooses none: the column set of §1; the concept lattice of
the formal context (the Birkhoff polarity of ledger §1.2); and, when $Q$ is a field, the
literal spectrum of $e$ as a linear map, which is what `LEAKAGE_RANK_IS_INCIDENCE_RANK.md`
works with. These give three different scintillations. A note that picked one and did not say
so would be exactly the failure `CLAUDE.md` was written against.

---

## 4. §H, clause 4 — brilliance $=\operatorname{EscapeValue}(\text{internal recursive path})$

**Verdict: PROGRAMME — but a *constrained* PROGRAMME, and the constraint is a theorem someone
else proved.**

$\operatorname{EscapeValue}$ is undefined and "internal recursive path" is undefined. That is
the verdict. What makes this entry worth more than the previous two is that the space of
admissible completions is not free.

`notes/ADVANCE_CONJUNCTS_DEFINED.md` §6.2 (Theorem U, read in full) proves: if $U$ assigns to
each step a value in a poset with distinguished $0$, and $U$ depends on the step only through
$(\sim_{\mathcal T_\alpha},\iota,\sim_{\mathcal T_{\alpha+1}})$, then $U$ is **constant** on
every step whose two ends satisfy $\operatorname{SearchSep}$ with $\iota=\mathrm{id}$ — so
"$U>0$" is vacuous or unsatisfiable on precisely the advancing runs. §H clause 4 is
$\operatorname{UsefulEscape}$ under another name (this identification is
`ADVANCE_UNDER_REPLACEMENT.md` §3.4's, not mine, and I checked it against both texts). Hence:

**Corollary 4.1.** Any definition of $\operatorname{EscapeValue}$ as a poset-valued function
of the resolving power of the test sets is *already refuted* as a progress measure by Theorem
U. A completion of clause 4 must therefore read $e$ or $\partial$ beyond $\sim$, or restrict
the steps. This is not a new theorem; it is the observation that the untouched region and the
worked region overlap, and that the untouched one inherits the worked one's no-go.

---

## 5. §H, clause 5 — trapped-light $\iff \Delta\partial_{\mathrm{future}}=0$

**Verdict: PROGRAMME.** A stipulative definition of a new name whose definiens contains two
symbols that do not denote — $\Delta$ (no definition anywhere in D0016) and, more seriously,
$\partial_{\mathrm{future}}$, which occurs only here and is not the $\partial$ of §B.

**And the base symbol is worse than undefined; it is ill-typed.** §B gives
$\partial\Diamond_\alpha:=\int^{(f,t)\in\mathcal F_\alpha\times\mathcal T_\alpha}e_\alpha(f,t)$.
A coend $\int^{x}F(x,x)$ requires a **bifunctor** $F:\mathcal C^{op}\times\mathcal C\to
\mathcal D$; the transmission supplies $e_\alpha:\mathcal F_\alpha\times\mathcal T_\alpha\to
Q_\alpha$, a functor of a *single* variance. So $\int^{(f,t)}e(f,t)$ is not a coend. Read
charitably as a colimit, $\partial\Diamond=\operatorname{colim}_{\mathcal F\times\mathcal T}e$,
it is evaluable — and on a **bare** Chu space, where $\mathcal F$ and $\mathcal T$ carry no
morphisms, the colimit over a discrete category is the coproduct
$\coprod_{(f,t)}e(f,t)\cong \mathcal F\times\mathcal T$, which **forgets $e$ entirely**. So
the charitable reading is degenerate exactly on the objects §F says are the part with
immediate content. A non-degenerate reading needs $\mathcal F$ and $\mathcal T$ to be genuine
categories and $e$ to be functorial, at which point $\partial\Diamond$ is the set of matrix
entries modulo the equivalence generated by the morphisms — a real and computable object, and
one the transmission nowhere says it wants.

This defect is inherited by clauses 5 and 6 and by nothing else in §H.

---

## 6. §H, clause 6 — productive-reflection $\iff \Delta\partial_{\mathrm{future}}\ne0\wedge\operatorname{Verify}=1$

**Verdict: PROGRAMME**, for the reasons of §5, with one component that *does* denote:
$\operatorname{Verify}$ is defined — in its citation-rigid reading — by
`ADVANCE_CONJUNCTS_DEFINED.md` §5, which I read. So clause 6 is one undefined symbol away
from evaluable, and clause 5 is the undefined symbol.

---

## 7. §H — the smuggled assertion: clauses 5 and 6 are not a dichotomy

**Verdict: REFUTED**, as the only genuine truth-apt claim in §H.

The two clauses are set out as an opposed pair — trapped versus productive — and the
surrounding prose of the transmission treats them as the two outcomes of a step. Read as an
exhaustive dichotomy, the pair is **false**, and the counterexample is a truth table, which is
a finite exhaustive verification and therefore proof:

| $\Delta\partial_{\mathrm{future}}$ | $\operatorname{Verify}$ | named by §H |
|---|---|---|
| $=0$ | $0$ | trapped-light |
| $=0$ | $1$ | trapped-light |
| $\ne0$ | $1$ | productive-reflection |
| $\ne0$ | $0$ | **nothing** |

The fourth row — the boundary moved and the verification failed — is the interesting one, and
§H has no name for it. The pair is exhaustive iff $\operatorname{Verify}\equiv1$ whenever
$\Delta\partial_{\mathrm{future}}\ne0$, which is a substantive claim about $\Pi$ that the
transmission neither states nor could state, since $\operatorname{Verify}$ is a function of
$\Pi$ and $\Delta\partial$ is a function of the Chu datum
(`ADVANCE_UNDER_REPLACEMENT.md` §3 types them as **disjoint** arguments — that disjointness is
exactly why the fourth row cannot be excluded).

**Ground.** The typing is `ADVANCE_UNDER_REPLACEMENT.md`'s, read and quoted; the table is
mine; the conclusion needs nothing else. Note what is and is not refuted: the two
*stipulations* stand, as stipulations always do. What is refuted is their jointly exhausting
the cases, and hence any use of "not trapped" as a synonym for "productive".

---

## 8. §I, first claim — ज्ञेयम $\not\subset$ एकदृष्टिः

*(The knowable is not contained in a single view. Note: the transmission's symbol is
$\not\subset$; the ledger and the mandate render it $\not\simeq$. I adjudicate the artifact's
symbol.)*

**Verdict: PROVED**, under the only reading §I makes available, by a two-object
counterexample.

**Reading, stated and defended.** §I supplies exactly one formal notion of "view":
$\mathfrak M_i=\operatorname{Map}(-,i)\otimes\operatorname{Map}(i,-)$, the object $i$ presented
through its two representables. एकदृष्टिः — a single view — is then $\mathfrak M_i$ for one
fixed $i$; ज्ञेयम, the knowable, is what the whole family $\{\mathfrak M_i\}_{i\in J}$
presents, which the next display identifies with $\int^i(\mathfrak M_i^\vee\otimes\mathfrak M_i)$.
So the claim is: **a single object is not in general dense.** This reading is forced by §I's
own two displays and by nothing else; it is the weakest under which the slogan is a
mathematical statement.

**Theorem 8.1.** There is a small category $J$ and no object $i\in J$ such that the inclusion
$\{i\}\hookrightarrow J$ is dense.

*Proof.* Let $J$ be the discrete category on two objects $\{a,b\}$. Fix $i\in\{a,b\}$; say
$i=a$. Density of $\{a\}$ requires the canonical map
$\operatorname{colim}_{(a\to b)\in \{a\}/b}a\to b$ to be an isomorphism. The indexing comma
category has objects the morphisms $a\to b$, of which there are none; the colimit over the
empty diagram is the initial object of $J$, which does not exist. Hence the canonical map is
not an isomorphism (it does not exist), and $\{a\}$ is not dense. By symmetry neither is
$\{b\}$. $\square$

**And the same in the corpus's own idiom, which is shorter.** In the Chu language: a single
test $t$ separates $X$ iff $\ker(e(-,t))=\Delta_X$, and the space E1 of
`SHRINKING_TESTS_LOWER_CURVATURE.md` §5 has no such column. One test is not a separating test
set. The two arguments are the same argument, and their agreement is worth exactly what an
easy fact proved twice is worth.

**Consistent with the ledger's generalisation** (§7 of the ledger: the transmissions'
*non-implications* survive). This is the only non-inclusion in the three regions, and it
survives. See §16.

---

## 9. §I, second claim — ज्ञेयम $\simeq\int^{i}(\mathfrak M_i^\vee\otimes\mathfrak M_i)$

**Verdict: PARTIAL. The split: CLASSICAL-true under the one-leg reading of $\mathfrak M$;
ill-posed under §I's own two-leg reading.**

### 9.1 The one-leg reading, where it is a theorem

Take $\mathfrak M_i:=\operatorname{Map}(-,i)$ and $\mathfrak M_i^\vee:=\operatorname{Map}(i,-)$
— the Chu duality of §E, $e^\vee(t,f)=e(f,t)$, applied to the two legs. Then

$$\int^{i\in J}\operatorname{Map}(i,-)\otimes\operatorname{Map}(-,i)\;\cong\;\operatorname{Map}(-,-),$$

the identity profunctor. This is the **co-Yoneda lemma** (density theorem): for a profunctor
$P$, $\int^i P(-,i)\otimes\operatorname{Map}(i,-)\cong P(-,-)$; take $P=\operatorname{Map}$.
Statement as I use it: *every presheaf is canonically the colimit of representables over its
category of elements*, equivalently *$\operatorname{Hom}$ is the unit for profunctor
composition*. Mac Lane, CWM, ch. IX §5 (coends) and the Yoneda-density argument there; quoted
from the standard statement, no text opened.

Under this reading the display is **true, classical, and content-free as a slogan**: it says
the knowable is the totality of the relations, which is the assertion that $J$'s hom-profunctor
is $J$'s hom-profunctor. That is not a criticism of the mathematics; it is a statement about
how much the slogan adds to it, which is nothing.

*Variance check, since a coend can be ill-typed and this one is not.* Set
$F(j,i):=\operatorname{Map}(j,-)\otimes\operatorname{Map}(-,i)$; it is contravariant in $j$
and covariant in $i$, so $F:J^{op}\times J\to[\,J^{op}\times J,\mathbf S\,]$ and
$\int^i F(i,i)$ is a legitimate coend. Checked before believing.

### 9.2 The two-leg reading, where it is not well-posed

§I *defines* $\mathfrak M_i:=\operatorname{Map}(-,i)\otimes\operatorname{Map}(i,-)$ — both
legs — and then writes $\mathfrak M_i^\vee\otimes\mathfrak M_i$. With $\vee$ the Chu leg-swap
of §E, $\mathfrak M_i^\vee=\operatorname{Map}(i,-)\otimes\operatorname{Map}(-,i)$ and the
integrand is a **fourfold** tensor
$\operatorname{Map}(i,-)\otimes\operatorname{Map}(-,i)\otimes\operatorname{Map}(-,i)\otimes\operatorname{Map}(i,-)$.
The coend is still formally typeable (two contravariant and two covariant occurrences,
diagonalised), so this is not a variance error. It is worse in a duller way: **there is no
co-Yoneda collapse.** Only one covariant/contravariant pair can be absorbed; what remains is a
coend of $\operatorname{Hom}\otimes\operatorname{Hom}$, which does not simplify, and which
depends entirely on a choice of $\otimes$ that the transmission never makes. Cartesian product
of presheaves, Day convolution, and the pairing $\langle-,-\rangle_i$ of D0018 §D give three
different answers. So under §I's own definition the right-hand side does not denote a
determinate object, and "$\simeq$" has no truth value.

**The split, stated once more so it cannot be compressed away:** the display is a classical
theorem if $\mathfrak M_i$ means the representable, and is ill-posed if $\mathfrak M_i$ means
what §I says $\mathfrak M_i$ means. The reading that makes it true is the reading the
transmission does not use.

---

## 10. §I, third claim — इन्द्रजालम $:=\operatorname{holim}_{\sigma\in N(J)}\mathfrak M_\sigma$

**Verdict: PROGRAMME, with a specific well-formedness gap: $\mathfrak M$ is defined on
objects of $J$, and this display evaluates it on **simplices** of $N(J)$.**

A simplex $\sigma\in N(J)_n$ is a chain $i_0\to i_1\to\cdots\to i_n$. §I gives
$\mathfrak M_i$ for objects only. Extending $\mathfrak M$ to a diagram on $N(J)$ requires a
choice — the value at the initial vertex, the value at the terminal vertex, the limit over
the chain — and these give different homotopy limits already for $J$ the walking arrow. The
display therefore names a construction whose input diagram has not been specified. This is
not pedantry about coherence: it is that two readers will compute two different objects.

*What it would need.* Either $\mathfrak M$ made a functor $J\to\mathcal D$ (then
$\operatorname{holim}_{N(J)}$ is the ordinary $\operatorname{holim}_J$, and the nerve is
decoration), or a genuine cosimplicial object $N(J)\to\mathcal D$ specified simplex-wise.

---

## 11. §I, fourth claim — अनन्तमाला $:=\operatorname{hocolim}_\alpha\mathfrak F^\alpha_\alpha(\Diamond_0)$

**Verdict: PROGRAMME — and *already* PROGRAMME. This is D0016 §C's ordinal ladder, verbatim,
under a new name.**

Ledger §1.13 classifies §C's ladder, $\mathfrak F$, $\mathbb B=\int^\alpha\Diamond_\alpha$ and
$\mathfrak F_{\alpha+1}\succeq\mathfrak F_\alpha$ as PROGRAMME: no convergence, no smallness,
no proof that $\Gamma$ is well defined on $\mathcal O_\alpha$, no value for $\kappa$, no proof
that $\mathfrak F$ is a functor. Every one of those gaps is a gap in this display, because
this display *is* that ladder with $\operatorname{hocolim}$ in place of $\int^\alpha$ and
अनन्तमाला in place of $\mathbb B$. The transmission's own §J6 is the applicable rule:
"Translation is not a result."

I record this as a **finding, not a footnote**: one of the two halves of §I's synchronic/
diachronic pair is a renaming of material the ledger had already classified, and the ledger
did not notice because it classified §I as a block.

---

## 12. §I, fifth claim — $\partial X\ne0\Rightarrow$ मा निरोधः; $\partial X\ne0\Rightarrow\Gamma\langle\partial X\rangle$

**Verdict: PARTIAL. The split: the first implication is not truth-apt; the second is a type
error with a repair, and the repair is PROGRAMME.**

*First conjunct.* मा निरोधः is an imperative — *do not stop*. An implication whose consequent
is a norm is not a proposition of the object language; it is a rule of the framework's
practice. I do not call it false, and I do not call it true. It is outside the fragment the
ledger's vocabulary applies to, and saying so is more useful than forcing a verdict.

*Second conjunct.* $\Gamma\langle\partial X\rangle$ is a **term**, not a proposition, so
"$\partial X\ne0\Rightarrow\Gamma\langle\partial X\rangle$" is not well-formed. This is the
identical defect the ledger found at §1.10 in $\Gamma\langle\operatorname{YB}_\delta(R)\rangle$,
which is now its second occurrence and therefore a pattern rather than a slip. The repair is
forced and I state it: read the consequent as "$\Gamma$ is defined at $\partial X$". Under
that repair the display asserts that $\Gamma$'s domain contains every nonzero boundary — a
substantive claim about $\Gamma$, and PROGRAMME, since ledger §1.13 records that $\Gamma$ is
not shown to be well defined on $\mathcal O_\alpha$ at all.

---

## 13. §I, sixth claim — सीमा $\ne$ अन्तः; सीमा $=$ उत्तररूपस्य योनिः

**Verdict: PROGRAMME, and this is the one place in all three regions where PROGRAMME is the
comfortable verdict rather than the disappointing one.**

*The boundary is not the end; the boundary is the womb of the successor form.* Neither अन्तः
(the end) nor उत्तररूपस्य योनिः (the womb of the successor form) is given any definition
anywhere in D0016. There is a legible intended content — that $\Diamond_{\alpha+1}$ is
generated from $\partial\Diamond_\alpha$, i.e. that $\mathfrak F$ factors through $\partial$ —
and if that is what is meant, then the claim is a **stipulation about $\mathfrak F$**, and
$\mathfrak F$ is exactly what ledger §1.13 records as not shown to be a functor. So the two
identifications are either undefined or a constraint on an undefined object. Notation awaiting
content, stated explicitly, as the mandate requires.

---

## 14. D0017 §E — the pentagon layer

The transmission displays

$$\tau_{jk}\circ\tau_{ij}\overset{\alpha_{ijk}}{\Longrightarrow}\tau_{ik},\qquad
\delta\alpha_{ijkl}=\alpha_{ikl}\circ(\alpha_{ijk}\star1)-\alpha_{ijl}\circ(1\star\alpha_{jkl}),
\qquad \delta\alpha_{ijkl}\ne0\Longrightarrow\mathfrak X\hookrightarrow\mathfrak X[\delta\alpha_{ijkl}].$$

### 14.1 The transport datum — **CLASSICAL**

A family of 1-cells $\tau_{ij}$ with invertible 2-cells
$\alpha_{ijk}:\tau_{jk}\circ\tau_{ij}\Rightarrow\tau_{ik}$ is precisely the data of a
**pseudofunctor** from the indexing (2-)category into the ambient bicategory — equivalently, a
**descent datum** / a normalised 2-cocycle. Statement as used: a pseudofunctor
$F:\mathcal C\to\mathcal B$ assigns to composable $f,g$ an invertible 2-cell
$F g\circ F f\Rightarrow F(gf)$ subject to a coherence condition for each composable triple.
Bénabou 1967 (bicategories, pseudofunctors) and Grothendieck's descent; standard statement,
no text opened. The transmission claims nothing beyond the data, and the data are right.

### 14.2 The coboundary — **CLASSICAL, with an omitted hypothesis, and I checked the pentagon**

**The two composites are parallel, and I verified it rather than assuming it.**
$\alpha_{ijk}\star1$ — whiskering $\alpha_{ijk}:\tau_{jk}\tau_{ij}\Rightarrow\tau_{ik}$ by
$1_{\tau_{kl}}$ — has source $\tau_{kl}\tau_{jk}\tau_{ij}$ and target $\tau_{kl}\tau_{ik}$;
post-composing $\alpha_{ikl}:\tau_{kl}\tau_{ik}\Rightarrow\tau_{il}$ gives
$\tau_{kl}\tau_{jk}\tau_{ij}\Rightarrow\tau_{il}$. Dually, $1\star\alpha_{jkl}$ has source
$\tau_{kl}\tau_{jk}\tau_{ij}$ and target $\tau_{jl}\tau_{ij}$, and
$\alpha_{ijl}:\tau_{jl}\tau_{ij}\Rightarrow\tau_{il}$ gives the same source and target. **Both
composites are 2-cells $\tau_{kl}\tau_{jk}\tau_{ij}\Rightarrow\tau_{il}$.** Further, the four
2-cells appearing are $\alpha_{jkl},\alpha_{ikl},\alpha_{ijl},\alpha_{ijk}$ — exactly the four
2-faces of the tetrahedron on $\{i,j,k,l\}$, each once. The display is the correct
pentagon/tetrahedron coherence expression. It passes.

**The omitted hypothesis, and it is a real scope correction.** The display uses a **minus
sign** between two 2-cells. Subtraction of 2-cells requires the hom-categories of the ambient
bicategory to be enriched in abelian groups. In a general bicategory there is no such
structure and $\delta\alpha$ does not denote; the correct general statement is the **equation**

$$\alpha_{ikl}\circ(\alpha_{ijk}\star1)\;=\;\alpha_{ijl}\circ(1\star\alpha_{jkl}),$$

and "$\delta\alpha\ne0$" must be read as "the two composites differ". So §E's pentagon layer
is **well-formed only in a linear (Ab-enriched, or 2-abelian) setting**, or when the
$\alpha$'s take values in an abelian group $A$ — in which case $\delta\alpha$ is literally the
simplicial coboundary of a 2-cochain on the nerve and its class lives in $H^3(-;A)$, the
standard gerbe/associator anomaly.

**This is the third occurrence of the same omission**, and the pattern is the finding: ledger
§2.1 flags $\delta_\Diamond=hf-kg$ (needs Ab-enrichment), ledger §2.9 quotes
$\partial\triangle_{ijk}=\mathfrak H_{ijk}-1$ (needs the holonomy to live in a ring, not a
group), and this is the third. The transmissions use "$-$" as a generic *difference* operator
across settings that supply no subtraction. That is one scope correction, not three, and it
should be applied wherever the symbol appears.

### 14.3 Pentagon $\ne$ coherence theorem — **CLASSICAL, and a distinction the display elides**

$\delta\alpha=0$ is a **condition**. Mac Lane's coherence theorem is a **consequence**: *in a
monoidal category satisfying the pentagon (and triangle) identities, every diagram built from
associators (and unitors) commutes* (Mac Lane 1963, "Natural associativity and commutativity in
categories"; CWM ch. VII §2; standard statement, no text opened). The transmission writes the
condition and nothing else, which is correct as far as it goes. What does **not** follow, and
is nowhere claimed but is the natural misreading, is that $\delta\alpha=0$ makes the
$\tau$-tower coherent in Mac Lane's sense: coherence for a pseudofunctor tower is a theorem
about *free* structures transported along a strictification, and its hypotheses (the
$\alpha$'s invertible, the indexing category free on a graph or the statement taken up to
the relevant equivalence) are not stated in §E. I record the distinction as the theorem this
region is standing next to, and note that nobody in the corpus has claimed the stronger form.

### 14.4 $\delta\alpha\ne0\Rightarrow\mathfrak X\hookrightarrow\mathfrak X[\delta\alpha]$ — **PARTIAL**

**The split: true but vacuous under free adjunction; false under the quotient reading.**

*Free reading.* $\mathfrak X[\delta\alpha]$ = $\mathfrak X$ with a new 2-cell generator freely
adjoined (a pushout of computads along a generator inclusion). Then $\mathfrak X\to
\mathfrak X[\delta\alpha]$ is faithful, by the normal-form argument for free extensions: no
new relations are imposed, so distinct 2-cells of $\mathfrak X$ remain distinct. But this is
true **whether or not $\delta\alpha\ne0$** — one may adjoin a generator to any $\mathfrak X$.
So the antecedent is idle and the implication carries no information. The hypothesis does no
work; that is the whole objection.

*Quotient / localisation reading*, i.e. $\mathfrak X[\delta\alpha]$ = $\mathfrak X$ with
$\delta\alpha$ inverted or killed, which is the reading under which the slogan "the obstruction
generates a new ambient in which it is resolved" would have content. **REFUTED**, by a finite
counterexample. Let $\mathfrak X$ be the one-object, one-1-cell $\mathbf{Ab}$-enriched
2-category with $\hom(\mathrm{id},\mathrm{id})=\mathbb Z$, and $\delta\alpha=2$. Killing
$\delta\alpha$ gives $\hom=\mathbb Z/2$, and $\mathfrak X\to\mathfrak X[\delta\alpha]$ sends
$0\ne 2\mapsto 0$: not faithful, so not an embedding. Hence "$\hookrightarrow$" fails.

*What would settle the intended claim.* A construction of $\mathfrak X[\delta\alpha]$ with a
universal property, plus a proof that the canonical 2-functor is faithful — which, by the
above, cannot be a quotient and cannot be a free adjunction if the hypothesis is to matter.
The remaining candidate is an extension in which $\delta\alpha$ acquires a *filler* one
dimension up (a 3-cell), i.e. passage from a bicategory to a tricategory; that is a real
construction, it is not what the notation $\mathfrak X[\delta\alpha]$ suggests, and it is not
in the transmission. This is offered as the live option, not as an amendment.

---

## 15. Found while reading, and outside the assigned region — one refutation, flagged as such

D0017 §E also displays $\mathfrak I=\int^{i\in J}\mathfrak M_i$ and
$\mathfrak I\simeq\operatorname{holim}_{\sigma\in N(J)}\mathfrak M_\sigma$. **The $\simeq$ is
false.** A coend is a colimit-shaped construction and a $\operatorname{holim}$ is a
limit-shaped one, and they do not agree.

*Counterexample.* Let $J$ be discrete on two objects and $\mathfrak M_a=\mathfrak M_b=\ast$
(a point) in spaces. Then $\int^i\mathfrak M_i=\coprod_i\mathfrak M_i=\ast\sqcup\ast$, two
points, while $\operatorname{holim}_{N(J)}\mathfrak M=\prod_i\mathfrak M_i=\ast$, one point.
$\ast\sqcup\ast\not\simeq\ast$. $\square$

I flag this as **outside my three regions** — it is §E's indexed-module layer, not its pentagon
layer, and the ledger classes it under §2.9's "not adjudicated". It is recorded here because I
read it and a false display should not survive being read. It should be entered in the ledger
as REFUTED; I have not edited the ledger, since the ledger is a referee artifact and amending
another pass's tally silently is the failure mode this corpus keeps finding.

---

## 16. Testing the ledger's generalisation against these three regions

The ledger's closing sentence: *the transmissions' non-implications survive; their implications
and correspondences carry every error.* The mandate requires me to test it here, not assume it.

**It holds, with one refinement that costs it some of its force.**

| region | form | verdict |
|---|---|---|
| §I: ज्ञेयम $\not\subset$ एकदृष्टिः | non-inclusion | **PROVED** (§8) |
| §I: ज्ञेयम $\simeq\int^i(\mathfrak M^\vee\otimes\mathfrak M)$ | correspondence | PARTIAL, ill-posed as written (§9) |
| §E: $\mathfrak I\simeq\operatorname{holim}$ | correspondence | **REFUTED** (§15) |
| §E: $\delta\alpha\ne0\Rightarrow\mathfrak X\hookrightarrow\mathfrak X[\delta\alpha]$ | implication | PARTIAL: vacuous or false (§14.4) |
| §H: clauses 5, 6 read as a dichotomy | correspondence | **REFUTED** (§7) |
| §E: transport datum, coboundary | data / equation | CLASSICAL and correct (§14.1–2) |

Every implication and correspondence in these regions is defective; the one non-inclusion is
true and provable in three lines. Four for four, on top of the ledger's tally.

**The refinement, and it weakens the generalisation as a predictive claim.** The regions are
*not* mostly implications and correspondences: eight of seventeen claims here are
**stipulations**, and a stipulation has no arrow at all, so the generalisation has nothing to
say about the majority of §H and half of §I. Where the transmissions are most schematic they
are also outside the reach of the pattern that describes them elsewhere. The correct statement
is therefore narrower than the ledger's: *among the truth-apt displays, the non-implications
survive and the implications and correspondences do not* — and in the untouched regions most
displays are not truth-apt. That is not a correction of the ledger's sentence; it is a
restriction of its domain, and the restriction is where the untouched regions live.

**My own generalisation, offered for audit as required.** The three regions differ from the
adjudicated ones in kind, not in quality: §§F, G of D0016 and §§C, F of D0017 are *statements
about a structure*, and §§H, I are *names for parts of it*. The failure mode of the first is a
wrong arrow; the failure mode of the second is an undefined symbol. Both are correctable, but
only the first kind is correctable **by mathematics** — the second requires the owner, because
choosing among three candidate meanings of $\operatorname{Spec}$ is not a theorem, it is a
decision. Hence: **the untouched regions were untouched because they are the owner's to
finish, and no amount of fleet time substitutes.** I claim this as a description of these
seventeen claims and of nothing else; a fourth region might refute it.

---

## 17. Is §I a restatement of the density comonad / codensity monad result?

**No — and the way it fails to be one is itself the finding.**

`notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md` (read in full) identifies D0018 §C's
$\delta_\lhd(X)=\operatorname{cofib}(\operatorname{hocolim}_{i\in J_X}\mathfrak M_i\to X)$ and
$\delta_\rhd(X)=\operatorname{fib}(X\to\operatorname{holim}_{i\in J_X}\mathfrak M_i)$ as the
counit of the **density comonad** $\operatorname{Lan}_G G$ and the unit of the **codensity
monad** $\operatorname{Ran}_G G$, and proves their independence by finite exhaustive
verification. D0016 §I's synchronic/diachronic pair shares that note's vocabulary and its
symbol $\mathfrak M_i$. It is not that result.

**(a) The holim leg is the degenerate case, and degenerate in exactly the place where the
content is.** D0018 §C's $\operatorname{holim}$ is indexed by $X/G$ — the comma category — and
depends on $X$. That dependence *is* the codensity monad: $\operatorname{Ran}_G G$ is a Kan
extension **along $G$**. D0016 §I's $\operatorname{holim}_{\sigma\in N(J)}\mathfrak M_\sigma$
has **no $X$ at all**. A limit over all of $J$ with no comma-category indexing is the right Kan
extension along $J\to 1$, i.e. the end $\int_i\mathfrak M_i$ — an absolute limit, a single
object, not a monad on $\mathcal C$. Deleting $X$ deletes the functoriality, the unit, and
therefore $\delta_\rhd$. §I's synchronic totality is the *value* of the codensity construction
at the terminal indexing, which is the one value that carries no information about
reconstructibility.

**(b) The hocolim leg is not the density comonad at all — it is a different index category.**
D0018 §C's $\operatorname{hocolim}$ is over $J_X$, objects of the relation category. D0016 §I's
$\operatorname{hocolim}_\alpha\mathfrak F^\alpha_\alpha(\Diamond_0)$ is over the **ordinal
ladder**. These are not the same colimit, they are not the same shape of colimit, and the
second is §C-of-D0016's PROGRAMME (§11 above). The synchronic/diachronic pair in §I is
therefore **not** a matched pair of adjoint constructions; it is one absolute limit and one
transfinite iteration, sharing only the words.

**(c) The one place where §I really is a restatement, and it should be said.** §I's second
display, under the one-leg reading of §9.1, is co-Yoneda — and co-Yoneda is the statement that
$\operatorname{id}_J$ is dense. D0018 §C's $\delta_\lhd\equiv0\iff G$ dense specialises at
$G=\operatorname{id}$ to exactly that. So §I's $\int^i(\mathfrak M^\vee\otimes\mathfrak M)$ is
a **restatement of the trivial instance** of the D0018 result — the instance where the answer
is yes for every category and no hypothesis is needed. That is a restatement in the sense
`CLAUDE.md` and D0016 §J6 mean it, and it is recorded as one.

Summary sentence, which I would defend under audit: *§I is not the density/codensity pair
restated; it is that pair with its argument deleted from one leg and its index category
replaced on the other, plus a restatement of the pair's trivial case.* Anyone tempted to read
§I as a second, independent arrival at the D0018 result should read §17(a) again — the missing
$X$ is not a notational economy, it is the whole theorem.

---

## 18. Scope limits

1. **Seventeen claims, and the count is a judgement.** §H has six displays and I made seven
   entries (splitting out the dichotomy of §7); §I has six displays after I separated the two
   consequents of §12 into one entry. A different carving would give a different tally. The
   verdicts do not depend on the carving; the counts do.
2. **§2 rests on a repository-wide string search**, and a search is evidence about this
   repository, not about the owner's other notes. If $\operatorname{SpecSep}$ is defined
   somewhere outside this repo, §2 is wrong and nothing else changes.
3. **No text was opened.** Mac Lane 1963 and CWM, Bénabou 1967, Grothendieck's descent, and
   the co-Yoneda lemma are quoted from their standard statements, written out in §9.1, §14.1
   and §14.3 so the use is checkable against the statement. No PDF decoded, none claimed.
4. **§14.4's free-adjunction faithfulness** is asserted from the normal-form property of free
   extensions of computads. I did not write the normal-form argument out. If it fails in the
   ambient the transmission intends, §14.4's first half weakens from "true but vacuous" to
   "unknown", and the second half — the counterexample — is unaffected.
5. **Nothing here is machine-checked**; no Agda or Lean was authored, and there is no
   toolchain in this container. No Python was written or run.
6. **D0018 §J5's $\chi_\alpha$ was not touched**, per mandate; §4 above cites
   `ADVANCE_CONJUNCTS_DEFINED.md` Theorem U for a structural constraint and neither measures
   nor rehabilitates any fitted quantity.
7. **§16's generalisation is mine and is offered for audit.** It is a claim about seventeen
   claims. It has no error bars because it is not a measurement, and it should be tested
   against the next region worked, not accepted.

---

## 19. Tally

| verdict | count | entries |
|---|---|---|
| PROVED | 1 | §8 (ज्ञेयम $\not\subset$ एकदृष्टिः) |
| REFUTED | 1 | §7 (§H clauses 5–6 are not a dichotomy) |
| CLASSICAL | 3 | §14.1, §14.2, §14.3 |
| PARTIAL | 4 | §1, §9, §12, §14.4 |
| PROGRAMME | 8 | §2, §3, §4, §5, §6, §10, §11, §13 |

**17 entries, each in exactly one class.** Plus one out-of-scope REFUTED (§15), counted
separately because it belongs to a region the ledger assigned to nobody and I was not asked
to work.

**The one-line answer to the mandate's question about §H.** Of six "gem invariants", **one is
an evaluable definition and is not an invariant** (illumination — repairable, and the repair
is an object the corpus already uses), and **five are names**. The honest verdict the mandate
anticipated is very nearly the true one; the correction is that it is five, not six, and that
the sixth is repairable in one line.

---

*Written by seed160, 2026-08-15, from the owner's transmissions D0016 §§H, I and D0017 §E.
Every note cited was read in full: `notes/OWNER_TRANSMISSIONS_LEDGER.md`,
`notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md`, `notes/ADVANCE_UNDER_REPLACEMENT.md` §3,
`notes/ADVANCE_CONJUNCTS_DEFINED.md` §§5–6, `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md`
§§0–2, `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` §5. No verdict was taken from a covering
message. Credit for the material adjudicated is the owner's; the errors found are in the
adjudication, not in the transmission's right to be schematic — it says on its own first page
that it is.*
