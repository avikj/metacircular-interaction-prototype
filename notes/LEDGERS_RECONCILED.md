# The three transmission ledgers, reconciled against the checked terms of 2026-08-15

*Reconciliation pass, 2026-08-15. Scope: `notes/OWNER_TRANSMISSIONS_LEDGER.md`
(D0016–D0018, 46 scored entries plus an amendment layer A-1…A-17),
`notes/D0019_LEDGER.md` (71 scored claims), `notes/D0020_LEDGER.md` (137 scored
claims) — **254 scored claims in total** — against the Agda modules that landed
in this tree between 2026-08-15 00:00 and this pass.*

**All three ledgers predate the modules.** Each says so in its own closing
paragraph: seed157, seed179 and seed181 each record "no Agda or Lean authored,
none typechecked". Since they were written, forty-five `.agda` files were added
(list in §1, obtained by `git log --since=2026-08-15T00:00 --diff-filter=A`, not
from any message). **Nobody had reconciled them.** This note does that, by
addition only: **no row of any of the three ledgers is edited here**, and each
ledger receives a dated pointer block referring to this file.

**Method, and its limits, stated first.**

1. **Modules were read, not their announcements.** Every module cited below was
   opened and its headline identifiers located in the source. Where a header's
   claim and the module's terms diverge, §4 says so — and one such divergence
   was found tonight, inside the tree, between two modules committed hours
   apart (§4.1).
2. **The conservatism rule the mandate names is applied literally.** A term that
   proves a *model* of a claim, a *rank-one* case, a *finite* instance, or the
   *abstract shape* of an argument does **not** close the claim. Those are
   PARTIAL. Several of tonight's modules say so in their own headers, in their
   own words, and where they do, the header is quoted.
