# Open problems we touch — an evidence-anchored answer to U0012

**Answering:** `collab/upstream/raw/U0012.txt`, the human owner, verbatim:

> "are there exissting open problems we've shed new light on? or our
> discoveries so far are in dark corners of the math world?"

**Filed:** 2026-08-14 · `cf-tessera-02` · reading and synthesis only. No
computation was run. No mathematics is created here; every row is a citation
of a corpus note plus a judgement about its relation to the outside world.

**The short answer, stated before the evidence, because the owner offered
"dark corners" as an acceptable answer and it is the true one:**

> **Mostly dark corners — and the corpus's one genuine external strength is
> not a theorem, it is the no-go column.** Zero corpus results prove a special
> case of a named open problem. One supplies an equivalent reformulation of
> RH, and it is downstream of an equivalent that was already known. Nine
> results rule out an approach with a named obstruction, and *that* is the
> column a working specialist could actually use. Seven are rediscoveries the
> corpus caught itself. Everything else — and "everything else" is roughly
> 490 of the 520 files in `notes/` — shares vocabulary with a research field
> and nothing more.

---

## 0. How to read this, and what it is not

**Evidence grades.** Corpus-internal statements cite note and section and
carry the note's own status word. Every external claim in this file is
**CITED, at search-summary grade**: `WebSearch` works, `WebFetch` is
`EGRESS_BLOCKED` on every host, so no paper was opened. Where I rely on a
search I name the query. **Absence of a located source is not evidence of
novelty**, and every "not located" below must be read that way.

> ~~TESTIMONY at search-summary grade (śabda)~~ — struck 2026-08-14 by
> cf-tessera, who commissioned this note and whose brief failed to carry the
> warning. `PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md` withdrew the identification
> `pratyakṣa/anumāna/śabda = MEASURED/PROVED/CITED` and withdrew "śabda is
> weakest": a pramāṇa is typed by its cognition-producing causal route and the
> *Tarkasaṅgraha* supplies no scalar order. `UNASSEMBLED_RESULTS_HARVEST.md`
> then measured the damage — 21 live uses, 1 citing the withdrawal, and **20
> of the 21 stamped in on 2026-08-14, after it** — so the label is not stale
> debt, it is actively re-propagating through briefs and sweep templates. This
> note was instance 22 and I caused it. Round-2 briefs now carry the warning
> explicitly. Use **PROVED / MEASURED / CITED / OPEN**.

**Two searches were run for this note**, both in the assigned frontier field
(proof complexity / Positivstellensatz):

1. `Weil quadratic form positive index at most one equivalent Riemann
   Hypothesis Bombieri negative eigenvalues off-line zeros`
2. `parity barrier sieve theory sum-of-squares degree lower bound
   Positivstellensatz proof complexity formalization`
3. `"sieve" parity obstruction "proof system" lower bound linear programming
   pseudo-expectation Tao convex duality formalize sieve axioms`

Everything else external in this file is **consumed, not re-derived**, from
four prior surveys, which are the real intellectual input here and are
credited row by row:

- `notes/FRONTIER_2026_MAP.md` — the 2026 analytic + formalization frontier
  against the corpus, 17 + 8 rows, and the only document that had already
  established the corpus's staleness verdict. **This note would not exist
  without it.**
- `notes/PRIOR_ART_SWEEP_COMPLETE.md` — 31 outstanding attribution flags
  serviced, 15 corpus claims identified as known mathematics.
- `notes/PRIOR_ART_INDEX.md` — the pre-`PROVE` grep protocol and the
  our-name/standard-name translation table.
- `collab/FAILURES.md` — the walk ledger, 40+ entries. This is where the
  category-(c) column lives; most of it is not in `notes/` at all.

Also consumed: `notes/RANDOM_FRONTIER_SAMPLE_01.md` (the control experiment
that independently recovered ~1/17 of `FRONTIER_2026_MAP` Part A),
`notes/METHOD.md` (the 2-of-30 experiment triage), `notes/LITERATURE.md`,
`notes/HOTT_ECOSYSTEM_MAP.md` and `notes/MATHLIB_INGESTION_MAP.md` (the
formalization-side maps), `notes/METALOOP.md`, `notes/MILLENNIUM_ROSETTA.md`.

**What this note is not.** It is not a novelty claim for anything. It is not
a re-search: where a sweep already recorded a verdict I cite the sweep and do
not re-run it. It does not weaken, strengthen or restate any theorem.

**The inflation guardrail I am bound by**, quoted because it applies to this
entire document and not only to the note it comes from — `notes/ATLAS_OF_N.md`
§2.5:

> **Guardrail, stated as strongly as the charter requires.** Corollary 2.13.1
> is a triviality about the weakness of the multiplicative monoid as a
> structure. It says that additive conditions are not expressible in chart
> (f), and **nothing else**. It is not an explanation of, and implies nothing
> whatsoever about, the difficulty of Goldbach, twin primes, $abc$, RH, or any
> other open problem. The charter […] forbids that inflation, and this note
> makes no such claim.

and its §10 item 3:

> **No claim about any open problem.** […] Nothing here bears on Goldbach,
> twin primes, $abc$, RH, or the repo's prime-pair field.

Where a row below is tempted toward inflation I say so in its verdict line.

**The relation codes**, as assigned by the task:

| code | meaning |
|---|---|
| **(a)** | proves a special case of the named open problem |
| **(b)** | supplies an equivalent reformulation |
| **(c)** | rules out an approach — a no-go with a named obstruction |
| **(d)** | rediscovers something already known |
| **(e)** | merely shares vocabulary |

---

## 1. The ledger

Twenty-four rows. These are the results that **plausibly touch a named open
problem or an active research frontier at all**. That is the selection
criterion, and it is the reason the counts below look better than the corpus
does: see §2 for the denominator.

### 1.1 The Weil-positivity / RH lane

---

**L1 — the index-one criterion.**

1. **Claim.** `notes/WEIL_INDEX_ONE.md` Theorem 3.1: RH ⟺ for every
   finite-dimensional complex $V\subset C_c^\infty(\mathbb R)$, the Hermitian
   form $I=\mathrm{pole}-W$ satisfies $n_+(I|_V)\le1$. Unconditional; no zero
   simplicity assumed. **Status as the note states it:** proved, with §4
   headed "What is and is not new" and §5 an audit-obligations list. It arose
   as the successor conjecture posed at `notes/LP_CERT.md` §8.
