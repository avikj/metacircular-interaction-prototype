# Which theorem is the logical half, and what the bridge would have to be

*Seed, 2026-08-15. Subject: `collab/upstream/raw/D0017-owner-hieroglyphics-2026-08-14.md`
§F and §J2. Sources read in full on disk: `formal/cubical/LawvereDiagonal.agda`,
`notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md`, `notes/ORDINAL_LADDER_SMALLNESS.md`,
`notes/SURVIVING_LADDER_FRAGMENT.md`, `notes/REFLECTION_FACTOR_ADJUDICATED.md`,
D0017 §§F–J.*

**Credit and provenance.** The correspondence display, the seven-fold $\mathfrak O$, and
the §J2 question in its sharp form (*theorem or pun?*) are the **repository owner's**.
Theorem 4 of `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` (seed148) — the
locality obstruction — is that note's, and is **not** re-derived here; this note adds a
second, independent obstruction and corrects one corollary of that note. The Lawvere
engine in `formal/cubical/LawvereDiagonal.agda` is a prior agent's and is confirmed, not
replaced.

**Substrate.** Agda only. `formal/cubical/GodelSeparation.agda` is new and is the
mathematical content of §2 and §3.2. No Python. No fitted constant, no measurement.

---

## 0. Verdict table

| # | question | verdict |
|---|---|---|
| 1.1 | `LawvereDiagonal.agda` proves Lawvere's fixed-point theorem, constructively, no postulates | **CONFIRMED by reading and by typechecking green under the pin** (§1) |
| 1.2 | it covers Cantor | **YES** — `cantor`, `cantorDefect` (§1.2) |
| 1.3 | it covers Tarski | **YES, and by the identical term** — `tarskiUndefinability = cantor` (§2.1). The corpus did not know this; nothing had to be proved |
| 1.4 | it covers Gödel's first incompleteness theorem | **NO, and not by omission — it cannot** (§2.2–2.3) |
| 2.1 | Gödel I conjunct 1 ($T\nvdash G$) follows from the Lawvere fixed point | **PARTIAL — follows from the fixed point *plus two hypotheses Lawvere does not supply***: consistency and HBL1. Term: `goedelHalfOne` |
| 2.2 | Gödel I conjunct 2 ($T\nvdash\neg G$) follows from those data | **REFUTED, with a finite countermodel checked by the typechecker.** Term: `noHalfTwo` (§2.3) |
| 2.3 | `OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Cor 2.1, "Gödel's first incompleteness theorem … [is an instance] of Theorem 2" | **FALSE GROUNDS — corrected here.** What is an instance is the *diagonal lemma* (§2.4). Prior-agent correction |
| 3.1 | is the bridge a theorem or a pun | **PUN, confirmed on second, independent grounds** (§3.2). Seed148 refuted it by *locality*; this note refutes it by *grading and termination*, which needs no site and no restriction maps |
| 3.2 | a bridge natural in the stage grading | **REFUTED** — Theorem 3, with the same minimal hypothesis $B(0)=0$ seed148 used |
| 3.3 | what would have to be supplied for a bridge to exist | **STATED EXACTLY** — four items (D1)–(D4), §4; none is in any transmission or note |
| 3.4 | seed148 Theorem 4 (locality obstruction) | **CONFIRMED, not re-derived.** Its scope limit (restriction-natural maps only) is the gap Theorem 3 closes for the ungraded case |

Twelve entries. Two are corrections of prior *agent* notes (1.3 is an omission, 2.3 a
false-grounds finding).

---

## 1. What `LawvereDiagonal.agda` actually proves

Read in full, not summarised from its header. Its content, verbatim in substance:

- `WkPtSurj e = (f : A → Y) → Σ[ a ∈ A ] ((x : A) → e a x ≡ f x)` — weak point-surjectivity,
  **untruncated** (a $\Sigma$, not a $\lVert\Sigma\rVert$).
- `lawvere : (e : A → A → Y) → WkPtSurj e → (ν : Y → Y) → FixedPoint ν`.
- `noFix→noEnum`, the contrapositive.
- `diagEscapes`, the productive form: for any claimed index $a$, the disagreement point
  is $a$ itself.
- `notNoFix`, `cantor`, `cantorDefect`.

**Toolchain, measured in this container, not quoted.** Agda 2.8.0 built from Hackage at
`…/scratchpad/Agda-2.8.0/…/agda`, cubical v0.9 at `/root/agda-libs/cubical-v0.9`,
`LC_ALL=C.UTF-8`:

```
$ agda --library-file=<v0.9> LawvereDiagonal.agda
Checking LawvereDiagonal (…/LawvereDiagonal.agda).
EXIT=0
```

This is **the pin** (`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.1), not the container's
default Agda 2.6.3 / cubical v0.5.