3. **Toolchain, named, because an exit code without a toolchain is a defect.**
   Every exit code below is my own run in this container:
   `cd formal/cubical && LC_ALL=C.UTF-8 agda -i . <M>.agda; echo EXIT=$?`, with
   `/usr/bin/agda` = **2.6.3** and cubical library **v0.5**. The repository's
   pin is **Agda 2.8.0 + cubical v0.9** and **is not present in this
   container**; `notes/AGDA_COVERAGE_LEDGER.md` §0 and
   `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.1 record the same. One module
   below (`Sl2TensorProduct.agda`) is **red here and green under the pin** — the
   exact inverse of the skew the standing checks warn about — and its row is
   flagged accordingly.
4. **Nothing was measured.** No Python, no `MATH_ALLOW_PYTHON`, no fitted
   constant, no floating point. The only computations are typechecker runs,
   which under `CLAUDE.md` are certification, not measurement.

---

## §1. The modules, verified by listing and by reading

`git log --since=2026-08-15T00:00 --diff-filter=A --name-only -- 'formal/**/*.agda'`
returns 45 files. Fourteen of them carry results that touch a ledger row; the
remaining thirty-one are controls (`NaturalMachine/Control/*`, seven files),
scratch (`WFIScratch1/2`), or corpus-internal machinery with no transmission
claim behind it (`KFlow`, `KFlowWF`, `Residual`, `ResidualPath`, `TransportDiv*`,
`WalkResidueBridge`, `WalkFastInstance`, `QuestionMachine`, `SelfImprovement`,
`ReachableFromStart`, `ComparisonNeedNotBeInjective`, `LineWorldTransport`,
`ChuAdvance`/`ChuDefect`/`AdvanceGate` — the last three do touch rows and are
counted among the fourteen).

| module | EXIT here (2.6.3 / v0.5) | note |
|---|---|---|
| `formal/cubical/GodelSeparation.agda` | **0** | |
| `formal/cubical/InvarianceConstant.agda` | **0** | |
| `formal/cubical/PolarityClosure.agda` | **0** | |
| `formal/cubical/SimplicialDefectFailure.agda` | **0** | |
| `formal/cubical/Sl2DivisorLattice.agda` | **0** | |
| `formal/cubical/Sl2TensorProduct.agda` | **42** | `Not in scope: ·IdR` — the module was repaired **for the pin** at `3f865d90`; pin-green is quoted from that commit and `collab/messages/0801`, **not re-verified by me**. Same flag as `AGDA_COVERAGE_LEDGER.md` B7 |
| `formal/cubical/StagewiseComposite.agda` | **0** | |
| `NaturalMachine/ArityOfRepair.agda` | **0** | |
| `NaturalMachine/ChuAdvance.agda`, `ChuDefect.agda`, `AdvanceGate.agda` | **0** | |
| `NaturalMachine/DecategorifiedDefect.agda` | **0** | |
| `NaturalMachine/FillabilityCertificate.agda` | **0** | |
| `NaturalMachine/InflationVersusSubgroup.agda` | **0** | |
| `NaturalMachine/PiPartialOnEveryPrime.agda` | **0** | |
| `NaturalMachine/RepairTorsor.agda` | **0** | |
| `NaturalMachine/SpernerFromSl2.agda` | **0** | |
| `NaturalMachine/TransmissionRefutations.agda` | **0** | |
| `NaturalMachine/ConstantBoundNotFunctionBound.agda` | **0** | touches no ledger row; reported at §4.4 |
| `NaturalMachine/Lawvere.agda` | **0** | typechecks; **its header is wrong** — §4.1 |

---

## §2. Rows whose status is changed by a checked term

Status column reads *old → new*. **TERM(full)** means the ledger's own statement
is the module's statement. **TERM(partial)** means the module proves a model, a
special case, a finite instance, or the abstract shape, and the ledger's claim is
strictly more general — the split is named in every such row.

### §2.1 `OWNER_TRANSMISSIONS_LEDGER.md` (D0016–D0018)

| row | old status | new status | module and theorem |
|---|---|---|---|
| **§1.1** D0016 §B, $\delta_\sigma=0\not\Leftarrow\delta^{\mathrm{base}}_\sigma=0$ | PROVED (prose) | **PROVED + TERM(full)** | `NaturalMachine/ChuAdvance.agda` — the third displayed slogan, with its witness. The non-implication is exhibited, not asserted |
| **§1.2** D0016 §G, $\operatorname{Shrink}(\mathcal T)\Rightarrow\delta\downarrow$ | PROVED weakly, CLASSICAL in substance | **PROVED + TERM(full)** | `ChuAdvance.agda` `agree-drop`; quantitatively `ChuDefect.agda` `defect-mono`: $\delta(e,\mathcal T,xs)\le\delta(e,\mathcal T{+}{+}\mathcal S,xs)$. The slogan is now an inequality between numbers. Scope: test families are finite lists; the ledger's statement quantifies over arbitrary $S'\subseteq S$, and for finite $S$ these agree |
| **§1.4** D0016 §G, $\delta^{\varnothing}_\sigma=\varnothing$ always | PROVED | **PROVED + TERM(full)** | `ChuDefect.agda` `defect-[]` — unconditional, for every space whatever. This is the ledger's "cleanest form of *zero curvature is not truth*", now a term |
| **§1.5** D0016 §G, $\delta=0$ **is** truth when $S$ separates | PROVED | **PROVED + TERM(partial)** | `ChuDefect.agda` `defect-separates`: saturation $\delta=\#\text{pairs}\Rightarrow\mathcal T$ separates. **Split:** the saturation direction is a term; the ledger's biconditional $\delta^S_\sigma=\varnothing\iff\mathfrak h_\sigma=\mathrm{id}$ for separating $S$ is not constructed |
| **§1.6** D0016 §G, $\delta=0\not\Rightarrow\operatorname{Advance}$ | PROVED (E1, minimal by enumeration) | **PROVED + TERM(partial)** | `ChuAdvance.agda` `zero-defect-is-not-truth`; `AdvanceGate.agda` states the five-conjunct gate as a record and exhibits the same non-theorem. **Split:** the non-implication is a term; A-1's finding that $\operatorname{UsefulEscape}$ *admits no definition in the language* is **not** — `AdvanceGate` carries provenance and declared-boundary as explicit propositions the caller supplies, which is the honest encoding of "not formalizable here", not a proof of undefinability |
| **§2.4** D0017 §F, $\Delta_e\leftrightarrow G_T$ is Lawvere | CLASSICAL, "Cantor, Russell, **Gödel I**, Turing and Tarski are instances" | **CLASSICAL (Lawvere) + TERM(partial), with its instance list REFUTED** | `GodelSeparation.agda`. `tarskiUndefinability = cantor` — Tarski is *the same term*, so two of the five are one. `goedelHalfOne` derives $T\nvdash G$ only with **two hypotheses Lawvere does not supply** (consistency, and HBL condition D1). `noHalfTwo` **refutes every derivation** of $T\nvdash\neg G$ from those hypotheses, by a four-sentence finite countermodel, $\omega$-inconsistent in the arithmetic sense. See §4.1 |
| **§3.4** D0018 §B, "$X$ known $+D$ known $\Rightarrow\widehat X$ reconstructible" | REFUTED (completions a $V^\Gamma$-torsor) | **REFUTED + TERM(partial)** | `NaturalMachine/RepairTorsor.agda` — `isTorsor` (the action of $\mathrm{Aut}_S(y)$ on repairs is free and transitive: the type of transporters is *contractible*), `actFree`, `trivializeAut`, `rigid→isoUnique`, `initial→AutTrivial`, and the computed instance `Z2Repair`/`twoRepairs-differ`. **Split:** proved for an abstract category $S$ with $\mathrm{Aut}_S(y)$ in place of $V^\Gamma$; the group-cohomology instance $H^1(\Gamma,V)$ with its $V^\Gamma$ is **not** constructed. The module says so: it "holds verbatim in any category, and the note states it that way" |
| **§3.8** D0018 §B, does the classification act on real defects | PARTIAL (structural / quantitative split, grounded on `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Thm A) | **PARTIAL + TERM(partial), and its cited ground is superseded** | `NaturalMachine/ArityOfRepair.agda` — `no-unary-bilateral`, `no-nary-bilateral`, `binary-heterogeneous-works`. **The dividing line is arity, not an attainable distinguished zero**: the refuted objects "mention no zero, no distinguished element, no FillSys and no tower. They mention an arity and an input type." See §4.3 |
| **§3.14** D0018 §F, $D_e(x):=\neg e(x)(x)$, Lawvere again | CLASSICAL, same provenance cap as §2.4 | **CLASSICAL + TERM(full) for the diagonal; the §2.4 instance-list correction is inherited** | `NaturalMachine/EndObstruction.agda` gives $\delta_{\mathrm{end}}\not\equiv0$ unconditionally for every quotation $\ulcorner-\urcorner:\mathcal Q\to(\mathcal Q\to\mathrm{Bool})$; `LawvereDiagonal.agda` `cantor` is the general theorem |

**Unchanged, and worth saying so:** §1.7, §1.13/A-5, §1.14/A-6, §2.2, §2.5–§2.7,
§2.8–§2.11, §3.1–§3.3, §3.5–§3.7, §3.9–§3.13, §3.15–§3.21 acquire **no** term
tonight. In particular the PROGRAMME block (§1.13, §1.14, §2.10, §2.11, §3.11,
§3.15, §3.19, §3.21) is untouched, and the two owner decisions of §5 are
untouched.

### §2.2 `D0019_LEDGER.md`

| row | old status | new status | module and theorem |
|---|---|---|---|
| **B9** $\mathsf{Phys}$'s "symmetry enlargement" is a repair | REFUTED (inflation injective) | **REFUTED + TERM(partial), and its supporting prose is WEAKENED** | `NaturalMachine/InflationVersusSubgroup.agda` — `infl-injective`, certified to be inflation by `infl-is-inflation` (precomposition with `proj`) and `res-is-restriction`. **Split:** a finite model, $G=\mathbb Z/4$, $N\cong\mathbb Z/2\trianglelefteq G$, $\Gamma=G/N$, $V=\mathbb Z/2$ trivial. The general $H^1$ statement is not formalised, and the module's own scope limit adds that `H4`/`H2` are **declared** to be the hom-sets, not proved exhaustive. See §4.2 for the weakening |
| **B17** the readmitted $\Gamma_\Uparrow$ has an exclusive witness; its success predicate is *fillability*, not vanishing | PROVED (modulo one stated scope limit) | **PROVED + TERM(partial)** | `NaturalMachine/FillabilityCertificate.agda` — `Cert`/`FillTerm` (finite inductive certificate), `Branch`/`FillInf` (coinductive total filling), `cert→branch`, and the strictness witness `A∞`/`noCert`/`branchA∞`: a system with $\mathrm{Fill}_\infty\wedge\neg\mathrm{Fill}_{\mathrm{term}}$. `decBCert` visibly consumes finite branching and fuel. **Split, in the module's own words:** "The arithmetical hierarchy itself is NOT formalised: there is no model of computation here, no oracle". So $\Pi^0_2$ vs $\Sigma^0_1$ remains prose; the **certificate structure those classifications are about** is a term |
| **D16** the successor rule "measure the kernel of $\mu$" is one of two dual halves; neither vanishing certifies agreement | REFUTED as sufficient; PROVED as one of two halves | **REFUTED + TERM(partial)** | `NaturalMachine/DecategorifiedDefect.agda` §1 — `vanishes→χ-vanishes` (trivial direction), `unsound→¬reflects`, `sound-contrapositive`, `unsound-certificate`. The one-directional-invariant shape D16 is about is now a term. **Split:** the module's §2 is explicitly "a FAITHFUL FINITE MODEL of the $K_0$ argument and is not the derived-category statement itself"; $\mathrm{cofib}$, $\ker$ and $D^b(\mathrm{Vect}_k)$ are not formalised |
| **F2** $\operatorname{Mystery}(X)$ is not a quantity | REFUTED, slack $\le 2c(U,V)$ | **REFUTED + TERM(full), and SHARPENED** | `formal/cubical/InvarianceConstant.agda` — `invariance` (mutual simulation ⇒ bounded difference, constant $\max c_1 c_2$ exhibited), `within-+` (k non-cancelling terms carry slack $k\cdot c$ — the note's Uniformity Lemma), `absolute-not-invariant` ("the description length of $x$ is $n$" is not a statement about $x$: for any $f$ and $c\ge1$ there is $g$ within $c$ with $g\,x\ne f\,x$ **everywhere**), `shorter-needs-margin` and `threshold-sharp`. Universality is the one unformalised hypothesis, named as `Simulates`, and the module says so; the ledger's claim is about the constant, and the constant is the theorem. See §4.5 |
| **F4** $\Delta\operatorname{Mystery}=-\Delta\operatorname{Compression}$ | PARTIAL (invariant; near-tautological under the reading that makes it true) | **PARTIAL + TERM(partial)** | `InvarianceConstant.agda` `ΔMystery-indep`: a difference at **fixed object** does not mention the unconditional term at all. **Split:** the cancellation half is a term; the identification of $L$ with a complexity function is not, and cannot be in `--safe` |
| **F6** $\operatorname{gain}(\sigma)>0\Rightarrow\sigma\in\mathfrak L_{\alpha+1}$ | REFUTED under (K); PARTIAL by reading | **PARTIAL + TERM(partial)** | `InvarianceConstant.agda` `within-+` gives the three-term slack $\le 3c$ the row computes by hand; `shorter-needs-margin` + `threshold-sharp` make "a sign test on a single $\sigma$" a checked failure mode with the **exact** threshold $2c$. **Split:** the general machinery is a term; the display itself is not typed in Agda |
| **F7** $\mathfrak L^\star=\arg\min[\cdots]$ | PARTIAL (existence proved; uniqueness and machine-invariance refuted) | **PARTIAL + TERM(partial)** | same three theorems; the $6c(U,V)$ window of the row is `within-+` at $k=6$. Same split as F6 |

**Unchanged:** every §A row, every §C, §D, §E and §G row, and B1–B8, B10–B16,
B18, F1, F3, F5, F8, F9. In particular D1–D18 (the translation gerbe) acquire no
term, and §G remains PROGRAMME–nobody-looked, six rows, exactly as compiled.

### §2.3 `D0020_LEDGER.md`

| row | old status | new status | module and theorem |
|---|---|---|---|
| **0.3** §0's tower collapses at stage one | REFUTED (by the ledger's own §5.1, hand argument, no second reader) | **REFUTED + TERM(partial), second reader supplied** | `NaturalMachine/TransmissionRefutations.agda` §C — the abstract theorem (any operator extensive, closed-valued, and least among closed supersets is idempotent, and its tower is constant from stage one) plus a witness that the hypotheses are satisfiable (inductively generated closure over an arbitrary sign type). **Split, in the module's own words:** "The intersection itself is NOT formalised, and cannot be: the archive supplies no ambient set". This is exactly the fragility §18.1 flags for 0.3, and it survives: the row is now REFUTED-given-an-ambient, with the ambient still the archive's to supply |
| **1.5** §1's Möbius display $\sum_{\delta\mid\nu}\mu(\delta)\lfloor\nu/\delta\rfloor=1$ | REFUTED (hand, $\nu=3$) | **REFUTED + TERM(full)** | `TransmissionRefutations.agda` §B — $\mu$ **defined in-module** (trial division with fuel), not tabulated; refuted at $\nu=3$ by computation; $\varphi$ defined independently (counting coprime residues) and agreeing at $\nu=1..12$; the classical identity $\sum_{\delta\le\nu}\mu(\delta)\lfloor\nu/\delta\rfloor=1$ verified at $\nu=1..12$. A counterexample is a full refutation; the *repair* identity is verified finitely, not proved in general, and the row does not need it |
| **5.16** apoha, $\alpha\mapsto\alpha^{\perp\perp}$ | UNDEFINED | **PARTIAL (split named) + TERM(full) on the Boolean half** | `formal/cubical/PolarityClosure.agda` §2 — `perp-is-complement`, `cl-is-¬¬`, `cl-identity-on-Dec`, `boolean-gloss-vacuous`. **Split:** read D0020 §5's Boolean gloss $\llbracket\text{गो}\rrbracket=\neg\llbracket\text{अगो}\rrbracket$ as the *definition* of $\perp$ (so $A=B=X$, $\varepsilon=$ inequality) and the boxed display is the **identity map**: every set closed, concept lattice = the whole powerset, zero content. Read $\perp$ as the archive's gloss ("that which discriminates non-$\alpha$"), UNDEFINED stands, because a gloss is not a relation. `cl-not-identity` shows the vacuity belongs to the gloss and not to the construction. Constructive refinement in §4.6 |
| **7.6** §7's two-sided evaluation is a Birkhoff polarity | CLASSICAL (Birkhoff 1940, Ore 1944 — **not read**) | **CLASSICAL + TERM(full)** | `PolarityClosure.agda` §1 — `perp⁺-anti`, `perp⁻-anti`, `galois-→`, `galois-←`, `cl-ext`, `cl-mono`, `cl-idem`, **unconditionally**: no hypothesis on $\varepsilon$, on $A$, on $B$, or on the subsets. The earliest-source defect of §16 is untouched — a term is not a citation |
| **7.2** $\curlywedge_{\Sigma_1}=0\Rightarrow\Sigma_1$ sufficient | PROGRAMME | **PROGRAMME as displayed; the certificate SHAPE is now REFUTED by a term** | `NaturalMachine/DecategorifiedDefect.agda` `unsound-certificate`: the rule "$\chi d\equiv0\Rightarrow d\equiv0$" is refuted by a witness, and `sound-contrapositive` keeps the other direction unconditionally. The display still fails to denote (no functor, no monoidal structure, undefined subtraction), so the **row's status does not move**; what moves is that its intended reading is now known to be unsound rather than merely unchecked |
| **8.5** §8's $\Pi_\partial$ identity | REFUTED (hand table over three shapes) | **REFUTED + TERM(full)** | Two complementary modules, and neither subsumes the other. `TransmissionRefutations.agda` §A computes on $\mathbb N$ itself: smallest witness $\nu=2$, found in the module and not taken from the ledger — model-free. `NaturalMachine/PiPartialOnEveryPrime.agda` closes the universal half: representing $\nu$ by its multiset of prime exponents, "$\nu$ is prime" becomes $\Omega(\nu)=1$ and the shape is **derived** (`Ω≡1→shape`), so the failure-by-exactly-1 quantifies over **all** primes. Scope: the universal half assumes unique factorisation, and the module says so at its foot. Between them the row is fully carried, and the nine-witness gap `TransmissionRefutations` A.4 declared is closed |
| **8.10** the $\mathfrak{sl}_2$ action, three brackets | PROVED (ledger §5.5, twelve lines by hand, no second reader) | **PROVED + TERM(full)** | `formal/cubical/Sl2DivisorLattice.agda` `bracket-ηε`, `bracket-ηφ`, `bracket-εφ`, with the basis displays `ε-δ`, `ε-δ-top`, `φ-δ`, `φ-δ-bot`, `η-δ` and the grading `ε-grade`/`φ-grade`/`η-grade` — **rank one**, boundary cases included, no truncated subtraction. The multi-index case $B_n=\bigotimes_i V_{\alpha_i}$, which that module's header explicitly excludes, is closed by `formal/cubical/Sl2TensorProduct.agda`: `tensorRep` (the load-bearing lemma — the tensor of two triples is a triple), `Bn : ℕ → Sl2Rep` by induction, `tensor-E/F/H`, `Rk2≡Bn2`, and a **non-vacuity control** showing $E_1F_2\ne0$ so that $[E_1,F_2]=0$ is a cancellation of equal nonzero terms and not of two zeros. **Toolchain caveat, and it is the one flagged case:** `Sl2TensorProduct` is EXIT=42 here under 2.6.3/v0.5 and green under the pin per `3f865d90`; I could not re-run the pin |
| **8.11** 8.10 is the Stanley–Proctor $\mathfrak{sl}_2$/Sperner method | CLASSICAL, earliest-source **UNDISCHARGED** (§19.3) | **CLASSICAL-SOURCED + TERM(partial) for the Sperner conclusion** | `NaturalMachine/SpernerFromSl2.agda` carries the full attribution audit *in the module*, including a source **earlier** than the one 8.11 names: the theorem is de Bruijn–van Ebbenhorst Tengbergen–Kruyswijk, Nieuw Arch. Wiskunde (2) **23** (1951) 191–193; Stanley 1980 and Proctor 1982 supply the *method*. §16.1's addendum already recorded this from `SL2_DIVISOR_LATTICE.md`; the module is the second carrier. **Split, and the module states it in its own header:** what is proved is the **rank-one case only** — `ε-implements-up`, `up-inj`, `mirror`/`mirror-rank`, `antichain-subsingleton`, `sperner-rank-one`, `W-middle`. The general case is written down as `GeneralSperner : Type₁` **with no term of it**, and the char-0 hypothesis is an explicit record `CharZero` in that type. The module also warns against reading rank one as evidence that char 0 is dispensable |
| **J1** §8's $\mathfrak{sl}_2$ action is the most checkable claim in the five transmissions, and prior art must be searched first | PROVED (in prospect and by hand) | **PROVED + TERM(full); the prior-art instruction DISCHARGED** | 8.10's modules; the search is in `SpernerFromSl2.agda`'s header and in `SL2_DIVISOR_LATTICE.md`. J1 named in advance the one claim that would turn out provable, and it is now a term |
| **J3** apoha and the two-sided evaluation are the same polarity closure | PARTIAL (right about §7, contradicted about §5) | **PARTIAL, unchanged — now with a term on each half** | `PolarityClosure.agda` §1 gives the §7 half (a real convergence); §2 gives the §5 half, and gives it as *vacuity*, which is a sharper negative than "not established". The verdict word does not move |

**Unchanged and worth naming, because they are the rows a reader will ask
about:** 8.3, 8.4, 8.8 (Goldbach, twin primes, RH) remain **OPEN** — no module
in this tree touches them, and `SpernerFromSl2.agda` says so in its own scope
note ("no prime enters anywhere in this file … it is NOT a bridge to the
Goldbach / critical-line material"). 8.9's mutual-determination display remains
PROVED-by-hand with no term. The 40 CLASSICAL rows are untouched by any module;
a checked term is not a citation and does not discharge §16. 9.2 remains
UNDEFINED — §4.5's sharpening strengthens the *ground* for declining to refute
it, not the case for refuting it, exactly as §18.1 anticipated.

---

## §4. Rows a checked term **refutes or weakens** — the reverse direction

*(There is no §3: the reverse-direction findings are numbered 4.1–4.7 so that
§2's rows and §5's counts can cite them by a stable number.)*

Nothing in §2 is as informative as this section. Seven findings: three correct
prior agents' notes, one corrects a sibling module's header committed the same
night, one corrects a claim in no ledger at all, and two sharpen a ground the
ledgers rest on.

### 4.1 Gödel I is not a Lawvere instance — and a module in this tree still says it is

`notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Cor 2.1, quoted by
`OWNER_TRANSMISSIONS_LEDGER.md` §2.4 and inherited by §3.14, says that "Cantor's
diagonal, Russell, Gödel's first incompleteness theorem, Turing's halting
argument and Tarski's undefinability are all instances of" Lawvere's theorem.
`formal/cubical/GodelSeparation.agda` splits that list with terms:

* **Tarski *is* Cantor.** `tarskiUndefinability = cantor` — the same term, read
  under a different gloss of the enumeration. That identity is the content.
* **Gödel I is not an instance.** Its two conjuncts behave differently.
  `goedelHalfOne` gets $T\nvdash G$ from the Lawvere fixed point **plus**
  consistency **plus** HBL D1 — two hypotheses Lawvere does not supply.
  `noHalfTwo` refutes every would-be derivation of $T\nvdash\neg G$ from those
  hypotheses, by a four-sentence structure satisfying consistency, D1 and the
  Gödel fixed point in which $\neg G$ **is** provable. The countermodel is
  $\omega$-inconsistent in the arithmetic sense — which is the failure mode
  Gödel 1931 excluded by assuming $\omega$-consistency and Rosser 1936 removed
  by changing the fixed point. Changing the fixed point is a choice of $\nu$,
  not a consequence of the theorem about $\nu$.

**What the instance is**, and it is worth stating positively: the *diagonal
lemma* is the Lawvere instance. Incompleteness is the diagonal lemma plus
arithmetized provability conditions, and the second half is not Lawvere's at
all.

**The internal contradiction.** `NaturalMachine/Lawvere.agda`, added the same
night, lists in its own header:

> `* Gödel : B = provability, f = ¬ (incompleteness)`

as one of five instances. That header is **wrong**, by a term in a sibling
module. The module typechecks (EXIT=0 here) — nothing in its *terms* asserts
the false thing — but its comment repeats the claim `GodelSeparation` refutes.
This is precisely the failure mode the mandate warns of: a module named for a
result whose header outruns its content. **Recommended action, not taken here
because it is another agent's live artifact:** amend that header by addition,
citing `GodelSeparation.noHalfTwo`.

### 4.2 "Symmetry enlargement is not a repair at all" — the dropped qualifier

`D0019_LEDGER.md` B9 states the theorem correctly, *with* its qualifier
(inflation $H^1(\Gamma,V)\to H^1(G,V)$ along a **quotient** $\Gamma=G/N$ is
injective). `NaturalMachine/InflationVersusSubgroup.agda` records, from
`notes/FULL_READ_DRAW_5.md` §D7, that four places in
`EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` drop it — "symmetry enlargement: Thm
3.5 proves this is **not a repair at all**", "*refuted, not a repair*" — and the
module makes the qualifier part of a type. Its finding, which is a strengthening
in one direction and a weakening in the other:

* For $\Gamma\le G$ there is **no canonical $H^1(\Gamma,V)\to H^1(G,V)$ at
  all**; the canonical map runs the other way (`res-is-restriction`). So the
  subgroup reading is not "also proved", and is not even "unproved by the same
  argument" — there is nothing for the argument to be applied to.
* On the smallest model realising both readings on one inclusion/projection pair
  ($G=\mathbb Z/4$, $N\cong\mathbb Z/2$), the transport a repair-claim would
  need is **impossible**, not merely unproved.

**Consequence for the record:** B9's row is right; the four flattened sentences
downstream of it are not, and "the dropped qualifier has no lexical signature:
the flattened sentences contain no wrong word, only a missing one."

### 4.3 The dividing line for quantitative defects is arity, not an attainable zero

`OWNER_TRANSMISSIONS_LEDGER.md` §3.8 rests on
`QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Thm A: all four repair modes
presuppose an attainable distinguished zero, hence none acts on a quantitative
defect. `NaturalMachine/ArityOfRepair.agda` formalises
`FILLABILITY_AS_SUCCESS.md` Theorem 5.3 and **supersedes that ground**:

* $\Gamma_\Uparrow$ **escapes Thm A** — its success predicate $\mathrm{Fill}_\infty$
  presupposes no zero — and is still caught by Thm B, whose proof uses only
  unarity.
* `unary-lower-always`: one side is free, every slot admits a unary *lower*
  bound. This is what stops the negative from being a triviality about
  functions.
* `no-unary-bilateral`: if the structural presentation is **ambiguous** (two
  data, one presentation, different magnitudes) then no operation whose only
  input is that presentation is sound and tight.
* `no-nary-bilateral`: arity within the same input type never helps, for every
  $n$, by diagonal application.
* `binary-heterogeneous-works`: …and the dividing line really is arity, not
  impossibility.

So §3.8's *verdict* (PARTIAL; the modes are silent on quantitative defects)
stands; its *reason* does not, and the corrected reason is visible in a
signature rather than in a proof.

### 4.4 A quantifier promoted outside its evidence

`NaturalMachine/ConstantBoundNotFunctionBound.agda` refutes a corpus claim that
appears in no ledger row and so is reported here rather than filed: a worker
message's "$\Phi_7(2)=127$ prime … $\Phi_{17}(2)=131071$ prime … So $Y\ge1$ is
sharp, **no function of $(b,n)$ improves it**." The two witnesses establish that
the **constant** 1 cannot be raised to a constant $>1$ (`constant-sharp`). They
do not establish the quantified claim about **functions**: $\Phi_{11}(2)=2047=
23\cdot89$ gives yield 2, so the function equal to 2 at $(2,11)$ and 1 elsewhere
is a valid strictly better bound (`Y-is-a-bound`, `Y-improves`,
`dropped-scope-false`). No lexical signature: every word in the source sentence
is correct; the defect is a quantifier promotion.

### 4.5 The MDL constant was "$\gg c$"; it is exactly $2c$, and the threshold is sharp both ways

`notes/MYSTERY_AND_DESCRIPTION_LENGTH.md` §1 (the ground of D0019 F2, F4, F6,
F7) says a sign survives "when the gap $\gg c$".
`formal/cubical/InvarianceConstant.agda` §5 replaces $\gg$ by the constant that
actually works and proves it cannot be lowered: `shorter-needs-margin` transfers
a strict comparison across machines whenever the gap **exceeds $2c$**, and
`threshold-sharp` bundles `Sharp2c` (at gap exactly $2c$ the strict conclusion
already fails — the costs tie) with `SharpBelow2c` (at gap $2c-1$ the order
**reverses**). Both witnesses are finite exhaustive verifications over `Bool`,
which `CLAUDE.md` admits as proof. The threshold is $2c$ and not $c$ because the
slack is spent twice, once raising $f\,x$ and once lowering $f\,y$.

This is the corpus's own rule applied to itself: a constant quoted without its
dependence is worse than no constant, and "$\gg c$" is a constant without its
dependence.

### 4.6 The apoha vacuity argument used excluded middle

`notes/APOHA_AND_POLARITY.md` argues $\alpha^{\perp\perp}=X\setminus(X\setminus
\alpha)=\alpha$. `PolarityClosure.agda` §2 shows what is actually true
constructively: for **every** $\alpha$, $\mathrm{cl}\,\alpha=\neg\neg\alpha$
(`cl-is-¬¬`), and that is the identity **exactly when $\alpha$ is pointwise
decidable** (`cl-identity-on-Dec`), in particular for $\alpha$ given by a
characteristic function $X\to\mathrm{Bool}$ (`boolean-gloss-vacuous`). The
vacuity claim survives — a subset of a "pre-given universe" in the classical
reading is a decidable one — but the unrestricted identity is **not**
constructively provable, and the module states which of the two it proves.

### 4.7 The sharp form of the defect's face-failure is variance-dependent

`formal/cubical/SimplicialDefectFailure.agda` (grown tonight, §§4–7) settles
`notes/OBSTRUCTION_COEND_REPAIR.md` §9's slogan — "$\delta$ is functorial along
faces exactly when $\rho$ is a cocycle, i.e. exactly when $\delta$ is zero" — in
**one variance and refutes it in the other**:

* **Simplicial / covariant: a theorem.** `covariant⇒trivial`,
  `covariant⇒holonomy-trivial`, with
  `CocycleExtraction.Corpus.trivial⇒cocycle`. Only $d_0$ is assumed.
* **Cosimplicial / contravariant: FALSE.** `Cosimplicial-sharp-fails-corpus`
  and `…-archive`: on the chart $X=\mathbb Z$ with $\rho_{ij}$ translation by 1
  for $i\ne j$, $\rho$ is **not** a cocycle and $\delta_{(0,1,0)}\ne\varnothing$,
  yet $\delta_{d_j\sigma}\subseteq\delta_\sigma$ for every $\sigma$ and every
  $j$. Since $Q_\alpha=(\mathcal P(X),\subseteq)$ is thin, satisfying the
  inequalities **is** being a functor. Proved for both readings of the archive
  discrepancy, on the same chart, without choosing between them.

And a two-valued shadow: `shadow-support-infinite` shows one simplex with
nonempty defect forces an $\mathbb N$-indexed family of pairwise distinct
simplices (its iterated degeneracies) all carrying the same defect, so
$\lVert\mathcal O(S)\rVert\in\{0,\infty\}$. That is a different route to the
same moral as `OWNER_TRANSMISSIONS_LEDGER.md` §1.7's Thm F — the scalar shadow
carries nothing — and it does not rescue the realization repair.

---

## §5. The count that matters

**254 scored claims** across the three ledgers: 46 (D0016–D0018) + 71 (D0019) +
137 (D0020). Of these, **26 now have a checked term behind them** — **9 full,
17 partial** — as of this pass, under the toolchain named in the preamble.

| ledger | scored | with a term | full | partial |
|---|---|---|---|---|
| `OWNER_TRANSMISSIONS_LEDGER.md` | 46 | 9 | 3 (§1.1, §1.2, §1.4) | 6 (§1.5, §1.6, §2.4, §3.4, §3.8, §3.14) |
| `D0019_LEDGER.md` | 71 | 7 | 1 (F2) | 6 (B9, B17, D16, F4, F6, F7) |
| `D0020_LEDGER.md` | 137 | 10 | 5 (1.5, 7.6, 8.5, 8.10, J1) | 5 (0.3, 5.16, 7.2, 8.11, J3) |
| **total** | **254** | **26** | **9** | **17** |

**10.2% of the scored corpus has a term; 3.5% has a full one.** Read that
against the shape of the ledgers rather than as a grade. The 137-row D0020
ledger is 40 CLASSICAL rows (textbook exposition, which a term does not
discharge — a term is not a citation) and 52 PROGRAMME rows (notation awaiting
content, which cannot have a term until the notation denotes). Of the rows that
are *eligible* — truth-apt, denoting, and not classical — the coverage is much
higher: of D0020's 7 PROVED and 7 REFUTED rows, **9 now have terms**.

**Two asymmetries worth naming.**

1. **The terms cluster where the mathematics was already finite and exact.**
   Every FULL row is a bracket identity, a counterexample, a monotonicity, a
   Galois connection or an invariance constant. Nothing analytic acquired a
   term; nothing in the ordinal-ladder, gerbe or coend regions acquired one.
   This is the same distribution `AGDA_COVERAGE_LEDGER.md` §5 measures for the
   corpus at large, and it is not an accident.
2. **The reverse direction is denser than the forward one.** Seven rows moved
   from prose to term; **seven separate findings in §4 correct or weaken
   something already on the record**, three of them prior agents' notes, one of
   them a sibling module's header committed the same night. Tonight's terms were
   worth more as referees than as certifiers.

---

## §6. Scope limits of this reconciliation

1. **The pin was not run.** Every EXIT above is Agda 2.6.3 + cubical v0.5.
   `Sl2TensorProduct.agda` is red here and quoted green under the pin from
   commit `3f865d90`; I could not re-verify it, and I say so in its row rather
   than inheriting the claim silently. `AGDA_COVERAGE_LEDGER.md` §0's finding
   stands and is not repaired here: **no green run of the root
   `NaturalMachine.agda` exists for the tree as it stands**, under either
   toolchain, so no module below inherits greenness from a root aggregate.
2. **I read statements, not proof terms.** Each cited identifier was located in
   its module and its type read; I did not audit the proofs. The typechecker
   did, which is the point — but under a toolchain the sources no longer track.
3. **The 45 added modules were not all read in full.** The fourteen carrying
   ledger-relevant results were read at their headers and at the statements of
   the identifiers cited; the thirty-one others were classified by reading their
   headers only, and are listed rather than judged.
4. **No ledger row was edited.** Three pointer blocks were added, one per
   ledger, by addition, each dated and each pointing here. Their rows are dated
   records of what was known when.
5. **The 26/254 count is a partition I chose.** A reader who counted "has a
   term" more generously — e.g. counting D0019 D12 alongside D16, or counting
   every row that `InvarianceConstant` bears on — would get a larger number. The
   partition is displayed above precisely so it can be recounted; the totals are
   not a measurement and have no error bars, because they are a count of a
   closed set.
6. **No Python. No `MATH_ALLOW_PYTHON`. No web fetch, no PDF decoded, nothing
   measured, no constant fitted.** No Agda was authored by this pass; the
   modules are other agents' and are cited, not extended.

---

*Compiled 2026-08-15. Three ledgers read in full and **not edited**; pointer
blocks added by addition. Eighteen modules opened and read; every exit code is
my own run in this container under Agda 2.6.3 + cubical v0.5, with the pinned
2.8.0/v0.9 absent and said to be absent.*
