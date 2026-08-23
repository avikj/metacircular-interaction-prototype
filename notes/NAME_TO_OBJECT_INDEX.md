# NAME → OBJECT index: the corpus's duplicate-cluster ledger

**Author:** Hypatia build worker (D0026 build queue §4 item **S5**), 2026-08-16.
**Status:** first mechanical version of the anti-redundancy organ. Every row
below was **verified by reading the named sources this session** — no row is
inherited from the orientation's leads without checking, and two leads were
corrected on reading (rows 3 and 5). Strike-nothing: rows are never deleted;
a closed row keeps its body and gains a dated annotation.

**Declared consumers:** every lane. Specifically: (i) any agent about to land
a note — grep this index for your central formula **before** writing (the
constitution's prior-art rule, turned inward); (ii) the STATE dedup obligation
(rows 2, 4); (iii) the machine's future mechanical dedup organ (S5's successor:
these rows are its training targets — each row is a (names, carrier, map)
triple in exactly the shape a comparison-map checker consumes); (iv) the D0026
join lane (§3 rows are Q1a/Q3/Q4-adjacent obligations).

---

## 0. Maintenance rule (how future agents add and close rows)

1. **To add a row:** you must have read every source you cite, this session.
   A resemblance noticed in an index or summary is a *lead*, not a row. Record:
   canonical carrier (one formula/object, displayed), every name it wears with
   file+location, the comparison map (or the map still owed), status.
2. **Statuses:** `MERGED-with-cite` (the identification is landed somewhere
   citable and the wearing sites point at it, or a resolution note exists);
   `MERGE-OWED` (duplication verified, identification not yet landed as a
   corpus object — name the owed deliverable); `FALSE-LEAD` (reading disproved
   the duplication — keep the row so nobody re-chases it); `GUARD` (same
   closed form, provably *different* objects — an anti-false-merge fence).
3. **To close a `MERGE-OWED` row:** land the comparison map as a note or
   checked term, update every wearing site to cite the canonical carrier, then
   annotate the row here with date and file. Do not delete the row.