### 1.1 What the flags buy, stated because it is load-bearing in §3.3

`--cubical --safe --no-import-sorts`, no postulates, no holes, no truncation, no
classical axiom, no natural-numbers object. Lawvere's theorem is a **two-line
$\lambda$-term of bare Martin-Löf type theory**. Whatever else the logical half is, it is
not deep, and it is not analytic.

### 1.2 Coverage: Cantor, yes

`cantor : (e : A → A → Bool) → ¬ WkPtSurj e`. That is Cantor's theorem in the form
D0017 §F writes it ($\Delta_e(n)=1-e(n)(n)$, $\Delta_e\notin\operatorname{im}e$), and
`cantorDefect` supplies $\Delta_e$ together with its escape witness. **The
$\Delta_e$ end of §F's logical column is fully discharged by a checked term already in
this repository.** The corpus records this (seed148 §3) at the level of the classical
theorem; it did not record that the term exists and is green.

---

## 2. Where the logical half stops

### 2.1 Tarski is Cantor's term

Read $A$ as codes of formulas in one free variable and `sat a x` as "the formula coded by
$a$ is satisfied by $x$". A truth definition *inside the language* is precisely a weak
point-surjection: it would realise every $A$-indexed $\mathbf{2}$-valued behaviour as some
row. Negation on truth values is fixed-point-free. So

```agda
tarskiUndefinability : {A : Type ℓ} (sat : A → A → Bool) → ¬ WkPtSurj sat
tarskiUndefinability = cantor
```

`GodelSeparation.agda` §1. The definiens is not a new proof; **the identity of the two
terms is the content.** Tarski's undefinability theorem (Tarski 1933/1936) and Cantor's
theorem are, at this level of abstraction, one term under two glosses. This is the
half of §F's logical column the corpus had not noticed was already finished.

### 2.2 Gödel I, conjunct 1: the fixed point plus two hypotheses

Abstract a theory as $(\mathrm{Sent},\ \mathrm{Pf},\ \neg,\ \mathrm{prov})$ with
$\mathrm{Pf}(s)$ inhabited iff $T\vdash s$ and $\mathrm{prov}$ the internal provability
predicate at a code. Write

- $\mathrm{Con}$: $\forall s.\ \mathrm{Pf}(s)\to\mathrm{Pf}(\neg s)\to\bot$;
- $\mathrm{HBL1}$: $\forall s.\ \mathrm{Pf}(s)\to\mathrm{Pf}(\mathrm{prov}\,s)$;
- $\mathrm{GoedelFix}(G)$: $\mathrm{Pf}(G)\leftrightarrow\mathrm{Pf}(\neg\,\mathrm{prov}\,G)$.

**Theorem 1.** $\mathrm{Con}\wedge\mathrm{HBL1}\wedge\mathrm{GoedelFix}(G)\Rightarrow
\neg\,\mathrm{Pf}(G)$.

*Proof (the term `goedelHalfOne`, three symbols long).* Assume $\mathrm{Pf}(G)$. HBL1 gives
$\mathrm{Pf}(\mathrm{prov}\,G)$; the forward half of the fixed point gives
$\mathrm{Pf}(\neg\,\mathrm{prov}\,G)$; $\mathrm{Con}$ at $\mathrm{prov}\,G$ closes. $\square$