2. **Open problem.** The Riemann Hypothesis (Clay Millennium).
3. **Exact relation: (b), and a strictly downstream one.** It is an equivalent
   reformulation of RH. But it is *derived from* Weil positivity, which is
   itself a classical equivalent of RH, using (i) Bombieri's 2000 finite-zero
   eigenvalue count and (ii) the Yoshida / Connes–Consani Appendix C
   interpolation lemma. The note says this itself: "the hard analytic
   ingredient is not new […] should be described as a short corollary/
   synthesis of this prior machinery — not as a new route around the analytic
   difficulty of RH." Search (query 1) returned Bombieri's *Remarks on Weil's
   quadratic functional* and its result that for a finite symmetric zero
   multiset the number of negative eigenvalues is exactly half the number of
   off-line zeros — i.e. the mechanism, at search-summary grade. The
   index-**one** packaging was not located; that is not evidence it is new.
4. **Would a specialist find it new? No.** Anyone working the Weil-positivity
   lane knows Bombieri's count and knows that flipping to $I=\mathrm{pole}-W$
   moves the deficit from "one negative direction per off-line pair" to "one
   positive direction from the hyperbolic pole plane". The genuine content is
   the *quartet* observation — an off-line zero yields **two** independent
   $J$-pairs over complex test functions, which is why the threshold is one
   and not two. That is a nice remark. RH has dozens of equivalents (Weil,
   Nyman–Beurling, Li, Robin, Lagarias, …); adding a corollary of one of them
   is near-zero information toward the problem, and the note does not pretend
   otherwise. **This is the strongest claim in the corpus by relation type and
   the most carefully graded document in it.**

---

**L2 — the relocation of the positivity question.**

1. **Claim.** `notes/LP_CERT.md` Prop. LP1: "the naive primitive question is
   trivial" — $W|_P$ is PSD under RH for the trivial reason that restriction
   cannot change the sign of a sum of squares. Prop. LP2: the non-trivial
   object is the **zero-free** arithmetic intersection form
   $I=\mathrm{prime}-\mathrm{arch}$, whose index (not definiteness) is the
   RH-sensitive quantity. **Status:** §7 "Honest limitations" — "nothing is a
   theorem toward RH"; the numerics are float, not interval-certified.
