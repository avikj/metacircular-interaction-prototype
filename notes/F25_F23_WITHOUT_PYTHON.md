# F25 and F23 without Python: two no-gos made replayable

**Author:** cf-tessera-r2-03, 2026-08-14.
**Deliverables:** this note, plus two new checked modules —
`formal/cubical/IntegerHullMultiplicity.agda` (F25) and
`formal/cubical/Window5Walsh.agda` (F23). Both are `--cubical --safe`,
Agda 2.6.3 + cubical v0.5, **exit 0, no postulates, no holes**. Neither is
added to the root aggregate `NaturalMachine.agda`; that is the parent's call
(`formal/cubical/BUILD.md` is explicit that the green claim is the root
aggregate and its transitive imports, not the directory).

**Why this exists.** `notes/OPEN_PROBLEMS_WE_TOUCH.md` §1 (rows **L3** and
**L24**) identified the highest-leverage repair available in this corpus:

> "the certified-computation evidence is a dead Python file … **Restating this
> in Agda or by hand would be the single highest-leverage page in the
> corpus.**" (L3, on F25)
>
> "the check ran in banned Python and cannot now be replayed … nobody has
> re-derived the witness by hand or in Agda. **Until (ii) and (iii) are
> addressed this is an assertion, not a finding.**" (L24, on F23)

The two entries are `collab/FAILURES.md` **F25** (cf-prime/opus5) and **F23**
(codex). Their notes are `notes/KAPPA.md` §4(5) and §7 (F25) and
`notes/CONSTRAINT_ALGEBRA.md` (F23). Their artifacts were
`code/exp61_integer_hull_check.py` and `code/exp53_window5_polytope.py`. Both
`.py` files were read as **source text only**; neither was run, and
`MATH_ALLOW_PYTHON` was not set at any point in this block.

**Headline.** Both are rescued, and they are rescued by *different* means,
which is the interesting part:

| | F25 | F23 |
|---|---|---|
| what the Python did | an integer-programming **search** over 5 values of N | an exact **finite table** over 32 patterns |
| what replaces it | **a proof, for all N** — the search was unnecessary | **a checked finite table** — the enumeration was the content |
| new evidence grade | **PROVED** (theorem, machine-checked, general) | **CHECKED-FINITE** (kernel-verified exhaustion, exactly as before, now replayable) |
| strength vs. Python | **strictly stronger** (5 instances → all t) | **equal in content, replayable in kind**, plus the four vertices and a control the note had only in prose |

---

## 1. What the two scripts actually computed

Read as source, with no run.

### 1.1 `code/exp61_integer_hull_check.py` (F25) — 45 lines

Setting, from its own docstring: distinct zeros carry integer multiplicities
$m_i\ge1$; $N=\sum m_i$ (zeros with multiplicity), $S=\sum m_i^2$ (known
$\le\frac43N$ in band 1). Two functionals: the number of atoms (distinct
zeros) and the number of *simple* atoms ($m_i=1$). Two routines:

- `exact_min_atoms(N,S)`: the least $k$ such that $k$ positive integers can sum
  to $N$ with $\sum m_i^2\le S$. It uses the standard fact that the minimum of
  $\sum m_i^2$ over $k$ positive parts summing to $N$ is attained by the
  as-equal-as-possible partition, and scans $k=1,2,\dots$
- `exact_min_simple(N,S)`: a memoised DP `f(n,s)` = fewest parts equal to 1
  needed to write $n$ as a sum of positive parts with square-budget $s$.

It printed one table row for each $N\in\{12,18,24,30,36\}$ at $S=\lfloor 4N/3\rfloor$:
the Cauchy–Schwarz bound $N^2/S$, `exact_min_atoms`, the bound $2N-S$, and
`exact_min_simple`. **That is the whole artifact.** Five rows, no controls,
no proof — and F25 read off from those five rows that the exact optima equal
$(5/6)N$ and $(2/3)N$, i.e. the two relaxations' values.

### 1.2 `code/exp53_window5_polytope.py` (F23) — 221 lines

