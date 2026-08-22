# Corpus-wide prior-art sweep, 2026-08-14 — every outstanding flag serviced

> **CORRECTION, SEED-83 (Robinson lens), 2026-08-14, per msg 0657's standing rule
> — strike, don't delete.** The filename asserts a property of the corpus; the note
> establishes a property of a *snapshot* of the corpus's *self-declared flags*. Read
> the title as ~~`PRIOR_ART_SWEEP_COMPLETE`~~ **`PRIOR_ART_SWEEP_COMPLETE_OVER_DECLARED_FLAGS_AS_OF_20260814T0916Z`**.
> Nothing in §§1–5 is withdrawn: over its class the sweep is complete and I found no
> counterexample. What is corrected is the quantifier. Three restrictions, unstated
> above, derived in `notes/SEED83_COMPLETENESS_IS_A_MATERIALIZED_VIEW.md` §1:
>
> - **R1 (selection by self-declaration).** §1 defines a serviced flag as *"a search
>   stated as not run"* — membership requires the author to have already suspected a
>   rediscovery. Coverage is therefore anti-correlated with the risk being managed.
>   Second form of R1: a flag may be raised *on the wrong object* (`SEED05` flags its
>   void law, not its classical height zeta) and the claim still sits outside the class.
> - **R2 (no watermark).** The base has moved: ~~by mtime, 313 of the 759 files now in
>   `notes/` postdate this sweep~~, **including all ~~79~~ `SEED*` notes** — the entire output
>   of the night in which it was written. A view named for a property of a base relation
>   must carry the base version it was computed from.
>
>   > **[SEED-124, 2026-08-15, K3 — witness replaced, claim intact.]** The mtime
>   > witness is void: git neither records nor restores mtimes, and **429 of the 779**
>   > `notes/*.md` files share the single minute 06:09 while **202** share 09:16 (see
>   > msg 0721 §1.1). Recomputed on the durable oracle — the commit that *adds* a file,
>   > `git log --diff-filter=A --format=%cI -- <file> | tail -1` — against this sweep's
>   > own add-commit **2026-08-14T02:17:55Z**: **186 of 779** `notes/*.md` files postdate
>   > it, and **91 of 91** `notes/SEED*.md` notes do (all of them, as claimed; the count
>   > 79 was current at writing). R2 therefore stands with a warrant that survives a
>   > checkout, and it stands more strongly than stated, since the SEED half is
>   > exhaustive. Caveat recorded rather than hidden: commit time is durable but coarse
>   > here — one bulk commit (`a55c4bc0`, 2026-08-13T06:29Z) adds **420** of the 779
>   > files, so it orders those files only against things outside it, not among
>   > themselves. It is before this sweep, so the count above is unaffected.
>   >
>   > The title's watermark is the same defect one level up: ~~`…_AS_OF_20260814T0916Z`~~
>   > was read off mtime, and 09:16 is the second bulk-operation minute (202 files),
>   > not an authorship time. Durable replacement: this file's last commit,
>   > **2026-08-14T10:44:09Z** (`git log -1 --format=%cI -- <file>`). Read the title
>   > as `PRIOR_ART_SWEEP_COMPLETE_OVER_DECLARED_FLAGS_AS_OF_COMMIT_20260814T1044Z`.
> - **R3 (attribution status, not resolution).** Already self-declared in §0 and §6;
>   restated here because the filename does not carry it.
>
> Specific uncovered results are named in SEED-83 §2: `SEED09_BASIN_NERODE` (Hopcroft /
> Paige–Tarjan / Kanellakis–Smolka), `SEED05_RATIONAL_CIRCLE_VOID_LAW` (Schanuel;
> classical conic height zeta), the 79 `SEED*` notes as a body (`SEED58` recursion
> theory, `SEED60` coarse geometry, `SEED70` sofic shifts), and the meta-object §6
> already declares open — to which SEED-83 §3 adds the corpus's own **sync discipline**,
> whose literature (CRDTs, FLP, session guarantees) is large and directly applicable.
>
> **In the sweep's favour, against the standing diagnosis.** `SEED42_OVERNIGHT_AUDIT`
> §4.2 says the corpus "searches prior art badly at the edges." §3's own FOUND table
> refutes that: ~~twelve~~ **nine [CORRECTED, SEED-117, 2026-08-14: the twelve were
> citations, not rows — Kildall/Kam–Ullman/GKT/de Kleer are one row, Stanley and
> Baez–Dolan another; by row the split is 6 in number theory / 9 outside, and the
> conclusion below is unchanged because 9/15 is still a majority. Enumeration in
> `SEED83_COMPLETENESS_IS_A_MATERIALIZED_VIEW.md` §1.1.]** of its fifteen rows are
> outside number theory (Kildall,
> Green–Karvounarakis–Tannen, de Kleer, Tsumoto–Hirano, Marshall–Olkin, Halmos,
> Baez–Dolan, Stanley, Cameron, Horn–Johnson, Matilal/Ganeri, Jäger). Border-lane
> *searching* works. The bottleneck is one step earlier — **flag-raising** — which is
> what R1 formalizes.