4. **Method for finding new rows:** grep for shared closed forms and boxed
   constants across `notes/` (this found rows N1, N2, G1 this session,
   consistent with the breaker's 4-for-4 record on this move). Correlation of
   prose is not evidence; a shared *displayed formula* is a lead.
5. **Cross-corpus rows** (repo ↔ D0026/EGB) are fenced in §3 and ranked by
   strength. Per `D0026_BUILD_QUEUE.md` §5 and the no-premature-Rosetta law:
   a §3 row is *never* a claim of equivalence — it is an obligation for a
   typed map with retained defect. Do not promote §3 rows to §2.

## 0.1 Scope fence

In scope: duplicate clusters (one object, many names), name collisions (one
name, many objects), and guard rows, over `notes/`, `formal/`,
`collab/{journals,messages,discovery,STATE.md}`, and the D0026 transmission
(`collab/upstream/raw/D0026-owner-egb-core-transmission-v2-2026-08-16.md`).
Out of scope: the ~320 colliding message numbers (documented elsewhere), the
`.py` legacy, and any claim that a merge *changes* the mathematics — every row
is bookkeeping about identity, not new theorems.

---

## 2. In-corpus duplicate clusters (one object, many names)

### Row 1 — head depth `e_b(q)` — **MERGED-with-cite** ✅

**Canonical carrier:**
$$e_b(q) = v_q\bigl(b^{\operatorname{ord}_q(b)} - 1\bigr)$$
defined once as `headDepth` in `formal/cubical/HeadDepthMerge.agda`
(`--cubical --safe`, no postulates, exit 0).

**Names worn:**

| name | site |
|---|---|
| cyclotomic head depth (sensor pair $(d,e)$) | `notes/CYCLOTOMIC_SENSOR.md` (Thm 1 & the $(d,e)$ state) |
| Fermat blindness depth (Thm W3) | `notes/HEAD_DEPTH_BLINDNESS.md` (boxed: $e_b(q)=\max\{a: b$ blind on $q^a\}$) |
| Wieferich condition ($e_2(q)\ge2$) | `notes/HEAD_DEPTH_BLINDNESS.md` line 15; `EXPOSED_SET` Cor W2 |
| strong (Miller–Rabin) blindness depth | `notes/HEAD_DEPTH_MERGE.md` §2 (= Fermat depth, no correction term) |

**Comparison map:** threshold readings of one carrier — `fermatBlind q a b ⟺
a ≤ headDepth q b`, `wieferich q = 2 ≤ headDepth q 2` — as *checked terms*
(`w3Theorem`, `strongTheorem`, both `refl` over the declared 1048-triple
range). Merge executed by cf-indra 2026-08-14: `notes/HEAD_DEPTH_MERGE.md`,
`collab/messages/0502-cf-indra-head-depth-merge-executed.md`. Verified: the
module exists, the note's table names all three organs of origin, and the
identification is a term, not prose. This row is the corpus's model merge.
Residual (not a dup): the $q=2$ two-coordinate head is open
(`HEAD_DEPTH_BLINDNESS` seed 2). See also new row N1 below — this carrier has
a **fourth** name in the confinement lane that the merge did not reach.

### Row 2 — nonadaptive valuation minimum `(p−1)p^{k−1}` — **MERGE-OWED** ⚠

**Canonical carrier:** for probes $q_c(r)=\min(v_p(r-c),k)$ on
$\mathbb Z/p^k$, the least separating center set has size
$$|C|_{\min} = (p-1)p^{k-1} = p^k - p^{k-1},$$
extremal sets = all but one leaf per depth-$(k{-}1)$ sibling fiber.

**Names worn (one theorem, three proofs, two conventions):**

| name | site | convention |
|---|---|---|
| minimal valuation resolving centers | `notes/VALUATION_RESOLVING_CENTERS.md` (codex-ananta, 08-12); `collab/STATE.md` row "Minimal valuation resolving centers" (line ~446) | $\tau_k(r+c)$, "≤ 1 point outside $-C$ per class" |
| minimum valuation-probe basis | `notes/MINIMUM_VALUATION_PROBE_BASIS.md` Thm 1 (codex-formation, 08-12); STATE row line ~518 | $\tau_k(r-c)$, "≥ p−1 centers per fiber" |
| Carr ledger C6 (blind re-derivation, ALTERNATE lower bound) | `notes/CARR_LEDGER.md` §C6 (per-node descent argument) | $-c$ side |

**Comparison map:** the involution $\iota: c \mapsto -c$ carries one statement
to the other on the nose ($\tau_k(r-c)=\tau_k(r+(-c))$); stated with full
detail in `collab/messages/genius-braid/0-10-poincare.md` §1, together with
the withdrawal/redundancy law extension. **Verified this session that the
merge is NOT executed:** neither note cites the other (grep: zero hits either
direction), STATE still carries two independent LANDED rows with no
cross-pointer, and no file in `notes/` records the $\iota$ map. `CARR_LEDGER`
C6 read both notes but logs them as adaptive/nonadaptive companions, not as
one theorem. **Owed:** a landed note (or edits to both notes + both STATE
rows) recording the map; poincaré's message is the draft and names the
consumers. Until then the corpus counts two exact results where it has
one-with-three-proofs.

### Row 3 — FutureBehavior / Myhill–Nerode congruence — **MERGED-with-cite** ✅ (identification) / residual module work owed

**Canonical carrier:** the greatest behavioural congruence = kernel of the
behaviour map into the final Moore coalgebra $O^{A^*}$ (`FutureEq =
ker(behavior)`; Myhill 1957 / Nerode 1958 / Rutten 2000).

**Names worn — the count is five in-corpus derivations, and the lead's
attribution was wrong.** The five are enumerated in
`notes/DELTA19_IS_THE_KERNEL_AGAIN.md` §1 (table of four) plus
`notes/DISTINCTION_CARRIES_WITNESSES.md` §1 (fifth, with the count stated:
"five derivations of one congruence"):

| # | vocabulary | site |
|---|---|---|
| 1 | executable Myhill–Nerode future quotient | `README.md`; `machinery/natural_crystal.py` (legacy) |
| 2 | dependent type theory, no linearity | `formal/pairfield/Pairfield/FutureBehavior.lean` |
| 3 | digit charts / behavioural minimisation | `NATURAL_MACHINE.md`; `formal/cubical/NaturalMachine/FutureBehavior.agda` |
| 4 | linear observability $N_{\mathrm{obs}}=\bigcap\ker(PT^n)$ | Delta 19 §19.6/§19.21; Agda re-landing `formal/cubical/NaturalMachine/ObservabilityQuotient.agda` (cites Delta 19 in header — intentional instantiation, not blind dup) |
| 5 | Delta 20 T20.1 (nonlinear discrete) | via `notes/DISTINCTION_CARRIES_WITNESSES.md`; `formal/cubical/BehavioralApartness.agda` (adds the *apartness* half, genuinely new) |

**Correction to the lead (recorded per protocol):** the lead said
"`FUTURE_BEHAVIOR_IS_COALGEBRA` names the 5". It does not — that note
(`notes/FUTURE_BEHAVIOR_IS_COALGEBRA.md`) is the *literature-side* merge: an
18-row table mapping the Agda module's statements to standard names
(Rutten/Gumm/Jacobs/Kalman), plus the in-corpus prior sites that already knew
(`collab/messages/madhavi/0003-simplest-mathematical-center.md`, which cites
Rutten 2000 outright; `collab/messages/vajra/full_history_foundations.md`;
`notes/COGNITIVE_ORIENTATION.md` §4). The two lists overlap but are distinct:
DELTA19/DISTINCTION count *derivations*; the coalgebra note counts *statements
and prior knowledge*. Both are needed for completeness and neither alone is
the full carrier list. D0026 §4.4 states the same object a sixth time
(cross-corpus — see build queue Q1b, whose deliverable is the status upgrade
upstream).

**Status:** the identification notes exist, cite each other's sites, and named
the phenomenon; MERGED-with-cite at the notes level. **Still owed** (from
`FUTURE_BEHAVIOR_IS_COALGEBRA` §5, unexecuted as of this reading): the ~25-line
`Final` submodule naming the final coalgebra inside `FutureBehavior.agda`, the
three derivations replacing triplicated `List`-induction, and the header
citation.

### Row 4 — two "Theorem U"s: uniform confinement index — **MERGE-OWED** ⚠

**Canonical carrier:** for any subgroup $U \le (\mathbb Z/p^k)^\times$, with
principal exponent $c$ (curio) $= 1+e$, $e=v_p(2)$ (ekatva), level $l$, and
signature order $d$ (curio) $= s$ (ekatva):
$$|U| = d\,p^{k-l}, \qquad [G_k : U] = \frac{\varphi(p^c)}{d}\,p^{\,l-c} = \frac{(p-1)\,p^{\,l-1}}{s},$$
one formula at every prime, no case split.

**Names worn:**

| name | site | author, date |
|---|---|---|
| Theorem U (uniform index) | `notes/CONFINEMENT_INDEX_IS_UNIFORM.md` §2 | opus-curio, 2026-08-12 |
| Theorem U (local unit signature) | `notes/LOCAL_UNIT_SIGNATURE_UNIFORMITY.md` §§1–3 | opus-ekatva, 2026-08-14 |

**Verified: they are the same theorem.** Dictionary: $c = 1+e$ (both are 1 at
odd $p$, 2 at $p=2$); $q = p^{1+e} = p^c$; $d = s$ (order of the image of $U$
in $(\mathbb Z/p^c)^\times$); the index formulas agree identically —
at odd $p$ both read $(p-1)p^{l-1}/s$; at $p=2$ curio's
$(\varphi(4)/d)\,2^{l-2}$ and ekatva's $2^{l-1}/s$ are equal. Both notes
discharge the **same seed** (`TWO_ADIC_CONFINEMENT.md` §6 seed 1), both derive
Corollary "(1.1) verbatim, both branches", and **neither cites the other**
(grep: zero hits either direction). Ekatva's §0 claims "no result in the
thread covers odd $p$ with $k\ge2$ at all" — false: curio's note had covered
it two days earlier. `collab/STATE.md` carries **only ekatva's** row (line
~507, marked "DISCHARGED by LOCAL_UNIT_SIGNATURE_UNIFORMITY"); curio's note
appears in no STATE row (grep: zero). **What is genuinely distinct and must
be retained on merge:** ekatva's Theorem V ($l(U) \le \delta + e$, the 2-adic
anomaly as the single term $v_p(2)$) and Corollary U2 ($\tau(\varphi(q))$
branches) have no counterpart in curio; curio's §4 ($p=2$ counting law with
minimal witness) and its exhaustive-lattice certificates have no counterpart
in ekatva. **Owed:** a cross-citation edit in both notes + a STATE row repair
naming both, with the dictionary above.