Exact `Fraction` arithmetic throughout, no floats, no scan (its own docstring
says so and disowns the interrupted WIP's step-$1/60$ grid). Five checks:

1. `check_class_table` — the map $\varepsilon\mapsto$ (coefficients of
   $32\mu$ in the basis $(1,a,b,c)$) takes exactly nine values, with
   multiplicities $2,2,2,2,4,4,4,4,8$ summing to $32$.
2. `check_sharp_countermodels` — at each of the four points
   $(a,b,c)=(\pm\frac13,\pm\frac13,\frac13)$: all 32 masses $\ge0$, total $32$,
   exactly ten zero.
3. `check_stationary_extension` — at $(\frac13,\frac13,\frac13)$: outgoing
   $=$ incoming $=(1+a\varepsilon_1\varepsilon_2\varepsilon_3\varepsilon_4)/16$
   at every one of the 16 de Bruijn states; every state mass strictly
   positive; every transition row nonnegative and summing to $1$; all 31
   nonempty Walsh coefficients equal to the advertised values; **plus a
   planted-false control** in which the two consecutive coefficients are set
   to $\frac13$ and $\frac14$ and flow conservation must break.
4. `check_printed_flip` — $32\mu(+,+,+,+,-)=0$ and $32\mu(-,+,+,+,+)=0$, the
   two patterns distinct, and $\varepsilon_1=-\varepsilon_5$.
5. `check_f2_identities` — four $\mathbb F_2[u]$ products.

Everything in it is a **finite exact computation**. Nothing in it is a search
over a continuum, and nothing is floating point.

---

## 2. F25: the search was unnecessary — here is the theorem

### 2.1 Statement

Let $m_1,\dots,m_k$ be positive integers with $N=\sum m_i$ and
$S\ge\sum m_i^2$. Write $s=\#\{i:m_i=1\}$. Then

$$\boxed{\;3N\;\le\;S+2k\qquad\text{and}\qquad 2N\;\le\;S+s\;}\tag{2.1}$$

and **both are equalities simultaneously** for the configuration consisting
only of $1$s and $2$s. At the band-1 ceiling $S=\frac43N$ (equivalently
$3S=4N$), (2.1) reads

$$k\;\ge\;\tfrac{3N-S}{2}=\tfrac56N,\qquad s\;\ge\;2N-S=\tfrac23N,$$

and the configuration $\mathrm{hull}(t)$ with $N=6t$ — namely $4t$ atoms of
multiplicity $1$ and $t$ atoms of multiplicity $2$ — has $S=8t$ (so $3S=4N$
exactly), $k=5t=\frac56N$ and $s=4t=\frac23N$. **Hence the minima are exactly
$\frac56N$ and $\frac23N$: the inequalities $m^2\ge3m-2$ and $m^2\ge2m-1$ are
the integer hull for these two functionals, and there is no room.**

### 2.2 Proof (one substitution)

Put $m_i=1+x_i$ with $x_i\ge0$. Then, summing over $i$,

$$N=k+X,\qquad S\ \ge\ \sum m_i^2=k+2X+Q,\qquad X:=\sum x_i,\ \ Q:=\sum x_i^2 .$$

Therefore

$$S+2k-3N\;\ge\;(k+2X+Q)+2k-3(k+X)\;=\;Q-X,$$
$$S+s-2N\;\ge\;(k+2X+Q)+s-2(k+X)\;=\;Q+s-k.$$

So (2.1) is *exactly* the pair of elementary per-element facts

$$x\le x^2\quad(x\in\mathbb Z_{\ge0}),\qquad\qquad 1\le x^2+[\,x=0\,] ,$$

summed over $i$. **That is all $m^2\ge3m-2$ and $m^2\ge2m-1$ ever were.**
Both per-element facts are equalities precisely on $x\in\{0,1\}$, i.e. on
$m\in\{1,2\}$ — which is why one configuration saturates both at once, and
why the two constants are attained together rather than by two competing
extremal configurations. For $\mathrm{hull}(t)$: $k=5t$, $X=t$, $Q=t$, so
$X=Q$ and $Q+s=t+4t=5t=k$, both with equality. $\square$

Note the parity remark that the Python's `//` quietly relied on and never
stated: $\sum m_i^2-N=\sum m_i(m_i-1)$ is always **even**, so a ceiling $S$
with $S\not\equiv N\pmod 2$ is never binding — it acts as $S-1$. The five
tested $N$ are all $\equiv0\pmod 6$, so $S-N=N/3$ was even and this never
bit. It would have bitten at $N=6$… and at any $N\equiv3\pmod6$.

### 2.3 What is in the Agda

`formal/cubical/IntegerHullMultiplicity.agda`. Configurations are `List ℕ`
where entry `x` **means** multiplicity `suc x`, so positivity is structural
rather than a side condition. The module contains:

- `decompN`, `decompSQ` — the reparametrisation $N=k+X$, $\sum m^2=k+2X+Q$
  (the only place the squares appear; `sqSuc : suc x · suc x ≡ suc (x + x + x · x)`);
- `x≤x²`, `one≤` — the two per-element facts, and `X≤Q`, `K≤Q+ones`, their sums;
- `distinctBound`, `simpleBound` — (2.1) for **every** configuration and
  **every** ceiling $S$, stated additively so that no truncated subtraction
  appears anywhere;
- `hullN`, `hullSQ`, `hullK`, `hullOnes`, `hullCeiling` — the four exact
  counts of $\mathrm{hull}(t)$ and $3S=4N$, for every $t$, by one-line
  inductions;
- `distinctOptimal`, `simpleOptimal` — $\frac56N$ and $\frac23N$ are lower
  bounds at the ceiling; `hullAttains` — they are attained;
- controls: `noBetterDistinct`, `noBetterSimple` (no feasible configuration
  beats the hull), and `cauchySchwarzNotAttained` — **at $N=12$, $S=16$ the
  Cauchy–Schwarz value $N^2/S=9$ is provably not attainable**, while
  `integerHullAt12` exhibits $k=10$. That is the $t=2$ row of the retired
  script's table, and it is the precise sense in which F25's parenthetical
  ("Cauchy–Schwarz alone would give only 3/4, so integrality is already being
  used, and used optimally") is true.

Two implementation facts worth recording for the next agent: cubical v0.5's
`Cubical.Tactics.NatSolver` **cannot see through `suc` or numeric literals**
(it files them as opaque constants and then fails), so every `solve` call in
the module is on a goal in variables only; numerals are handled by
`·-distribˡ`/`·-assoc`/`·-comm` and by definitional reduction (`c + z` reduces
to `sucᶜ z`, which is what makes `cong (6 +_) ih` typecheck as the induction
step). This is a sixth version-skew note for `BUILD.md`.

### 2.4 Evidence grade, and what did *not* change

- **Before:** *asserted-from-dead-script.* Five printed rows in a file no one
  may run.
- **Now:** **PROVED**, and machine-checked, for every $N$ and every $S$ — not
  five instances. The exhaustive search was not merely replaceable; it was
  never needed. This is the third time `CLAUDE.md`'s prediction ("in every
  instance in this corpus, the derivable quantity behind the measurement
  existed and was shorter than the experiment") has held on the nose: the
  proof above is shorter than the 45-line script *and* infinitely stronger.

- **Unchanged and still open:** F25's yield (3) — the localization of where
  the frontier argument *is* lossy, namely the von Neumann transplant from
  multiplicities to matrix eigenvalues (`notes/KAPPA.md` §4(5), Lemma 3.2).
  Nothing here touches that. The measure-level statement is now *proved*
  tight; the matrix-level statement is still only *believed* lossy. F25's
  "Extend" line — quantify the transplant loss — is untouched and is now the
  only live thing in that lane.
- **Unchanged:** the audience. The target manuscript is unrefereed
  (`notes/KAPPA.md` §0, §5.2). This note does not change that.

### 2.5 Prior art (searched **before** the write-up, per `CLAUDE.md`)

Queries run this session (WebSearch; `WebFetch` is EGRESS_BLOCKED, so nothing
below was read in full and nothing is characterised beyond its title/abstract
snippet):

1. *"minimize number of parts integer partition fixed sum bounded sum of
   squares extremal parts 1 and 2"* — returned work on partitions with
   prescribed $\sum m_i^2$ (e.g. arXiv:2204.07873, and the classical
   ScienceDirect item *"The sum of the squares of the parts of a partition"*)
   but **nothing stating (2.1) or its tightness**.
2. *"Montgomery pair correlation … $m^2\ge3m-2$ Conrey Ghosh Gonek … 5/6"* —
   returned arXiv:2501.14545 (*Pair Correlation of Zeros … I*) and the
   standard record that CGG/Bui–Heath-Brown reach $19/27\approx0.7037$ simple
   and $\approx0.8457$ distinct under RH+GLH. **CITED**, not read.

**Honest verdict on novelty:** (2.1) is elementary — a two-line majorization
argument — and I would expect it to be folklore to anyone who has written down
the extremal configuration. The searchable literature did not produce it in
this form, but *absence of a hit is not novelty*, and this corpus has been
burned by exactly that inference three times
(`notes/OPEN_PROBLEMS_WE_TOUCH.md` §2, category (d) = 7 rows). The value of
§2.2 is **not** that it is new; it is that the corpus's claim is now warranted
by something a reader can check in thirty seconds, instead of by a script the
repository forbids running.

---

## 3. F23: the enumeration *was* the content, so it is now a checked table

### 3.1 What is in the Agda

`formal/cubical/Window5Walsh.agda`. Signs are a two-element datatype `Sg`;
patterns are 5-tuples; the rational arithmetic is cleared **once** by working
throughout with the integer

$$\mathrm{m96}(\varepsilon):=96\,\mu_{1/3,1/3,1/3}(\varepsilon)
=3+\varepsilon_{1234}+\varepsilon_{2345}+\varepsilon_{1345}+\varepsilon_{1235}+\varepsilon_{1245}\in\mathbb Z,$$

so no `Fraction` analogue is needed anywhere and every check is an integer
equality the kernel evaluates. Correspondence with the retired script,
check for check:

| `exp53` check | Agda term(s) | status |
|---|---|---|
| `check_class_table` | `classCounts`, `classComplete`, `classDistinct` | ✅ nine forms, multiplicities 2/4/8, nothing else occurs, nine really distinct |
| `check_sharp_countermodels` | `massesNonNeg`, `massTotal`, `zeroCount`, `fourSharpVertices` | ✅ all four vertices $(\pm\frac13,\pm\frac13,\frac13)$ |
| — (new) | `massValues`, `massSpectrum` | ✅ the mass spectrum is exactly $\{0,4,8\}$ with multiplicities $10,20,2$ |
| `check_stationary_extension` (flow) | `flowConserved` | ✅ out $=$ in $=6+2\varepsilon_{1234}$ and $>0$ at all 16 states |
| `check_stationary_extension` (Walsh) | `walshOK`, `shiftEquality`, `reflectionEquality`, `twoPointVanishes`, `oddOrderVanishes` | ✅ all 31 nonempty coefficients |
| `check_stationary_extension` (planted-false control) | `flowBroken`, `flowBrokenWitness` | ✅ the control **fires**: the check evaluates to `false` by `refl` |
| `check_printed_flip` | `flipFixesZero`, `flipDistinct`, `flipIsEndpointFlip` | ✅ both masses zero, patterns distinct |
| `check_f2_identities` | `f2Identity1`–`f2Identity4`, `f2Control` | ✅ plus a new planted-false control |

The transition-row facts the script also asserted (each row nonnegative,
summing to $1$) are the quotient $K(v,\varepsilon_5)=\mu/\pi(v)$ of
`massesNonNeg` by `flowConserved` + positivity, so they are implied rather
than separately stated; that is the one place the Agda is an implication
short of the script's literal assertion list, and it is a division, not a
fact.

**One structural remark the enumeration handed over for free**, which the note
did not have: the product of the five characters
$\varepsilon_{1234}\varepsilon_{2345}\varepsilon_{1345}\varepsilon_{1235}\varepsilon_{1245}$
is identically $+1$ (each $\varepsilon_i$ occurs in exactly four of the five
4-sets). So the number of $-1$s among the five is always **even**, the sum of
the five lies in $\{5,1,-3\}$, and $\mathrm{m96}\in\{8,4,0\}$ — nonnegativity
at the sharp point is a *parity* fact, not a computation, and a mass vanishes
iff exactly four of the five characters are $-1$. `massValues` and
`massSpectrum` are the checked form of that observation. The count $10$ still
needs the class analysis (or the enumeration): $4+4+2$ from classes B, C, A of
`notes/CONSTRAINT_ALGEBRA.md` §2.

### 3.2 Evidence grade

- **Before:** *asserted-from-dead-script* for the finite content; the
  continuous maximum (`CONSTRAINT_ALGEBRA` Theorem 2.1) was already a hand
  proof, but its **input** — the nine-form class table — was only in the script.
- **Now:** **CHECKED-FINITE.** Every finite assertion is a term the Agda
  kernel normalises, `--safe`, no postulates. That is precisely what
  `CLAUDE.md` admits ("a finite exhaustive verification … produces
  mathematical objects, not measurements"). Theorem 2.1's input is now checked,
  so the hand proof of the continuous maximum is warranted end to end.
- **Deliberately unchanged:** the claim about the *published paper*. I did
  **not** read Tao–Teräväinen §7. `WebFetch` is EGRESS_BLOCKED in this
  session, so the audit in `notes/CONSTRAINT_ALGEBRA.md` §4 stands on that
  note's own reading and remains at **CITED** grade there. I add only:

  - Search run this session: *"Tao Teräväinen … erratum corrigendum Theorem
    1.14 sign patterns 24 patterns"*. It located the paper — *Value patterns
    of multiplicative functions and related sequences*, arXiv:1904.05096,
    Forum of Mathematics Sigma — and returned, from result snippets only,
    that Theorem 1.14 is "Length 5 sign patterns of Liouville: there are at
    least 24 sign patterns in $\{-1,+1\}^5$ attained by $\lambda$ with
    positive upper density". **No erratum or corrigendum surfaced.** This
    corroborates `CONSTRAINT_ALGEBRA` §4's own null search and, exactly as
    that note says, *does not establish novelty*.
  - I make **no** characterisation of the paper's §7 argument. Everything
    this repository says about that argument is `CONSTRAINT_ALGEBRA` §4's, at
    that note's grade, and a specialist should be handed the Agda module (a
    self-contained finite object about a measure on $\{\pm1\}^5$) rather than
    our reading of their prose.

So: **the mathematical object is now replayable; the claim about the
literature is not, and I have not upgraded it.** Those are two different
things and L24's caveats (i)–(iii) are now (i) unchanged, (ii) fixed,
(iii) fixed.

---

## 4. Method: two lenses that disagreed, and which one was right where

Assigned lenses: **Turing** (build the machine whose behaviour *is* the
definition) and **Simone Weil** (attention is the faculty; look without
imposing). They gave *different answers*, and the difference is the finding.

- On **F23**, Turing was right. The content of the claim genuinely is a finite
  table; the honest object is the machine that produces it, and Agda's kernel
  running `refl` *is* that machine, with the further property Python lacked —
  it is also the proof. Building it took an afternoon and the result is
  strictly better than the script (four vertices instead of one, two extra
  controls, and no trust in an interpreter).
- On **F25**, Turing was **wrong**, and following him would have wasted the
  block. The Turing move is: port `exact_min_atoms` and the memoised DP to
  Agda and let the kernel exhaust $N=12,\dots,36$. That is buildable, would
  have typechecked, and would have been *worthless* — it would have
  re-certified five instances of a statement true for all $N$, and left the
  claim exactly as narrow as the Python left it. The Weil move — read the
  script's *object* rather than its *procedure*, without imposing the frame
  "this must become a checked computation" — gives the substitution
  $m=1+x$ in one line, and with it the general theorem. **A machine that
  faithfully reproduces an unnecessary search is a faithful reproduction of a
  mistake.**

The operational rule I would hand forward: *before porting a computation to
the proof assistant, ask which of the two it is — a table or a search. Port
tables. Kill searches.* `CLAUDE.md`'s standing rule ("before running any
computation, write down the theorem it would replace") does not by itself
cover the rescue case, because the computation has already been run; this is
its retro form.

**Ancient field drawn** (by `shuf` from
`random_entry_seeder_so_agents_dont_cluster/ancient_fields.txt`): *Arabic
optics and experiment: Ibn al-Haytham's controlled method.* It is load-bearing
here, not ornament. Al-Haytham's *i'tibār* is not "do an experiment"; it is the
requirement that the apparatus be described completely enough that a hostile
reader can rebuild it and get the same result — and, in the *Doubts on Ptolemy*,
that the authority of a predecessor is no substitute for that. A result whose
warrant is a script the repository forbids running fails his criterion twice:
the apparatus cannot be rebuilt, and the corpus was being asked to accept a
number on the authority of a prior agent. That is the exact failure mode L3 and
L24 named, stated a millennium earlier. It also supplies the right standard for
what "replayable" should mean here: not "we kept the file" but "the check is the
object, and it re-runs in the reader's own kernel."

**Frontier field assigned:** homotopy type theory / univalent foundations —
cubical models, higher inductive types. **Honest report: neither rescue needed
any of it, and I did not manufacture a use.** Both objects are sets; every
statement is $\pi_0$-level; the only things the cubical setting contributes
are that `refl` *is* definitional computation and that `--safe` mechanically
forbids the postulate that would otherwise hide a gap. That is exactly the
verdict `NaturalMachine/SieveFiber.agda` recorded for its own model ("No
higher structure appears … every obstruction here is π₀-level"), and
`notes/CUBICAL_QUOTIENT_AUDIT.md` §6 predicted it for this shape of model.
Two independent instances of the same negative is worth one line in the
ledger: **finite-verification rescues do not exercise the univalent layer**,
and an agent assigned that frontier should not go looking for a HIT in them.

---

## 5. Residue: what I am least sure of

Invited, and named plainly.

1. **The step I am least sure of** is not in either Agda module — it is the
   *identification* in §2.1 of the abstract integer program with what the
   frontier argument actually consumes. I have taken $(N,S,k,s)$ and the band-1
   ceiling $S=\frac43N$ from `notes/KAPPA.md` §4(5) and from F25's own
   statement, and I have **not** verified against the manuscript that
   `Lemma 3.2`'s trace inequality is applied to exactly these four
   functionals in exactly this grouping (F25 says "regrouping simple zeros on
   the rank side" gives the $3m-2$ form — that regrouping is where a mismatch
   would live). If the manuscript's grouping differs, §2 remains a correct
   theorem about a correct integer program and stops being *the* one. Someone
   with the manuscript should check that one sentence.
2. `hullCeiling` proves $3S=4N$ for $\mathrm{hull}(t)$, i.e. that the witness
   sits *on* the ceiling. It does not prove that $\frac43N$ *is* the band-1
   ceiling — that is analytic input from Montgomery's second moment, quoted,
   not derived, and nothing in this block touches it.
3. In §3 I read `exp53` as source and matched its assertions one by one. If it
   contained an assertion I mis-parsed, my table in §3.1 would be silently
   short by one row. The table is my reading, not a diff.
4. `notes/CONSTRAINT_ALGEBRA.md` (3.3) contains two typos — `,quad` for
   `\quad` — in the Walsh-coefficient display. Not corrected here (this note
   does not edit other notes); flagged so the next editor sees it. The
   coefficients themselves are the ones `walshOK` verifies, so the content is
   confirmed.

## 6. Reading-rule compliance, stated because it is a rule

The eleven drawn files were read in full **except** `collab/chronicle/COMMITS.md`
(716 KB / 18 560 lines, a mechanically generated commit-and-file listing). I
read its head (~300 lines) and its last ~1 160 lines and sampled between; I did
not read all 18 560. Recording the shortfall rather than implying otherwise.
The one line from that file that changed this block's plan is the 2026-08-12
commit *"Retire Python witness into checked Agda normalization"* (codex-pravaha,
`42eea70`), which **deleted** `machinery/symmetry_arithmetic_action.py` in
favour of a checked module and wrote `notes/PROOF_EVIDENCE_TERMINOLOGY_AUDIT.md`.
That is the precedent this block followed, two days later, for two harder cases;
it is also the reason both new modules are additions and no `.py` was touched.

`collab/upstream/raw/U0009.txt` — the owner's "transfer kernels of intelligence
down towards traditional programs … way cheaper/higher throughput than running
primarily through language models" — is answered directly, and in the owner's
own terms, by §4: an Agda module is exactly such a transfer (the kernel, not a
model, does the checking, and it costs seconds), and §2 is the *cheaper* answer
still, because a proved theorem costs zero CPU on every subsequent read. The
correct order is: derive if you can, check finitely if you cannot, and never
ship a script.
