# D0020 — consolidated claim ledger of the fifth owner transmission

*Compiled seed181, 2026-08-15. Source artifact:
`collab/upstream/raw/D0020-owner-fifth-transmission-2026-08-15.md` (561 lines at the time of
reading: a preamble, §§0–10, and a triage J1–J9). This ledger is the D0020 counterpart of
`notes/D0019_LEDGER.md` (scope D0019) and `notes/OWNER_TRANSMISSIONS_LEDGER.md` (scope
D0016–D0018). **Both of those are other agents' live artifacts and are not edited here**; they
are cross-referenced, and where a verdict of theirs transfers it is quoted, not re-derived.*

**What this is.** Every distinct claim of D0020 that could be true or false, in the owner's own
notation, with exactly one status, a one-line reason, and — where one exists — the file where it
was settled. **Where nothing settles it, the row says nobody looked, in those words.**

**Verdict vocabulary**, inherited from the two predecessor ledgers and extended by one:

- **PROVED** — with the hypothesis it needs.
- **REFUTED** — with the counterexample or the inconsistency.
- **PARTIAL** — *always with the split named*: which half holds, which does not.
- **CLASSICAL** — *with the earliest source named and cited*. **Where I did not read that source,
  the row says so and the defect is the row's, not the transmission's.** No CLASSICAL row in this
  ledger rests on a PDF I decoded; I decoded none.
- **OPEN** — truth-apt, unadjudicated, with what would settle it.
- **PROGRAMME** — notation awaiting content; **and where PROGRAMME means *nobody has looked*, the
  row says "nobody looked"** rather than dressing the gap as OPEN.
- **UNDEFINED** *(new in this ledger)* — the claim's terms are not defined anywhere in this
  archive or corpus, so the claim **cannot be PROVED or REFUTED at all**. This class is introduced
  because this fleet has already erred in exactly the available way: `D0019_LEDGER.md` C7 records
  a pass that identified two quantities *neither of which has a definition*, and rightly reports
  that "two quantities neither of which has a definition cannot be proved equal". UNDEFINED is the
  status that stops that move. It differs from PROGRAMME: PROGRAMME is a frame offered as a frame;
  UNDEFINED is a **truth-shaped display whose symbols do not denote**, i.e. a non-statement wearing
  the clothes of a statement.

**What this is not.** It is not an adjudication of the transmission's mathematics beyond the
handful of exact, finite symbolic checks recorded in §5 and marked as mine. Those checks are proof
under `CLAUDE.md` (exact symbolic computation), were done by hand, and are displayed in full so
they can be refuted. Nothing was measured, nothing was fitted, no code was run.

---

## §1. The archive, checked as a record before it is read as mathematics

D0020 opens with its own transcription warning, and that warning is **more careful than any
predecessor's** — it names the loss mode up front rather than being caught at it. Three record
findings, each verified by opening the file:

1. **The declared omission marker is never used.** The preamble says omitted runs "are marked
   `` […run…] ``". `grep` finds that string **exactly once in the file: in the warning itself**.
   The actual omissions in §§1–4 are compressed into running prose ("Then, in a long run: …"),
   which is a different and *lossier* convention than the one declared, because a prose summary
   does not mark where a display stood. **Reported, not concluded from**: the displays are the
   owner's and are held by the owner.
2. **§10's stretto table is explicitly absent** — "[reproduced in the original as a $6\times12$
   array]". No verdict is taken on it (row 10.3).
3. **§10 says "the six domain-fugues" and then lists five** ($\Omega_{\text{गणित}}$,
   $\Omega_{\text{भौतिक}}$, $\Omega_{\text{जीव}}$, $\Omega_{\text{भाषा}}$,
   $\Omega_{\text{दर्शन}}$); the sixth, $\Omega_{\text{वेणी}}$, appears **only inside the boxed
   tensor identity**. Either a display was dropped or the word "six" is wrong. **Candidate loss,
   not established** (row 10.4).