**Status: complete for the flags that carried an obligation.** This note is
attribution status only. **No mathematical claim anywhere in the corpus was
weakened, strengthened, or restated by this sweep**, and no novelty was claimed
on the strength of any null result.

Continues and does not repeat `collab/messages/0458-cf-tessera-search-debt-sweep.md`,
which serviced five flags on 2026-08-14 (`E2B_PROOF.md` L4,
`PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` T5, `LEAKAGE_IS_HALF_COMMUTATOR_RANK.md` §3,
`DRIFT_EXPONENT_EXACT.md` §8/DE10, `FIVE_FACES.md` §10 item 4). Those five are
untouched here, except that **one of `cf-tessera`'s NO-MATCHes has been overturned**
— see rediscovery #1.

## 0. Egress, restated because it governs every grade below

`WebSearch` **works**. `WebFetch` is **blocked on every host tried**, verbatim:

```
{"error_type":"EGRESS_BLOCKED","domain":"arxiv.org",
 "message":"Access to arxiv.org is blocked by the network egress proxy."}
```

**Every citation produced by this sweep is search-summary (śabda) grade.** No PDF,
no abstract page, no wiki page was read; formulas quoted below are as they were
displayed in a search summary. That is a genuine upgrade over from-memory — a
search summary can be wrong, but it cannot be a hallucinated paper — and a genuine
downgrade from verified. Several notes in the corpus still say "egress is blocked"
and downgrade their citations on that basis; that phrasing is half wrong, and the
appends fix it where they touch it.

## 1. The count

| | |
|---|---|
| Files matched by the sweep grep (`notes/` + `collab/`) | **110** |
| Of those, the **declared-classical class** — say "no novelty is claimed" *and* already name the standard object (Smith normal form, Hecke algebras, LTE, Ramanujan sums, torsors, Vieta, …). These claim nothing and carry **no obligation**; they were read and left alone | **47** in `notes/` alone |
| **Genuine outstanding flags** — a search stated as not run, with a live attribution question | **31** |
| Serviced by `cf-tessera` on 2026-08-14, not redone here | 5 |
| **Serviced by this sweep** | **26** |
| — of which the load-bearing part was **RESOLVED-FOUND** | **15** |
| — of which the load-bearing part was **RESOLVED-NO-MATCH** | **18** (several notes split both ways) |
| — **UNSERVICEABLE** (verbatim tool error, nothing obtainable) | **0** |
| Flags reviewed and found to carry **no obligation**, recorded rather than dropped | 5 |

The 47-file declared-classical class is the reason the raw grep number is misleading.
"No novelty is claimed for the Smith/homothety mechanism" in a note that then cites
Smith normal form is not a search debt; it is an already-discharged attribution.
Conflating the two is what makes the corpus look like it has a hundred open debts
when it has about thirty.

## 2. Ranking, and why

Ordered by load-bearingness — how much else breaks or changes if the attribution is
wrong — not by how interesting the search was.

1. **`E2_PROOF.md` H6** — feeds `COPRIME_MERTENS`, `MERTENS_FLOOR`,
   `DRIFT_EXPONENT_EXACT`, `PROVABLE_MEASUREMENTS_TRIAGE`. The most-cited open
   attribution in the analytic lane.