2. **Open problem.** RH via Weil/Cohn–Elkies-style positivity certificates.
3. **Relation: (c).** It rules out the naive attack ("show $W$ is negative on
   primitives") by showing it is vacuous, and relocates the live question.
4. **Specialist verdict: no.** LP1 is one line once written down. Its value is
   internal — it is what generated L1.

---

**L3 — the integer hull of the critical-line certificate.**

1. **Claim.** `collab/FAILURES.md` **F25** (cf-prime/opus5). The two
   convex relaxations $m^2\ge2m-1$ and $m^2\ge3m-2$ used by the August-2026
   $2/3$ manuscript **are the integer hull**: solving the exact integer
   program (minimize simple atoms / distinct atoms over positive-integer
   multiplicity vectors with $\sum m=N$, $\sum m^2\le S$ at the band-1 ceiling
   $S=\tfrac43N$) returns exactly $(2/3)N$ and $(5/6)N$. Hence $2/3$ and $5/6$
   are the exact optima of **any** argument consuming $(N,\sum m^2,$
   integrality$)$. **Status:** the walk is recorded as DIED-with-yield; the
   evidence artifact is `code/exp61_integer_hull_check.py` — **Python, now
   banned, and per the `F33`/`F35` precedent a script nobody may run is an
   assertion with no replay.** The target manuscript is not peer reviewed
   (`notes/KAPPA.md` §0, §5.2; `FRONTIER_2026_MAP.md` A14).
2. **Frontier.** The unconditional critical-line proportion — the most active
   thing the corpus is adjacent to.
3. **Relation: (c), and the sharpest one in the corpus.** It closes a whole
   class of improvements ("spend the integrality better") and localizes the
   remaining loss precisely: not in integrality, but in the von Neumann
   transplant from multiplicities to matrix eigenvalues.
4. **Specialist verdict: plausibly yes, with two heavy caveats.** Someone
   working on that manuscript would want this: it converts "best this argument
   achieves" into "exact optimum of this input", on both axes independently
   (combined with CCLM17 Cor. 14 for the optimality of $S$). But (i) the
   certified-computation evidence is a dead Python file, so the claim now
   rests on a reader re-deriving a small integer program by hand, and (ii) the
   audience is currently the authors of an unrefereed preprint. **Restating
   this in Agda or by hand would be the single highest-leverage page in the
   corpus.**

---

**L4 — the lossiness budget: worst-case inequalities cannot certify.**

1. **Claim.** `collab/FAILURES.md` **F26** (cf-vesper/opus5), yield (1): a
   tool that inflates the off-diagonal prime term by a factor $C$ gives
   $\max_\lambda H = 2-2\sqrt{C/3}$, so $C<3$ or the certificate is vacuous.
   The large sieve's $C=\pi^4/18=5.4116$ fails by exactly $1.80$. **Status:**
   the walk it belonged to DIED on two independent counts; this is the
   surviving yield, derived rather than measured.
2. **Frontier.** Same as L3.
3. **Relation: (c).** It eliminates **worst-case inequalities as a class** —
   $|\mathrm{OffDiag}|\le\mathrm{Total}+\mathrm{Diag}$ can never certify
   $\mathrm{OffDiag}=o(\mathrm{Diag})$ — and derives, rather than asserts, why
   the door needs Hardy–Littlewood-strength sharp evaluation.
4. **Specialist verdict: partly.** The principle is folklore to anyone who has
   tried it; the *number* $C<3$ attached to this specific certificate is not.
   Small, correct, narrow audience. Note the entry's own process confession:
   the walk proposed something the primary source had already answered in its
   Remark 7.2(i), because §7.2–7.3 were not read.

---

**L5 — the double-positivity obstruction.**

1. **Claim.** `collab/FAILURES.md` **F17** / `notes/L3_SDP.md` Lemma L3.2:
   every $\mathrm{tr}(A^2)$-realizable pair kernel has
   $\hat g(u)=L^2\int z(t,u)^2dt\ge0$ for **every** real coefficient
   combination, whereas the Chirre–Gonçalves–de Laat SDP gain lives exactly in
   $\hat g<0$ outside the band. **Status:** re-proved from scratch by a hostile
   twin (`F19`), with the recorded subtlety that pointwise $g\ge0$ needs a PSD
   coefficient matrix while $\hat g\ge0$ is unconditional in $c$.
2. **Frontier.** Fourier-optimization / SDP majorant methods for zero
   proportions (Carneiro–Chandee–Chirre–Milinovich line;
   `FRONTIER_2026_MAP.md` A13).
3. **Relation: (c).** A named obstruction to transferring the CGdL gain into
   the unconditional inertia frame, with a corollary that any surviving
   sign-indefinite freedom must enter through $\mathrm{tr}(A^3)$.
4. **Specialist verdict: probably not new in substance** — "quadratic traces
   force nonnegative Fourier transforms" is the kind of thing an SDP-majorant
   practitioner meets immediately — **but it is correctly stated and correctly
   scoped**, which is more than most of the corpus.

---

### 1.2 The parity lane

---

**L6 — the width of the parity barrier.**

1. **Claim.** `notes/WIDTH.md`: the uniformity ladder (a)–(d) in one
   normalization; the two-layer separation (Buchstab/density layer vs.
   charge/equidistribution layer); "the parity barrier has infinite width on
   the exponent scale". **Status:** §6 — "(a)–(c): assembled from the cited
   literature; nothing new claimed"; Lemma W1 "standard argument". §5's
   numerics are exactly the artifact class `CLAUDE.md` was written to end.
2. **Open problem.** The parity barrier; individual equidistribution past
   $\theta=1/2$.
3. **Relation: (e), with a factual defect that was (d).** The assembly is
   vocabulary-sharing. Its uniqueness claim — "the only known crossing of
   $\theta=1/2$ in any averaged sense" — was **false as worded** against
   results that already existed: Lichtman arXiv:2309.08522 ($66/107$) and
   Pascadi arXiv:2505.00653 ($5/8$). Located and adjudicated by
   `notes/FRONTIER_2026_MAP.md` rows A5/A6 and independently re-surfaced by
   `notes/RANDOM_FRONTIER_SAMPLE_01.md` §3.3. **Corrected in place by
   strike-through today** (`WIDTH.md` §2(b) and §3), restricting the
   uniqueness to $\lambda/\mu$-type multiplicative functions. Nothing the note
   *proves* falls.
4. **Specialist verdict: no, and worse than no.** A specialist would have
   spotted the false uniqueness claim on sight in 2025. The note's §4 taxonomy
   also omits the Helfgott–Radziwiłł expander layer (arXiv:2103.06853) —
   `FRONTIER_2026_MAP.md` A8 calls this "the corpus's largest parity-lane
   blind spot" — and its two-point state of the art is Tao-era rather than
   Pilatte-era (arXiv:2310.19357, A7). Those two gaps remain open.

---

**L7 — the parity barrier as a protected gauge sector.**

1. **Claim.** `notes/GAUGE.md` Theorem F: the unique KMS state of Cuntz's
   $Q_{\mathbb N}$ vanishes identically on every nontrivial isotypic sector of
   the multiplicative gauge torus; hence every parity-odd observable has
   exactly zero equilibrium expectation. **Status:** proved, two lines, with
   an honesty header conceding the operator-algebraic ingredients are standard
   toolbox (Exel; an Huef–Laca–Raeburn–Sims; Cuntz–Echterhoff–Li) and claiming
   only "the *arithmetic identification* of the protected sector with
   factorization parity, which we have not found anywhere."
2. **Open problem.** The sieve parity barrier.
3. **Relation: (c) internally, (e) externally.** Internally it closes the
   graded-KMS route posed at `notes/PARITY.md` §2.2(1) — closed as a no-go in
   `notes/CORE_KMS.md`. Externally it is a slogan: "sieves cannot see parity
   for the same structural reason that gauge-invariant states cannot detect
   Wilson lines."
4. **Specialist verdict: no.** The mathematics is a two-line isotypic-vanishing
   argument that any operator algebraist would write down; the arithmetic
   identification is an interpretation, not a theorem, and it does not
   constrain a single sieve argument. Its real value is the derived meta-move
   recorded in `notes/METALOOP.md` §2 — *interrogate every persistent barrier
   for the conservation law protecting it, because that tells you what an
   attack must break* — which is a research heuristic, not a result.

---

**L8 — proof mass: the noisy sieve LP.**

1. **Claim.** `notes/PROOF_MASS.md` PM1–PM6: a formalized noisy affine axiom
   system for sieve derivations, weak duality, a completeness statement inside
   the finite box-and-slab LP, and charge/margin bookkeeping along a Selberg
   swap path. **Status:** the honesty header is explicit — "No theorem-level
   novelty is claimed"; §6 records the prior-art boundary.
2. **Frontier.** LP proof complexity (Sherali–Adams pseudo-expectation lower
   bounds) meeting the sieve parity obstruction. **This is my assigned
   frontier field.**
3. **Relation: (d) in form, (e) in application.** The abstract core is Tao's
   2014 "A general parity problem obstruction" (Hahn–Banach on forbidden sign
   patterns, conditional on a Liouville-pseudorandomness conjecture) plus
   standard robust-LP / approximate-Farkas sensitivity; the note says so. My
   search (query 3) returned Tao's two parity posts and confirmed the
   convex-duality framing is his; the specific arithmetic specialization
   (charges, margins, the swap path) was not located, which is not evidence of
   novelty.
4. **Specialist verdict: no.** A proof-complexity person reads PM1 as a
   dual-sensitivity inequality and PM2 as a fooling-distribution argument; a
   sieve person reads the witness pair as Selberg 1949. The synthesis is
   competent and correctly self-graded.

---

**L9 — "the parity barrier is a Positivstellensatz degree lower bound."**

1. **Claim.** `notes/ATLAS.md` §5.8 and `notes/ABHAVA.md` §4. Stated in
   `ABHAVA.md` as the shape of a programme, in the author's own words a
   "question I do not know the answer to":
   > **The parity barrier is a Positivstellensatz degree lower bound.** Not
   > logical independence […] A statement that *any* positivity certificate
   > for the parity-separating statement has degree $\ge f(N)$.
   `ATLAS.md` §5.8 supplies the concrete year-long target: a calculus
   $\mathfrak L(\theta,k,X)$ whose axioms are congruence sums to level
   $X^\theta$, smooth archimedean moments and Buchstab/Bombieri identities of
   depth $\le k$, each with its proved error interval; prove there is a
   degree-$k$ pseudo-measure feasible for every axiom with
   $\Lambda(1)=X(1+o(1))$ and $\Lambda(\mathbb 1_{\rm Prime})=0$.
   **Status: PROPOSED. Not a theorem, not attempted.**
2. **Frontier.** Positivstellensatz / SOS degree lower bounds (Grigoriev's
   $\Omega(n)$ bound for the mod-2 counting principle) meeting analytic number
   theory.
3. **Relation: (e) today; a *proposed* (b).** The vocabulary match is exact and
   striking — my search (query 2) confirms at śabda grade that linear degree
   lower bounds for Positivstellensatz-calculus proofs of the parity principle
   exist, and that "low-degree positivity certificates cannot see a mod-2
   invariant" is a theorem in that setting, which is word-for-word the sieve
   statement. **But no theorem connects the two**, and the hard parts are all
   undone: defining a proof system whose degree measure is meaningful for
   sieve arguments, and proving a lower bound in it. No source was located
   doing this; that is not evidence nobody has.
4. **Specialist verdict: the analogy is folklore, the theorem is absent.** A
   proof-complexity researcher would say "yes, obviously, and the reason
   nobody has done it is that the sieve axioms are analytic with error terms,
   so 'degree' has no canonical meaning." **This is the corpus's most
   interesting unexecuted idea in my assigned field, and simultaneously its
   most inflatable sentence — it must never be quoted without the words
   "proposed" and "not attempted" attached.**

---

**L10 — the Beurling wall.**

1. **Claim.** `notes/ATLAS.md` §5.8: RH is *false* for some Beurling
   generalized-prime systems (Diamond–Montgomery–Vorhauer), therefore **every
   proof of RH must invoke an axiom separating $\mathbb Z$'s prime system from
   those systems.** **Status:** stated as a permanently binding constraint;
   the citation is from memory/search grade.
2. **Open problem.** RH.
3. **Relation: (d), used as (c).** The DMV counterexample is published and well
   known in the Beurling-systems community. The corpus's own move is its *use*:
   as a checkable, non-metaphorical filter on proposed RH proofs, and as the
   countermodel source for L9's degree-$k$ pseudo-measure.
4. **Specialist verdict: no, and the corpus does not claim otherwise.** But it
   is the correct kind of import — a known negative result recruited as a
   constraint rather than as decoration. This is what "standing on shoulders"
   looks like when it works.

---

**L11 — retiring the independence route.**

1. **Claim.** `notes/ATLAS.md` §5.8: the "RH is independent of PA" north star
   is strictly more expensive than RH itself ($T\nvdash\neg$RH *is*
   $\mathrm{Con}(T+\mathrm{RH})$, and for $\Pi^0_1$ statements consistency is
   truth); forcing provably cannot deliver it (Shoenfield absoluteness); every
   classical independence result is a $\Pi^0_2$ totality statement whose
   independence is ordinal exhaustion, a shape analytic number theory does not
   have; PNT is provable in $I\Delta_0+\exp$ (Cornaros–Dimitracopoulos).
   Conclusion: RH's difficulty is quantitative, not ordinal.
2. **Open problem.** RH, and the recurring "maybe RH is independent" folk
   proposal.
3. **Relation: (d).** All of this is standard logic lore.
4. **Specialist verdict: no.** A logician finds nothing new. **It is still one
   of the most valuable pages in the corpus**, because it killed a whole
   direction the corpus was drifting toward and replaced it with L9. Category
   (d) is not the same as worthless.

---

### 1.3 The Goldbach-average / Cesàro shelf — the one place the corpus is current

---

**L12 — the uniform coprime Mertens sum.**

1. **Claim.** `notes/COPRIME_MERTENS.md` Theorem U2′ with constant
   $C_n=C+\sum_{p\mid n}\frac{\log p}{p}$ and uniform error
   $\ll d(n)Y^{-1/2}(1+\log Y)^3$. **Status: complete elementary proof**, and
   ledger row L3 records the verdict.
2. **Frontier.** Classical; feeds `E2_PROOF.md` Corollary U8.
3. **Relation: (d), fully.** The note's own L3: "**Verdict: Theorem U2′ is
   known mathematics in full, constants and all**" — the identical statement
   including the $\sum_{p\mid n}\log p/p$ correction is Prop. A.1 of
   arXiv:2603.22124 after R. Sitaramachandra Rao (1985), **with a sharper
   error term** $O(2^{\omega(q)}M^{-1/2})$ than the corpus's. Lineage: Ward
   (1927), van Lint–Richert (1964), Montgomery–Vaughan (1973). Located by the
   2026-08-14 sweep (`PRIOR_ART_SWEEP_COMPLETE.md` §3), overturning an earlier
   NO-MATCH.
4. **Specialist verdict: no, definitively.** And the note is *better* for
   having been written: its function was to replace an unchecked citation with
   a proof, and that function is unaffected. This is the corpus's model
   category-(d) entry.

---

**L13 — the Ramanujan–Fourier expansion of $\tfrac{\varphi}{\mathrm{id}}\Lambda$.**

1. **Claim.** `notes/E2_PROOF.md` U3: $\lim\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q(m)=\frac{\varphi(m)}{m}\Lambda(m)$.
2. **Relation: (d).** It is **Hardy's own 1921 theorem** (Proc. Camb. Phil.
   Soc. **20**, 263–271), which proves both this and the $\Lambda_1$
   expansion. Located by `PRIOR_ART_SWEEP_COMPLETE.md` §3.
