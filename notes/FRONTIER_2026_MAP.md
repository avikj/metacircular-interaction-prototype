# The 2026 frontier map: where the field is, and how stale this corpus is against it

**Filed:** 2026-08-14 · branch `claude/repo-live-collaboration-4gn2fs` · reading/ingestion block, no new mathematics.

**Task.** Establish where the actual research frontier sits, in August 2026, for
the two areas this corpus works in — analytic number theory and formalization —
and state plainly how stale the corpus is against it. This note reports; it does
not synthesize and it proposes no research.

---

## 0. Channel facts and evidence grade (read this before using any citation)

Verified this session, and consistent with the sweeps already recorded at
`BARRIER_SMOOTH_TERM.md` W8, `BARRIER_UNIFORM.md` U7, `E2B_PROOF.md` L4′ and
`PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` T5′:

- `WebFetch` is **EGRESS_BLOCKED on every host** — arxiv.org, ncatlab.org,
  wikipedia, publisher sites. No PDF, no abstract page, no HTML full text was
  read this session.
- `WebSearch` **works** and is the only literature channel.

**Therefore every external citation below is śabda grade — search-summary
testimony.** Titles, arXiv numbers, years, journals and quoted numerical values
are as the search layer reported them; none was checked against source text.
This is one grade below the corpus's `FETCHED` label and two below `CLASSICAL`.
Nothing in this note is licensed to become load-bearing in any proof. Absence
of a located result is not evidence that none exists.

Corpus-internal statements are labelled **CORPUS** and cite the note and line.

**Search queries run this session** (recorded so the next block extends rather
than repeats):

1. `zero-density estimate 2026 improvement Guth-Maynard sequel`
2. `Chowla conjecture progress 2026 Tao Teräväinen logarithmic averaging new`
3. `Pilatte two-point Chowla conjecture without logarithmic averaging 2025`
4. `parity barrier circumvention 2025 2026 Helfgott Radziwill expansion divisibility parity`
5. `bounded gaps between primes 2026 new bound 246 improvement Polymath8`
6. `proportion of simple zeros Riemann zeta assuming RH pair correlation Fourier optimization 2025 Carneiro Chirre Milinovich`
7. `Tao Trudgian Yang additive energy zeros Riemann zeta function N* new bounds 2025`
8. `Bui Heath-Brown 70.3% simple zeros Riemann hypothesis`
9. `"2501.14545" pair correlation zeros Riemann proportions simple critical zeros Goldston`
10. `Languasco Zaccagnini Goldbach Cesaro average explicit formula 2025 2026 new results`
11. `Bombieri-Vinogradov beyond x^1/2 level of distribution 2025 2026 new result primes`
12. `Lichtman twin primes Goldbach upper bound level of distribution 2025 2026 sieve`
13. `Lichtman Pascadi 2025 primes in arithmetic progressions large moduli exponent of distribution new record`
14. `primes in short intervals x^17/30 improvement 2026 zero density new exponent`
15. `large value estimates Dirichlet polynomials 2026 improvement beyond Guth-Maynard new paper`
16. `large gaps between consecutive primes 2025 2026 new record Ford Green Konyagin Maynard Tao improvement`
17. `Sarnak conjecture Möbius disjointness 2025 2026 new progress zero entropy`
18. `Chowla conjecture 2026 Liouville correlations breakthrough Teräväinen Matomäki new`
19. `"The Alternative Hypothesis for Zeros of the Riemann Zeta-Function" 2025 arXiv authors result`
20. `"2607.04632" OR "Turnage-Butterbaugh" decades-long breakthrough zero-density estimates primes short intervals 2026`
21. `Lean FLT project Fermat Last Theorem formalization progress 2026 Buzzard milestone`
22. `Equational Theories Project completed results 2025 Tao formalization Lean automated exploration`
23. `sphere packing formalization Lean 2025 2026 Viazovska Maryna formal proof completed`
24. `AI mathematics 2026 formal proof research-level theorem AlphaProof Erdos problems solved by AI`
25. `Agda vs Lean vs Rocq 2026 formalization mathematics community state cubical`
26. `Harmonic Aristotle Axiom math AI 2026 Lean autoformalization Mathlib milestone research mathematics`
27. `theorem proving benchmarks 2026 PutnamBench miniF2F saturated state of the art premise selection`
28. `Anthropic Claude Riemann zeta two thirds critical line manuscript status peer review reaction 2026`