2. **`COPRIME_MERTENS.md` L3** — is the proof that replaced E2's unchecked citation.
3. **`LEAKAGE_RANK_IS_INCIDENCE_RANK.md` Cor 2.2** — cited twice in `collab/STATE.md`,
   joins three lanes (`opus-samhita`, `claude_ananta`, `codex-vajra`/`codex-madhavi`),
   and is the input to `LEAKAGE_BOUND_ATTAINMENT`, `LENS_REPAIR_TWO_AXIS_WITNESS`,
   `DEFICIT_LEAKAGE_ADJUDICATION`, `LEAKAGE_PAST_IDEMPOTENCE`.
4. **The barrier family** (`BARRIER_UNIFORM` U7, `BARRIER_ERROR_WINDOW` V9,
   `BARRIER_SMOOTH_TERM` W8) — one shared obligation across three notes that feed a
   paper section.
5. **`ATLAS_OF_N.md` §10 item 2** — an atlas other notes navigate by.
6. **`OBLIGATION.md` §6** — explicitly "blocks all novelty language in §1–§2", i.e. the
   note itself made the flag load-bearing.
7. **`MERTENS_FLOOR` MF6, `ENERGY_CONSTANT_EXACT` EC10** — single-note results with
   downstream triage consequences.
8. Everything else — side remarks, self-contained lemmas, and framing notes.

## 3. Results that are known mathematics

**This is the section the sweep was run for.** Each row is a corpus claim that turned
out to be standard, with its standard name and a citation. Stated plainly, as the
owner asked: these are services to their authors, not attacks. Several of the authors
guessed exactly right in their own flags — that is worth saying too.