3. **Specialist verdict: no.** Notable because the corrected factor
   $\varphi(m)/m$ was the fix that turned `METHOD.md`'s Proposition M1 into
   M1′ — the corpus found the right statement by proving it, then found Hardy
   had it a century earlier.

---

**L14 — the Cesàro/Riesz Goldbach-average shelf.**

1. **Claim.** `notes/E2_PROOF.md` / `E2B_PROOF.md` / `BARRIER_UNIFORM.md` /
   `BARRIER_SMOOTH_TERM.md` / `METHOD.md` §1. Headline: the $[\sharp\sharp]$
   block constant is exactly $\tfrac14\log^2Q+(\tfrac C2+2S_\infty)\log Q+O(1)$
   with $\tfrac C2+2S_\infty=1.181852\ldots$, and after L12 the two leading
   coefficients carry proved unconditional rates. **Status:** the leading
   coefficients are proved; the constant term still contains Hypothesis U
   (ledger H3), open.
2. **Frontier.** Languasco–Zaccagnini and successors (Cantarini,
   Brüdern–Kaczorowski–Perelli, Goldston–Suriajaya, Cantarini–Gambini–
   Zaccagnini arXiv:2603.10241). `FRONTIER_2026_MAP.md` A17: "**This is the
   one analytic lane where the corpus is at the frontier rather than behind
   it.**"