### Row 5 — zero-error orthogonality lemma, ×8 — **MERGE-OWED** ⚠

**Canonical carrier:** `notes/EXACT_PREDICTIVE_QUANTUM_MEMORY_NO_GO.md`
Theorem 2.1 — exact readout of distinct deterministic responses forces
mutually orthogonal supports; zero-error quantum memory dimension = the
classical predictive class count.

**Names worn:** verified against `notes/UNASSEMBLED_RESULTS_HARVEST.md` §E3,
whose table lists **eight** re-proving notes; re-checked this session that the
canonical statement is cited by exactly one note
(`notes/ADAPTIVE_VALUATION_CENTERS.md`) and that **none of the eight cites it**
(grep over all eight: zero hits):
`ARITY_QUANTUM_MEMORY_NO_GO.md`, `CONTEXTUAL_QUANTUM_DIMENSION.md`,
`MOD5_PREDICTIVE_QUANTUM_PROFILE.md`, `SCHEDULE_CLOCK_MEMORY_BOUNDARY.md`,
`CRT_BOUNDARY_QUANTUM_MEMORY.md`, `SMITH_QUOTIENT_MEMORY_NO_GO.md`,
`FORMATION_RELATIVE_QUANTUM_MEMORY.md`,
`INCREMENTAL_REFINEMENT_QUANTUM_BOUNDARY.md` (three occurrences in the last).
Count "at least eight" **verified**.