**A correction to the record that this pass owes its predecessor.** `notes/D0019_LEDGER.md` §2,
§12.4 report `notes/ARCHIVE_FIDELITY_AUDIT.md` and `notes/FILLABILITY_AS_SUCCESS.md` as
**non-existent** and take no verdict from either. **Both exist in the tree now** —
`ARCHIVE_FIDELITY_AUDIT.md` (298 lines, seed176) and `FILLABILITY_AS_SUCCESS.md` (302 lines,
seed177) — verified by `ls` and read at their openings. They were in flight when that ledger was
compiled, exactly as its own §1 predicted ("presumably in flight; when it lands it should be
checked against this paragraph"). Relatedly, the **D0019 archive is now 704 lines, not 286**, and
its §E′ carries the heading "**The physics/Yoneda section — RESTORED 2026-08-15**". So
`D0019_LEDGER.md` §1's third row and §9's closing paragraph ("No verdict is possible on a section
that is not there") are **stale, not wrong when written**. This is stated here because D0020's own
preamble asserts the restoration, and a ledger must not relay that assertion untested: I opened
the file. Nothing in `D0019_LEDGER.md` is edited by this pass.

---

## §2. Adjudicating notes, checked for existence before use

**No note in this corpus adjudicates D0020.** `grep -rl D0020 notes/ collab/messages/` returns
nothing. The transmission arrived after every note cited below. What follows is therefore a table
of notes whose verdicts **transfer** to a D0020 display, each checked by `ls` and read at the
sections cited.

| note | exists | transfers to | what it gives |
|---|---|---|---|
| `notes/ORDINAL_LADDER_SMALLNESS.md` | **yes** (seed165) | §0.6, §10.8 | $\Gamma$ is **not a function** and $\vee$ makes the composite contravariant, so a $\Psi$-ladder has no diagram; $\kappa=\mathbf{Ord}$ refuted |
| `notes/SURVIVING_LADDER_FRAGMENT.md` | **yes** (seed174) | §9.3, §10.8 | what survives of a ladder: a **choice tree**, not a sequence; an object per branch, non-canonical |
| `notes/ADVANCE_CONJUNCTS_DEFINED.md` | **yes** | §9.2, J6 | `UsefulEscape` **has no definition in the language**; the Collapse theorem |
| `notes/SHRINKING_TESTS_LOWER_CURVATURE.md`, `notes/CHANGING_TESTS_VERSUS_SHRINKING.md` | **yes**, both | §7.6, J3 | the Birkhoff/Chu polarity and its closure, with theorems |
| `notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` | **yes** | §5.16, J3 | **apoha is *not* an untyped Boolean complement of a pre-given set** — with primary texts |
| `notes/ABHAVA.md` | **yes** | §5.5 | absence is a **three-slot relation** (pratiyogin/anuyogin/avacchedaka), not a tuple entry |
| `notes/FOUR_REPAIR_MODES.md`, `notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` | **yes**, both | §1.2, J2 | $\Gamma_\varnothing$ / coefficient enlargement, and its universality by Shapiro |
| `notes/OWNER_TRANSMISSIONS_LEDGER.md` §3.16–3.18, §2.8 | **yes** | §8.2, §8.7, §8.9, §10.7 | the half-integer caveat; $\xi(s)=\xi(1-s)$ CLASSICAL; the Mellin identity **REFUTED**; $\mathbb B\simeq\Phi\mathbb B$ PARTIAL |
| `notes/D0019_LEDGER.md` D10, D13, C7 | **yes** | §6.10, §6.11, J7 | the dropped tetrahedron; holonomy is not a number; $\chi_\alpha\ne\rho(D\mathcal K)$ |
| `notes/ARCHIVE_FIDELITY_AUDIT.md`, `notes/FILLABILITY_AS_SUCCESS.md` | **yes** (see §1) | §1, §7.9 | the fidelity findings the preamble cites; fillability as a $\Pi^0_2$ success predicate |

---

## §3. Preamble

| # | claim | status | reason |
|---|---|---|---|
| P.1 | सर्वज्ञानम $\ne$ वाक्यसमष्टिः; सर्वज्ञानबीजम $=$ सीमितचिह्नम $+$ अनन्तव्युत्पत्तिः | **PROGRAMME** | the frame of the transmission, offered as a frame. Not truth-apt as displayed: no equality of what with what. It does real work below — §0 is the finite sign-set and §§1–10 the derivation — and by row 0.3 the "infinite" half of it is **false of §0's own closure** |
| P.2 | the archive is "structurally faithful but not display-complete" | **PARTIAL** | *split:* the warning is correct and is the best of the five; but the declared marker `` […run…] `` is used **zero times** and three specific absences are unmarked (§1). The record claim overstates the record's own discipline |

---

## §4. §0 — the seed alphabet and its closure

| # | claim | status | reason |
|---|---|---|---|
| 0.1 | $\Theta_0:=\langle\varnothing,\bullet,\to,\leftrightarrow,\oplus,\otimes,\circ,\partial,\delta,\Gamma,\Phi,(-)^\vee,\ulcorner-\urcorner\rangle$ | **PROGRAMME** | a stipulated alphabet. Thirteen signs, of which $\partial,\delta,\Gamma,\Phi,(-)^\vee,\ulcorner-\urcorner$ are the six of §10's $\sigma$; nothing is asserted |
| 0.2 | $\kappa(\Theta)$ is well-defined as $\bigcap\{\Upsilon\supseteq\Theta\mid\Upsilon\text{ closed}\}$ | **PARTIAL** | *split:* **PROVED** — on any ambient set closed under the nine operations, an intersection of closed supersets is closed, so $\kappa$ is the least-closed-superset operator, i.e. a closure operator. **Not supplied** — the ambient. Without one the intersection ranges over a class and $\kappa$ does not denote |
| 0.3 | the tower $\Theta_{\nu+1}:=\kappa(\Theta_\nu)$, $\Theta_\lambda:=\bigcup_{\nu<\lambda}\Theta_\nu$, $\Theta_\infty:=\bigcup_\lambda\Theta_\lambda$ | **REFUTED as a transfinite hierarchy — it collapses at stage one** | $\kappa$ is idempotent (0.2), so $\Theta_2=\kappa(\Theta_1)=\Theta_1$, hence $\Theta_\nu=\Theta_1$ for all $\nu\ge1$ and $\boxed{\Theta_\infty=\Theta_1=\kappa(\Theta_0)}$. The ordinals do no work: the operations are **finitary**, so the closure is reached in $\omega$ steps of *generation* and in **one** step of $\kappa$. Proof in §5.1. **This contradicts J8**, which files §0's $\Theta_\infty$ as PROGRAMME beside §10's — see J8 |
| 0.4 | $\boxed{\omega_\chi:=\delta(\partial\chi)}$ | **PROGRAMME** | a definition; $\partial$ and $\delta$ carry no typing in this archive. `OWNER_TRANSMISSIONS_LEDGER.md` A-12 (boundary-operator typing) is about D0016's $\partial$ and is **not** transferred, the ambients being different |
| 0.5 | $\chi^+:=\Phi\chi$ if $\omega_\chi=0$; $\chi\sqcup^\sim_{\partial\chi}\Gamma\langle\omega_\chi\rangle$ if $\omega_\chi\ne0$ | **PROGRAMME** | the branching step. A homotopy pushout needs a category with them; none is fixed |
| 0.6 | $\blacklozenge:=\Gamma\circ\delta\circ\partial$, $\Xi:=\ulcorner-\urcorner\circ(-)^\vee\circ\Phi$, $\Psi:=\blacklozenge\circ\Xi\circ\blacklozenge$ are composable operators | **REFUTED — transferred verdict, not re-derived** | $\Gamma$ is **a choice among repair modes, not a function** (`ORDINAL_LADDER_SMALLNESS.md` §1, three independent fatal reasons for the cognate $\mathfrak F$; `EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` Thm 6.1 gives the multivaluedness a theorem). A composite through $\Gamma$ is not an operator. J8 itself says this transfers |
| 0.7 | $\Diamond_0\to\Psi\Diamond_0\to\Psi^2\Diamond_0\to\cdots$ | **PROGRAMME** | depends on 0.6; and nothing says what the arrows are |
| 0.8 | the three verdicts $\checkmark:\alpha\simeq\beta$, $?:\alpha\rightsquigarrow\beta$, $\bot:\alpha\not\rightsquigarrow\beta$ | **PROGRAMME** | stipulative. Note it is **the same trichotomy** as D0019 §E's $\{\text{theorem},\text{bounded analogy},\bot\}$, which `ATTACK_SET_CALIBRATED.md` §3 ran once end-to-end (`D0019_LEDGER.md` E3, PROVED usable). Nobody has run this one |
| 0.9 | $\boxed{\alpha\sim\beta\not\Rightarrow\alpha\simeq\beta}$ | **UNDEFINED** | $\sim$ occurs **once in the archive, here**, and is never defined. As a slogan it is §5's rule (5.1) and is the transmission's best instinct; as a display it relates an undefined relation to an undefined one |
| 0.10 | $\boxed{\alpha\simeq\beta\Rightarrow\Pi(\alpha)\simeq\Pi(\beta)}$ | **UNDEFINED** | $\Pi$ is not defined here (in §2 $\Pi$ is a quantum observable, in §9 a theorem-tuple). *If* $\Pi$ ranges over functors the display is functoriality and PROVED-trivially; *if* over arbitrary maps of presentations it is false. The row is UNDEFINED because the archive does not choose |

---

## §5. The exact checks this pass ran

Five finite symbolic computations, each done by hand, each displayed so it can be refuted. Under
`CLAUDE.md` these are proof, not measurement: no floating point, no fit, no run.

### 5.1 §0's tower collapses at stage one (row 0.3)

Fix an ambient set $\mathcal S$ of signs closed under the nine operations (0.2 records that the
archive does not supply one; the argument is uniform in the choice). For $\Theta\subseteq\mathcal S$
let $\mathcal F(\Theta)$ be the family of closed $\Upsilon$ with $\Theta\subseteq\Upsilon\subseteq\mathcal S$;
$\mathcal S\in\mathcal F(\Theta)$, so it is non-empty. Each of the nine operations has finite arity,
so an intersection of closed sets is closed: if $\alpha,\beta\in\bigcap\mathcal F(\Theta)$ then
$\alpha\oplus\beta\in\Upsilon$ for every $\Upsilon\in\mathcal F(\Theta)$, hence
$\alpha\oplus\beta\in\bigcap\mathcal F(\Theta)$; likewise for the other eight. So
$\kappa(\Theta):=\bigcap\mathcal F(\Theta)$ is itself a member of $\mathcal F(\Theta)$, i.e. the
**least** closed superset. Therefore $\kappa(\kappa(\Theta))=\kappa(\Theta)$, and by induction
$\Theta_\nu=\Theta_1$ for every $\nu\ge1$; unions at limits change nothing. Hence
$\Theta_\infty=\Theta_1=\kappa(\Theta_0)$. $\square$

*What this does and does not say.* It does **not** say $\Theta_1$ is finite — it is countably
infinite, generated in $\omega$ generation-steps. It says the **ordinal indexing is inert**: the
display's $\Theta_\lambda$, $\Theta_\infty$ and the machinery of limits are consumed by a single
application of an idempotent operator. A transfinite ladder that stops at 1 is not a ladder.

### 5.2 §1's Möbius display is false as written (row 1.5)

Displayed: $\sum_{\delta\mid\nu}\mu(\delta)\lfloor\nu/\delta\rfloor=1$. Since $\delta\mid\nu$,
$\lfloor\nu/\delta\rfloor=\nu/\delta$ exactly, so the left side is
$\sum_{d\mid n}\mu(d)\,\frac nd=\varphi(n)$ — Euler's totient, which is $1$ only for $n\in\{1,2\}$
and is $\ge2$ for every $n\ge3$. **Counterexample:** $n=3$ gives $\mu(1)\cdot3+\mu(3)\cdot1=3-1=2\ne1$.

**Exact repair.** The classical identity the display is one character away from is
$$\sum_{d\le n}\mu(d)\left\lfloor\frac nd\right\rfloor=1,$$
the sum being over **all** $d\le n$, not the divisors: it counts
$\sum_{m\le n}\sum_{d\mid m}\mu(d)=\sum_{m\le n}[m=1]=1$. The floor is load-bearing there and
inert here, which is the signature of the error. Possibly a transcription slip (§1); reported
either way.

### 5.3 §8's $\Pi_\partial$ identity fails on every prime (row 8.5)

Displayed: $1\le\Omega(\nu)\le2\Rightarrow\Pi_\partial(\nu)=\frac{1-\lambda(\nu)}2-\mathbf1_\wp(\nu)$,
with $\Pi_\partial(\nu):=\mu(\nu)^2-\pi_1(\nu)$ and $\pi_1(\nu):=\omega(\nu)-1$.
Exhaustive over the three shapes with $1\le\Omega\le2$:

| $\nu$ | $\mu^2$ | $\omega$ | $\pi_1$ | $\Pi_\partial$ | $\lambda$ | $\frac{1-\lambda}2$ | $\mathbf1_\wp$ | RHS |
|---|---|---|---|---|---|---|---|---|
| $p$ | 1 | 1 | 0 | **1** | $-1$ | 1 | 1 | **0** |
| $pq$, $p\ne q$ | 1 | 2 | 1 | **0** | $+1$ | 0 | 0 | **0** |
| $p^2$ | 0 | 1 | 0 | **0** | $+1$ | 0 | 0 | **0** |

The identity holds on $\Omega=2$ and **fails on every $\nu$ with $\Omega(\nu)=1$, by exactly $1$**.

**Exact repair:** delete the last term. $\boxed{1\le\Omega(\nu)\le2\Rightarrow\Pi_\partial(\nu)=\tfrac{1-\lambda(\nu)}2}$
holds on all three rows, as the table shows. Equivalently: on $\Omega\le2$, $\Pi_\partial=\mathbf1_{\Omega=1}$.
Under the alternative reading that $\mathbf1_\wp$ indicates *prime powers* the same table refutes
it identically ($p$ and $p^2$ both indicated: RHS $0,-1$ against $1,0$). The only reading under
which the display survives is $\mathbf1_\wp\equiv0$, which makes the term ornamental.

### 5.4 §7's tropical adjunction is correct, and is contravariant (row 7.8)

Displayed: $(\beta\star\alpha)^\sharp=\alpha^\sharp\circ\beta^\sharp$ with
$(\beta\star\alpha)(\xi,\zeta)=\bigwedge_\eta[\alpha(\xi,\eta)+\beta(\eta,\zeta)]$ and
$\alpha^\sharp(\upsilon)(\xi)=\bigwedge_\eta[\alpha(\xi,\eta)+\upsilon(\eta)]$. Then
$$(\beta\star\alpha)^\sharp(\upsilon)(\xi)=\bigwedge_\zeta\Bigl[\bigwedge_\eta[\alpha(\xi,\eta)+\beta(\eta,\zeta)]+\upsilon(\zeta)\Bigr]
=\bigwedge_{\eta,\zeta}[\alpha(\xi,\eta)+\beta(\eta,\zeta)+\upsilon(\zeta)],$$
$$(\alpha^\sharp\circ\beta^\sharp)(\upsilon)(\xi)=\bigwedge_\eta\Bigl[\alpha(\xi,\eta)+\bigwedge_\zeta[\beta(\eta,\zeta)+\upsilon(\zeta)]\Bigr]
=\bigwedge_{\eta,\zeta}[\alpha(\xi,\eta)+\beta(\eta,\zeta)+\upsilon(\zeta)].$$
Equal. $\square$ **Hypothesis the display does not state and the proof needs:** the value semiring
must satisfy $x+\bigwedge S=\bigwedge(x+S)$, which holds in $\mathbb R\cup\{+\infty\}$ with all
meets, **except** where $x=+\infty$ meets an empty index set. So the identity is PROVED with a
non-empty-index or finite-$\eta$ side condition. The **order of the composition is reversed** on
the two sides of the equation, which is the content: $(-)^\sharp$ is contravariant. That is the
standard weakest-precondition/abstract-interpretation fact, classically Cousot–Cousot 1977 —
**named, not read** (see the CLASSICAL defect register, §16).

### 5.5 §8's $\mathfrak{sl}_2$ brackets hold — the check J1 asked for (row 8.10)

One variable first: on $\vartheta[\xi]/(\xi^{\alpha+1})$ with basis $\xi^k$, $0\le k\le\alpha$,
$$\varepsilon(\xi^k)=\xi^{k+1},\qquad \varphi(\xi^k)=k(\alpha-k+1)\xi^{k-1},\qquad \eta(\xi^k)=(2k-\alpha)\xi^k,$$
where $\xi^{\alpha+1}=0$ and $\varphi(\xi^0)=0$ (the coefficient vanishes at $k=0$, so no
convention is needed).
- $\varepsilon\varphi(\xi^k)=k(\alpha-k+1)\xi^k$; $\varphi\varepsilon(\xi^k)=(k+1)(\alpha-k)\xi^k$,
  which is also correct at $k=\alpha$, both sides being $0$. Hence
  $[\varepsilon,\varphi](\xi^k)=\bigl[k(\alpha-k+1)-(k+1)(\alpha-k)\bigr]\xi^k=(2k-\alpha)\xi^k=\eta(\xi^k)$. ✔
- $[\eta,\varepsilon](\xi^k)=(2(k+1)-\alpha)\xi^{k+1}-(2k-\alpha)\xi^{k+1}=2\varepsilon(\xi^k)$. ✔
- $[\eta,\varphi](\xi^k)=(2(k-1)-\alpha)\varphi(\xi^k)-(2k-\alpha)\varphi(\xi^k)=-2\varphi(\xi^k)$. ✔

Several variables: $\varepsilon=\sum_\iota\varepsilon_\iota$, $\varphi=\sum_\iota\varphi_\iota$,
$\eta=\sum_\iota\eta_\iota$, each $\iota$-component acting on its own variable, so operators with
different $\iota$ commute and all cross terms of $[\varepsilon,\varphi]$ vanish:
$[\varepsilon,\varphi]=\sum_\iota[\varepsilon_\iota,\varphi_\iota]=\sum_\iota\eta_\iota=\eta$, and
similarly for the other two. $\square$

So the transmission's displayed operators do satisfy the three $\mathfrak{sl}_2$ relations, in
every number of variables, exactly. **This is the one place in D0020 where the corpus gains a
verified statement**, which is what J1 said it would be, and it took twelve lines.

---

## §6. §1 — number, form, proof

| # | claim | status | reason |
|---|---|---|---|
| 1.1 | $\boxed{\aleph\subset\zeta\subset\vartheta\subset\varrho\subset\chi}$, with von Neumann ordinals | **CLASSICAL** | the standard number tower. *Earliest sources named:* von Neumann 1923 (ordinals); Dedekind, *Stetigkeit und irrationale Zahlen*, 1872 (reals by cuts); Hamilton 1837 (complexes as ordered pairs). **None read by me** — defect registered at §16 |
| 1.2 | the tower is "repeated obstruction–repair", the four $\rightsquigarrow$ steps being four instances of one move (J2's framing) | **REFUTED — one of the four steps is a different kind of repair, and it is the one the display mislabels** | $3-5\notin\aleph$ and $1\div2\notin\zeta$ are **algebraic** completions (Grothendieck group; field of fractions), and $\xi^2=-1\rightsquigarrow\iota$ is an **algebraic** extension — three instances of coefficient enlargement, which `FOUR_REPAIR_MODES.md` and `EIGHT_CLASSES…` Thm 3.3 cover. But $\xi^2=2\rightsquigarrow\sqrt2\in\varrho$ **does not produce $\varrho$**: the repair that solves $\xi^2=2$ is $\vartheta(\sqrt2)$, a degree-2 extension; $\varrho$ is obtained by **metric completion**, which is not an enlargement of coefficients and has no row in the four modes. The transmission's own gloss betrays it — it writes the reals as $\overline{\vartheta}$, a *closure* bar, for an object no algebraic closure produces. **J2 asks whether the proved theory classifies these four correctly; the answer is three of four**, and the failure is informative: completion is the repair mode the corpus's classification lacks |
| 1.3 | $\boxed{\text{असमर्थता}\xrightarrow{\Gamma}\text{विस्तृतलोकः}}$ | **PROGRAMME** | the slogan of 1.2, not truth-apt as displayed |
| 1.4 | the long run: $\sum_1^\nu=\nu(\nu+1)/2$, the binomial theorem, unique factorisation, completing the square, inner products and Pythagoras, $\phi^2=\phi+1$, $\varepsilon_\star=\sum1/\nu!$, calculus and both halves of the fundamental theorem, eigenvalues, SVD, self-adjoint $\Rightarrow$ real spectrum, category axioms | **CLASSICAL** | standard, and correctly stated. *Earliest sources named:* Euclid IX.14 and Gauss, *Disquisitiones* art. 16 (unique factorisation); Euler, *Introductio*, 1748 (the exponential/trigonometric identities). **Not read**; §16 |
| 1.5 | $\sum_{\delta\mid\nu}\mu(\delta)\lfloor\nu/\delta\rfloor=1$ | **REFUTED** | the sum over **divisors** equals $\varphi(\nu)$, not $1$; counterexample $\nu=3$ gives $2$. The classical identity sums over all $\delta\le\nu$. Proof and repair: §5.2. The companion display $\sum_{\delta\mid\nu}\mu(\delta)=[\nu=1]$ **is** correct |
| 1.6 | $\boxed{\varepsilon_\star^{\iota\theta}=\kappa+\iota\varsigma}$, $\kappa^2+\varsigma^2=1$, $\boxed{\varepsilon_\star^{\iota\pi}+1=0}$ | **CLASSICAL** | Euler. Correctly stated |
| 1.7 | $\boxed{\alpha\simeq(\langle-,\alpha\rangle,\langle\alpha,-\rangle)}$ | **CLASSICAL — with a typing defect the display hides** | Yoneda (Yoneda 1954; Grothendieck, Tôhoku 1957). What is true is that $\alpha\mapsto\langle-,\alpha\rangle$ is **fully faithful**, so $\alpha$ is determined **up to isomorphism** by *either* hom-functor; the displayed $\simeq$ between an object and an ordered **pair** of functors is not an isomorphism in any category the display names. Same shape recurs at 6.8. Sources **not read**; §16 |
| 1.8 | $\eta_\nu=$ cycles/boundaries with $\partial_{\nu-1}\partial_\nu=0$; $\pi_1(\bigcirc)\cong\zeta$; $\upsilon(\gamma)=\frac1{2\pi\iota}\oint\delta\zeta/\zeta$ | **CLASSICAL** | homology, the fundamental group of the circle, the winding number. Correct |
| 1.9 | Bayes; Shannon entropy and mutual information; Cantor's diagonal $\Delta_\epsilon\notin\epsilon[\aleph]$; $\beta$-reduction; Gödel $\gamma_\Theta\Leftrightarrow\neg\Box_\Theta\ulcorner\gamma_\Theta\urcorner$ with $\Theta\nvdash\gamma_\Theta\wedge\Theta\nvdash\neg\gamma_\Theta$ | **CLASSICAL** | correct, with the standard unstated hypotheses on $\Theta$ ($\omega$-consistency or Rosser). *Sources named:* Cantor 1891; Gödel 1931; Shannon 1948. **Not read**; §16 |
| 1.10 | $\boxed{\text{एकरूपम}\xleftrightarrow{\Phi}\text{बहुस्वरम}}$ | **PROGRAMME** | the Fourier slogan; $\Phi$ here is not the $\Phi$ of §0 |

---

## §7. §2 — matter, time, geometry, wave

| # | claim | status | reason |
|---|---|---|---|
| 2.1 | least action and Euler–Lagrange; Hamilton; Noether ($\delta_\epsilon\Sigma=0\Rightarrow\partial_\tau\Theta_\epsilon=0$); Maxwell and the wave equation; Minkowski, $\gamma_\upsilon$, $\epsilon^2=\pi^2\varsigma^2+\mu^2\varsigma^4$; $\boxed{\varrho_{\mu\nu}-\frac12\gamma_{\mu\nu}\varrho+\Lambda\gamma_{\mu\nu}=\kappa\Theta_{\mu\nu}}$; geodesics and Riemann | **CLASSICAL** | correctly stated throughout. *Sources named:* Noether 1918; Maxwell 1865; Einstein 1915/1917. **Not read**; §16 |
| 2.2 | quantum mechanics: Schrödinger, Born, uncertainty, the measurement/entanglement chain, $\rho_\alpha^2\ne\rho_\alpha\Leftarrow$ non-separability, the path integral with $\delta\Sigma[\gamma_\star]=0$ | **CLASSICAL** | correct. The reduced-density-matrix statement is the standard purity criterion |
| 2.3 | relational QM: $\rho_{\alpha\mid\beta}\not\equiv\rho_\alpha$; तथ्यम् $=$ सम्बन्धे जातम् | **CLASSICAL** | Rovelli, *Relational Quantum Mechanics*, Int. J. Theor. Phys. 35 (1996) 1637. **Not read**; §16. It is an interpretation, and the row is CLASSICAL *as an interpretation*, not as a theorem — the transmission does not claim otherwise |
| 2.4 | quantum logic: distributivity fails; $[\Pi,\Theta]\ne0\Rightarrow$ order-dependence | **CLASSICAL** | Birkhoff–von Neumann, *The Logic of Quantum Mechanics*, Ann. Math. 37 (1936) 823. **Not read**; §16 |
| 2.5 | LQG: holonomy, flux, spin networks, area spectrum $8\pi\gamma\lambda_0^2\sum\sqrt{\lambda_\epsilon(\lambda_\epsilon+1)}$ | **CLASSICAL** | Rovelli–Smolin 1995; Ashtekar–Lewandowski. The $\gamma$ is the Immirzi parameter and is **not** fixed by the theory — the display does not say so. **Not read**; §16 |
| 2.6 | $\boxed{\Phi_{\Omega_1\cup_\Sigma\Omega_2}=\int_{\psi_\Sigma}\Phi_{\Omega_2}\Phi_{\Omega_1}\delta\psi_\Sigma}$ | **CLASSICAL** | the gluing/composition axiom (Atiyah 1988, axiom set for TQFT), which spin-foam models impose by construction. **Not read**; §16. Defect: the measure $\delta\psi_\Sigma$ is not defined in general and the display does not flag it |
| 2.7 | the constraint-algebra anomaly: $\curlywedge_{\Theta\Theta}$ as displayed, with $\boxed{=0\Rightarrow\text{पथसामञ्जस्यम्};\ \ne0\Rightarrow\text{क्वाण्टज्यामितिविघ्नः}}$ | **CLASSICAL** | J5 is right that this is correctly stated and correctly *attributed* — it is the closure problem of the Dirac constraint algebra (Dirac 1958; DeWitt 1967), a genuine open problem in physics, not a defect the framework repairs. The two boxed implications are definitional restatements of "anomalous". **Not read**; §16. **This is the one place the transmission's obstruction vocabulary lands on an existing hard problem rather than renaming a solved one** |
| 2.8 | entropy $\eta=\kappa_\beta\lambda_\star(\Omega)$, the second law, the fluctuation theorem $\varpi_+[\gamma]/\varpi_-[\gamma^\vee]=\varepsilon_\star^{\Delta\eta/\kappa_\beta}$, Planck, the first law, Friedmann + continuity | **CLASSICAL** | Boltzmann; Evans–Cohen–Morriss 1993 / Crooks 1999; Planck 1901; Friedmann 1922. **Not read**; §16 |

---

## §8. §3 — chemistry, heredity, the web of life

| # | claim | status | reason |
|---|---|---|---|
| 3.1 | hydrogenic Schrödinger, quantum numbers, Pauli exclusion, kinetics, $\Delta\gamma=\Delta\upsilon+\pi\Delta\nu-\vartheta\Delta\eta$, Arrhenius | **CLASSICAL** | correct. Pauli 1925; Arrhenius 1889. **Not read**; §16 |
| 3.2 | $\boxed{\text{उत्प्रेरकः}:\Delta\gamma^\ddagger\downarrow;\ \Delta\gamma\text{ अचलम}}$ | **CLASSICAL** | a catalyst lowers the barrier and not the free-energy difference — a consequence of $\Delta\gamma$ being a state function. Correctly stated, and one of the cleanest displays in §3 |
| 3.3 | autocatalysis $\alpha+\phi\to2\alpha$, $\partial_\tau\alpha=\kappa\phi\alpha-\delta\alpha$; the boundary loop $\partial\Omega\to$ अन्तःसन्धानम $\to\partial\Omega$ | **CLASSICAL** *(first half)* | the ODE is standard. The boundary loop has no types and is carried in this row rather than given its own, being a gloss on it |
| 3.4 | $\beta:=\{\triangle,\triangledown,\square,\lozenge\}$ with $\triangle^\dagger=\triangledown$, $\rho$ reversal, $\boxed{\sigma\bowtie\rho(\sigma^\dagger)}$ | **PROGRAMME** | a faithful *notation* for base pairing and antiparallel complementarity; $\bowtie$ is undefined and occurs with four different arities in this transmission (here, 3.7, 3.12, 4.8) |
| 3.5 | transcription/translation as $\tau_1,\tau_2$; the codon map $(\beta')^3\to\{\alpha_1,\ldots,\alpha_{20},\bot\}$; the pipeline सूत्रम्→…→क्रिया | **CLASSICAL** | the genetic code, $64\to20+\text{stop}$. Nirenberg–Matthaei 1961; Crick 1958 for the pipeline. **Not read**; §16 |
| 3.6 | folding as an $\arg\min$ of $\gamma$ | **PARTIAL** | *split:* **CLASSICAL** for small single-domain proteins (Anfinsen's thermodynamic hypothesis, 1973); **false in general** — kinetic traps, chaperone-dependent folding and prions are standing counterexamples, and the display carries no hypothesis. The $\arg\min$ also inherits D0019 F7's defect: an $\arg\min$ returns an object, and uniqueness is asserted by the notation |
| 3.7 | $\boxed{\text{आनुवंशिकसूत्रम}\ne\text{अचलनियति}}$; रूपम $=$ सूत्रम $\bowtie$ विकासः $\bowtie$ पर्यावरणम $\bowtie$ इतिहासः | **PROGRAMME** | a non-identity between glosses |
| 3.8 | the replicator equation and the Price equation | **CLASSICAL** | Price 1970; Taylor–Jonker 1978. **Not read**; §16 |
| 3.9 | $\boxed{\text{भेदः}+\text{आनुवंशिकता}+\text{भिन्ननिरन्तरता}=\text{विकासः}}$ | **CLASSICAL** | Lewontin's three conditions (*The Units of Selection*, Ann. Rev. Ecol. Syst. 1, 1970). **Not read**; §16. The display's "$=$" is an "if and only if" claim about sufficiency that Lewontin states as sufficiency; correctly rendered |
| 3.10 | Turing morphogenesis: $\delta_\alpha\ne\delta_\beta\Rightarrow$ spatial pattern | **REFUTED as displayed** | unequal diffusion is **necessary, not sufficient**. Turing instability additionally requires activator–inhibitor sign structure in the Jacobian and a diffusion ratio past a threshold; with $\delta_\alpha\ne\delta_\beta$ and a stable, non-activator–inhibitor kinetics there is no pattern. The classical statement (Turing 1952) carries those hypotheses; the display drops them. **Not read**; §16 |
| 3.11 | generalised Lotka–Volterra; trophic efficiency ratios | **CLASSICAL** *(the ODEs)* | the efficiency ratios are flagged by J7 as measure-less quantities — carried at J7, not scored twice |
| 3.12 | $\circledast_{\text{जीव}}:=\int^\iota(\xi_\iota,\alpha_{\iota-},\alpha_{-\iota},\partial\Omega_\iota)$ | **UNDEFINED** | a coend needs a functor $\mathcal C^{op}\times\mathcal C\to\mathcal D$; what is written is a coend of a **tuple**, over an unnamed index. Same defect as 6.8 |
| 3.13 | $\boxed{\text{जीवः}\ne\text{एकाकीवस्तु}}$; $\boxed{\text{सततभौतिकप्रवाहः}\ne\text{पृथक् पदार्थस्तराः}}$ | **PROGRAMME** | slogans, offered as slogans |

---

## §9. §4 — nerve, language, mind, society

| # | claim | status | reason |
|---|---|---|---|
| 4.1 | leaky integrators; feedforward layers; attention $\alpha_{\iota\kappa}=\mathrm{softmax}(\langle\theta_\iota,\kappa_\kappa\rangle/\sqrt\delta)$, $\upsilon'_\iota=\sum\alpha_{\iota\kappa}\upsilon_\kappa$; gradient descent | **CLASSICAL** | scaled dot-product attention, Vaswani et al., *Attention Is All You Need*, NeurIPS 2017 — correctly stated, $\sqrt\delta$ included. **Not read**; §16 |
| 4.2 | $\boxed{\text{स्मृतिः}=\text{भूतप्रभावस्य भविष्यक्रियायां उपस्थितिः}}$ | **PROGRAMME** | a stipulative definition of memory |
| 4.3 | $\chi\to\ulcorner\chi\urcorner\to\chi'\to\ulcorner\chi\to\chi'\urcorner\to\chi''$; $\boxed{\text{प्रतिबिम्बनम}=\ldots}$ | **PROGRAMME — and nobody looked** | the reflection tower. Cognate to D0016 §D's $\Phi_{\mathrm{refl}}$, which **is** adjudicated (`OWNER_TRANSMISSIONS_LEDGER.md` §1.9 CLASSICAL, amended A-16), but that verdict is about a *consistency-strength* claim this display does not make. **It does not transfer, and no note touches this one** |
| 4.4 | ध्वनि→वर्ण→…→संवाद; $\Gamma:=(\Sigma,\varrho,\prec,\partial,\alpha,\iota,\pi,\beta)$; $\sigma_{\nu+1}=\varrho_{\theta_\nu}(\sigma_\nu)$, $\theta_{\nu+1}=\mu(\theta_\nu,\sigma_\nu,\Gamma)$ | **PROGRAMME** | an eight-slot tuple whose components are never named. **Notation collision, reported as a defect of the archive:** $\Gamma$ is the repair operator in §0, §6, §7 and §10, and a grammar here |
| 4.5 | rule ordering and blocking | **CLASSICAL** | ordered-rule systems: Pāṇini; Chomsky–Halle, *The Sound Pattern of English*, 1968. **Not read**; §16 |
| 4.6 | $\boxed{\text{वस्तुरूपपरिवर्तनम}\ne\text{व्याकरणपरिवर्तनम}}$ | **PROGRAMME** | slogan |
| 4.7 | compositionality with $\llbracket\alpha\rrbracket_\kappa\ne\llbracket\alpha\rrbracket_{\kappa'}$ | **CLASSICAL** | context-dependence of interpretation: Montague 1970; Kaplan, *Demonstratives*, 1977/1989. **Not read**; §16 |
| 4.8 | $\boxed{\text{अर्थः}=\text{चिह्नम}\bowtie\text{सन्दर्भः}\bowtie\text{वक्ता}\bowtie\text{श्रोता}\bowtie\text{इतिहासः}}$ | **PROGRAMME** | a five-fold $\bowtie$ of glosses |
| 4.9 | $\triangle_{\text{चिह्न}}:=(\omega,\sigma,\iota)$, $\omega\xrightarrow\sigma\iota\xrightarrow\kappa\omega'$; $\boxed{\text{चिह्नार्थः}\ne\text{चिह्नस्य अन्तरस्थवस्तु}}$ | **CLASSICAL** | Peirce's triadic sign (object / sign / interpretant) and the denial that meaning is inside the sign. Peirce, *Collected Papers* 2.228. **Not read**; §16 |
| 4.10 | Pāṇinian derivation; $\boxed{\text{अनुवृत्तिः}+\text{अधिकारः}+\text{परिभाषा}+\text{निषेधः}+\text{लोपः}\to\text{व्युत्पन्नरूपम}}$ | **CLASSICAL** | the five metarule types are correctly named and are the standard ones. Pāṇini, *Aṣṭādhyāyī*; Kiparsky, *Pāṇini as a Variationist*, 1979. **Not read**; §16 |
| 4.11 | Bhartṛhari: $(\phi_1,\ldots,\phi_\nu)\xrightarrow{\Phi}\Sigma_{!\circ}$ with $\Sigma_{!\circ}\not\equiv\phi_1\oplus\cdots\oplus\phi_\nu$ | **UNDEFINED** | as **doctrine** (sphoṭa, *Vākyapadīya*) it is classical and correctly rendered; as a **display** it asserts a non-identity between the image of an undefined $\Phi$ and an undefined $\oplus$-sum, in an unnamed ambient. It cannot be proved or refuted, and this is precisely the class of display this ledger introduced UNDEFINED for |
| 4.12 | channel/decoding, conditional entropy, mutual information; $\boxed{\text{ज्ञानम}=\text{अनिश्चितताक्षयः}+\text{परिवर्तनक्षमता}}$ | **CLASSICAL** *(the information theory)* / the box is **PROGRAMME** and is carried at 9.6, where the same definition of ज्ञानम् recurs |
| 4.13 | strict partial orders; Nash equilibrium; a budget-balance condition | **CLASSICAL** | Nash, *Equilibrium Points in n-Person Games*, PNAS 36 (1950) 48. **Not read**; §16 |
| 4.14 | $\boxed{\text{संस्था}=\text{स्मृति}+\text{नियम}+\text{भूमिका}+\text{दण्ड}+\text{विश्वास}}$; the nesting व्यक्ति↔…↔जीवमण्डलम्; a legal-judgement map into $\{\checkmark,?,\bot\}$ | **PROGRAMME** | stipulative. The judgement map is the third appearance of 0.8's trichotomy and the transmission does not say whether it is the same map |
| 4.15 | small-integer ratios; $\omega_\nu=\omega_02^{\nu/12}$; harmonic decomposition | **CLASSICAL** | equal temperament. The display quietly **replaces** the small-integer ratios by their irrational approximations in the same breath and does not note the tension, which is the classical comma problem |
| 4.16 | the four fugal operations $\rho,\iota,\alpha_\mu,\delta_\mu$; $\boxed{\text{स्वरूपैक्यम}+\text{परिवर्तनम}+\text{बहुवाणी}+\text{व्यतिकरणम}=\text{फ्यूग्}}$ | **PROGRAMME** | the operations recur at 10.2 where they are given relations and become checkable; the box is a stipulation |
| 4.17 | the projective map $(\xi,\eta,\zeta)\mapsto(\phi\xi/\zeta,\phi\eta/\zeta)$ | **CLASSICAL** | central projection with focal length $\phi$. **Notation collision:** $\phi$ is the golden ratio at 1.4 |

---

## §10. §5 — the philosophy mandala

*Two corpus notes bear directly on this section and **disagree with the transmission's triage**;
both are read at the sections cited and neither is edited.*

| # | claim | status | reason |
|---|---|---|---|
| 5.1 | $\boxed{\text{समता प्रमाणेन};\ \text{साम्येन न}}$ — equality by proof, not by resemblance | **PROGRAMME** | a norm, and not truth-apt; **and the best sentence in the five transmissions**, as J9 says. It is entered PROGRAMME rather than praised into a theorem, which is itself an application of it. §17 uses it to score the transmission's own triage |
| 5.2 | $\tau_{\lambda\mu}:\chi^\lambda\rightharpoonup\chi^\mu$; $\Delta_{\lambda\mu}(\chi):=\tau_{\mu\lambda}\tau_{\lambda\mu}(\chi)-\chi$ | **PROGRAMME** | the round-trip defect. Two unstated requirements: subtraction needs additive structure on $\chi^\lambda$ (D0019 §D was **refuted** for exactly this and repaired to $\operatorname{cofib}$ — `D0019_LEDGER.md` D12, and the repair is **not carried over here**); and $\rightharpoonup$ is partial, so $\tau_{\mu\lambda}\tau_{\lambda\mu}(\chi)$ may not exist, which the display does not handle |
| 5.3 | $\boxed{\Delta_{\lambda\mu}\ne0\Rightarrow\text{अनुवादविघ्नः}\Rightarrow\text{नवप्रमेयबीजम}}$ | **PROGRAMME** | the second implication has no consequent that could fail. **Structural observation, filed as a defect at §15.6:** D0020 carries **three** round-trip/failure-of-composition defects that it never relates — $\Delta_{\lambda\mu}$ (5.2), $\omega_{\iota\kappa\lambda}$ (6.11), $\curlywedge_{\Sigma_1}$ (7.1) — and J4 relates only the third to D0019 §D |
| 5.4 | न्याय: four pramāṇas, the five-membered inference, विषयः⋈गुणः⋈सम्बन्धः⋈प्रमाणम् | **CLASSICAL** | *Nyāya-sūtra* 1.1.3 (the four pramāṇas), 1.1.32 (the five members). **Not read by me**; but `notes/ABHAVA.md` and the corpus's Nyāya notes do read primary text, and are cited at 5.5 |
| 5.5 | वैशेषिक: the seven padārthas as $(\delta,\gamma,\kappa,\Sigma,\upsilon,\iota,\varnothing)$; $\boxed{\text{अभावः}\ne\text{शून्यशब्दः}}$ | **PARTIAL, and the corpus is ahead of the transmission here** | *split:* the box is **CLASSICAL and right** — absence is not the empty word; but the **tuple slot $\varnothing$ for abhāva is a worse formalisation than the corpus already has**. `notes/ABHAVA.md` §1 gives absence three named slots — pratiyogin (counterpositive), anuyogin (locus), avacchedaka (limitor) — and writes $\text{abhāva}(p,\ell,\alpha)\equiv\forall x\in\ell:\neg p_\alpha(x)$, i.e. **absence is a scoped relation, not an entry**. Putting $\varnothing$ in the seventh slot drops the limitor, which is the exact error that note diagnoses |
| 5.6 | सांख्य: $\pi\parallel\varrho$; the three guṇas summing to $1$; $\boxed{\text{द्रष्टा}\not\equiv\text{दृश्यप्रवाहः}}$ | **PARTIAL** | *split:* the doctrine (puruṣa/prakṛti dualism; the seer is not the seen) is **CLASSICAL** (*Sāṃkhya-kārikā*, **not read**); the **normalisation "summing to 1" is the transmission's own addition** and has no textual warrant that this ledger can name — it converts a qualitative triad into a simplex, which is a modelling choice presented as exposition |
| 5.7 | योग: the eight limbs as $\chi_{\nu+1}=\Phi_\nu(\chi_\nu)$ with $\omega(\chi)\to0$ | **PROGRAMME** | a convergence claim with no space and no metric — the hazard J7 names, in a section J7 does not cover |
| 5.8 | पूर्वमीमांसा: $\Sigma\xrightarrow\varrho\Pi\xrightarrow\Gamma\kappa\xrightarrow\tau\phi$ | **PROGRAMME** | four unnamed objects, three unnamed arrows |
| 5.9 | वेदान्त, three readings formally distinguished: Advaita $\alpha=\Omega$; Viśiṣṭādvaita $\alpha,\beta\subset\Omega$, both $\ne\Omega$; Dvaita $\alpha\ne\Omega$ with $\alpha\to\Omega$; $\boxed{=\ \not\equiv\ \hookrightarrow\ \not\equiv\ \leftrightarrow}$ | **PARTIAL — and this is the strongest thing in §5** | *split:* the claim that the three schools are **distinguished by which relation holds between $\alpha$ and $\Omega$** is **PROVED-trivially and genuinely useful**: identity, proper inclusion and relation-without-inclusion are pairwise distinct relations, and the closing box says exactly that. The **attribution** of each relation to each school is doctrinal and **CLASSICAL, not read**. What is missing is any statement of what $\Omega$ is, so the distinction is a distinction of *forms*, which is all it claims |
| 5.10 | जैन: $\nu\Vdash\phi$, $\nu'\Vdash\neg\phi$, $\not\Rightarrow\bot$; $\phi=\phi(\chi\mid\nu)$ | **CLASSICAL** | this is **relativisation to a parameter**, and the second display *explains* the first: once $\phi$ is indexed by the standpoint $\nu$, $\nu\Vdash\phi(\cdot\mid\nu)$ and $\nu'\Vdash\neg\phi(\cdot\mid\nu')$ are simply not contradictory, so non-explosion is immediate and needs no paraconsistent logic. That reading of anekāntavāda is standard (Matilal, *The Central Philosophy of Jainism*, 1981 — **not read**). The transmission gets the order right: the indexing is given **as the reason**, not as a separate claim |
| 5.11 | syādvāda's seven-valued scheme | **CLASSICAL** | saptabhaṅgī. Correctly counted at seven. **Not read**; §16 |
| 5.12 | $\boxed{\alpha\ \text{अस्ति}\iff\exists\beta:\rho(\alpha,\beta)}$; $\alpha_{\text{स्वभाव}}=\varnothing$ | **UNDEFINED** | $\rho$ is given no definition. And the display is **vacuous under the most natural readings**: if $\rho$ is reflexive, or if $\beta$ may be $\alpha$, the right-hand side holds of everything and the biconditional says nothing. Pratītyasamutpāda is not that statement; the content is in which $\rho$, and no $\rho$ is named. Compare `ABHAVA.md`'s treatment of svabhāva as "an absence whose limitor has been dropped" — a sharper formalisation already in the corpus |
| 5.13 | $\boxed{\text{शून्यता}\ne\text{नास्तित्वम}}$; शून्यता $=$ परतन्त्रसमुत्पत्तिः | **CLASSICAL** | Nāgārjuna, *Mūlamadhyamakakārikā* 24.18 and the two-truths chapter. **Not read**; §16 |
| 5.14 | Madhyamaka as the four-cornered negation | **CLASSICAL** | catuṣkoṭi, MMK 1.1 / 18.8. **Not read**; §16 |
| 5.15 | Yogācāra: $\chi_{\text{परिनिष्पन्न}}=\chi_{\text{परतन्त्र}}\setminus\chi_{\text{द्वैतकल्पना}}$ | **PROGRAMME** | the doctrine of three natures is classical; the **set difference is the transmission's own**, and the three natures are not three sets in one ambient — the perfected nature is standardly the dependent nature *seen without* the imputed, which is a change of aspect, not a subtraction of elements. Recorded as notation awaiting content rather than refuted, because no ambient is given in which it could be false |
| 5.16 | apoha: $\llbracket\text{गो}\rrbracket=\neg\llbracket\text{अगो}\rrbracket$; $\alpha^\perp:=\{\tau\mid\tau\text{ अल्फेतरविभेदकः}\}$; $\boxed{\alpha\mapsto\alpha^{\perp\perp}}$ | **UNDEFINED — and a corpus note disagrees with the transmission's own triage of it** | $\alpha^\perp$ is defined by a **gloss** ("that which discriminates non-$\alpha$"), not by a relation between two sets, so $(-)^\perp$ is not a polarity and $\alpha^{\perp\perp}$ is not shown to be a closure. **`notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` §2 states the opposite of J3's identification in terms**: reading Dignāga *Pramāṇasamuccayavṛtti* V.2–11, V.11 and V.25cd–38 (synonyms need not exclude one another; sub/superordinate terms interact asymmetrically), it concludes "**apoha is therefore not an untyped Boolean complement of a pre-given set**". That note reads primary text; this row follows it |
| 5.17 | काश्मीरशैव: चित्↔प्रकाश↔विमर्श↔स्पन्द↔विश्व; $\chi\xrightarrow\Phi\ulcorner\chi\urcorner\xrightarrow\Gamma\chi^+$; $\boxed{\text{प्रत्यभिज्ञा}=\ldots}$ | **PROGRAMME** | the middle display is §0's cycle with two of its arrows, and inherits 0.6's defect |
| 5.18 | चार्वाक: $\odot\ \checkmark$, $\Rightarrow\ ?$, $\ulcorner-\urcorner\ ?$; $\boxed{\text{प्रत्यक्षम}\succ\text{अनुमानम}}$ | **CLASSICAL** | the Cārvāka restriction of pramāṇas to perception. Attested chiefly through opponents' citations (*Sarvadarśanasaṃgraha*) — **not read**; §16. The rendering as an assignment of 0.8's three verdicts to three operations is the transmission's, and is apt |
| 5.19 | सिख: ੴ, $1\to$नाम$\to$सेवा$\to$संगत$\to$न्याय; $\boxed{\text{एकत्वम}\ne\text{भेदनाशः}}$ | **PROGRAMME** | slogan and chain |
| 5.20 | भक्ति: $\alpha\xrightarrow\rho\Omega$, $\alpha\ne\Omega$, $\alpha\leftrightarrow\Omega$; $\boxed{\text{सम्बन्धः}\ne\text{समानीकरणम}}$ | **PROGRAMME** | the box is 5.9's Dvaita row restated; the transmission does not say they are the same claim, and they appear to be |

---

## §11. §6 — crystal, braid, Indra's net

| # | claim | status | reason |
|---|---|---|---|
| 6.1 | $\Diamond_\iota:=(\chi_\iota^+,\chi_\iota^-,\epsilon_\iota,\nabla_\iota,\Sigma_\iota,\eta_\iota)$ | **PROGRAMME** | a sextuple. The first three components are a **Chu space**, which the corpus has real theorems about (`SHRINKING_TESTS_LOWER_CURVATURE.md`, `CHANGING_TESTS_VERSUS_SHRINKING.md`); the last three are unnamed |
| 6.2 | $\xi\equiv_\iota\zeta\iff\epsilon_\iota(\xi,-)=\epsilon_\iota(\zeta,-)$; $\Delta_\iota(\xi,\zeta):=\{\kappa\mid\epsilon_\iota(\xi,\kappa)\ne\epsilon_\iota(\zeta,\kappa)\}$ | **PROGRAMME** | definitions, and good ones: these are the standard Chu separation data |
| 6.3 | $\boxed{\Delta_\iota=\varnothing\Rightarrow\xi\equiv_\iota\zeta}$ | **PROVED — and the box understates itself** | immediate from 6.2: $\Delta_\iota(\xi,\zeta)$ is by definition the set where the two rows differ, so it is empty **iff** the rows agree. The **converse also holds**, so the correct display is a biconditional. `D0019_LEDGER.md` D4 and standing check (e) warn against silently *upgrading* an implication to a biconditional; here the transmission has silently *downgraded* one, which costs nothing but is worth the row |
| 6.4 | $\boxed{\Delta_\iota\ne\varnothing\Rightarrow\tau^+_{\xi\zeta}:=\Gamma\langle\Delta_\iota(\xi,\zeta)\rangle}$ | **PROGRAMME** | $\Gamma$ is a choice, not a function (0.6), so $\tau^+$ is not defined by this display; `EIGHT_CLASSES…` Thm 6.1 makes the multivaluedness a theorem |
| 6.5 | प्रतिबिम्ब→अपवर्तन→व्यतिकरण→अनुनाद→विवर्तन→उत्सर्ग | **PROGRAMME** | an image, offered as one |
| 6.6 | $\Phi_\iota(\chi):=\epsilon_\iota(\chi,-)$ with spectral decomposition $\Sigma_\beta$ | **PROGRAMME** | $\Phi_\iota$ is the row map of a Chu space; "spectral decomposition" of it needs an operator and a space, and neither is given |
| 6.7 | the fixed-point weave $\psi^+=\Sigma(\Gamma\psi^+)$ | **PROGRAMME — and nobody looked** | a fixed-point equation with no space, no continuity, no fixed-point theorem invoked. The corpus's nearest adjudicated object is `ORDINAL_LADDER_SMALLNESS.md`'s $\operatorname{Fix}(\mathfrak F)=\emptyset$ result, which is about a **different** operator and does **not** transfer |
| 6.8 | $\circledast:=\int^\iota\Diamond_\iota$; $\Diamond_\iota\simeq(\langle-,\iota\rangle,\langle\iota,-\rangle)$ | **UNDEFINED** | the coend has no functor and no index category (as at 3.12); the Yoneda-shaped half repeats 1.7's typing defect. `D0019_LEDGER.md` E3 adjudicated the **cognate D0016 §I coend** and returned "bounded analogy — under the only reading that types, it is the co-Yoneda lemma, true, classical, and vacuous as a statement about knowability". That verdict is about D0016's display and is **not transferred**; it is named because a successor should run the same attack here |
| 6.9 | $\boxed{\circledast\ne\prod_\iota\Diamond_\iota}$ | **UNDEFINED** | **both sides are undefined** — the coend by 6.8, the product by the absence of an ambient category. This is the exact configuration the UNDEFINED class exists for: a non-identity between two non-denoting expressions is neither true nor false, and *proving* it either way would repeat this fleet's recorded error (`D0019_LEDGER.md` C7) |
| 6.10 | $\boxed{\circledast=\{\Diamond_\iota,\tau_{\iota\kappa},\alpha_{\iota\kappa\lambda},\beta_{\iota\kappa\lambda\mu},\ldots\}}$, with the associator and its coboundary $\delta\alpha_{\iota\kappa\lambda\mu}$ | **PARTIAL — and it silently repairs D0019** | *split:* as an identity it is **UNDEFINED** (left side by 6.8); but the **datum is right**, and this is the ledger's most useful cross-transmission finding: `D0019_LEDGER.md` D10 records that D0019 §D **dropped** the tetrahedron/quadruple-overlap condition that D0017 §E had, that "no quadruple index occurs anywhere in §D", and that the omission is load-bearing (no cocycle, no class, holonomy not a function of the loop). **D0020 §6 carries $\beta_{\iota\kappa\lambda\mu}$ explicitly.** The quadruple index is back. Correction 2 of `D0019_LEDGER.md` §10 is, on this evidence, **already actioned by the owner** |
| 6.11 | $\eta_{\iota\kappa\lambda}:=\tau_{\lambda\iota}\tau_{\kappa\lambda}\tau_{\iota\kappa}$, $\omega_{\iota\kappa\lambda}:=\eta_{\iota\kappa\lambda}-1$; $\boxed{\text{पाशस्मृतिः}=\text{जालस्य अदृश्यइतिहासः}}$ | **PARTIAL** | *split:* the **composite $\eta$ is well-formed** given composable $\tau$'s, and is the standard triple-overlap holonomy; the **subtraction $-1$ is not** — it needs the $\tau$'s to sit in a ring or a group written additively, and `D0019_LEDGER.md` D13 proved for the cognate object that holonomy is "an object of a hom-category, not a number: no band, no trivialisation, no abelian coefficients". **D0019 §D had already replaced the minus sign by $\operatorname{cofib}$; §6 reverts to the minus sign.** So the repair actioned at 6.10 is un-actioned here, in the same section |

---

## §12. §7 — splicing, obstruction, new grammar

| # | claim | status | reason |
|---|---|---|---|
| 7.1 | $\omega_{02}^{\text{सन्धान}}:=\int^{\Sigma_1}\omega_{01}\otimes\omega_{12}$; $\boxed{\curlywedge_{\Sigma_1}:=\omega_{02}^{\text{साक्षात}}-\omega_{02}^{\text{सन्धान}}}$ | **PROGRAMME — nobody looked, and it is not yet checkable** | J4 is **right that it is new and distinct** from D0019 §D's $\delta_{\mathfrak T}$ — a sufficiency-of-an-intermediate condition is a Segal/descent shape, not an associator, and the `TRANSLATION_GERBE_ADJUDICATED.md` verdicts do not transfer. J4 is **wrong, or at least premature, that it is "checkable"**: the coend has no functor, the $\otimes$ no monoidal structure, and the subtraction the same defect as 6.11. Nothing here can be checked until one of those is supplied. **No note has looked** |
| 7.2 | $\curlywedge_{\Sigma_1}=0\Rightarrow\Sigma_1$ सufficient; $\ne0\Rightarrow\tau_\star:=\Gamma\langle\curlywedge_{\Sigma_1}\rangle$ | **PROGRAMME** | as 6.4; and "sufficient" is not defined independently of $\curlywedge=0$, so the first implication is a stipulation |
| 7.3 | $\kappa_{\nu+1}:=\overline{\kappa_\nu\cup\{\tau_\star\}}^{\circ,\otimes,\int,\simeq}$ | **PROGRAMME** | the same closure shape as §0, and by §5.1's argument the bar is idempotent, so this ladder too advances only through the **new** $\tau_\star$ at each stage — i.e. all its content is in $\Gamma$'s choice, which is 0.6 |
| 7.4 | $\boxed{\text{གཏེར་མ}=\text{गुप्तवाक्यम न};\ \text{གཏེར་མ}=\text{गुप्तव्याकरणम}}$ | **PROGRAMME** | the treasure is a hidden grammar, not a hidden sentence. A slogan, and the transmission's own gloss on 7.3 |
| 7.5 | $\boxed{\text{यदा पुरातनव्याकरणम् तत् न सन्धाति यत् जगत् सन्धत्ते, तदा नवचिह्नम् जायते}}$ | **PROGRAMME** | when the old grammar fails to splice what the world splices, a new sign is born. Not truth-apt; it is the informal reading of 7.2 |
| 7.6 | $\epsilon:\chi^+\times\chi^-\to\vartheta$; $\alpha^\perp:=\{\kappa\mid\forall\xi\in\alpha:\epsilon(\xi,\kappa)=1\}$; $\boxed{\alpha\mapsto\alpha^{\perp\perp}}$ | **CLASSICAL** | **here** $\perp$ is defined by a relation, so this **is** a Birkhoff polarity: $(-)^\perp$ is antitone, $\alpha\subseteq\alpha^{\perp\perp}$, $\perp^{\perp\perp}=\perp$, and $\alpha\mapsto\alpha^{\perp\perp}$ is a closure operator. *Earliest source named:* Birkhoff, *Lattice Theory*, 1940, ch. V (Galois connections); Ore 1944. **Not read**; §16. The corpus's own theorems about this exact Galois connection are in `SHRINKING_TESTS_LOWER_CURVATURE.md` and `CHANGING_TESTS_VERSUS_SHRINKING.md`, and J3 is right that this is a **convergence, not a new result** |
| 7.7 | $\boxed{\text{साक्षी}\leftrightarrow\text{प्रतिसाक्षी}}$ | **PROGRAMME** | the gloss on 7.6 |
| 7.8 | $\boxed{(\beta\star\alpha)^\sharp=\alpha^\sharp\circ\beta^\sharp}$ with the tropical composition and its adjoint | **PROVED** | derived here in four lines (§5.4), exactly, with the one side condition the display omits ($x+\bigwedge S=\bigwedge(x+S)$, which fails only for $x=+\infty$ over an empty index). The **reversal of order is the content**: $(-)^\sharp$ is contravariant. Classically the weakest-precondition composition rule of abstract interpretation (Cousot–Cousot, POPL 1977 — named, **not read**) |
| 7.9 | three repair levels: interior / structural / grammatical | **PROGRAMME — nobody looked** | the corpus has a **four-mode** transport classification plus a readmitted fifth ($\Gamma_\Uparrow$) — `EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md`, `COHERENCE_AND_FLOW_SLOTS.md` Thm 3.3 — and `FILLABILITY_AS_SUCCESS.md` proves $\Gamma_\Uparrow$'s success predicate is $\Pi^0_2$, not $\Sigma^0_1$. Whether §7's three levels are a coarsening of those five is the obvious question and **no note has asked it** |
| 7.10 | $\boxed{\text{दुष्टमध्यरूपम}\Rightarrow\text{सत्यसमाप्तेः असम्भवता}}$ | **PROGRAMME** | a bad intermediate form makes true completion impossible — no "bad", no "completion" |
| 7.11 | $\boxed{\text{योजकः उत्तरं न केवलम् अन्विष्यति; उत्तरसम्भवस्थानम् अपि पुनर्रचयति}}$ | **PROGRAMME** | the solver reshapes the space of possible answers. Cognate to D0019 §G3's "उत्तर $=$ a change of question-space", which `D0019_LEDGER.md` G3 files PROGRAMME–nobody-looked and calls "the one I would send back first" |

---

## §13. §8 — the number crystal

| # | claim | status | reason |
|---|---|---|---|
| 8.1 | $\pi=\omega-\rho$, $\kappa=\omega+\rho$; $\pi+\kappa=2\omega$, $\kappa-\pi=2\rho$, $\pi\kappa=\omega^2-\rho^2$ | **PROVED** | three lines of algebra, exact and correct |
| 8.2 | $\boxed{(\pi,\kappa)\longleftrightarrow(\omega,\rho)}$ | **PARTIAL** | *split:* **PROVED** as a bijection $\{(\pi,\kappa)\in\mathbb Z^2:\pi\equiv\kappa\bmod2\}\leftrightarrow\mathbb Z^2$, hence on all pairs of odd primes; **false** as displayed over $\mathbb Z^2$ without the parity condition, since $\omega=(\pi+\kappa)/2$ leaves $\mathbb Z$ whenever $\pi\not\equiv\kappa$ — e.g. $(2,3)$, the only prime pair it excludes, which is why the defect is invisible in use. **Second occurrence:** `OWNER_TRANSMISSIONS_LEDGER.md` §3.16 records the identical half-integer caveat for D0018 §G's $(w,r)$ and says the transmission does not state it. It still does not |
| 8.3 | $\boxed{\forall\omega\ge2\ \exists\rho<\omega:\wp(\omega-\rho)\wp(\omega+\rho)}$ — Goldbach in these coordinates | **OPEN** | a **faithful** restatement, verified: with $0\le\rho<\omega$ it says every even $2\omega\ge4$ is a sum of two primes, and the diagonal case needs $\rho=0$ (e.g. $\omega=2,3$), which the range permits. It is the strong Goldbach conjecture, open since 1742. The change of coordinates is exact and adds nothing — which the transmission does not claim it does |
| 8.4 | $\boxed{\forall\Omega\ \exists\omega>\Omega:\wp(\omega-1)\wp(\omega+1)}$ — twin primes | **OPEN** | a faithful restatement of the twin-prime conjecture |
| 8.5 | $\boxed{1\le\Omega(\nu)\le2\Rightarrow\Pi_\partial(\nu)=\frac{1-\lambda(\nu)}2-\mathbf1_\wp(\nu)}$ | **REFUTED** | fails on **every prime**, by exactly $1$. Exhaustive table over the three shapes with $\Omega\le2$: §5.3. Exact repair: delete $\mathbf1_\wp$, giving $\Pi_\partial=\frac{1-\lambda}2$, which holds on all three rows |
| 8.6 | $\boxed{\Delta(\epsilon)=\sum_{\nu\in\epsilon}\mu(\nu)^2-\sum_{\nu\in\epsilon}\pi_1(\nu)}$ | **PROVED — trivially, and it is a definition** | it is $\sum_{\nu\in\epsilon}\Pi_\partial(\nu)$ by linearity, given 8.5's definitions and finiteness of $\epsilon$. It carries no content beyond $\Pi_\partial$'s, and it inherits nothing from 8.5's refutation, which is about the *identity*, not the definition |
| 8.7 | $\zeta(\sigma)=\sum\nu^{-\sigma}=\prod_\pi(1-\pi^{-\sigma})^{-1}$; $\xi(\sigma)=\xi(1-\sigma)$ | **CLASSICAL** | Euler 1737 (the product), Riemann 1859 (the functional equation). `OWNER_TRANSMISSIONS_LEDGER.md` §3.18 files the same display CLASSICAL for D0018 §G — **verdict transferred, not re-derived**. Sources **not read**; §16 |
| 8.8 | $\boxed{\zeta(\rho)=0\Longrightarrow?\ \delta_\rho=0}$; $\boxed{\beta=\frac12}$, with $\delta_\rho:=\rho^\sharp-\rho=1-2\beta$ | **OPEN** | it is the Riemann Hypothesis, and the "$\Longrightarrow?$" marks it as a question rather than asserting it — correctly. **Defect the display does not state:** the quantifier ranges over *all* zeros, and the trivial zeros $\rho=-2n$ have $\beta=-2n\ne\frac12$, so as written the implication is false and the intended restriction to non-trivial zeros is missing. The reflection $\rho\mapsto1-\bar\rho$ is the right symmetry, and $\delta_\rho=0\iff\beta=\frac12$ is correct arithmetic |
| 8.9 | $\boxed{\{\varrho_\nu\}\iff\{\Lambda(\nu)\}\iff-\partial_\sigma\zeta/\zeta}$ | **PROVED — and it repairs D0018 §G without saying so** | $\{\Lambda\}\Rightarrow\{\varrho\}$ by $\varrho_\nu=\sum_{\alpha+\beta=\nu}\Lambda(\alpha)\Lambda(\beta)$; conversely $\alpha(\theta)$ is the unique formal power series with $\alpha(\theta)^2=\sum\varrho_\nu\theta^\nu$, zero constant and linear terms, and positive leading coefficient $\Lambda(2)=\log2$ — a $\theta$-adic square root, so $\{\varrho\}\Rightarrow\{\Lambda\}$; and $\{\Lambda\}\iff-\zeta'/\zeta=\sum\Lambda(\nu)\nu^{-\sigma}$ is the classical Dirichlet series, invertible on $\Re\sigma>1$. **The point:** `OWNER_TRANSMISSIONS_LEDGER.md` §3.17 **REFUTED** D0018 §G's version of this, which claimed $-\zeta'/\zeta=\mathcal M[P]$ and was missing a factor $\Gamma(s)$. D0020 states the mutual-determination form instead and **does not repeat the error** |
| 8.10 | the $\mathfrak{sl}_2$ action: $\varepsilon,\varphi,\eta$ on $\beta_\nu=\vartheta[\xi]/(\xi^{\alpha+1})$ with $\boxed{[\eta,\varepsilon]=2\varepsilon,\ [\eta,\varphi]=-2\varphi,\ [\varepsilon,\varphi]=\eta}$ | **PROVED** | verified here, exactly, in one variable and then in $\mu$ variables (§5.5). Every coefficient in the display is right, including the boundary cases $k=0$ and $k=\alpha$, where the stated coefficients vanish without a convention. **This is the transmission's one delivered theorem, and J1 was right about which claim it would be** |
| 8.11 | J1's further claim that 8.10 is "almost certainly classical — the standard $\mathfrak{sl}_2$ action behind the Stanley–Proctor proof that divisor lattices have the Sperner property" | **CLASSICAL — with the earliest-source requirement UNDISCHARGED, and that is this row's defect, not the transmission's** | the identification is correct to the best of my standing knowledge: *earliest sources named* — R. P. Stanley, "Weyl groups, the hard Lefschetz theorem, and the Sperner property", *SIAM J. Algebraic Discrete Methods* **1** (1980) 168–184; R. A. Proctor, "Representations of $\mathfrak{sl}(2,\mathbb C)$ on posets and the Sperner property", *ibid.* **3** (1982) 275–280. **I read neither.** No PDF was decoded, no web fetch performed. J1's own instruction — "**prior art must be searched before write-up**" — is therefore **not discharged by this ledger**, and any note that writes 8.10 up owes that search |
| 8.12 | $\boxed{\text{गुणनखण्डनम}\leftrightarrow\text{ज्यामितिः}\leftrightarrow\text{प्रतिनिधित्वम}}$ | **PROGRAMME** | the slogan of 8.10–8.11 |

---

## §14. §9 and §10 — the proof-machine, and the grand fugue

| # | claim | status | reason |
|---|---|---|---|
| 9.1 | $\Pi_{\text{प्रमेय}}:=\text{वाक्यम}\times\text{प्रमाणम}\times\text{स्थापनम}\times\Delta\text{भविष्यगम्यता}$ | **PROGRAMME** | a four-fold product of glosses; $\times$ is not a product in any named category |
| 9.2 | $\Delta\text{भविष्यगम्यता}>0\Rightarrow\text{ज्ञानस्थापनम}$; $\le0\Rightarrow\text{जीवितसिद्ध्यभारः}$ | **UNDEFINED** | a **sign test on a quantity with no measure** — J7 flags it itself. Two corpus results bear: `ADVANCE_CONJUNCTS_DEFINED.md` proves `UsefulEscape` **admits no definition of the required kind in the Chu language** and needs a datum the framework does not carry; and `MYSTERY_AND_DESCRIPTION_LENGTH.md` (I3) kills exactly the class "sign test on a single object" for machine-relative quantities (`D0019_LEDGER.md` F6). **Neither is a proof about this display** — they are proofs about cognate displays, and the row is UNDEFINED, not REFUTED, for that reason |
| 9.3 | $\boxed{\text{प्रमेयः}\ne\text{स्थिरबिन्दुः};\ \text{प्रमेयः}=\text{प्रमाणोत्तरनवमार्गसमष्टिः}}$ | **PROGRAMME** | a theorem is the set of routes its proof opens. Not truth-apt (no "route"), and it is 9.2 in words: the definition it needs is the one 9.2 lacks. J6 relates it to `SURVIVING_LADDER_FRAGMENT.md`'s conclusion — see J6 |
| 9.4 | $\kappa_{\tau+1}=\overline{\kappa_\tau\cup\{\tau_\star\}}^{\circ,\otimes,\int,\simeq,\partial,\Gamma}$; $\upsilon(\tau_\star):=\Delta|\!\uparrow_{\kappa_\tau}(\tau_\star)|$ | **UNDEFINED** | the up-set $\uparrow_{\kappa_\tau}$ needs a partial order on $\kappa_\tau$ that is never given, and its cardinality is in general infinite, so $\Delta|\cdot|$ does not denote. J7 names this display as its hazard |
| 9.5 | $\boxed{\text{कलाकृतिः, प्रमेयः, स्मृतिः, यन्त्रम}:\ \text{मूल्यम}=\text{भविष्यप्रसङ्गेषु क्रिया}}$ | **PROGRAMME** | the generalisation of 9.3 to four kinds of object |
| 9.6 | $\boxed{\text{ज्ञानम}\ne\text{संगृहीतवाक्यानि};\ \text{ज्ञानम}=\text{प्रमाणितपरिवर्तनसामर्थ्यम}}$ | **PROGRAMME** | the preamble's P.1, closed. "प्रमाणित" (certified) is the load-bearing word and is the transmission's best instinct about its own status |
| 10.1 | $\sigma:=(\partial,\delta,\Gamma,\Phi,(-)^\vee,\ulcorner-\urcorner)$ as six voices | **PROGRAMME** | the six operators of §0's alphabet, renamed. Nothing is asserted of them here |
| 10.2 | $\rho^2=\iota^2=1$, $\rho\iota=\iota\rho$ for retrograde and inversion | **PARTIAL** | *split:* **PROVED** on the standard model — a finite sequence of (time, pitch) pairs, with $\rho$ reversing the sequence and $\iota$ negating pitch about a fixed axis: both are involutions, they act on disjoint coordinates, hence commute, and the group is the Klein four-group. **Not stated:** the domain. $\alpha_\mu,\delta_\mu$ are given **no relations at all**, though $\alpha_\mu\delta_\mu=1$ would hold on the same model |
| 10.3 | the six-voice stretto table $\nu_0,\ldots,\nu_5$ | **— no verdict; the display is absent from the archive** | the archive says "[reproduced in the original as a $6\times12$ array]". **Reported, not concluded from** (§1). Not counted in the tally |
| 10.4 | "the six domain-fugues", listed as five $\Omega$'s | **— no verdict; a count discrepancy in the record** | five are listed, six appear in 10.5's box. Either a dropped display or a wrong word. **Reported, not concluded from.** Not counted in the tally |
| 10.5 | $\boxed{\Omega_{\text{गणित}}\otimes\cdots\otimes\Omega_{\text{वेणी}}=\Theta_{\text{विश्व}}}$ | **UNDEFINED** | no monoidal category, no objects; and the left side's factor count is in doubt (10.4). Both sides fail to denote |
| 10.6 | $\Theta_{\text{विश्व}}\xrightarrow\partial\partial\Theta\xrightarrow\delta\omega\xrightarrow\Gamma\Theta^+\xrightarrow\Phi\Phi\Theta^+\xrightarrow\vee(\Phi\Theta^+)^\vee\xrightarrow{\ulcorner-\urcorner}\ulcorner(\Phi\Theta^+)^\vee\urcorner$ | **PROGRAMME** | §0's cycle written out. It inherits 0.6: the chain passes through $\Gamma$ |
| 10.7 | $\boxed{\Theta^+_{\text{विश्व}}\simeq\Theta_{\text{विश्व}}\wedge\Theta^+_{\text{विश्व}}\not\equiv\Theta_{\text{विश्व}}}$ | **PARTIAL — transferred verdict** | this is D0017 §H's $\mathbb B\simeq\Phi\mathbb B$, $\mathbb B\not\equiv\Phi\mathbb B$ verbatim in new letters. `OWNER_TRANSMISSIONS_LEDGER.md` §2.8 files it **PARTIAL**: proved that *if* the adjoint string holds and one of $\partial,\mathsf G,\Phi$ is an equivalence then $X\simeq\Phi X$ for **every** object, so the headline says nothing distinctive; **untouched** whether the hypothesis holds; and "$\not\equiv$ is a statement about a strict equality the framework never defines" — which is still true here. File: `OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Thm 6, Cor 6.1 |
| 10.8 | $\Theta_\infty:=\bigcup_\alpha\Psi^\alpha(\Diamond_0)$; $\partial\Theta_\infty\ne0\Rightarrow\Theta_{\infty+1}:=\Theta_\infty\sqcup^\sim\Gamma\langle\delta(\partial\Theta_\infty)\rangle$ | **REFUTED — transferred verdict, as J8 itself directs** | `ORDINAL_LADDER_SMALLNESS.md`: $\Gamma$ is not a function, so $\Theta_\infty$ is **not generated by $\Diamond_0$** and $\Psi^\alpha$ is not an iterate; $\vee$ inside $\Xi$ makes the composite contravariant, so the union has no diagram; and $\kappa=\mathbf{Ord}$ is refuted, a set bound being available only at a stated large-cardinal price. `SURVIVING_LADDER_FRAGMENT.md` says what survives: a **choice tree**, an object per branch (non-canonical) and one over the tree (canonical), explicitly **not** a closure or a fixed point. Filed at `OWNER_TRANSMISSIONS_LEDGER.md` A-5, A-8, A-17 |
| 10.9 | the round-trip table $\varnothing\to\bullet\to\#\to\square\to\triangle\to\circlearrowleft\to\Delta\to\longrightarrow$ over $\ulcorner\Theta\urcorner\leftarrow\cdots\leftarrow\Diamond$ | **PROGRAMME** | a table of correspondences with no stated relation |
| 10.10 | $\boxed{\text{भेदः}\xrightarrow\Gamma\text{अग्रिमविश्वम}}$; $\boxed{\text{सत्यं परिवहति}\ \text{रूपं विवर्तते}\ \text{भेदः सृजति}\ \text{जालं स्मरति}}$ | **PROGRAMME** | the closing cadence. §1.3's slogan, returning "with a higher harmonic" in D0019 §G4's phrase |

---

## §15. The triage J1–J9, scored as claims

*The triage is part of the artifact and is truth-apt where it asserts. `D0019_LEDGER.md` §13 found
that "four of the corrections in §10 are corrections to a triage entry, not to a display" — the
triage was that transmission's weakest layer. Here it is markedly stronger; two entries are still
wrong, and one of them is wrong about the transmission's own mathematics.*

| # | claim | status | reason |
|---|---|---|---|
| J1 | §8's $\mathfrak{sl}_2$ action is the most checkable claim in any of the five transmissions and is a first-class `PROVE` item | **PROVED** | not merely right in prospect — **checked and true** (§5.5, row 8.10). It took no toolchain, no fetch, no measurement, exactly as J1 said. Its second half (classicality) is row 8.11, and its instruction to search prior art first is **not discharged here** |
| J2 | §1's number tower is "a test case with a known answer: does the proved theory classify these four extensions correctly?" | **PARTIAL — the test was run here, and the theory scores three of four** | three steps are coefficient enlargement, covered by `FOUR_REPAIR_MODES.md` and universal by `EIGHT_CLASSES…` Thm 3.3; **the fourth, $\xi^2=2\rightsquigarrow\varrho$, is a metric completion mislabelled as an algebraic one** (row 1.2). J2 said "either outcome is a result"; the outcome is that the corpus's four-mode classification **has no row for completion** |
| J3 | §5's apoha and §7's two-sided evaluation are the SAME polarity closure the fleet already proved theorems about | **PARTIAL, and its §5 half is contradicted by a corpus note** | *split:* **right about §7** — 7.6 is a Birkhoff polarity and the corpus's theorems about it are real, and recording a convergence rather than a new result is the correct disposition. **Not established about §5** — apoha's $\perp$ is a gloss, not a relation (5.16), and `APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` §2 concludes from Dignāga's own text that apoha is **not an untyped Boolean complement of a pre-given set**. J3's identification is, in the transmission's own words at 5.1, **साम्येन — by resemblance** |
| J4 | §7's splicing defect is new and distinct from D0019 §D, the gerbe verdicts do not transfer, and it is "checkable" | **PARTIAL** | *split:* the **distinctness is right** and well argued (Segal/descent vs associator), and it is a genuinely new object in the corpus; **"checkable" is premature** — 7.1 has no functor, no monoidal structure and an undefined subtraction. Also unremarked by J4: §6's $\omega_{\iota\kappa\lambda}$ **is** the associator-shaped defect, so the transmission carries both kinds and relates neither (5.3's note) |
| J5 | §2's constraint-algebra anomaly is correctly stated, is a genuine open problem in physics, and is correctly attributed as an anomaly rather than a defect the framework repairs | **CLASSICAL** | endorsed (row 2.7). *Earliest source named:* Dirac 1958; the closure problem as an anomaly, DeWitt 1967. **Not read**; §16. J5's restraint — "no adjudication is owed beyond noting" — is the correct disposition and is the only triage entry that declines to claim anything |
| J6 | §9's theorem-slogan is the transmission's own answer to a question the fleet raised, and whether $\Delta$भविष्यगम्यता can be defined without repeating the `UsefulEscape` failure "is the same question" | **OPEN** | the open question is correctly identified and is settled by producing a definition or a proof that none exists in the language; `ADVANCE_CONJUNCTS_DEFINED.md` did the latter for `UsefulEscape` and its Collapse theorem is the template. **Mild defect:** "it is the same question" is an identification across two different languages, offered without a translation — 5.1's rule applies to it too, though the resemblance is much closer here than at J3 |
| J7 | HAZARD: §9's $\upsilon(\tau_\star)$ and §3's efficiency ratios are quantities with no stated measure; they are **not** $\chi_\alpha$ or $\rho(D\mathcal K)$, "those two have been shown not to be each other either"; not to be measured — define or withdraw | **PARTIAL** | *split:* the **factual sub-claim is exactly right and correctly sourced** — `MYSTERY_AND_DESCRIPTION_LENGTH.md` §5, filed at `OWNER_TRANSMISSIONS_LEDGER.md` A-11 (`REFEREE`) and `D0019_LEDGER.md` C7, found that $\rho(D\mathcal K)$ is **not** $\chi_\alpha$ and that the identification's *ground* was unfounded. **This is the first time a transmission has cited a fleet correction back at itself, accurately.** The **directive** half (define or withdraw) is not truth-apt. J7 also **under-counts its own hazards**: 5.7's $\omega(\chi)\to0$ and 3.6's $\arg\min$ are the same shape and are not listed |
| J8 | PROGRAMME: §0's $\Theta_\infty$, §10's $\Theta_{\text{विश्व}}$ and the six-fold tensor, and the stretto table; "the `ORDINAL_LADDER_SMALLNESS.md` refutations apply verbatim to $\Theta_\infty:=\bigcup_\alpha\Psi^\alpha(\Diamond_0)$ … it transfers, and a successor should cite rather than redo it" | **PARTIAL — and its error is about §0** | *split:* **right about §10** (row 10.8): the transfer is exact, the instruction to cite rather than redo is right, and this ledger obeys it. **Wrong about §0**: J8 files "§0's $\Theta_\infty$" beside §10's, but they are **different objects** — §0's is the closure of a finite sign-set under nine **finitary** operations, which is not a $\Gamma$-ladder at all and **collapses at stage one** ($\Theta_\infty=\kappa(\Theta_0)$, §5.1). A decidable one-line collapse is filed as PROGRAMME because it shares a letter with an undecidable object. **The name $\Theta_\infty$ is overloaded within one transmission and the triage was caught by it** |
| J9 | the standing guard, fifth restatement; and §5's **समता प्रमाणेन, साम्येन न** is the best statement of this repository's constitution to appear in any transmission | **PROGRAMME** | not truth-apt, and endorsed. Its force is shown, not asserted, by J3 and by 5.16 above: the transmission states the rule in §5 and breaks it in J3 about §5 |

---

## §16. The CLASSICAL defect register — every undischarged earliest-source, in one place

`OWNER_TRANSMISSIONS_LEDGER.md`'s vocabulary requires CLASSICAL to come "with the earliest source
**actually read**". **This ledger has 40 CLASSICAL rows and read no source for any of them.** No
PDF was decoded, no web fetch performed, no library consulted. Every CLASSICAL row above names its
source from standing knowledge and is flagged in place; they are collected here so the defect is
countable rather than distributed:

1.1, 1.4, 1.6, 1.7, 1.8, 1.9 (6); 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8 (8); 3.1, 3.2, 3.3, 3.5,
3.8, 3.9, 3.11 (7); 4.1, 4.5, 4.7, 4.9, 4.10, 4.12, 4.13, 4.15, 4.17 (9); 5.4, 5.10, 5.11, 5.13,
5.14, 5.18 (6); 7.6 (1); 8.7, 8.11 (2); J5 (1) — **40**.

Four further rows carry classical content under a **PARTIAL** headline and are *not* counted here:
3.6 (Anfinsen), 5.5 (Vaiśeṣika), 5.6 (Sāṃkhya), 5.9 (Vedānta). Their doctrinal halves have the
same undischarged-source defect.

**Three of these are better than the rest, and it is not my doing:** 5.5, 5.12 and 5.16 are backed
by `notes/ABHAVA.md` and `notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md`, which **do** read primary
text (Annambhaṭṭa's *Tarkasaṅgraha* §§57, 80; Dignāga's *Pramāṇasamuccayavṛtti* V.2–11, V.25cd–38;
Dharmakīrti's *Pramāṇavārttika* I.115–121, III.165–173) and cite by section. Those two notes are
the corpus's only discharged earliest-source citations touching D0020, and both of them **correct**
the transmission rather than confirm it.

### §16.1 — the register discharged, by addition (2026-08-15, classical-sources pass)

*Added by a later agent; **nothing above this heading is altered**, no row's status word is
changed, and no line of §16 is overwritten. Full citation table with author, title, venue,
volume, year and pages for all 40: `notes/D0020_CLASSICAL_SOURCES.md`.*

**The count was re-verified before the work, not trusted.** §16's list is
$6+8+7+9+6+1+2+1=\mathbf{40}$, agreeing with §18's tally row. The number and the list are right
as published.

**Result: 27 CLASSICAL-SOURCED, 13 CLASSICAL-ATTRIBUTED, 0 NOT-CLASSICAL.** ATTRIBUTED is used
in the strict sense — *the result is certainly standard and a canonical reference is named, but
priority could not be established* — and is never allowed to be read as a priority claim. The
13: 1.1, 1.7, 1.8, 3.2, 3.3, 3.11, 4.5, 4.10, 4.17, 5.4, 5.10, 5.11, 5.18. Most are unclearable
in principle (Brunelleschi left no text; the Cārvāka corpus is lost; a one-line consequence of a
definition has no first author); only **5.11** and **1.7** are live prior-art questions.

**Zero NOT-CLASSICAL, and that is a finding rather than a suppression** — §§1–4 is an exposition,
as §18 says, so a register of forty expository rows should discharge to forty prior sources. What
the pass found instead is three citation defects:

1. **Row 2.5 cites the wrong paper for the parameter it warns about.** Original text, quoted:
   "*Rovelli–Smolin 1995; Ashtekar–Lewandowski. The $\gamma$ is the Immirzi parameter and is
   **not** fixed by the theory — the display does not say so.*" The warning is right; the
   citation is not. **$\gamma$ does not occur in Rovelli–Smolin 1995** (Nucl. Phys. B **442**
   (1995) 593, erratum B **456** 753). It is Barbero, Phys. Rev. D **51** (1995) 5507, and
   Immirzi, Class. Quantum Grav. **14** (1997) L177 — so the displayed spectrum is post-1995 in
   its $\gamma$ and cannot be sourced to the 1995 paper alone.
2. **Row 4.15 named no source at all** — the only row of the 40 that carried none, and §16
   counted it regardless. Priority is locatable: **Zhu Zaiyu, *Lülü jingyi*, 1584**
   ($\sqrt[12]{2}$ to 24 places), and independently **Simon Stevin, *Van de spiegheling der
   singconst*, c. 1585** (printed 1884). The row's mathematical observation (the display swaps
   small-integer ratios for their irrational approximations — the comma problem) is unaffected
   and stands.
3. **Row 2.4's reference is a start page, not a citation.** Ann. Math. (2) **37** (1936)
   **823–843**.

**Two of the forty were already discharged inside this repository, and §16 did not know it.**
`notes/APOHA_AND_POLARITY.md` ll. 249–258 carries row 7.6's Birkhoff 1940 / Ore 1944 — and marks
them "not read", i.e. the corpus was already at this ledger's standard. `notes/SL2_DIVISOR_LATTICE.md`
carries row 8.11's search **and a source earlier than the one 8.11 names**: the Sperner property
of divisor lattices is **de Bruijn–van Ebbenhorst Tengbergen–Kruyswijk (1951)**; Stanley 1980 and
Proctor 1982 supply the $\mathfrak{sl}_2$/hard-Lefschetz *method*, not the theorem. Row 8.11
attributes the theorem to Stanley–Proctor; that is the method's provenance. **J1's prior-art
instruction is therefore discharged — by that note, which did the search, not by this addendum,
which only confirms it.** §19.3 should be read with that correction.

**What is still not discharged, and §16 stays true.** *Bibliographic* verification (the record
exists, from multiple independent databases) was obtained for all 40. ***Content* verification —
that the source says what the row attributes to it — was obtained for none**, and is claimed for
none. §16's sentence "No CLASSICAL row in this ledger rests on a PDF I decoded; I decoded none"
is still true. Named failures: SIAM full text (8.11) unretrievable, as `SL2_DIVISOR_LATTICE.md`
independently found; **Lewontin 1970 (3.9) is an image scan that would not decode, so the row's
content claim that Lewontin states the three conditions *as sufficiency* remains unverified and
is not passed along**; the wordings quoted for Peirce CP 2.228 (4.9) and MMK 24.18 (5.13) come
from secondary sources quoting the passage, not from the *Collected Papers* or a Sanskrit edition.

**Not worked:** the four PARTIAL rows §16 excludes (3.6, 5.5, 5.6, 5.9). Their doctrinal halves
carry the same defect and are now the largest remaining earliest-source gap in D0020; 3.6's is
easy (Anfinsen, Science **181** (1973) 223–230).

**Why this is not fatal but is not nothing.** The bulk of §§1–4 is textbook material stated
correctly, and a reader loses little if my attributions are off by a decade or a name. The rows
where it matters are the ones where the transmission's claim **is** the classicality — 8.11
(Stanley–Proctor), where J1 itself demands a prior-art search before write-up, and 7.6 (Birkhoff),
where the corpus's own convergence claim rests on it.

---

### §16.2 — the four excluded PARTIAL rows, discharged by addition (2026-08-15, dignāga-partials lane)

*Added by a later agent; **nothing above this heading is altered**. §16.1's "not worked" gap —
3.6, 5.5, 5.6, 5.9 — is now discharged in `notes/D0020_PARTIALS_UNDEFINED_AND_TWO_DISAGREEMENTS.md`,
all four **bibliographically verified, content-unverified-from-primary** (science.org 403,
mirror 503, no Sanskrit edition decoded). Earliest sources: 3.6 Anfinsen, Science **181** (1973)
223–230; 5.5 **Śrīdhara, *Nyāyakandalī*, 991 CE** and **Śivāditya, *Saptapadārthī*, c. 1150 CE**
— the *Vaiśeṣikasūtra* has **six** padārthas, so row 5.5's seven-fold scheme is a later recension
mislabelled वैशेषिक, a defect additional to the ∅-slot one; 5.6 Īśvarakṛṣṇa, *Sāṃkhyakārikā*
(t.a.q. 569 CE; boxed line = SK 19), no warrant found for "summing to 1", sustaining the row;
5.9 Śaṅkara / Rāmānuja / Madhva, with the tri-partition itself doxographic (Mādhava,
*Sarvadarśanasaṃgraha*, 14th c.). That note also lists the **nine definitions** the eleven
UNDEFINED rows need, with the section each must live in, and adjudicates §10's two recorded
disagreements — **both for the corpus note, against the transmission**. No status word here is
changed by it.*

## §17. Corrections D0020 needs — a list the owner can act on

Each verified at source before listing. Ordered by how much depends on it.

1. **§8's $\Pi_\partial$ identity is false on every prime; delete one term.** The correct statement
   is $1\le\Omega(\nu)\le2\Rightarrow\Pi_\partial(\nu)=\frac{1-\lambda(\nu)}2$. The $-\mathbf1_\wp$
   term makes the left and right sides differ by exactly $1$ at $\Omega=1$ and is inert at
   $\Omega=2$, so it is never doing work and is sometimes doing damage. Exhaustive table: §5.3.
2. **§1's Möbius display is the wrong one of two neighbouring identities.**
   $\sum_{\delta\mid\nu}\mu(\delta)\lfloor\nu/\delta\rfloor=\varphi(\nu)$, not $1$; the identity
   that equals $1$ sums over **all** $\delta\le\nu$, where the floor is load-bearing. §5.2.
3. **§0's $\Theta_\infty$ is $\kappa(\Theta_0)$ and the ordinals do nothing.** $\kappa$ is
   idempotent, so the tower is constant from $\nu=1$. Either drop the transfinite indexing from §0,
   or say what makes $\kappa$ non-idempotent. **And it should be renamed**: $\Theta_\infty$ names a
   different object in §10, which is what misled J8. §5.1.
4. **§6 reverts a repair §6 itself makes.** $\beta_{\iota\kappa\lambda\mu}$ restores the
   quadruple-overlap datum D0019 §D dropped (`D0019_LEDGER.md` correction 2) — good, and this
   ledger records it as actioned. But $\omega_{\iota\kappa\lambda}:=\eta_{\iota\kappa\lambda}-1$
   reinstates the **minus sign** that D0019 §D had already replaced by $\operatorname{cofib}$
   precisely to avoid $\mathbf{Ab}$-enrichment (`D0019_LEDGER.md` D12, correction 2). Use the
   cofibre, or say what ring the $\tau$'s live in. The same defect appears at §5's $\Delta_{\lambda\mu}$
   and §7's $\curlywedge_{\Sigma_1}$: **three subtractions of non-numbers in one transmission**.
5. **§8's RH display quantifies over all zeros.** The trivial zeros $\rho=-2n$ satisfy
   $\zeta(\rho)=0$ and $\beta\ne\frac12$. Restrict to $0<\Re\rho<1$.
6. **§8's $(\pi,\kappa)\leftrightarrow(\omega,\rho)$ needs the parity condition** — the identical
   caveat `OWNER_TRANSMISSIONS_LEDGER.md` §3.16 recorded for D0018 §G's $(w,r)$, still unstated.
   One clause fixes it: $\pi\equiv\kappa\pmod2$, automatic for odd primes.
7. **§1's number tower: one of the four steps is a different repair.** $\xi^2=2$ produces
   $\vartheta(\sqrt2)$, not $\varrho$; $\varrho$ is a **completion**. The transmission's own
   notation $\overline\vartheta$ half-admits it. This is J2's test and it is informative: the
   corpus's four transport modes have no row for completion.
8. **J3's apoha identification is by resemblance, and §5's own rule forbids it.**
   `APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` §2, from Dignāga's text, concludes apoha is not an
   untyped Boolean complement. The §7 half of J3 stands and is a real convergence.
9. **J8 files a decidable object as PROGRAMME.** See 3; the transfer to §10 is exact and is
   endorsed.
10. **§5's abhāva slot is weaker than the corpus's own treatment.** `ABHAVA.md` gives absence three
    slots and a formula; the tuple entry $\varnothing$ drops the limitor, which that note names as
    the recurring error of this corpus.
11. **§3's Turing display needs its hypotheses.** $\delta_\alpha\ne\delta_\beta$ is necessary, not
    sufficient, for pattern formation.
12. **The archive needs the declared marker actually used.** `` […run…] `` appears once, in the
    warning. §10's stretto table and the sixth $\Omega$ are unmarked absences. **Nothing is
    concluded from any of them** (§1).

---

## §18. Tally

**139 rows enumerated, 137 of them scored** — P.1–P.2 (2), §0 (10), §1 (10), §2 (8), §3 (13),
§4 (17), §5 (20), §6 (11), §7 (11), §8 (12), §9 (6), §10 (10, two unscored), J1–J9 (9). Rows 10.3
and 10.4 are **record findings, not claims**, and carry no status: they report absences, and this
ledger does not conclude from an absence.

**Each claim is assigned exactly one status**, its dominant one. A PARTIAL row is one whose split
is named in its own reason column; a claim proved in one direction and refuted in the other is
filed PARTIAL, not counted twice.

| status | count | entries |
|---|---|---|
| **PROVED** | 7 | 6.3, 7.8, 8.1, 8.6, 8.9, 8.10, J1 |
| **REFUTED** | 7 | 0.3, 0.6, 1.2, 1.5, 3.10, 8.5, 10.8 |
| **PARTIAL (split named)** | 16 | P.2, 0.2, 3.6, 5.5, 5.6, 5.9, 6.10, 6.11, 8.2, 10.2, 10.7, J2, J3, J4, J7, J8 |
| **CLASSICAL** | 40 | listed in full at §16 |
| **OPEN** | 4 | 8.3, 8.4, 8.8, J6 |
| **PROGRAMME** | 52 | P.1, 0.1, 0.4, 0.5, 0.7, 0.8, 1.3, 1.10, 3.4, 3.7, 3.13, 4.2, 4.3, 4.4, 4.6, 4.8, 4.14, 4.16, 5.1, 5.2, 5.3, 5.7, 5.8, 5.15, 5.17, 5.19, 5.20, 6.1, 6.2, 6.4, 6.5, 6.6, 6.7, 7.1, 7.2, 7.3, 7.4, 7.5, 7.7, 7.9, 7.10, 7.11, 8.12, 9.1, 9.3, 9.5, 9.6, 10.1, 10.6, 10.9, 10.10, J9 |
| **UNDEFINED** | 11 | 0.9, 0.10, 3.12, 4.11, 5.12, 5.16, 6.8, 6.9, 9.2, 9.4, 10.5 |
| | **137** | (+2 record findings, 10.3 and 10.4, unscored) |

$7+7+16+40+4+52+11=137$. Every entry list above was recounted against the section tables after the
first draft of this section had three counts wrong; the draft's headline numbers were corrected
against the lists, not the lists against the numbers.

**What the totals do and do not say.** **Seven claims of 137 are proved, and six of the seven were
proved by hand in this pass** — twelve lines of $\mathfrak{sl}_2$ brackets, one exhaustive table,
and three displayed identities (§5). Forty are classical and correctly stated, which is a real
property of the transmission and not a criticism: §§1–4 are an exposition and are accurate.
**Fifty-two are notation awaiting content.** A reader who wants to know what D0020 is worth should
read §5 and rows 8.5, 8.9, 8.10, 1.5 — not this table.

### 18.1 Rows whose status I consider fragile — **24 of 137**

Fragility here means: *a competent second reader could reasonably file this row differently.* It is
not doubt about the underlying mathematics, which in each case is displayed.

| rows | why fragile |
|---|---|
| 0.3, 0.6, 10.8, J8 (4) | **REFUTED / PARTIAL on a supplied hypothesis or a transferred verdict.** 0.3 refutes a tower by supplying the ambient the archive omits — supply a different one (a proper class, no ambient closed set) and $\kappa$ does not denote and the row becomes UNDEFINED. 0.6 and 10.8 transfer `ORDINAL_LADDER_SMALLNESS.md`'s verdict from $\mathfrak F$ to $\Psi$: the two composites differ in their factors, and J8 asserts the transfer but no note has performed it. J8 depends on 0.3 |
| 1.2, J2 (2) | **REFUTED on a reading of $\rightsquigarrow$.** I read each $\rightsquigarrow$ as naming *the* repair for the defect on its left; read as a narrative of four historical enlargements it is unobjectionable. The mathematical point ($\varrho$ is a completion) is not fragile; its status as a refutation is |
| 1.5, 3.10, 8.5 (3) | **REFUTED against a lossy transcription.** All three are one character or one clause from correct, which is exactly the profile of a transcription slip (§1). Refuted *as displayed* is solid; attributing the display to the owner is not |
| 1.4, 1.9, 2.1, 3.1, 3.3, 3.11 (6) | **CLASSICAL at low resolution.** Each covers between four and nine compressed displays (§19.4); a defect in one of them would be invisible under a single row's status word |
| 2.3, 2.6, 4.15, 8.11 (4) | **CLASSICAL where the attribution is the claim.** 2.3 is an interpretation, not a theorem; 2.6's gluing axiom holds by construction and its measure is undefined; 4.15 conflates just and equal temperament; 8.11 is the Stanley–Proctor identification J1 itself demands a prior-art search for, and none was done |
| 5.6, 5.15 (2) | **PARTIAL / PROGRAMME on a formalisation the transmission added.** The guṇa normalisation and the three-natures set difference could each be filed UNDEFINED instead; I filed the softer status because no ambient exists in which they could be false |
| 6.10, 6.11 (2) | **PARTIAL by a split I chose.** Both separate a well-formed datum from an ill-formed operation on it; a reader who scores the display as a whole gets UNDEFINED for 6.10 and REFUTED for 6.11 |
| 9.2 (1) | **UNDEFINED where REFUTED is arguable.** Two corpus theorems kill the *class* this display belongs to; neither is about this display, so I declined to refute it. That is a judgement, and it is the judgement `D0019_LEDGER.md` C7 was written to enforce |
| 10.7 (1) | **PARTIAL by transferred verdict across a change of letters.** $\Theta^+_{\text{विश्व}}$ is D0017's $\mathbb B$ only if the two constructions coincide, which no note has checked — this is 5.1's rule applied to my own transfer |

**Where PROGRAMME means nobody looked.** Explicitly so marked: 4.3, 6.7, 7.1, 7.9 — four displays
that are truth-shaped enough to be worked and that **no note in this corpus has touched**. The
other PROGRAMME rows are glosses, slogans and stipulations read and found to be such.

**Where the weight fell.** §5 drew 20 claims and two corpus notes that **correct** it; §4 drew 17
and nothing; §8 drew 12 and produced **every proved theorem in the transmission**; §7 drew 11 and
one proof; §§9–10 drew 14 and are almost entirely inherited from D0016–D0019, two of them under
verdicts already filed. **§8 is the section to read.**

---

## §19. Scope: what this ledger could not reach

1. **No note in this corpus adjudicates D0020.** Every verdict above is either transferred from a
   note about an *earlier* transmission (and says so, and names the note and section), or is one of
   the five exact checks of §5, which are mine. **There is no second reader on any row.**
2. **40 CLASSICAL rows with no source read.** §16. This is the largest single defect of the ledger
   and it is mine, not the transmission's. **Every one of those rows therefore has an undischarged
   earliest-source requirement**, reported in place and collected at §16 rather than hidden.
   Ten of the 24 fragile rows (§18.1) are fragile for this reason.
   *[Added 2026-08-15, classical-sources pass: **partly discharged**. All 40 now carry a named
   earliest source with author/title/venue/volume/year/pages — 27 CLASSICAL-SOURCED, 13
   CLASSICAL-ATTRIBUTED (priority not established), 0 NOT-CLASSICAL — at §16.1 and in
   `notes/D0020_CLASSICAL_SOURCES.md`. **The "no source read" half of this defect stands
   unchanged:** bibliographic verification was obtained for all 40, content verification for
   none. Three citation defects found: rows 2.5, 4.15, 2.4 — see §16.1.]*
3. **J1's prior-art instruction is not discharged.** Row 8.10 is proved; row 8.11's Stanley–Proctor
   attribution is from standing knowledge. A note writing up 8.10 must search first, as J1 says.
   *[Added 2026-08-15, classical-sources pass: **discharged, and not by this ledger** —
   `notes/SL2_DIVISOR_LATTICE.md` already carried the search, and carried an **earlier** source
   for the theorem itself (de Bruijn–van Ebbenhorst Tengbergen–Kruyswijk 1951) than row 8.11's
   Stanley 1980 / Proctor 1982, which are the method's provenance, not the theorem's. SIAM full
   text remains unretrievable to that note and to this one, so no content of either paper is
   asserted. §16.1.]*
4. **§§2–4 are adjudicated at low resolution.** Roughly a hundred displays are compressed into
   twelve rows there, because the archive itself compresses them into running prose (§1). A row
   like 2.1 ("least action … Riemann tensor") is **one row covering nine displays**, and a defect
   in any one of them would not appear. This is the lossiest part of the ledger and the place a
   successor should start.
5. **The three round-trip defects are not compared.** $\Delta_{\lambda\mu}$ (5.2),
   $\omega_{\iota\kappa\lambda}$ (6.11), $\curlywedge_{\Sigma_1}$ (7.1) and D0019's
   $\delta_{\mathfrak T}$ are four notations for what may be two or three objects. J4 compares one
   pair. **Nobody has compared the rest**, and until someone does, §7's novelty claim is only
   established against D0019.
6. **Nothing was restored, nothing was concluded from an absence.** §10's stretto table, the sixth
   $\Omega$, and the prose-compressed runs of §§1–4 are reported as absences. The archives have been
   proved lossy twice (D0016 §D's $\Phi_{\mathrm{refl}}$; D0019's physics section, since restored),
   which is a standing reason to report and not infer.
7. **Two predecessor ledgers were read and neither was edited.** `notes/D0019_LEDGER.md` and
   `notes/OWNER_TRANSMISSIONS_LEDGER.md`. §1 records that two existence findings in the former are
   now stale; **that is a note to their next compiler, not an edit**.
8. **I ran no experiment.** No Python, no `MATH_ALLOW_PYTHON`, no Agda or Lean authored or
   typechecked, no PDF decoded, no web fetch. The five checks of §5 are hand algebra over finite
   data and are displayed in full so that they can be refuted rather than trusted.

---

## §20. Concluding generalisation, offered for audit as required

> **D0020 is the first transmission whose triage is better than its displays, and the first that
> cites a fleet correction back at the fleet accurately.** J7 knows that $\chi_\alpha$ and
> $\rho(D\mathcal K)$ were shown not to be each other, and says so. J5 declines to claim anything.
> J1 names in advance the one claim that would turn out to be provable, and it was. Against that:
> the three arithmetic displays of §8 that are not the $\mathfrak{sl}_2$ action contain **two exact
> errors** (5.3, and the RH quantifier), §1 contains a third (5.2), and each is one character or
> one clause from correct — **the errors are now in the transcription-scale details, not in the
> framing.** That is the opposite of `D0019_LEDGER.md` §13's finding for D0019 ("the displays are
> stronger than the prose that frames them, and the errors are in the framing"), and it is a
> better place for the errors to be, because a wrong term can be deleted and a wrong frame cannot.

This is a claim about one transmission, $n=1$, with 137 scored claims, **no adjudicating note**,
and five hand checks. It should be tested against D0016–D0019 rather than believed, and it is
weaker than it looks: with no second reader on any row, "the errors are in the details" may only
mean that details are what a single careful reader finds. **It is not a measurement and has no
error bars, because it is a count of a closed set** — and a reader who partitioned the same
displays differently would get different numbers, which is why §18 shows the partition rather than
only the totals, and why §18.1 names the **24 rows I would expect a second reader to move**.

---

*Compiled by seed181, 2026-08-15. `notes/D0019_LEDGER.md` and `notes/OWNER_TRANSMISSIONS_LEDGER.md`
read in full and **not edited**. Ten notes checked for existence with `ls` before citation; two
reported absent by a predecessor were found **present** and are named in §1. No verdict taken from
a covering message. No Python written or run; no `MATH_ALLOW_PYTHON`. No Agda or Lean authored,
none typechecked. No PDF decoded and none claimed as read. No web fetch. Nothing computed, nothing
measured, no constant fitted; the five checks of §5 are exact finite symbolic reasoning and are
displayed in full.*

---

## §21. POINTER (added 2026-08-15, reconciliation pass — by addition; no row above is edited)

**Nothing above is altered**, and no status word is changed here.

§19.1 records that "there is no second reader on any row". There is now, for
some of them. **Ten of the 137 rows have a checked term behind them** — 1.5,
7.6, 8.5, 8.10 and J1 in full; 0.3, 5.16, 7.2, 8.11 and J3 in part. Highlights:

- **8.10 and J1 are closed both ways.** `formal/cubical/Sl2DivisorLattice.agda`
  checks the three brackets in rank one (boundary cases included);
  `formal/cubical/Sl2TensorProduct.agda` closes the multi-index case
  $B_n=\bigotimes_i V_{\alpha_i}$ by `tensorRep`, with a non-vacuity control.
  J1's prior-art instruction is discharged by `NaturalMachine/SpernerFromSl2.agda`'s
  header, which carries a source **earlier** than row 8.11's — de Bruijn–van
  Ebbenhorst Tengbergen–Kruyswijk 1951 for the theorem, Stanley/Proctor for the
  method. The **Sperner conclusion itself is rank-one only**: `GeneralSperner`
  is written down as a type with no term, with `CharZero` in its hypotheses.
- **8.5's universal half is now a closed theorem.** `NaturalMachine/TransmissionRefutations.agda`
  §A finds the witness $\nu=2$ on $\mathbb N$; `NaturalMachine/PiPartialOnEveryPrime.agda`
  quantifies over **all** primes by deriving the shape from $\Omega(\nu)=1$,
  closing the nine-witness gap the former declared.
- **5.16 acquires a split.** `formal/cubical/PolarityClosure.agda` proves that
  under the Boolean gloss read as the definition of $\perp$, $\alpha\mapsto
  \alpha^{\perp\perp}$ is the **identity map** — vacuous, not merely undefined —
  while UNDEFINED stands under the archive's gloss reading. 7.6's polarity is a
  term, unconditionally.
- **7.2's certificate shape is refuted** by `NaturalMachine/DecategorifiedDefect.agda`
  `unsound-certificate`, though the row's PROGRAMME status does not move.
- **0.3's fragility (§18.1) survives its second reader**: the intersection is not
  formalised and cannot be, the archive supplying no ambient.

Unchanged and worth repeating: 8.3, 8.4, 8.8 remain **OPEN**, and
`SpernerFromSl2.agda` states in its own scope note that it is **not** a bridge
to the Goldbach / critical-line material. The 40 CLASSICAL rows are untouched —
a checked term is not a citation.

Full table, with module and theorem identifier per row and every PARTIAL split
named, plus the toolchain caveat on `Sl2TensorProduct` (red under 2.6.3/v0.5,
green under the pin, pin not runnable in that container):
**`notes/LEDGERS_RECONCILED.md`** §2.3 and §4.