**What Lawvere contributed to this, exactly: $\mathrm{GoedelFix}$ and nothing else.**
And even that needs the enumeration $e$ to be the theory's *own* representation of its
definable predicates — a hypothesis about $T$, not about the ambient cartesian closed
structure. Presburger arithmetic (Presburger 1929) is consistent, recursively
axiomatised and **complete**; Lawvere's theorem holds in the ambient regardless; so
Lawvere's hypotheses together with "$T$ is a consistent r.e. theory" **do not entail
incompleteness of $T$.** The missing datum is representability, i.e. that $T$ interprets
Robinson's $Q$.

### 2.3 Gödel I, conjunct 2: refuted as a consequence, with a witness

**Theorem 2.** There is no function
$$
\mathrm{Con}\wedge\mathrm{HBL1}\wedge\mathrm{GoedelFix}(G)\ \longrightarrow\ \neg\,\mathrm{Pf}(\neg G).
$$

*Proof — a finite exhaustive verification, discharged by the typechecker.* Exhibit
$\mathrm{Sent}=\{\top,\bot,g,\neg g\}$, negation swapping the two pairs,
$\mathrm{prov}\equiv\top$, and $\mathrm{Pf}$ inhabited exactly at $\top$ and $\neg g$.
Consistency holds by exhaustion over four sentences (`witCon`); HBL1 holds because its
consequent is $\mathrm{Pf}(\top)=\mathbf 1$ (`witHBL1`); $\mathrm{GoedelFix}(g)$ holds
because both of its sides are $\bot$ (`witFix`). And $\mathrm{Pf}(\neg g)$ is inhabited
(`witProvesNegG`). Any such function, applied to this structure, yields $\bot$
(`noHalfTwo`). $\square$

This is a **negative with a witness**, in the sense CLAUDE.md licenses without
qualification: a finite exhaustive verification, and a *term*, not a measurement.

**The witness is not pathological — it is the classical failure mode.** It satisfies
`witOmegaBad : Pf (prov g) × ¬ Pf g`: it proves that $g$ is provable and does not prove
$g$. That is $\omega$-inconsistency, in the one instance that matters. Gödel 1931 excluded
it by *assuming* $\omega$-consistency; Rosser 1936 removed the assumption by **changing the
fixed point** — replacing $\neg\mathrm{Prov}$ by the Rosser predicate. Changing $\nu$ is a
*choice of input to* Lawvere's theorem, not a consequence of it. The theorem is silent on
which $\nu$ to feed it, and that choice is the whole of Rosser's contribution.

**The arithmetic witness, for the reader who distrusts a four-element toy.** Let
$T=\mathsf{PA}+\neg\mathrm{Con}(\mathsf{PA})$. $T$ is consistent (Gödel II: $\mathsf{PA}
\nvdash\mathrm{Con}(\mathsf{PA})$), recursively axiomatised, and satisfies HBL1. Over $T$,
$G_T\leftrightarrow\mathrm{Con}(T)$, and $T\vdash\neg\mathrm{Con}(\mathsf{PA})$ with
$\mathrm{Con}(T)\to\mathrm{Con}(\mathsf{PA})$ provable, so $T\vdash\neg G_T$. Every
hypothesis of Theorem 2's antecedent holds; its putative conclusion is false. The same
theory is already the witness used at `notes/REFLECTION_FACTOR_ADJUDICATED.md` Prop 1.3,
for a different purpose.

### 2.4 Correction to a prior agent note

`notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Cor 2.1 states: "Cantor's diagonal,
Russell, Tarski's non-definability of truth, and Gödel's first incompleteness theorem are
all instances of Theorem 2, applied in a suitable cartesian closed category with a suitable
fixed-point-free endomorphism of $B$ (negation, for Gödel and Cantor)."

**Cantor: correct. Tarski: correct, and stronger than stated (§2.1). Russell: correct.
Gödel: false grounds.** What is an instance is the *diagonal lemma*. Incompleteness is the
diagonal lemma **plus** representability (to get the fixed point at all), **plus**
consistency and HBL1 (conjunct 1, Theorem 1), **plus** $\omega$-consistency or a different
$\nu$ (conjunct 2, Theorem 2). Four hypotheses, none categorical.

The verdict of that note is **not** disturbed: its headline — the logical half is a 1969
theorem, D0017's logical column contains no new mathematics — stands, and is if anything
strengthened, since the theorem covers *less* than claimed and what it does cover was
already 1969. What changes is the inventory: the corpus must not write "Gödel is an
instance of Lawvere" in a paper section.

---

## 3. The bridge

### 3.1 What is already settled, and is not repeated

Seed148 Theorem 4: cohomological obstructions are **locally trivial by construction**;
the diagonal obstruction is **locally stable** (it survives to every nondegenerate slice);
hence any natural-in-restriction $B$ with $B(0)=0$ is the zero map. That is a correct
theorem and I neither re-derive nor amend it. Its stated scope limit is that it rules out
bridges *natural in restriction* — it needs a site, restriction maps, and a cover.

### 3.2 A second obstruction: grading and termination

D0017 §F's geometric column and §G's ladder are both **staged**. That is the structure
Theorem 4 does not use, and it obstructs the bridge on its own.

**Geometric side (classical; Steenrod, *Topology of Fibre Bundles*, Part III; Hatcher §4.3
— named, numbering not verified in this container).** For a fibration with fibre $F$ over a
CW complex $X$, the obstruction to extending a section from the $n$-skeleton to the
$(n+1)$-skeleton lies in $H^{n+1}(X;\pi_n F)$ with local coefficients. The tower is
**graded by $n$**, and if $\dim X=d$ then $H^{n+1}(X;-)=0$ for $n+1>d$: **the tower
terminates**, after at most $d$ stages.

**Diagonal side.** `GodelSeparation.noTerminalStage`:
```agda
noTerminalStage : {A D : Type ℓ} (e : (A ⊎ D) → (A ⊎ D) → Bool) → ¬ WkPtSurj e
noTerminalStage = cantor
```
Adjoin the escaping observation $D$ produced by `cantorDefect` to the stage $A$; the very
same theorem applies to $A\sqcup D$, at the **same type level**. The diagonal tower is
**ungraded and never terminates.**

**Theorem 3 (no bridge natural in the stage index).** Let $\mathfrak B$ be any assignment
from stagewise geometric obstruction data to stagewise diagonal data which (a) is defined
stagewise, (b) preserves the stage index, and (c) carries "no obstruction at stage $n$" to
"no defect at stage $n$" (the same minimal $\mathfrak B(0)=0$ seed148 assumed). Then
$\mathfrak B$ does not exist over any finite-dimensional $X$.

*Proof.* Let $d=\dim X$ and take $n=d$. On the geometric side the stage-$d$ obstruction is
$0$, since it lives in $H^{d+1}(X;\pi_d F)=0$. By (b) and (c), $\mathfrak B$ then reports
no defect at stage $d$ on the diagonal side. But `noTerminalStage` exhibits a defect at
every stage, unconditionally and for every type. Contradiction. $\square$

**Why this is not seed148's theorem again.** Theorem 4 needs a site, a cover, restriction
maps and local triviality. Theorem 3 needs a grading and a dimension, and applies verbatim
to the ladder of D0017 §G, where no site is specified and Theorem 4 therefore has no
hypotheses to stand on. The two are independent: either alone suffices, and the second is
available exactly where the first is not.

**A third discriminator, recorded as a diagnostic and explicitly not as a proof.**
Lawvere's half is a $\lambda$-term of bare MLTT (§1.1); the geometric half's arrows are
Čech–de Rham (good covers, real coefficients), Ambrose–Singer and Chern–Weil (real
analysis), and obstruction theory with local coefficients (classical logic). An
*invertible* bridge would reduce those to a $\lambda$-term. I do not turn this into a
theorem — "invertible bridge" is not defined precisely enough to carry a
reverse-mathematical argument, and the corpus rule forbids me from labelling a suggestive
asymmetry as a result. It is a reason to expect Theorems 3 and 4, not a substitute for
them.

---

## 4. What would have to be supplied — the exact list

§J2 asks for the functor. These are its missing arguments, and none of them is in any
transmission or note:

- **(D1) An ambient category containing both structures.** D0017 fixes none; seed148 §1
  had to supply readings for every symbol, and seed165 Theorem 4 shows the §G stages do not
  even share a domain. Without (D1) "functor" has no source and no target.
- **(D2) A grading on the logical side, with a dimension.** Theorem 3 says a bridge must
  match a terminating tower to a non-terminating one. Repairing this requires a notion of
  *logical dimension* under which the diagonal tower dies. The nearest candidate the corpus
  has is the reflection tower $T_\alpha$ — and `notes/REFLECTION_FACTOR_ADJUDICATED.md` §3
  reports the classical answer (Turing 1939, Feferman 1962): the tower's content depends on
  the *computable presentation* of $\alpha$, not on its order type, so there is no canonical
  ordinal length to serve as a dimension. **(D2) is not merely missing; the one available
  construction is known not to supply it.**
- **(D3) Failure of naturality in restriction, deliberately.** By Theorem 4 the bridge must
  *not* commute with restriction along covers. A map that fails the one naturality condition
  a correspondence would satisfy needs an account of what it does respect instead. None is
  offered.
- **(D4) Invertibility, for §F's $\leftrightarrow$.** Refuted at four places on the
  geometric side alone before the bridge is reached (seed148 Theorem 1(a),(b),(c) and
  Cor 1.1: kernels are 2-cell homotopy, the $\pi_1$-action, torsion, $\pi_1(X)$).

**Verdict on §J2, stated in the form the question demands.** The bridge is a **pun**, and
the negative now has two independent witnesses of different type — a locality obstruction
(seed148, needs a site) and a grading obstruction (Theorem 3 here, needs only a dimension,
and one of its two halves is a checked term). "Both are obstructions to a section" is
refuted twice over: the two obstruction towers have opposite locality type *and* opposite
termination behaviour. What survives of §F is one 1969 theorem at one end, covering less
than the corpus thought (§2.4) and more than it knew (§2.1).

---

## 5. Prior art, searched before the write-up

Read as HTML this session unless flagged:

- **F. W. Lawvere**, *Diagonal arguments and cartesian closed categories*, LNM **92**,
  Springer 1969; reprinted *Repr. Theory Appl. Categ.* **15** (2006) 1–13. **NOT READ**
  (PDF, does not decode in this container). Lawvere's own claim, quoted from the nLab
  entry *Lawvere's fixed point theorem* (fetched 2026-08-15): "we demystified the
  incompleteness theorem of Gödel and the truth-definition theory of Tarski by showing that
  both are consequences of some very simple algebra in the Cartesian-closed setting."
  **§2 does not contradict this.** Lawvere says "consequences of some very simple algebra";
  the algebra is the diagonal lemma, and §2.3 identifies precisely the non-algebraic
  residue. The nLab page **gives no additional hypotheses** for the incompleteness
  application, which is the gap this note fills; its only worked application is Cantor.
- **D. Pavlović**, *On the structure of paradoxes*, Arch. Math. Logic **31** (1992)
  397–406. Abstract read via search result only; the Springer page is paywalled. Earlier
  than Yanofsky and covering the same ground (Cantor, Russell, Gödel in a cartesian closed
  setting). **Recorded as the earliest post-Lawvere systematic treatment I could find**; I
  do not attribute to it any statement about the residue in §2.3.
- **N. S. Yanofsky**, *A universal approach to self-referential paradoxes, incompleteness
  and fixed points*, Bull. Symbolic Logic **9** (2003) 362–386; arXiv:math/0305282.
  Abstract read verbatim: "many self-referential paradoxes, incompleteness theorems and
  fixed point theorems fall out of the same simple scheme". Full text **NOT READ**.
  **Honest scope limit:** I therefore do not claim Yanofsky fails to state the extra
  hypotheses — only that the corpus's Cor 2.1, which cites him, does not.
- **D. M. Roberts**, *Substructural fixed-point theorems and the diagonal argument: theme
  and variations*, Compositionality (2023), arXiv:2110.00239. Abstract read via search.
  Strips the hypotheses back **further** than cartesian closure, to a magmoidal product
  with diagonals. Relevant here in the direction of §1.1: the logical half gets *weaker*
  hypotheses the more carefully it is looked at, never stronger, which is the opposite of
  what a bridge to the analytic geometric side would need.
- **Gödel 1931** ($\omega$-consistency) and **J. B. Rosser**, *Extensions of some theorems
  of Gödel and Church*, J. Symbolic Logic **1** (1936) 87–91 (removing it by changing the
  fixed point). Cited as textbook classics; not re-read this session.
- **M. Presburger 1929**, for the consistent, r.e., complete witness of §2.2. Textbook;
  not re-read.
- **Abramsky, Barbosa, Kishida, Lal, Mansfield**, *Contextuality, Cohomology and Paradox*,
  CSL 2015, arXiv:1502.03097. Already in the corpus (seed148 §5) and confirmed on-target
  for a *gluing* paradox, not a diagonal one. I searched for and **did not find** any
  source relating a Čech obstruction to Lawvere's fixed-point theorem — the same negative
  seed148 reports, independently re-run.
- **J. L. Bell**, *Incompleteness in a General Setting*. PDF; **NOT READ** (does not decode
  here). Flagged as an unexamined lead for a future block, since its title is exactly the
  §2 question.

---

## 6. Scope limits

- **Theorem 2 is about the abstract hypothesis set displayed in §2.2**, not about
  arithmetic. It says those four data do not entail $T\nvdash\neg G$. The arithmetic
  witness $\mathsf{PA}+\neg\mathrm{Con}(\mathsf{PA})$ is given separately and is classical.
- **Theorem 3 assumes $X$ finite-dimensional.** Over an infinite-dimensional complex the
  geometric tower need not terminate and the argument gives nothing; Theorem 4 (locality)
  is unaffected and still applies there.
- **Nothing here decides D0017 §G's ladder, §A's functional, or §J3.** §J3 is settled at
  `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §6; §G at
  `notes/ORDINAL_LADDER_SMALLNESS.md` and `notes/SURVIVING_LADDER_FRAGMENT.md`.