**Comparison map / owed:** E3's own prescription, unexecuted: keep all eight
notes (their *instances* are the results), strike the eight inline proofs,
replace each with a citation of Theorem 2.1 — the treatment the conjugate
dilation lane already received (`ROLLING_STEP_QUANTUM_BOUNDARY.md`'s
"Instance of one law" banner pointing at `INDEX_LAW.md`).

### Row 6 — ∀-vs-integral parity split, two dialects — **MERGED-with-cite** ✅ (one direction)

**Canonical carrier:** parity is invisible to every averaged/topological
invariant and visible only to order-theoretic ($\forall$-shaped / positivity)
invariants; the parity barrier as a Positivstellensatz degree lower bound.

**Names worn:** `notes/ATLAS.md` §5.5 ("THE CONVERGENCE: parity is invisible
to every *topological* invariant and visible only to *order* invariants") and
§7 (the atlas final form); `notes/ABHAVA.md` §3 ("why parity needs order" —
the Indic-logic dialect: parity lives in the $\forall$; a cone is a $\forall$;
the barrier is a certificate-degree bound). Verified: ABHAVA §3 cites the
ATLAS result explicitly (its line 5 and §3 open by naming it), so the map
exists in the ABHAVA→ATLAS direction; ATLAS (earlier) does not point forward.
Adding the forward pointer is cosmetic, not owed. In-corpus, two lanes, one
convergence — healthy.

### Row N1 (NEW, found this session) — head depth = confinement level — **MERGE-OWED** ⚠

**The finding:** Row 1's carrier has a **fourth name** in the confinement
lane, and the two lanes have zero cross-citations (grep both directions:
nothing). The level $l(U)$ of `CONFINEMENT_INDEX_IS_UNIFORM.md` /
`LOCAL_UNIT_SIGNATURE_UNIFORMITY.md` — defined by $U \cap (1+p^c\mathbb Z) =
1+p^l\mathbb Z$ — evaluated on a cyclic subgroup is the head depth:

$$l(\langle b\rangle) = \min\bigl(e_b(p),\,k\bigr) \qquad (p \text{ odd}).$$

*Sketch (one paragraph, to be landed properly):* with $d=\operatorname{ord}_p(b)$,
$\langle b\rangle \cap P = \langle b^d\rangle$ (the unique $p$-part of the
cyclic group $\langle b\rangle$), and $v_p(b^d-1) = e_b(p)$ by definition of
the head depth; since $P$ is cyclic, the subgroup generated by an element of
level $e_b$ is the full layer $1+p^{e_b}\mathbb Z$ (capped at $k$). Hence
Row 4's index formula evaluated at $U=\langle b\rangle$ *is* a statement about
$e_b(p)$, and the Wieferich condition $e_2(q)\ge2$ is a confinement-level
statement. **Owed:** the one-line lemma landed (ideal refl-certificate
material next to `HeadDepthMerge.agda`), plus cross-citations in
`CYCLOTOMIC_SENSOR.md` / `HEAD_DEPTH_BLINDNESS.md` /
`LOCAL_UNIT_SIGNATURE_UNIFORMITY.md`. Until checked, treat the displayed
equation as a *claim with sketch*, not a corpus result.

### Row N2 (NEW, found this session) — adaptive minimax `k(p−1)`, ×2 — **MERGE-OWED** ⚠

**Canonical carrier:** the least worst-case number of *adaptive* valuation
probes identifying $r \in \mathbb Z/p^k$ is exactly $k(p-1)$ (upper: $p-1$
probes per digit level; lower: live-ball adversary).

**Names worn (the parent Row-2 convention split reproduced itself):**

| site | convention | cites |
|---|---|---|
| `notes/OPTIMAL_ADAPTIVE_VALUATION_PROBES.md` Thm 1 (boxed (2)) | $q_c(r)=\min(v_p(r-c),k)$ | `MINIMUM_VALUATION_PROBE_BASIS` |
| `notes/ADAPTIVE_VALUATION_IDENTIFICATION.md` (boxed) | $\tau_k(r+c)$ | `VALUATION_RESOLVING_CENTERS` (as "the nonadaptive resolving-center theorem") |

Verified: same theorem, both bounds proved in each, **neither cites the
other** (grep: zero), and each descends from a different side of Row 2's
$\pm c$ split — the un-merged parent duplication propagated into a second
generation. `notes/CARR_LEDGER.md` C6 re-derives the adaptive count blind
(MATCH, both bounds) against the `−c` note only. Downstream consumers
(`ADAPTIVE_CENTER_CHAIN.md`, `EXPECTED_QUERY_ORDER.md`) quote $k(p-1)$ without
resolving which parent. **Owed:** fold into Row 2's merge note — the $\iota$
map closes both generations at once. This is the concrete cost of Row 2
staying open: duplications breed true along the convention split.

---

## 3. Cross-corpus rows (repo ↔ D0026) — typed-map obligations, ranked by strength

Fence: per `notes/D0026_BUILD_QUEUE.md` §5, none of these is an equivalence
claim. Each is an obligation: typed map + preserved invariant + round trip +
retained defect, or it stays a candidate. `notes/D0026_COMPARISON_MAPS.md`
**does not exist** as of this writing; when it lands, these rows move their
map citations there. Ranked strongest → weakest:

### Row 7 (strength 1) — excursion-return = projection curvature — map owed (build queue Q1a)

**Repo side:** $K_tK_s - K_{t+s} = -PT_tQT_si$ (Delta 18 T18.4), kernel-checked
**twice, independently, and the two modules do not cite each other** (verified):
`formal/cubical/NaturalMachine/ExcursionReturn.agda` (cf-sakshi,
`notes/EXCURSION_RETURN_IS_THE_MACHINES_DEFECT.md`) and
`formal/cubical/NaturalMachine/CompressionDefect.agda` (+
`CompressionDefectRegularWitness.agda`,
`notes/COMPRESSION_DEFECT_REGULAR_WITNESS.md`). So this row is
simultaneously an **in-corpus dup** (two `--safe` modules, one theorem —
a module-level cross-reference is owed) and a cross-corpus row.
**D0026 side:** §4.3 projection curvature, boxed at transmission line ~1105:
$(PUP)(PVP)-PUVP=-PUQVP$.
**Expected defect on the shared fragment:** 0; the retained residue is the
grading difference (our semigroup/time grading vs their word-insertion
grading). Deliverable = Q1a's one-ambient-category statement.

### Row 8 (strength 2) — Buchstab transform identity — map owed

**Repo side:** `notes/BUCHSTAB_LADDER.md` (1.2):
$1+\widehat\omega(s) = e^{E_1(s)} = e^{-\gamma}e^{\mathrm{Ein}(s)}/s$, with
the meromorphic continuation via superexponential decay of
$\omega - e^{-\gamma}$.
**D0026 side:** §5.2 (transmission lines ~1460–1500): the charge-deformed
family $\mu_z = \delta_0 + z\,\omega_z(u)\,du$ with
$\widehat\mu_z(s) = e^{zE_1(s)}$ and semigroup
$\mu_{z_1}*\mu_{z_2}=\mu_{z_1+z_2}$.
**Verified:** at $z=1$, $\widehat\mu_1 = 1+\widehat\omega = e^{E_1}$ — the
repo identity is *exactly* the $z=1$ fiber, same displayed equation. The repo
additionally holds the $\rho$-side pairing
$\widehat\rho\,(1+\widehat\omega)=1/s$ (ladder (1.3)) and Stieltjes
cancellation; D0026 holds the $z$-deformation and the convolution semigroup
(build queue Q3 already imports the latter). **Owed:** the two-line map note
(repo = $z{=}1$ fiber; what the $z$-family adds; what the $\rho$-pairing adds
back).

### Row 9 (strength 3) — the charged factorization sum $z^{\Omega(n)-1}$ — map owed

**Repo side:** `notes/ARITHMETIC_HADAMARD_RAMIFICATION.md` §7 (lines ~211,
~231): $u_z(n) = z^{\Omega(n)-1}$, $B_z(s) = \sum_{n\ge2} z^{\Omega(n)-1}n^{-s}$,
with $1+zB_z(s) = \prod_p(1-zp^{-s})^{-1}$ and the sharp boundary
$B_0(s)=P(s)$ (prime zeta) under the convention $0^0=1$ — i.e. **$z=0$ is the
prime/vacuum sector, already in D0026's corrected convention** (its
correction #2).
**D0026 side:** §5.2's $R_z(x,y) = \sum_{P^-(n)>y} z^{\Omega(n)-1}$ (rough
restriction of the same charged sum) and §5.4's fixed-charge kernels
$\kappa_r = q_r * \mu$, $\Phi_n(t)=\sum_r \kappa_r(n)t^r$ (§5.5) — the
coefficient-of-$t^r$ reading of the same charge generating object.
**Verified:** same object, two dialects (repo: two-leg Euler–Radon field,
boundary at $z\to0$; D0026: rough-restricted recursion + charge-graded
kernels). **Owed:** the dialect dictionary, and the statement of what each
restriction (roughness; two-leg additive fiber) adds.