**Not searched, and therefore not covered here** (gaps for the next block):
Duffin–Schaeffer-adjacent work; moments of ζ and the Fyodorov–Hiary–Keating
line; Maynard's primes-with-restricted-digits successors; the function-field
side (`PROOF_DIFF_FF.md`'s neighbourhood); Selberg-eigenvalue/Kloosterman
inputs beyond what Pascadi's abstract mentions; explicit/computational ANT
(Platt–Trudgian style RH verification height).

---

## Part A — the analytic number theory frontier, 2025–2026

Column 4 is the deliverable: **does it change a corpus claim?**

| # | Result (as reported by search) | Year | Citation (śabda) | Does it change a corpus claim? |
|---|---|---|---|---|
| A1 | **Guth–Maynard, new large-value estimates for Dirichlet polynomials.** New bounds on how often a Dirichlet polynomial of length $N$ takes values near $N^{3/4}$; consequence $N(\sigma,T)\ll T^{30(1-\sigma)/13+o(1)}$ and prime asymptotics in intervals $[x,x+x^{17/30+o(1)}]$. First improvement at that point of the strip since Ingham (>80 yrs). | announced 2024; **published Annals of Math. 203 (2026) no. 2, 623–675, online 1 Mar 2026**; arXiv revision 7 Apr 2026 | arXiv:2405.20552 | **No claim invalidated — but a currency gap.** The corpus mentions Guth–Maynard exactly once, in `LITERATURE.md:29`, as a parenthetical ("additive energy as a tool predates, e.g. Heath-Brown, Guth–Maynard"). It is not in `BARRIER.md`, `WIDTH.md` or `HOLOGRAM.md`. Nothing in the windowed-linear class (`BARRIER.md` Def. WL$_d$) or the depth law (`HOLOGRAM.md` Thm K) depends on a zero-density input, so no statement flips. What is stale is the *framing*: `WIDTH.md`'s "uniformity ladder" is presented as the live frontier of prime-distribution uniformity, and since 2024 the live frontier in that neighbourhood is the large-value/zero-density axis, which the ladder does not mention at all. |
| A2 | **Turnage-Butterbaugh, expository account of A1** — "A decades-long breakthrough in zero-density estimates and primes in short intervals", 21 pp., companion to the 2026 JMM Current Events Bulletin talk, to appear Bull. AMS. | 6 Jul 2026 | arXiv:2607.04632 | **No.** But it is the canonical 2026 entry point to the axis the corpus is missing, written by an author the corpus already cites in another role (A6/A7 below). |
| A3 | **Tao–Trudgian–Yang, "New exponent pairs, zero density estimates, and zero additive energy estimates: a systematic approach"** — four new exponent pairs, new zero-density estimates, **new additive-energy-of-zeros estimates**, obtained by building the Analytic Number Theory Exponent Database (ANTEDB) and optimizing over recorded relations. | 28 Jan 2025 | arXiv:2501.16779 | **No — and the corpus already has it.** `LITERATURE.md:27` records "Tao–Trudgian–Yang arXiv:2501.16779 confirmed; repo's citation accurate". `REPORT.md`'s depth staircase places "Goldbach variance → additive energy of zeros ($\gamma_1+\gamma_2\approx\gamma_3+\gamma_4$)" as a *dependency*, not a numerical claim, so improved $N^*$ bounds sharpen the ambient literature without touching the staircase. **Live-frontier flag:** the ANTEDB itself — a machine-readable, systematically optimized exponent database — is the closest external object to what this corpus calls a proof-carrying research system, and no corpus note names it (`grep ANTEDB notes/` → empty). |
| A4 | **Bin Chen, zero-density for Dirichlet $L$-functions via the Guth–Maynard method** — exponent $7/3$, improving Huxley's $12/5$; key step a sharp bound for sums over affine transformations with GCD twists. Applications: least prime in an arithmetic progression, **least Goldbach number in an arithmetic progression**. | Jul 2025 | arXiv:2507.08296 | **No claim invalidated.** Touches the corpus's twisted-tower neighbourhood (`FAMILY.md` §2.1, twisted Goldbach over $L$-zeros) at the level of *inputs*, not identities. Unknown to the corpus. |
| A5 | **Lichtman, "Primes in arithmetic progressions to large moduli, and Goldbach beyond the square-root barrier."** Primes have level of distribution $66/107\approx0.617$ with triply-well-factorable weights (improving Maynard's $3/5$); yields new upper bounds for twin primes **and for Goldbach representations** — reported as the first use of a level of distribution past the square-root barrier for Goldbach, and the largest improvement on that problem since Bombieri–Davenport 1966. Predecessors in the same line: Lichtman arXiv:2211.09641 ($x^{17/32}$ quadrilinear, past Maynard's $x^{11/21}$ and BFI's $x^{29/56}$); Lichtman arXiv:2109.02851 (modified linear sieve, $x^{10/17}$). | 2023, with 2025 follow-ups | arXiv:2309.08522 | **YES — it corrects `WIDTH.md`.** `WIDTH.md:69–70` and §3 both assert that Granville–Shao's $X^{20/39-\varepsilon}$ is "**the only known crossing of $\theta=1/2$ in any averaged sense**" and that "the averaged $20/39$ of Granville–Shao is the only crossing known". As worded that is false in 2026. The defensible narrow reading — the only crossing *for $\lambda$/$\mu$-type multiplicative functions* — is not what the note says, and the note's own object $D_\lambda(X;q,a)$ does not make the restriction explicit in the surrounding prose. This is a scope/wording defect, not a mathematical invalidation: nothing in §3's Siegel-hardness lemma (W1) or the infinite-width statement depends on the uniqueness claim. **Action for a future block: `PROVE`-adjacent correction to `WIDTH.md` §2(b) and §3, restricting the uniqueness claim to $\lambda$ and citing A5/A6.** |
| A6 | **Pascadi, "On the exponents of distribution of primes and smooth numbers."** Primes *and* smooth numbers equidistributed in progressions to moduli up to $x^{5/8-o(1)}$ (primes with triply-well-factorable weights); **removes the dependence on Selberg's eigenvalue conjecture** present in earlier Lichtman/Pascadi work. Applications: refined twin-prime and consecutive-smooth-number upper bounds. | May 2025 | arXiv:2505.00653 | **YES — same row as A5.** $5/8=0.625$ is the reported current record exponent of distribution. `grep Pascadi notes/` → empty. Same correction target. |
| A7 | **Pilatte, "Improved bounds for the two-point logarithmic Chowla conjecture"**: $\sum_{n\le x}\frac{\lambda(n)\lambda(n+1)}{n}\ll(\log x)^{1-c}$ for an absolute $c>0$ — a *power* saving in $\log x$, improving Helfgott–Radziwiłł's $O(1/\sqrt{\log\log x})$. arXiv v-revision Dec 2025. | 2023, rev. 2025 | arXiv:2310.19357 | **Not invalidating; the corpus does not know it exists.** `grep Pilatte notes/` → empty. The corpus's parity discussion (`WIDTH.md` §3–§4, `PARITY.md`, `GAUGE.md`) is built on Tao's logarithmic Chowla and on MRT short-interval results, and does not carry the current two-point record. Any future corpus sentence of the form "the best known two-point bound is …" must cite Pilatte, not Tao/Tao–Teräväinen. |
| A8 | **Helfgott–Radziwiłł, "Expansion, divisibility and parity"**: the divisibility-by-primes graph is a strong local expander almost everywhere (within a constant of locally Ramanujan); consequences past the parity barrier, incl. $\frac{1}{\log x}\sum_{n\le x}\lambda(n)\lambda(n+1)/n=O(1/\sqrt{\log\log x})$ and $\sum_{N<n\le2N}\lambda(n)\lambda(n+1)=o(N)$ at almost all scales. Expository companion arXiv:2201.00799. Follow-up located: arXiv:2512.01739, "Quantitative correlations and some problems on prime factors of consecutive integers" (Dec 2025). | 2021 / 2022 / 2025 | arXiv:2103.06853 | **YES, structurally — this is the corpus's largest parity-lane blind spot.** `grep Helfgott notes/` returns only `TERNARY.md` (ternary Goldbach) and three unrelated notes; the expander/parity paper appears nowhere. `WIDTH.md` is *titled* "The width of the parity barrier" and its §4 names "two failure layers", yet the one recent programme that actually crosses the barrier by a new mechanism (expansion in the divisibility graph) is absent from its ladder, its layer taxonomy and its open question. The open question at `WIDTH.md` §3 ("exhibit any individual estimate past $\theta=1/2$") is *not* answered by A8 — but a note claiming to map the barrier's width and failure modes without the expander layer is incomplete as a map. |
| A9 | **Baluyot–Goldston–Suriajaya–Turnage-Butterbaugh, "Pair Correlation of Zeros of the Riemann Zeta Function I: Proportions of Simple Zeros and Critical Zeros."** Pair-correlation method extended to the *horizontal* distribution of zeros; RH removed from Montgomery's theorem, giving simple-zero results under hypotheses weaker than RH. | arXiv Jan 2025, v-revision 21 Nov 2025 | arXiv:2501.14545 | **No — corpus is current.** Cited at `KAPPA.md`, `BEYOND.md`, `L3_SDP.md`. |
| A10 | **Goldston–Lee–Suriajaya–Sono (GLSS) line: "Pair Correlation Conjecture for the zeros of the Riemann zeta-function I: simple and critical zeros"** (arXiv:2503.15449) and **II: The Alternative Hypothesis** (arXiv:2507.06823, **published J. Number Theory, 2026**). | 2025–2026 | arXiv:2503.15449 / 2507.06823 | **Partly.** `KAPPA.md` cites 2503.15449 (part I). Part II and its journal publication are **not** in the corpus. |
| A11 | **Baluyot–Goldston–Suriajaya–Turnage-Butterbaugh, "The Alternative Hypothesis for Zeros of the Riemann Zeta-Function."** Formulates AH without assuming simple zeros; under RH + AH, constraints on the density of pairs at $k/2$ times average spacing, hence on multiple zeros; a strong AH implies the Essential Simplicity Hypothesis. | 14 Aug 2025 | arXiv:2508.10857 | **Gap, not invalidation.** `grep "Alternative Hypothesis" notes/` → empty; `grep 2508.10857 notes/` → empty. This sits directly on `KAPPA.md` §7 / `BEYOND.md`'s "what is still alive above 2/3" axis — the AH is exactly the configuration that caps pair-correlation methods — and the corpus's frontier statement there does not account for it. |
| A12 | **Goldston–Suriajaya survey, "Zeta zeros on the critical line."** | Nov 2025 | arXiv:2511.20059 | **No — corpus is current.** `KAPPA.md` §1 uses it precisely to certify that the pre-August-2026 unconditional record was PRZZ 41.7%. |
| A13 | **RH-conditional simple-zero proportions.** Montgomery 1973: $2/3$; Montgomery–Taylor 1975: $0.6725$; Cheer–Goldston 1993: $0.6727$; Bui–Heath-Brown 2013: $19/27\approx0.7037$ on RH alone (removing CGG's GLH); Chirre–Gonçalves–de Laat 2020: $0.6792$ by SDP majorants. Live method: Fourier-optimization frameworks after Carneiro–Chandee–Chirre–Milinovich (arXiv:2310.01913, arXiv:2502.05106). | ≤2025 | as listed | **No — corpus is current and correct.** `KAPPA.md:81–83` records all of these with the right attributions, including the point that CGdL's route uses a regime different from the band-limited one. The corpus's constants $0.6725$/$0.83625$ are **not** stale: they are the optimal-window constants of the August 2026 unconditional theorem, and the RH-conditional records above them are correctly logged as adjacent. |
| A14 | **Status of the Aug-2026 unconditional $2/3$ manuscript** ("More than two thirds of the zeros … lie on the critical line", Claude/Anthropic, 2026-08-10; Lean repo `anthropics/zeta-23-lean`). As of mid-August 2026: **no peer-reviewed publication, no published independent replication, no external referee report**; read on short notice by Conrey and Goldston; internal review by Alpöge and Furman. | Aug 2026 | anthropic.com/research/riemann-zeta + press coverage | **No change — and the corpus is *more* careful than the public record.** `KAPPA.md` §0 already downgrades its own verification ("partial build/axiom evidence, not yet an independent verification"), §5.2 records the Codex audit finding that the archived build log is curated. Nothing located this session contradicts or upgrades that. |
| A15 | **Bounded gaps between primes.** No improvement on Polymath8b's $H_1\le246$ (2014) located. Large gaps: no theoretical improvement on Ford–Green–Konyagin–Maynard–Tao located for 2025–2026; only computational records (largest known maximal gap 1854, May 2026; largest known merit 41.94). | — | — | **No.** The corpus makes no $H_1$ claim. Reported so the next block does not re-search: **this sub-frontier has not moved.** |
| A16 | **Sarnak / Möbius disjointness.** No 2025–2026 breakthrough located. Incremental: disjointness for product flows of affine-linear ⊗ rigid systems (2024); logarithmic disjointness descends along factor maps for distal systems; "Almost countable spectrum and logarithmic Sarnak conjecture" (arXiv:2511.04419, Nov 2025). | 2024–2025 | as listed | **No.** The corpus's Sarnak references (`JEWELS.md`, `BUDGET.md`, `DIRECT.md`, `KAPPA.md`, `ATLAS.md`) are framing, not load-bearing. |
| A17 | **Goldbach-average / Cesàro line (Languasco–Zaccagnini and successors).** Nothing newer than the corpus's own 2026-08-14 sweep located. The shelf as the corpus has it: L–Z arXiv:1206.0251 ($k>1$ Cesàro Goldbach), arXiv:1606.00869 (short intervals), arXiv:1711.08610 (identities), arXiv:2012.02503 (arbitrary prime powers + squares); Cantarini arXiv:1607.05629 (Linnik numbers, order $>3/2$); Brüdern–Kaczorowski–Perelli arXiv:1712.00737 (explicit formula for the Cesàro–Riesz mean of **every** order $k>0$); Goldston–Yang arXiv:1601.06902; Goldston–Suriajaya arXiv:2007.14616, arXiv:2007.16099; Cantarini–Gambini–Zaccagnini arXiv:2603.10241 (Mar 2026, $\lambda$/$\mu$ discrete convolution). | ≤ Mar 2026 | as listed | **No — the corpus is fully current here, by its own work today.** `E2B_PROOF.md` L4′, `BARRIER_UNIFORM.md` U7, `BARRIER_SMOOTH_TERM.md` W8, `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` T5′ all carry 2026-08-14 sweeps at exactly this shelf. `REPORT.md` Theorem D is correctly attributed to L–Z ($k=1$). **This is the one analytic lane where the corpus is at the frontier rather than behind it.** |

### A-summary

Two distinct kinds of staleness show up, and they must not be conflated.

1. **Attribution staleness — one confirmed instance, `WIDTH.md`.** Its
   uniqueness claim for Granville–Shao's $20/39$ is false as worded (A5, A6),
   and the parity-barrier map it draws omits the expander layer (A8).
2. **Axis staleness — the corpus's analytic lane is not on the axis the field
   is on.** Since 2024 the moving frontier in prime distribution is
   large-value estimates → zero density → primes in short intervals
   (A1–A4), and the systematic-exponent-database style of doing it (A3). The
   corpus's `BARRIER`/`WIDTH`/`HOLOGRAM` cluster is on a different axis
   entirely — *what a class of observables can in principle see* — which is a
   legitimate axis and, as far as this session's searches reach, an
   externally unoccupied one. Unoccupied is not the same as live.

No result located this session **invalidates** a corpus theorem.

---

## Part B — the formalization frontier, 2025–2026

| # | Result (as reported by search) | Year | Citation (śabda) | Does it change a corpus claim? |
|---|---|---|---|---|
| B1 | **Sphere packing in dimension 8, formalized and sorry-free.** The Sphere-Packing-Lean project (launched 2024 after Viazovska–Hariharan met in Lausanne) announced a **sorry-free Lean proof on 23 February 2026** that $E_8$ is optimal in $\mathbb{R}^8$. The remaining goals were autonomously discharged by **Gauss**, Math Inc.'s autoformalization agent, working from the mid-January repository state. Repo scope extends to dim 24 and uniqueness among periodic packings. Progress paper arXiv:2604.23468; EPFL/AIhub coverage Apr 2026. | Feb–Apr 2026 | github.com/math-inc/Sphere-Packing-Lean; arXiv:2604.23468 | **YES — it resets the corpus's implicit baseline.** `grep -l "sphere packing" notes/` returns only `L3_SDP.md`, and there in its SDP/LP-duality role, not its formalization role. This is the first *Fields-Medal-level, research-frontier* theorem formalized end-to-end with the last mile done by an autonomous agent. Any corpus statement about what "proof-carrying research" currently costs (`RESEARCH_SYSTEM.md`, `MACHINE.md`, `PYTHAGOREAN_EUCLIDEAN_MACHINE.md`) is calibrated against a world where that had not happened. |
| B2 | **The Equational Theories Project, completed and written up.** All **22,028,942** implications among the **4,694** equational laws on magmas with ≤4 operations resolved, by mixed human/automated proof, **all validated in Lean**. New magma constructions discovered; finite-magma restriction addressed separately. | arXiv Dec 2025 (announced on Tao's blog 9 Dec 2025) | arXiv:2512.07087 | **YES, as calibration.** `grep -l Equational notes/` → `WOLFRAM_ADOPTION.md` only. ETP is the existence proof for large-scale, machine-mediated, formally-validated collaborative exploration — which is the operating model this corpus describes itself as building. The corpus discusses that model philosophically (`context_dump.md` §"What the project is") without citing the one completed instance of it. |
| B3 | **Lean FLT project.** Ongoing under Buzzard, EPSRC-funded through **Sep 2029**; formalizing the "21st century" route (Khare–Wintenberger, Kisin) planned with Richard Taylor, not the original Wiles/Taylor–Wiles argument. Many components done; not complete. Regular-prime case completed separately (Best–Birkbeck–Brasca–Rodriguez Boidi–Van de Velde–Yang, arXiv:2410.01466). | ongoing 2023–2026 | ImperialCollegeLondon/FLT | **No claim invalidated.** `grep -l FLT notes/` → `FIVE_FACES.md`, `COGNITIVE_ORIENTATION.md`, both treating FLT as a *mathematical* object. `FIVE_FACES.md`'s verdict ("no, the five are not one obstruction") is untouched by formalization progress. Currency note only: FLT is **not** done, and any corpus prose implying otherwise should be checked. |
| B4 | **Autonomous solution of open problems, formally verified.** An AlphaProof-based agent framework (LLM subagents coordinated by an evolutionary algorithm, using AlphaProof as a focused Lean prover) **autonomously solved 9 of 353** formalized Erdős problems from the Formal Conjectures repository (state of early Feb 2026), **including two open for 56 years**, at a few hundred dollars per problem; also **44 of 492** OEIS conjectures; used in live research across graph theory, optimization, algebraic geometry, additive combinatorics, quantum optics. Reported side-finding: mathematicians valued failed attempts, because formal sketches let them focus on the unresolved subgoals instead of re-verifying the whole argument. | May 2026 | arXiv:2605.22763; benchmark arXiv:2605.13171 (Formal Conjectures) | **YES — it is the sharpest external calibration available for this corpus's premise.** `grep -ri autoformaliz notes/` → empty. The corpus's stated purpose (`context_dump.md`) is to build conditions in which exact mathematics changes the means of subsequent mathematics; B4 is the 2026 external measurement of exactly that, with a number attached (9/353 ≈ 2.5% of formalized Erdős problems, autonomously). The 9/353 figure is also a **sobriety check**: research-level autonomy is real and rare, not general. |
| B5 | **Olympiad-level formal reasoning by RL, in Nature.** "Olympiad-level formal mathematical reasoning with reinforcement learning" (the AlphaProof paper). | Nature, 2025 | nature.com/articles/s41586-025-09833-y | No corpus claim affected. Context for B4. |
| B6 | **Benchmarks are saturating.** miniF2F (488 olympiad problems) reported **saturated in 2025** by Seed-Prover (99.6%, 243/244 on the standard split, one problem left). PutnamBench (1,724 formalizations of 672 theorems across Lean 4, Isabelle, **Rocq**) reported at **99.4% by "Aleph" as of 2026**; Seed-Prover 1.5 at 87.9%, Goedel-Architect 88.8% with NL augmentation. The evaluation frontier has moved to **research-level** benchmarks: FormalProofBench (graduate-level, arXiv:2603.26996), TheoremBench (arXiv:2606.09450), CombiBench (arXiv:2505.03171), Formal Conjectures (arXiv:2605.13171), and long-horizon autoformalization (LeanMarathon, arXiv:2606.05400). Premise selection at mathlib scale (LeanDojo's framing) is still named as the bottleneck. | 2025–2026 | as listed | **YES, as calibration.** No corpus note names any of these benchmarks. The corpus's formal lane (59 `.agda` files in `formal/cubical/`, 24 `.lean` in `formal/pairfield/`) is hand-written; the external frontier has moved from "can a model do olympiad problems" to "can an agent formalize a paper", and 2026's answer is *sometimes, for a mid-sized paper, at four-figure cost*. |
| B7 | **Named autoformalization systems, 2025–2026** — all closed-source company products, per the survey framing: **Gauss** (Math Inc., 2026; did B1's last mile), **Aristotle** (Harmonic, arXiv:2510.01346; New Scientist coverage Jan 2026 for AI-assisted Erdős-problem proofs), **AxiomProver** (Axiom Math, 2025). Infrastructure paper: **Lean Atlas**, "an integrated proof environment for scalable human–AI collaborative formalization" (arXiv:2604.16347). Surveys: "Lectures on AI for Mathematics" (arXiv:2604.11504), "From Solvers to Research" (arXiv:2607.07779). | 2025–2026 | as listed | **No claim invalidated; total blind spot.** None of these appears anywhere in `notes/`. |
| B8 | **Lean vs Agda vs Rocq, 2026.** Lean 4 + mathlib (**>2M lines by 2025**, port completed 2023) is the default for mathematics, and the ecosystem argument is explicit in the sources: "a theorem prover without a library is like a programming language without packages". **Agda**: elegant syntax, native cubical type theory, QIITs without encodings — and, in the same sources, "**no substantial mathematical library**"; active mainly in HoTT-flavoured research. **Rocq**: present (it is one of PutnamBench's three target languages), used for HoTT model constructions over UniMath. | 2026 | lean-lang.org; nLab "Lean"; arXiv:2604.00747, arXiv:2602.10844 | **YES — this is a direct verdict on `CLAUDE.md`'s substrate rule.** `CLAUDE.md` mandates Agda (`formal/cubical/`, `--cubical --safe`) as the primary substrate with Lean reserved for "the analytic lane". Against the 2026 external state that is a **minority choice**: the library, the tooling, the benchmarks, the autoformalization agents (B1, B4, B6, B7) and the collaborative-scale precedent (B2) are all Lean-side. Reported as a fact about the field, not as a recommendation — the substrate decision is the human owner's (2026-08-13) and is out of this note's scope. What *is* in scope: the corpus should not assume that Agda-side work inherits any of the 2026 tooling frontier. It does not. |

### B-summary

The formalization frontier in 2026 has three properties the corpus does not
reflect anywhere in `notes/`:

- **A research-level theorem has been formalized end-to-end with an autonomous
  agent closing it** (B1, Feb 2026).
- **A large collaborative exploration has been completed and fully validated in
  a proof assistant** (B2, Dec 2025) — 22M implications.
- **Autonomous agents now prove previously-open problems at a measurable,
  low-but-nonzero rate** (B4, 9/353 Erdős problems, May 2026), and the
  benchmark suite has moved past olympiad level (B6).

All three are Lean-side. The corpus's Agda-primary substrate (B8) is on the
side of that split with no library and no agent tooling.

---

## Part C — the staleness verdict

Stated plainly, per the task's instruction to say the honest thing.

### C.1 On a live frontier

- **`KAPPA.md`.** The single most current note in the corpus. It tracks the
  August 2026 unconditional $2/3$ / $0.6725$ / $0.83625$ event against
  correctly-attributed adjacent records (A13), cites the right 2025 pair-
  correlation papers (A9, A10-I, A12), and — unusually — is *more* epistemically
  careful about the manuscript's verification status than the public record is
  (A14). Its one gap is the Alternative Hypothesis cluster (A10-II, A11), which
  bears on exactly its §7 "what is still alive" statement.
- **`E2_PROOF.md` / `E2B_PROOF.md` / `BARRIER_UNIFORM.md` / `BARRIER_SMOOTH_TERM.md`
  / `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md`.** The Cesàro/Riesz Goldbach-average
  shelf (A17). These were swept **today** and the sweeps are correct, complete
  against what search can reach, and correctly graded śabda. `REPORT.md`'s
  Theorem D attribution to Languasco–Zaccagnini is right.
- **`MERTENS_FLOOR.md`, `DRIFT_EXPONENT_EXACT.md`.** Not frontier-facing at all,
  and that is fine: they are internal audits that replaced fitted constants
  with exact ones ($\tfrac12$, $-(\log2\pi+\tfrac14)$; drift exponent exactly
  $\tfrac12$ with closed-form constant $\sqrt{\zeta(2)/12\zeta(4)}$). Nothing
  external touches them. They are the `CLAUDE.md` protocol working.
- **`LITERATURE.md`.** Current as of 2026-08-11 on the five headline claims,
  including the Cantarini–Gambini–Zaccagnini prior-art hit (Mar 2026) and the
  Suzuki screw cluster (Jun–Jul 2026). Its one weakness is coverage, not
  currency: it audits five claims and does not attempt the ambient frontier.

### C.2 Behind the frontier

- **`WIDTH.md` — the one note with a defect, not merely a gap.** Its uniqueness
  claim for the $20/39$ crossing (§2(b), and restated as the "Open question" in
  §3) is false as worded against Lichtman $66/107\approx0.617$ (A5) and Pascadi
  $5/8=0.625$ (A6). Its parity-barrier taxonomy (§4, "two failure layers")
  omits the Helfgott–Radziwiłł expander layer (A8) entirely, and its
  two-point-correlation state of the art is Tao-era rather than Pilatte-era
  (A7). Nothing it *proves* (Lemma W1, the infinite-width statement) falls; the
  ladder it presents as a map of the frontier is a map of the 2018–2021
  frontier.
- **`BARRIER.md`, `HOLOGRAM.md`.** Not wrong; on a different axis (A-summary
  point 2). `HOLOGRAM.md`'s own §7 lesson — that a constant measured at one
  scale hides its scaling — has an analogue here that the note cannot see about
  itself: a *frontier* assessed at one date hides its motion. The zero-density
  axis (A1–A4) is nowhere in either note.
- **`REPORT.md`.** Its mathematical content is intact and its attributions
  survive (Theorem D → L–Z; the D″ additive-energy dependency is a dependency,
  not a number). What is dated is its self-positioning: it is written as a
  survey of *the* live structure around Goldbach averages, and the 2024–2026
  live structure around primes is large-value/zero-density, which it never
  mentions. Its numerics — "band correlation 0.9999", "amplitude ratio 0.9991",
  "measured exponent $-2.500$" — are also exactly the artifact class
  `CLAUDE.md` was written to end; that is an internal-protocol staleness, not a
  literature one, and `notes/METHOD.md`'s triage is the right place for it.

### C.3 Questions the field has moved past, or moved around

- **Everything in the corpus that is framed as "the mollifier/Levinson record".**
  `KAPPA.md` §2 already says this out loud: the Levinson-framework questions
  (the $\theta=4/7$ wall, PRZZ's coefficient search) are "now **historical**".
  The corpus is correct and current on this; recorded here only so no future
  block reopens it.
- **The formalization-substrate question, as the corpus poses it.** The corpus
  debates Agda-vs-Lean as a question of mathematical hygiene (`CLAUDE.md`: a
  checked term is the object itself). The field in 2026 has settled it on
  entirely different grounds — library mass and agent tooling (B8) — and has
  moved on to *autoformalization of papers* (B1, B4, B6, B7). The corpus's
  formal lane is 59 hand-written Agda files and 24 hand-written Lean files
  while the external question has become how much of a paper an agent can
  close. This is the corpus's **largest** distance from a live frontier —
  larger than anything in Part A.
- **"Can machines do research-level mathematics?"** Answered externally in
  2026 (B1, B4) with specific numbers. Any corpus prose still treating it as
  open should be re-read.

### C.4 The verdict, in one paragraph

The corpus's analytic lane is **not** working on questions settled or bypassed
in 2024–2026 — no located 2025–2026 result invalidates a corpus theorem, and on
the two shelves where it engages the literature seriously (the Cesàro–Goldbach
family, and the critical-line proportion) it is at or near the frontier, in the
latter case within days. What it is, is **off-axis and one wording-error stale**:
the moving frontier in prime distribution since 2024 is large-value estimates →
zero density → short intervals, which appears in the corpus exactly once as a
parenthetical; and `WIDTH.md` asserts a uniqueness that Lichtman and Pascadi
have falsified. The formalization lane is a different story and a worse one: the
corpus is roughly **one full year behind** an external frontier at which a
Fields-medal theorem has been formalized sorry-free with an autonomous agent
closing it, a 22-million-implication collaborative project has been completed in
Lean, and agents autonomously prove open Erdős problems at a few hundred dollars
each — none of which appears anywhere in `notes/`.

---

## Appendix: what a next block can pick up without re-searching

Filed as observations of the corpus's state, **not** as proposed research
(per the task's constraint). Priority tags per `CLAUDE.md` standing queue
discipline are left unassigned deliberately — assigning them is a research
decision, not a reading one.

1. `WIDTH.md` §2(b) and §3 contain a factually false uniqueness claim (A5, A6).
   Correcting it needs no computation and no new mathematics.
2. `WIDTH.md` §4's failure-layer taxonomy has no expander layer (A8).
3. `KAPPA.md` §7's frontier statement predates the Alternative Hypothesis
   cluster (A10-II, A11).
4. `LITERATURE.md`'s sweep covers five claims; Parts A and B above cover the
   ambient frontier. Neither covers the topics listed as **not searched** in §0.
5. Every citation in this note is śabda grade. If `WebFetch` egress is ever
   restored, the first six worth upgrading to FETCHED are: arXiv:2309.08522
   and arXiv:2505.00653 (they carry a correction), arXiv:2508.10857 (it bears
   on `KAPPA.md` §7), arXiv:2512.07087 and arXiv:2605.22763 (they carry the
   Part B calibration), and arXiv:2405.20552 (the axis).