| Corpus claim | Standard name | Citation (śabda grade) |
|---|---|---|
| `E2_PROOF.md` U3: the limit of $\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q(m)$ is $\frac{\varphi(m)}{m}\Lambda(m)$ | The Ramanujan–Fourier expansion of $\frac{\varphi}{\mathrm{id}}\Lambda$ — **Hardy's own theorem**, not just Hardy's $\Lambda_1$ expansion | G. H. Hardy, *Note on Ramanujan's trigonometrical function $c_q(n)$ and certain series of arithmetical functions*, Proc. Camb. Phil. Soc. **20** (1921) 263–271, which proves **both** $\Lambda_1=\sum\frac{\mu(q)}{\varphi(q)}c_q$ and the expansion of $\frac{\varphi(n)}{n}\Lambda(n)$. Secondary: Murty, Hardy–Ramanujan J. **36** (2013) 21–33; arXiv:1705.07193 |
| `COPRIME_MERTENS.md` Theorem U2′ — **including the $\sum_{p\mid n}\frac{\log p}{p}$ coprimality correction and the constant $C=1.332582\ldots$** | The classical asymptotic for $\sum_{n\le M,(n,q)=1}\frac{\mu^2(n)}{\varphi(n)}$ | $\frac{\varphi(q)}{q}\bigl(\log M+c+\sum_{p\mid q}\frac{\log p}{p}\bigr)+O(2^{\omega(q)}M^{-1/2})$, $c=\gamma+\sum_p\frac{\log p}{p(p-1)}$ — arXiv:2603.22124 Prop. A.1, after R. Sitaramachandra Rao (1985). Lineage confirmed: Ward, J. London Math. Soc. **2** (1927) 210–214; van Lint–Richert, Proc. Kon. Nederl. Akad. Wetensch. A **67** (1964) 582–587; Montgomery–Vaughan, Mathematika **20** (1973) 119–134 |
| `DRIFT_EXPONENT_EXACT.md` §8(iv) / `E2_PROOF.md` Lemma U2's imported constant | Same as above | Same as above. **Overturns `cf-tessera`'s NO-MATCH of 2026-08-14** |
| `LEAKAGE_RANK_IS_INCIDENCE_RANK.md` Cor 2.2: two orthogonal projections commute iff the contingency table in each join block has rank one | Composite of two published equivalences: (i) commuting conditional expectations ⟺ conditional independence given the meet; (ii) contingency-matrix rank $=1$ ⟺ statistical independence | (i) ~~arXiv:1307.6403 Prop. 7~~ **[seed135, 2026-08-14: demoted — the corpus's "Prop. 7" quotation is that paper's introduction, its $\mathcal F,\mathcal G$ are product filtrations, §6 does not render in this container; carry leg (i) at śabda grade, so this row is RESOLVED-FOUND on one read leg (ii) and one reported leg (i). Not refuted]** (already cited in the note). (ii) Tsumoto–Hirano, **Contingency Matrix Theory I: Rank and Statistical Independence in a Contingency Table**, RSCTC 2008, LNCS/LNAI **5306**, 240–249; and Inf. Sci. **179** (2009) 1615–1627 |
| `ATLAS_OF_N.md` Thm 6.1's index $n!/\prod_p(p!)^{a_p}a_p!$ | The classical count of set partitions of an $n$-set with exactly $a_p$ blocks of size $p$; equivalently $[S_n:\prod_p(S_p\wr S_{a_p})]$ | Standard enumerative combinatorics (Stanley, *EC1* §1.3); appears verbatim in ordinary multinomial-coefficient lecture notes. Categorification framing: Baez–Dolan, *From Finite Sets to Feynman Diagrams*, arXiv:math/0004133 |
| `OBLIGATION.md` §1–§2's lattice machinery | Monotone dataflow analysis with semiring-annotated propagation | Kildall, POPL 1973, 194–206; Kam–Ullman, *Monotone data flow analysis frameworks*, Acta Informatica **7** (1977) 305–317; Green–Karvounarakis–Tannen, *Provenance semirings*, PODS 2007, 31–40; de Kleer, *An assumption-based TMS*, Artificial Intelligence **28** (1986) 127–162. **All four from-memory attributions verify** |
| `ABHAVA.md` §2.1's typed treatment of the fourfold absence | Typed *abhāva* in cubical type theory — an existing programme, not a first | arXiv:2605.12548, *Cubical Type Theoretic Navya-Nyāya*, which names "typed absence (abhāva)" among the structures earlier formalizations lose. Prior formalizers confirmed: Matilal (first-order, HUP 1968, xi+208), Ganeri (higher-order), Bhattacharyya (Martin-Löf) |
| `ANTICHAIN_FORMATION_SUFFICIENCY.md` frontier reduction + upper-set equality | The antichain ↔ up-set bijection $S\mapsto\,\uparrow\!S$ on a finite poset | Standard order theory: Cameron, Combinatorics Study Group poset notes; Gunter–Ngair, *Sets as Anti-Chains* |
| `UNIT_PRODUCT_VIETA.md`'s convex lemma | **Schur-concavity** of elementary symmetric functions on the positive orthant — the right name for it | Marshall–Olkin, *Inequalities: Theory of Majorization and Its Applications*; restatements across the symmetric-function inequalities literature. Cafure–Cesaratto, AMM **124** (2017) 37–53, confirmed |
| `CROSS_REVERSAL_CHARGE.md`'s abstract formula | Second (additive) compound matrix / second exterior power; resultant as Sylvester determinant | Horn–Johnson, *Topics in Matrix Analysis* ch. 6; arXiv:1806.07162 |
| `FORMED_UNIT_FILTRATION_DEPTH.md`'s notion of *level* of a subgroup of $\mathbb Z_p^\times$ | The filtration $U_n=1+p^n\mathbb Z_p$ and its **depth/level** — standard local arithmetic, and the same word as in the Zassenhaus-filtration literature | Conrad, expository notes on prime-power units; Springer/J. Math. Sci., *Filtration of the group of principal units of a local function field as a Galois module* |
| `SMITH_PATH_COORDINATE_TORSOR.md`'s torsor/stabilizer mechanism | The unimodular left/right multiplier action on Smith transformation pairs — standard **for SNF specifically**, not only in the abstract | Jäger, *Reduction of Smith Normal Form Transformation Matrices* (Kiel), which works with exactly $U'=WU,\ V'=VZ$; Stanley, *Smith normal form in combinatorics*, arXiv:1602.00166 |
| `LEAKAGE_PAST_IDEMPOTENCE.md` Theorem B | Spectral-projection decomposition of the invariant (cyclic) subspace generated by a set: $\bigoplus_iE_iU$ | Textbook spectral theory (Halmos, *Finite-Dimensional Vector Spaces*; *A Hilbert Space Problem Book*) |
| `BARRIER_UNIFORM.md` §2's *phenomenon* — absolute convergence after one smoothing fails once the factor count grows | The standing convergence hypothesis of the Cesàro/Riesz-average literature, where the required order rises with the number of summands | Languasco–Zaccagnini arXiv:1206.0251 (order $>1$, two primes); Cantarini arXiv:1607.05629 (order $>3/2$); Languasco–Zaccagnini arXiv:2012.02503 = Res. Number Theory (2022), arbitrary number of summands; Brüdern–Kaczorowski–Perelli arXiv:1712.00737 |
| `R0014`'s engines | Function-field Chowla and twin primes | Sawin–Shusterman, **Annals of Math. 196 (2022) no. 2, 457–506** (arXiv:1808.04001) |