- **The archive is a transcription.** D0017 §G carries a recorded candidate transcription
  gap (the $\mathfrak F^{\langle n\rangle}$ tower and the large commuting diagrams are
  absent). I read §F and §J2 as they stand and **report, rather than conclude from**, that
  absence: if the original carried a diagram exhibiting the bridge explicitly, Theorems 3
  and 4 constrain what it can have been but do not tell us what it was.
- **`Everything.agda`** imports the new module and checks **EXIT=0 under the pin** with the
  import in place, measured in this container (195 warning lines, 0 `error:` lines).
  `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` and `formal/cubical/check.sh` both record
  `Everything.agda` as "currently expected red under the pin"; that expectation is stale as
  of this run. I report the measurement and do not amend those files, since a single green
  run is evidence about this container and this moment, not about the general claim they
  make.

---

## 7. Ledger

| claim | status |
|---|---|
| `LawvereDiagonal.agda` proves Lawvere + Cantor, green under the pin | **Verified by running the pin** |
| Tarski is the same term as Cantor | **Proved** — `tarskiUndefinability` |
| Gödel I conjunct 1 from fixed point + Con + HBL1 | **Proved** — `goedelHalfOne` |
| Gödel I conjunct 2 from those data | **Refuted with a finite witness** — `noHalfTwo` |
| "Gödel I is an instance of Lawvere" (corpus Cor 2.1) | **False grounds; corrected** |
| Bridge, by grading and termination | **Refuted** — Theorem 3 |
| Bridge, by locality | **Confirmed refuted** (seed148 Thm 4), not re-derived |
| What a bridge would need | **Stated exactly** — (D1)–(D4); (D2) known unavailable |
| A Čech-to-Lawvere bridge in the literature | **Searched, not found** (independent re-run of seed148 §5) |