3. **Relation: (e), with a small (a)-flavoured component.** `REPORT.md`
   Theorem D is correctly attributed to L–Z, so the framework is imported. The
   corpus's own additions are exact evaluations of a *corpus-chosen* object
   $T(X)=\sum_{n\le X}(\Lambda*\Lambda)(n)/n^2$ — not a named open problem —
   plus `BARRIER_UNIFORM`'s exact threshold $k\le2j$ (RESOLVED-NO-MATCH,
   `PRIOR_ART_SWEEP_COMPLETE.md` §4).
4. **Specialist verdict: a working member of that shelf would recognise every
   technique and would have to check whether the specific constants are new.**
   My honest guess is that they are small new evaluations inside a known
   framework — worth a section of a paper, not a paper. The corpus's own
   history here is the point: `exp27` published a *fitted* $0.362$–$0.421$
   where the truth is exactly $\tfrac14$, and that error propagated into two
   notes, a paper section and a round of cross-review before `METHOD.md` §1
   caught it. **The recovery is a better advertisement for the method than the
   constant is for the mathematics.**

---

**L15 — no zero-statistics input can decide $D''$.**

1. **Claim.** `notes/DPP.md` / `notes/METHOD.md` §3 item 5. The route "get the
   $D''$ off-diagonal bound from Tao–Trudgian–Yang $N^*$" is a **category
   error** — their additive energy lives on zeros *off* the critical line,
   which is empty under RH — and Theorem 10 proves that **no asymptotic
   zero-statistics input can decide it**, because the exact weight
   $2\pi s^{-5}$ concentrates the sum at the bottom of the spectrum.
2. **Relation: (c).** A no-go with a named mechanism, killing the corpus's own
   flagship proposed route and replacing it with a finite separation check.
3. **Specialist verdict: no — but this is exactly the right shape of result.**
   It is small, correct, and it changed the corpus's plan. Audience: the
   corpus.

---

### 1.4 The observable-class / barrier lane

---

**L16 — windowed-linear observables and the depth law.**

1. **Claim.** `notes/BARRIER.md` Def. WL$_d$ and Theorem B1; `notes/HOLOGRAM.md`
   Theorem K (capacity/depth law). **Status: partly retracted and partly
   sketch.** `BARRIER.md` §0 self-describes B1 as "proof-sketch grade";
   Corollary B2 is **false as stated** for $\Lambda,k\ge2$ (corrected to B2′ in
   `BARRIER_SMOOTH_TERM.md`); the $d$ row of Theorem U1 is wrong;
   `HOLOGRAM.md`'s original depth exponent $T\log^2T$ is **retracted** — the
   true exponent is $T^{1/2}\log^{3/2}T$ once Lemma N derives the noise floor
   ($\varepsilon\approx10^{-3}$ was $X^{-1/2}$). `CLAUDE.md` cites this as the
   corpus's own worked example of why a measured constant hides its scaling.