**Fifteen corpus claims are known mathematics.** In eleven of the fifteen the note's
own flag had guessed as much ("likely folklore", "almost certainly classical",
"standard group action theory") — the corpus's instincts were good and its follow-through
was the missing part. In two cases the located literature is **sharper than the corpus's
version**: the $\mu^2/\varphi$ error term $O(2^{\omega(q)}M^{-1/2})$ beats
`COPRIME_MERTENS`'s $O(Y^{-1/2}(1+\log Y)^3)$ (which L2 had already flagged as
non-optimal), and Hardy 1921 states U3 outright rather than as a corollary.

## 4. RESOLVED-NO-MATCH, with the queries recorded

Absence of a located source is **not** evidence of novelty, and none of these is
treated as such. The queries are written into each source note so the next block
extends rather than repeats.

`E2_PROOF` U4 ($\Lambda^\sharp_Q(P_Q)=M(Q)$) · `MERTENS_FLOOR` Lemma 1
($\sum_{d\le Q}A_d=M(Q)$) · `BARRIER_ERROR_WINDOW`'s window transfer law and the $X_0$
invariant · `BARRIER_SMOOTH_TERM`'s graded ladder · `BARRIER_UNIFORM`'s exact threshold
$k\le2j$ · `ENERGY_CONSTANT_EXACT` Lemma $\rho$ · `ATLAS_OF_N` Thm 4.2's parameter count
and the two-completions framing · `LEAKAGE_BOUND_ATTAINMENT` Prop. A · `LENS_REPAIR_TWO_AXIS_WITNESS`'s
Lemma · `LENS_ORDER_COMMUTATION`'s integrality obstruction (third null) ·
`DIGIT_CRYSTAL` Prop. 1.3 (second null) · `GAUGE_OF_THE_FLEET`'s gauge framing of
verification · `FORMED_UNIT_FILTRATION_DEPTH`'s $l(U)$ obstruction ·
`CROSS_REVERSAL_CHARGE`'s prime-prefix packaging · `UNIT_PRODUCT_VIETA`'s boxed-product
form · `ANTICHAIN_FORMATION_SUFFICIENCY`'s chart-sufficiency packaging · `ABHAVA` §3's
average/forall reading · `R0009`'s degree-nine prime-prefix theorem.

Two nulls are now **doubly or triply searched** and should be treated as such rather
than re-run: `DIGIT_CRYSTAL` Prop. 1.3 (2026-08-12 and 2026-08-14) and
`LENS_ORDER_COMMUTATION`'s integrality obstruction (twice on 2026-08-12, once today).
Untried vocabulary is named in both appends.

## 5. Flags reviewed and found to carry no obligation

Recorded, not dropped, so a later triage does not re-open them as debts:
`DEFICIT_LEAKAGE_ADJUDICATION` (negative verdict on a dictionary between two in-corpus
notes — no external referent) · `VEC_INDEX_IS_THE_WARNING` (claims no mathematics) ·
`TRANSSERIES_RETRO` (guards a *withdrawn* claim) · `CYCLOTOMIC_TRACE` (a search **was**
run and is properly recorded with volume, page and DOI) · `CROSSREVIEW_A2PRIME` (prior-art
search was part of the audit method).

## 6. What this sweep did not do

- **No commits, no pushes, no branch changes.** One dated append per source note, plus
  this file.
- **No mathematics touched.** Where a finding bears on a claim — `ABHAVA` §2.1 most
  sharply — the finding is recorded and the adjudication is named as the author's, not
  made here.
- **Nothing verified.** `WebFetch` is blocked; every citation is search-summary grade
  and can be wrong in its details. The first block that finds a fetchable mirror should
  re-read this table's fifteen rows against source text, in the order of §2's ranking.
- **`collab/discovery/claims/*.md` front-matter untouched.** `R0002` and `R0009` carry
  the machine field `novelty: unsearched`; the searches are recorded in prose and the
  field is left for the owning generator to change.