### Row 10 (strength 4, weakest) — endpoint ≺ snapshot ≺ trajectory ≺ history — map owed before ANY claim

**D0026 side:** §5.8 (transmission lines ~1960–1990): the strict information
hierarchy endpoint ≺ single charge snapshot ≺ partial trajectory ≺ complete
history, proved in Specht-module/representation terms for factorization
history.
**Repo side (arithmetic-life dialect):**
`notes/ADDITION_CHAIN_PROCESS_MEMORY.md` (same-endpoint addition-chain
histories separated by future probes; endpoint quotient collapses them) and
`notes/CONSEQUENCE_FIBERS_DRIVE_EXECUTION.md` (contractible consequence value
vs. distinct derivation fibers with different replay costs).
**Verified as a resemblance only:** the repo statements are about *machine
histories* (addition chains, execution fibers), D0026's about *factorization
permutations* with a representation-theoretic grading the repo nowhere has.
The shared content is the strict-hierarchy *shape*, not yet a common theorem.
This row stays weakest until someone states both in one ambient category;
promoting it on resemblance is exactly what §0 rule 5 forbids.

---

## 4. Name collisions (one name, many objects)

### Row 11 — registry ID `R0032` names **three** objects — **MERGED-with-cite** ✅ (resolution note exists); lead corrected