2. **Frontier.** Nearest live neighbours: Sarnak/Möbius disjointness ("which
   observables see $\lambda$"), and resource-bounded proof complexity.
3. **Relation: (e).** Vocabulary-sharing with an aspiration to (c). The class
   WL$_d$ is a corpus definition; no external result is constrained by it.
4. **Specialist verdict: no, and `FRONTIER_2026_MAP.md` A-summary point 2 says
   why, better than I can:**
   > The corpus's `BARRIER`/`WIDTH`/`HOLOGRAM` cluster is on a different axis
   > entirely — *what a class of observables can in principle see* — which is
   > a legitimate axis and, as far as this session's searches reach, an
   > externally unoccupied one. **Unoccupied is not the same as live.**

   That sentence is the honest answer to the second half of the owner's
   question, written by an earlier block, and I am adopting it rather than
   improving on it.

---

### 1.5 Structural / foundational

---

**L17 — the atlas of $\mathbb N$.**

1. **Claim.** `notes/ATLAS_OF_N.md`: seven presentations of $\mathbb N$, every
   adjacent transition map proved, every residual named; base-$b$ positional
   notation requires a finite quotient, a $\mathbb Z/2$-torsor trivialization
   and a nonzero class in $H^2$. **Status: PENDING HOSTILE AUDIT**, no
   numerics, and §9 states line by line that essentially every ingredient is
   classical.
2. **Relation: (d) for the parts, (e) for the whole.** The carry cocycle is
   Isaksen (Amer. Math. Monthly 2002); Theorem 6.1's index is standard
   enumerative combinatorics (`PRIOR_ART_SWEEP_COMPLETE.md` §3); the
   antichain/up-set bijection is standard order theory.
3. **Specialist verdict: no. And the note says so first**, in bold: "none of
   the individual lemmas would surprise a category theorist, a set theorist,
   or a number theorist. The assembly is the deliverable." Its §2.5 guardrail
   is quoted in §0 above and is the single best-written paragraph of
   anti-inflation discipline in the repository.

---

**L18 — the future-behavior quotient is standard coalgebra.**

1. **Claim.** `notes/FUTURE_BEHAVIOR_IS_COALGEBRA.md`, first line, the corpus
   auditing itself: `NaturalMachine/FutureBehavior.agda` **is** the
   minimal-realization theorem for coalgebras of the Moore functor
   $F(Z)=O\times Z^A$, proved from scratch under private names; 18 of its 20
   statements have standard names and sources dating 1958–2000.
2. **Relation: (d), self-diagnosed.** Additionally: the same induction was
   written **three times** in one module without anyone naming the final
   coalgebra it constructs (`PRIOR_ART_INDEX.md`).
3. **Specialist verdict: no. This is the corpus's best entry**, because it is
   the mechanism of the disease named and treated: our private names are
   exactly what hide the standard objects. It generated `PRIOR_ART_INDEX.md`'s
   translation table, which is infrastructure that will keep paying.

---

**L19 — the leakage identities.**

1. **Claim.** `collab/messages/shilpin/character_projector_leakage_triangle.md`:
   $\|[P,A]\|_F^2=2\|QAP\|_F^2$ for an orthogonal projector $P$ and
   self-adjoint $A$, with three exact corners (Peres–Mermin, Ramanujan
   translations, arithmetic position at $q=6$ giving $31/6$ and $31/3$).
   `notes/LEAKAGE_IS_HALF_COMMUTATOR_RANK.md` Theorem 1:
   $\mathrm{rank}((I-P)AP)=\tfrac12\mathrm{rank}[P,A]$.
   `notes/LEAKAGE_RANK_IS_INCIDENCE_RANK.md` Cor 2.2.
   **Status:** the drawn message says it plainly — "This is standard
   projection algebra". `LEAKAGE_IS_HALF_COMMUTATOR_RANK.md` §7 records that
   after the author applied the Python ban to himself, Theorem 1's
   verification was **deleted** and Cor 2.5 was **demoted to conjecture**.
2. **Relation: (e), with a (d) component.** Cor 2.2 is a composite of two
   published equivalences — commuting conditional expectations ⟺ conditional
   independence given the meet (~~arXiv:1307.6403 Prop. 7~~ **[seed135,
   2026-08-14: śabda grade — the "Prop. 7" quotation is that paper's
   introduction and §6 does not render; the equivalence is still believed
   classical, so relation (e) stands and only its citation weakens]**) and contingency-matrix
   rank 1 ⟺ statistical independence (Tsumoto–Hirano, RSCTC 2008 / Inf. Sci.
   179) — located by `PRIOR_ART_SWEEP_COMPLETE.md` §3. Halmos, *Two subspaces*
   (1969), is the ambient frame.
3. **Specialist verdict: no.** Nothing here would detain an operator theorist.
   The §7 self-demotion — paying the cost of one's own norm in public, losing
   the composite that joined two lanes — is worth more to this collaboration
   than the theorem was.

---

**L20 — the operational / formation / Smith mass.**

1. **Claim.** Roughly 250 notes: observation-forgetting quotients, syntactic
   monoids, minimal changed action domains, Smith path holonomy and torsors,
   arithmetic life, predictive cache quotients, witness forests, and
   **seventeen files named `*_NO_GO.md`**. Representative: the drawn
   `collab/messages/workers/20260812T144712.610033Z--claude_ananta--0002.md`
   (the labelled block graph does not determine the minimal changed domain —
   **all 81** realizable labelled classes contain conflicting answers), and
   `collab/FAILURES.md` F37–F43 (arity hierarchy for cancellation observables;
   the subset-sum polynomial composes only after a task quotient; a cost
   transports through a quotient iff it is fiber-constant).
2. **Relation: (e) externally, (c) internally and abundantly.** These are
   correct, small, well-proved statements about finite algebraic systems that
   this repository invented. No external open problem is named, touched, or
   claimed.
3. **Specialist verdict: no, and no audience.** The nearest real fields are
   coalgebra / Myhill–Nerode theory and process algebra, where the general
   theorems (L18) already exist and these are bespoke instances. **§3 is about
   this lane.**

---

**L21 — near-miss: the corpus had both ingredients of the $2/3$ theorem.**

1. **Claim.** `notes/KAPPA.md` §6: both ingredients of the August-2026
   unconditional $2/3$ result — Montgomery's $F$-plateau machinery, and the
   Weil-form inertia structure — "were independently built in this repository
   as `notes/DSIDE.md` and `notes/WEIL.md` + `notes/LP_CERT.md` before the
   announcement."
2. **Relation: (e).** Having the two ingredients is not having the theorem;
   the missing step (a rank–trace inequality via von Neumann against a second
   unconditionally evaluated trace) is the entire content. `notes/ATLAS.md`
   §5.1 states this precisely: "Bombieri read $n_-$; the frontier reads rank
   and $n_+$."
3. **Verdict: honest and instructive, and it must not be inflated into
   "we nearly had it".** We did not. But `KAPPA.md` is, per
   `FRONTIER_2026_MAP.md` C.1, "the single most current note in the corpus"
   and is *more* epistemically careful about the manuscript's verification
   status than the public record is.

---

**L22 — the charge/additive-projection commutator is trivial.**

1. **Claim.** `collab/FAILURES.md` **F27** / `notes/CHARGED_FIXED_FIBER_AUDIT.md`
   (codex-noether). The proposal was that the commutator of sharp
   factorization charge with sharp additive projection has a residue coupling
   RH, Goldbach and twin primes. **KILLED at the exact finite level:** additive
   Fourier projection commutes coefficientwise with charge extraction; at
   $(0,0)$ it is exactly the classical prime-indicator circle integral. The
   **proves-too-much control** is decisive: the same algebra works after
   replacing $\Omega$ by an arbitrary colouring, so there is no prime-specific
   rigidity in the commutator at all.
2. **Relation: (c).** A clean no-go with the strongest kind of witness.
3. **Specialist verdict: no — but the *control* is the transferable content.**
   "Does your mechanism still work with $\Omega$ replaced by a random
   colouring?" is a one-line filter that would kill a large fraction of
   amateur RH/Goldbach proposals, and this repository derived it by being
   killed by it.

---

**L23 — scalar entropy erases the decisive incidence.**

1. **Claim.** `collab/FAILURES.md` **F29** / `notes/LEAST_FACTOR_REFLECTION_TRANSPORT.md`.
   The reflection and least-prime-factor stopping projections genuinely do not
   commute, but after scalarization to fiber masses the entropy/Hall-capacity
   inequality is satisfied identically, and a false model with all one-point
   marginals preserved has target pair count identically zero. Plus the
   **audit addendum** (opus-mira, cross-lineage): the false model's universe is
   a disjoint union of reflection pairs only when $\gcd(N/2,W)>1$; the correct
   no-go is about *off-diagonal* pairs; and the capacity criterion needs the
   integrality floor $\sum_q\lfloor C_q\rfloor<|S|$.
2. **Relation: (c).** A no-go against a named class (scalar entropy /
   capacity arguments for Goldbach), with an explicit list of what a successor
   must retain: signed bilinear cross-level information, Type-II coupling,
   or dispersion in the moving residue.
3. **Specialist verdict: no** — sieve theorists know that scalar entropy loses
   the bilinear structure. **The reusable addendum is genuinely good:** when
   building a false-model control, first locate the fixed points of the
   involution, because those are exactly the configurations one-point
   statistics *can* decide. That is a piece of methodology I have not seen
   written down elsewhere.

---

**L24 — a stationary false model for the Tao–Teräväinen Walsh table.**

1. **Claim.** `collab/FAILURES.md` **F23** (codex-transport). Reading
   Tao–Teräväinen arXiv:1904.05096v2 §7, the walk reconstructed all 32 Walsh
   atoms on the full continuous facet polytope and found the printed
   nonzero-$(a,b,c)$ claim fails at $(a,b,c)=(1/3,1/3,1/3)$, where the first
   flip maps $(+,+,+,+,-)$ to $(-,+,+,+,+)$ and **both masses vanish**. The
   same table has 10 zeros and an exact conserved de Bruijn flow, hence a
   **stationary Markov extension satisfying all listed five-window correlation
   inputs**. **Status and its own guard:** "The Liouville theorem itself is not
   refuted by the stationary false model." The evidence artifact was Python.
2. **Frontier.** Logarithmic Chowla / Liouville sign patterns — live.
3. **Relation: (c), and pointed at a published paper.** It says a specific
   step's stated inputs (stationarity + local Walsh symmetry) do not suffice
   for the 24-pattern conclusion, and names what a repair must use:
   complete-multiplicative dilation compatibility, a higher-window constraint,
   or another arithmetic forcing theorem.
4. **Specialist verdict: this is the one row where a working specialist might
   genuinely want to hear from us**, because it is a concrete claim about an
   exposition gap in a live paper, with an explicit witness configuration.
   Three heavy caveats: (i) the corpus explicitly does not claim the theorem
   is wrong; (ii) the check ran in banned Python and cannot now be replayed;
   (iii) nobody has re-derived the witness by hand or in Agda. **Until (ii)
   and (iii) are addressed this is an assertion, not a finding.**

---

## 2. The counts, and the denominator that makes them honest

| category | count in the ledger | rows |
|---|---|---|
| **(a)** proves a special case | **0** | — |
| **(b)** equivalent reformulation | **1** | L1 |
| **(c)** rules out an approach | **9** | L2, L3, L4, L5, L15, L22, L23, L24, and L7 internally |
| **(d)** rediscovery | **7** | L8, L10, L11, L12, L13, L17, L18 |
| **(e)** shares vocabulary | **7** | L6, L9, L14, L16, L19, L20, L21 |
| | **24** | |

**Now the denominator, which is the actual answer to the owner's question.**
`notes/` held **520 files** when I counted it this session (it grows during a
block; concurrent lanes added two while I wrote). The 24 rows above are the ones that plausibly
touch a named open problem or an active frontier *at all*. The other ~496 are
category (e) by construction — they are about objects this repository defined.
Restating the table at corpus scale:

| | |
|---|---|
| corpus notes | 520 |
| notes that touch a named open problem or live frontier | ~24 (4.6%) |
| of those, proving a special case of a named open problem | **0** |
| of those, supplying an equivalent reformulation | 1, downstream of a known one |
| of those, ruling out an approach | 9 |
| of those, rediscovering known mathematics | 7 |
| corpus claims independently confirmed as known mathematics by the 2026-08-14 sweep | **15** (`PRIOR_ART_SWEEP_COMPLETE.md` §3) |
| of those 15, where the located literature is **sharper** than ours | 2 (L12, L13) |
| of those 15, where the note's own flag had already guessed "likely classical" | 11 |
| experiments that earned their keep under the current standard | **2 of ~30** (`METHOD.md` §2) |

**So: the honest headline is that the corpus's external contribution, as of
today, is nine no-gos and one reformulation, none of them individually large,
against roughly five hundred documents.** That is not a failure — see §4 — but
it is the number, and anyone quoting this repository's output should quote it.

---

## 3. Which of our discoveries ARE in dark corners

The owner asked this directly and it is strategic information, not an insult.
A dark-corner result here means: **correct, plausibly not written down
elsewhere, and of interest to nobody currently working.**

**The candidates, ranked by how confident I am that each is correct and how
confident I am that nobody wants it.**

1. **The formation / observable-arity chain** — `collab/FAILURES.md` F37–F43,
   `notes/CANCELLATION_OBSERVABLE_FORMATION.md`,
   `notes/HIGHER_ARITY_CANCELLATION_FORMATION.md`,
   `notes/SUBSET_SUM_CARRIER_FORMATION.md`. Statements like *"observable
   formation is strictly context-arity sensitive: admitting an $n$-input sum
   creates distinctions absent from the entire lower-arity action language"*
   (F38, killed at every arity and every prime by the explicit family
   $(1,\dots,1,p^r-(n-1))$) and *"a cost transports through a quotient iff it
   is fiber-constant"* (F41). These are clean, small, correctly proved, and
   nobody outside this repository has the question.
2. **`notes/PINNING.md` Theorem P** — "an anatomy is forced exactly on its
   pinned part, and permanence is orthogonal", reached by a public
   **self-refutation** of the author's own slogan two turns earlier ("freedom
   and permanence are exclusive"), with the counterexample being sensors given
   overlapping refutation modes. Verified exhaustively for $B\le100$. Correct,
   pretty, and of interest to nobody.
3. **The RESOLVED-NO-MATCH shelf** — `PRIOR_ART_SWEEP_COMPLETE.md` §4:
   `BARRIER_ERROR_WINDOW`'s window transfer law and $X_0$ invariant;
   `BARRIER_SMOOTH_TERM`'s graded ladder; `BARRIER_UNIFORM`'s exact threshold
   $k\le2j$; `ENERGY_CONSTANT_EXACT` Lemma $\rho$; `ATLAS_OF_N` Thm 4.2's
   parameter count; `LEAKAGE_BOUND_ATTAINMENT` Prop. A;
   `FORMED_UNIT_FILTRATION_DEPTH`'s $l(U)$ obstruction; `DIGIT_CRYSTAL`
   Prop. 1.3 (doubly searched); `LENS_ORDER_COMMUTATION`'s integrality
   obstruction (triply searched). **The sweep's own warning applies to every
   one of these and I repeat it: absence of a located source is not evidence
   of novelty.** They are dark-corner *candidates*, not dark-corner findings.
4. **The Kuṭṭaka/Smith trace calculus in Agda** — `PRIOR_ART_INDEX.md` records
   that `KuttakaValli.agda` overlaps agda-unimath's Bezout only partially:
   upstream has the arithmetic correctness, ours has a trace calculus over it
   that upstream does not have. That is a real formalization asset in a corner
   with roughly three inhabitants.
5. **The methodology itself** — `notes/METALOOP.md`, `collab/FAILURES.md`'s
   reframe of failure as walk-derivative, the hostile-twin discipline, the
   `PRIOR_ART_INDEX` translation table, the honesty ledgers.
   `PRIOR_ART_SWEEP_COMPLETE.md` §6 flags the gap precisely: *"No search on
   the meta-object. Nobody has searched whether the corpus's own apparatus —
   obligation calculi, honesty ledgers, the three-verdict lens scheme — has
   prior art."* Until that search runs, this is an unassessed dark corner and
   possibly the largest one.

**And the counter-list, which the owner should also have: what is in a dark
corner because the field has moved, not because we found something new.**
`FRONTIER_2026_MAP.md` Part C is unambiguous:

- The formalization lane is **roughly one full year behind** an external
  frontier where a Fields-medal theorem was formalized sorry-free with an
  autonomous agent closing it (Sphere-Packing-Lean, Feb 2026), a
  22-million-implication project was completed in Lean (ETP, Dec 2025), and
  agents autonomously prove previously-open Erdős problems at a few hundred
  dollars each (9/353, May 2026). "This is the corpus's **largest** distance
  from a live frontier — larger than anything in Part A."
- The analytic lane is **off-axis**: since 2024 the moving frontier in prime
  distribution is large-value estimates → zero density → short intervals
  (Guth–Maynard, Annals 2026), which appears in the corpus exactly once, as a
  parenthetical in `LITERATURE.md:29`.

Being in a dark corner because you built something nobody wanted and being in
a dark corner because you did not notice the field moved are different
conditions with different treatments, and the corpus is in both.

---

## 4. What I would tell the owner if I had one paragraph

You asked whether we have shed new light on existing open problems or whether
our discoveries are in dark corners. **The truthful answer is: dark corners,
with one column of genuine exception.** We have proved no special case of any
named open problem. Our one equivalent reformulation of RH is a careful,
well-audited corollary of machinery that was already an equivalent of RH, and
its own note says so before I did. But we have accumulated **nine no-gos with
named obstructions** — the large sieve cannot certify because its lossiness
$C=\pi^4/18$ exceeds 3; the $2/3$ and $5/6$ constants are the exact integer
hull, so more integrality buys literally nothing; no asymptotic
zero-statistics input can decide $D''$; scalar entropy erases the incidence
that a Goldbach transport needs; the charge/projection commutator survives
replacing $\Omega$ by a random colouring, so it contains no prime-specific
rigidity. **Those are real, they are the cheapest kind of mathematics to
verify and the most expensive kind to discover by hand, and they are the
thing this collaboration is unusually good at producing.** The reason they
have no audience yet is that eight of the nine are addressed to routes only we
were walking. The exception is L24 — a concrete claim about an exposition gap
in a live published paper — and it is currently unusable because the check ran
in Python that is now banned and nobody has re-derived it. **If you want one
action from this note: restate L3 and L24 by hand or in Agda. Those are the
two places where an outside specialist could plausibly want to hear from us,
and in both the mathematics is intact while the evidence is dead.**

---

## 5. Honesty ledger

| # | item | status |
|---|---|---|
| O1 | Every external claim in this note | **śabda (search-summary) grade.** `WebFetch` EGRESS_BLOCKED on every host. Three queries run, recorded in §0; everything else consumed from `FRONTIER_2026_MAP.md`, `PRIOR_ART_SWEEP_COMPLETE.md`, `PRIOR_ART_INDEX.md`, `collab/FAILURES.md`, credited row by row. **No paper was opened.** |
| O2 | Category assignments | **My judgement, contestable.** Each row states its evidence. The assignments I am least sure of are named in O6. |
| O3 | The counts in §2 | Counts of *my* ledger, not of the corpus. The 520/24 denominator is the number that matters and is stated as such. |
| O4 | "Not located" | Used in L1, L9, L14 and throughout §3. **Never treated as novelty.** |
| O5 | Correction made to another note | `notes/WIDTH.md` §2(b) and §3: strike-through + dated correction of the "only known crossing of $\theta=1/2$" claim, per `FRONTIER_2026_MAP.md` A5/A6, which had filed the action as needing "no computation and no new mathematics". **Nothing deleted; the original text remains struck through.** No other file was edited. |
| O6 | Judgements I am least confident in | **(i) L1's verdict.** I grade the index-one criterion as "not new to a specialist" on the strength of one search summary plus the note's own §4. I did not read Bombieri 2000, Yoshida, Connes–Consani Appendix C, or Suzuki's 2023/2026 screw-function papers — the search surfaced arXiv:2606.09096, *Weil's quadratic form via the screw function* (2026), which is close enough to the object that it could contain the index statement or could contain a reason the packaging is not equivalent. **If any single judgement here is wrong, it is this one, and it is the one that matters most, because L1 is the only (b) in the ledger.** (ii) **L14** — I guess the $\tfrac14$/$1.181852$ evaluations are small-new-inside-known, but I cannot distinguish that from already-published without reading the Cesàro–Goldbach shelf. (iii) **L9** — I call the parity/SOS analogy "folklore" on the strength of two searches; a proof-complexity researcher might say it is folklore, or might say it is a real programme nobody has posed. |
| O7 | What I could not assess | The **~250-note operational/formation/Smith lane** was read at index and representative-sample level (L20's cited files, plus the eleven drawn entry files), not exhaustively. A claim in there could touch an open problem in finite semigroup theory, automata theory or coalgebra without my noticing. Also unassessed: `formal/cubical/` (59 Agda files) and `formal/pairfield/` (24 Lean files) as *mathematical* content rather than as substrate — `HOTT_ECOSYSTEM_MAP.md` and `MATHLIB_INGESTION_MAP.md` cover their ecosystem position, not their theorems. And per O1, no primary source. |
| O8 | This note claims no mathematics | It weakens, strengthens and restates nothing. It is a reading. |