- **No search on the meta-object.** Nobody has searched whether the corpus's own
  apparatus — obligation calculi, honesty ledgers, the three-verdict lens scheme — has
  prior art. `OBLIGATION.md` §6 now half-answers this for the lattice part and leaves
  the calculus itself open.

---

## 7. Appended 2026-08-19, another thread: three fresh instances of R1, and a probe that does not need a flag

*Nothing above is altered. This bears on the SEED-83 correction's **R1** and on
the diagnosis attached to it — "the bottleneck is one step earlier —
flag-raising" — and on §6's last bullet only by declining it.*

**Scope, stated first because the two kinds are easy to run together.** This
note's subject is prior art in the **literature**. What follows is about prior
art **inside the corpus**. R1 as stated is about the selection mechanism —
"membership requires the author to have already suspected a rediscovery" — and
that mechanism is the same in both cases, which is why this is appended here
rather than filed separately. No claim is made about the fifteen rows of §3,
and §6's meta-object search remains undone: egress is still blocked, so no
literature search was attempted.

### 7.1 R1 predicted these and they happened, unflagged, in one session

| rediscovered | prior art, in the corpus the whole time | commit recording it |
|---|---|---|
| closure of stability under `¬`, `→`, `×`, `Π`, and their instantiation at obstruction shapes | `NaturalMachine.DeflationaryTest` §§4–5 — imported by `RootsThreadLatch` at line 53, typechecked every cycle | `beb8d4c6` |
| `¬ FactorsThrough eval size` and `¬ FactorsThrough asSet cost` from the general collision lemma | `NaturalMachine.OneLemmaFiveSites` §§1–2 | `f5fb30ee` |
| an entire three-thread agenda | `notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md`, which closes all three with modules and quoted exit codes | `3b2e9756` |

No flag existed for any of the three. In each case the author — me — had no
suspicion to declare, which is R1 exactly: **coverage is anti-correlated with
the risk being managed.** The third is the sharpest: the thread name and the
module name were the same word for many cycles and neither was ever grepped
against the other.

The overlap in the first case is not argued but **checked**: each closure lemma
on the rediscovering side is `refl`-equal to the prior module's, because they
are the same term
(`NaturalMachine.TheDeflationaryTestWasAlreadyRun`).

### 7.2 A probe that does not depend on flag-raising

R1 says the selection is by self-declaration. The repair has to fire on **every**
write, not on writes whose author is already worried. Two checks were added to
`.claude/hooks/source-coverage.sh` — advisory, `exit 0`, fail open, in the same
style as the checks already there:

1. **the audit behind the term** — for each Sanskrit technical term in a write,
   which `notes/` files carry it *and* which of those already carry a correction
   marker. A term whose note has been audited is where the trap is.
2. **modules that share your imports** — which existing modules open the modules
   this write opens. Duplicate work nearly always opens the same things.

Measured, not asserted: on a dry run against the file whose cycle had just
missed it, check 2 put `OneLemmaFiveSites` in its top three.

**Why imports and not names.** Grepping the latch for a *thread's name* was
tried and failed at `f5fb30ee`: `OneLemmaFiveSites` contains none of "Laghava",
"Anuvrtti", "Pratyahara", "Apavada", the four names that thread was working
under. Worse, a duplicated proof of a **negation** is invisible in the
conclusion — negations are propositions, so any two proofs of one are equal, and
that equality is itself a checked term in this corpus. Imports and statements
are the only places such a duplicate can show.

### 7.3 The honest limits of the probe

- It finds duplicates that **share imports**. A duplicate reached from different
  modules — or written before the module it duplicates — is invisible to it.
- It is advisory and its output must be read. Nothing enforces reading it, and
  the same R1 logic applies one level up: an advisory that only worried authors
  read is selected the same way a flag is.
- It says nothing about literature prior art, which is this note's actual
  subject. §6's meta-object bullet is untouched.
- Two checks, three instances, one measured hit. That is not evidence that the
  probe works in general, and §4.2 of `NEGATIVE_KNOWLEDGE_IS_TYPED.md` names the
  matching failure mode: an instrument can be true and idle. It should be struck
  if a session passes in which it fires and nothing is caught, or in which a
  rediscovery lands that it could have seen and did not.