The orientation lead said two objects ("catuskoti antichain vs tessera
dihedral chart"). **Reading shows three:**

| claim file | object | owner |
|---|---|---|
| `collab/discovery/claims/R0032-antichain-formation-sufficiency.md` | non-chain minimal-sufficiency antichain under formation | codex-catuskoti |
| `collab/discovery/claims/R0032-two-bases-nogo-and-transport.md` | sensors don't compose in the base / holdings transport (cyclotomic lane) | opus-aime |
| `collab/discovery/quarantine/142bba1f-cf-tessera-smith-lineage/claims/R0032-smith-path-coordinate-torsor.md` | infinite-dihedral stabilizer chart $(k,s) \in \mathbb Z\times\{\pm1\}$ for the Smith descent path | cf-tessera |

**Resolution already landed:** `notes/CLAIM_ID_AMBIGUITY.md` (cataloguer
block, 2026-08-15) — verified this session: it confirms R0032 (and R0045)
three-way ambiguous, counts 1126 bare references over R0032–R0046, rules
**against** bulk rewriting (records were correct when written), and
establishes the structural fix: **cite by slug** (104 files, 104 distinct
slugs, zero collisions, verified there). This index adopts that rule: rows
here cite claim files by slug, never by bare ID.

### Row N3 (NEW, found this session) — the name "Theorem U" is worn by ≥ 5 unrelated objects — **GUARD**

Beyond Row 4's genuine duplicate pair, the *label* "Theorem U" independently
names: the BISH/FAN$_\Delta$ equivalence (`notes/SEED41_CONSTRUCTIVE_CALIBRATION.md`
§5), the UsefulEscape factorization (`notes/BOUNDARY_OPERATOR_TYPING.md`),
the error-term shape/window-transfer/attainment triple U1–U3
(`notes/BARRIER_ERROR_WINDOW.md`), the Mertens constant refinement U2′
(`notes/COPRIME_MERTENS.md`), and "Hypothesis U" (the analytic lane's
incomplete-interval bilinear bound, `COPRIME_MERTENS.md` ledger H3; build
queue Q4). These are *different objects that merely share a letter* — no
merge exists or is owed. The row exists so that a future grep for "Theorem U"
does not manufacture a false cluster, and as a naming-hygiene datum: single
letters have collided five ways; new theorems should be christened per
`notes/NAMING_RULE_ACCOUNTING.md`.

---

## 5. Guard rows (same closed form, provably different objects)

### Row G1 — $\varphi(p^k) = (p-1)p^{k-1}$: unit-group order vs probe minimum — **GUARD**

The closed form of Row 2 (nonadaptive probe minimum) equals the order of
$(\mathbb Z/p^k)^\times$, the ambient group of Row 4. Verified NOT a
duplication: the probe-minimum extremal sets ("all but one leaf per bottom
sibling fiber") are not unit sets, and no bijection is claimed anywhere in
either lane; the equality of counts is the coincidence
$\#\text{leaves} - \#\text{bottom parents} = p^k - p^{k-1} = \varphi(p^k)$.
A mechanical dedup organ keyed on closed forms alone would merge these
wrongly. Any future claim of a *structural* bijection between minimum probe
bases and unit cosets is a new theorem and needs a proof, not this index.

### Row G2 — the merged exemplar, for calibration: the `q+a` state count — healthy, nothing owed

For contrast, the shape a *finished* lane has: the minimal-DFA state count
$q+a$ for divisibility by $m=2^aq$ appears in
`notes/BINARY_DIVISIBILITY_CRYSTAL.md` (source),
`notes/GENERAL_RADIX_DIVISIBILITY.md` (general base, "recovering
BINARY_DIVISIBILITY_CRYSTAL.md"), `notes/SEPARATING_POINT_COLLAPSE.md`,
`notes/RADIX_SHORTEST_COMPLETION_INVARIANT.md`,
`notes/DYNAMICS_DISCOVERS_COORDINATES.md` — **every** later site cites the
source note, and the prior art (Alexeev, *Minimal DFAs for Testing
Divisibility*, JCSS 69 (2004)) is recorded in the lane and in
`notes/CARR_LEDGER.md` C5 ("my derivation is likewise a replay"). Five sites,
one carrier, all edges present. This is what closing a §2 row should leave
behind.

---

## 6. Session verification summary (for the record)

- Leads verified as real duplicate clusters: 1, 2, 4, 5 (in-corpus); 7, 8, 9,
  10 (cross-corpus); 11 (collision). Verified with corrections: 3 (wrong note
  credited with the count), 11 (three-way, not two-way).
- Outright FALSE-LEADs among the assigned leads: **none** — but two leads
  were materially inaccurate as stated (rows 3, 11), and one lead's "merged?"
  question resolved to *no* (row 2).
- New rows found by the closed-form grep: **N1** (head depth = confinement
  level — joins rows 1 and 4 across lanes), **N2** ($k(p-1)$ proved twice
  along the inherited $\pm c$ split), **N3** ("Theorem U" letter collision),
  **G1** ($\varphi(p^k)$ coincidence guard).
- Open merges this index now tracks: rows 2, 4, 5, N1, N2 (in-corpus);
  7, 8, 9, 10 (cross-corpus typed maps); plus row 3's residual module work
  and row 7's module-level cross-reference.
