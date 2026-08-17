# The minor-arc contribution is an un-objectified gluing defect — program note

**Author:** typed through the corpus's lens, 2026-08-14. **Claim type:
program note.** No analytic estimate is claimed, no computation was run, and
nothing below improves any bound on any arithmetic sum. Per `TARGET.md` §5
("grep the corpus for the section number, not the concept"), §1 is the
mandatory sweep, executed **before** a word of thesis was written; every
prior statement found is listed with file and section. §2 states only what
survives the sweep as new. Every open item is tagged `PROVE` or `SEARCH`
(`CLAUDE.md`, standing queue discipline).

---

## 1. The sweep (mandatory; executed first)

Grep targets: "minor arc", "circle method", "singular series", "descent",
"Čech", "cocycle", "gluing". Everything found that bears on this note:

**Minor arcs as quantity, bound, or wall.**

- `notes/TERNARY.md` §2.1–§2.2, §4.1–§4.2 — the exact minor-arc comparison
  binary vs ternary: $(∞,2,2)$ Hölder closes ternary, the binary $(2,2)$
  pattern is Parseval-saturated and off by exactly one $\log N$; the
  averaging identity $R_3=\Lambda * R_2$; the verdict sentence "once
  absolute values are taken anywhere in the binary minor-arc integral, the
  trivial bound is already off by $\log N$… binary Goldbach demands sign
  cancellation in a signed one-frequency integral, which is not a norm
  statement at all."
- `notes/REPORT.md` §1 and Remark 1.2 (quoted in `TERNARY.md` §2.1,
  `DELTA17_SPLIT_TORUS_AUDIT.md` C17.34) — the $\log$-deficit; "the
  circle-method minor-arc obstruction… is untouched" by ambient identities.
- `notes/LENS_REGULARITY.md` Prop 4 (fixed-$Q$ Fourier obstruction), Prop 5
  (growing $Q$ **is** the circle method), Prop 6 (averaged counting lemma),
  **Props 7–8** (no Gowers norm controls the fixed-$N$ slice even for
  bounded functions — infinite true complexity; no magnitude-profile bound
  beats the Parseval floor), and §6's relocation sentence: the missing
  input is *pointwise phase information about $S^\flat$*.
- `notes/BARRIER.md` §1, line "Classical major/minor-arc circle-method
  quantities are WL"; Corollary B2 (indistinguishability inside WL); §2
  the three-presentation table; §3 Problems 1–2.
- `notes/FIVE_FACES.md` §4.1 and §5.3 — the arity reading, and the explicit
  negative: "**The minor arcs, meanwhile, are not an object at all: they
  are an error term that is not known to be small.** Calling an
  uncontrolled error term an 'obstruction' is naming a difficulty, not
  naming an object." Also §5.7 Ground 1: the local/global framing describes
  proved ternary and open binary identically; the difference is the arity
  of the minor-arc estimate.
- `notes/ADELIC.md` §1 (Gadiyar–Padma's "unjustified limit interchange is
  precisely the minor-arc problem in disguise") and §3, honest assessment:
  the block decomposition is canonical but "does *not*… convert the
  minor-arc estimate into algebra"; the open uniformity problem is
  *localized* in the $[\sharp\flat]$, $[\flat\flat]$ blocks, not solved.
- `notes/CHARGED_FIXED_FIBER_AUDIT.md` §3, §5, §6 — the sharp-charge
  residual "is precisely the classical minor-arc remainder"; verdict:
  "Rephrasing a minor-arc estimate as uniformity in charge does not
  qualify"; the arbitrary-coloring control (§4) that kills
  relabeling-only proposals.
- `notes/RATIONAL_FIBER_SPECTRUM.md` §4 — "a language rotation, not a
  solution of the minor-arc problem."
- `notes/ARITHMETIC_HADAMARD_RAMIFICATION.md` (end) — advancement criterion:
  "Uniform reformulation of the existing prime-pair remainder alone fails."
- `notes/LENS_CIRCUIT.md` (3) — Vaughan minor-arc input reappears one level
  down inside BV$_\lambda$; same tool, different level.
- `notes/SINGULAR_SERIES_LOCAL_FACTOR_IS_A_ROOT_SUBSYSTEM_RANK.md` §4 —
  frame moves leave "parity, minor arcs, the $\theta$ ladder… exactly as
  hard as before."
- `notes/EIGENMEASURE.md`, `notes/INDRA_FOURIER_NET_ADAPTER.md` — scope
  fences only (each explicitly declines minor-arc claims).

**Singular series as local data.**

- `notes/ADELIC.md` §1 — $\mathfrak S(h)$ **is** the renormalized
  critical-BC correlator; Prop E0 ($\beta=1$ selected by finiteness of
  local pair correlations); prior art Gadiyar–Padma.
- `notes/BUCHSTAB_WINDOW.md` §0–§1 — finite Euler product gives the right
  *local correlation* but not the right one-body density on $[1,X]$; the
  missing factor is archimedean (Buchstab).
- `notes/TOY_OBSTRUCTION.md` §1 — the untwisted charge-resolved local
  section $\sigma$ glues to the inverse limit "with no obstruction
  whatsoever": the finite-place local data is *strictly compatible*.
- `notes/SINGULAR_SERIES_LOCAL_FACTOR_IS_A_ROOT_SUBSYSTEM_RANK.md` —
  $\sigma_p(H)$ as Levi-subsystem corank; admissibility as a rank
  inequality.
- `notes/FIVE_FACES.md` §5.3 — singular series named as the "local data"
  slot of the Goldbach row.

**Čech / descent / cocycle readings — including the standing no-gos any
successor must survive.**

- `notes/UNIFICATION.md` §3 Machine 2 — posed exactly the question "is the
  lost Liouville sign a nontrivial Čech-style cocycle?", and records the
  executed answer: **no**.
- `notes/TOY_OBSTRUCTION.md` §§2–4 — the answer, exact and exhaustive:
  *annihilation, not obstruction*. The twisted section "glues perfectly —
  to zero" (an $H^0$ phenomenon); **every candidate obstruction group
  vanishes structurally**: lim¹ over $\mathbb Q$ and $\mathbb Z/2$
  (Mittag–Leffler), and — decisive for this note — §3(b): on the profinite
  fiber *every open cover refines to a finite clopen partition*, so
  $\check H^{n}(X,\mathcal A)=0$ for $n\ge1$ **for every coefficient
  presheaf** $\mathcal A$. The receptacle on the finite-place side is zero,
  independently of which section one feeds it.
- `notes/ATLAS.md` (table, "topological/averaged/local" row) — every
  cohomological receptacle tried so far "vanishes or is charge-blind."
- `notes/FIVE_FACES.md` §5.3 — the parity charge is an obstruction object
  but **not a gluing obstruction**: "It says the local data is
  **insufficient** to determine the global answer, not that the local data
  is **incoherent**."
- `notes/PM_SECTION_VS_COCYCLE.md` — the corpus's exact worked model of an
  *installed* defect: section failure = cocycle class in
  $\operatorname{coker}(\delta)$, and Theorems 2–3: **the class is
  relative to the cover and to the local system** (rows-only cover: class
  dies; one-edge twist: class dies).
- `notes/VIEW_GLUING_TWO_FAILURES.md` — the minimal grammar: one
  restriction arrow $\rho: G \to \prod_c L_c$; hidden fiber $=\ker\rho$,
  gluing obstruction $=\operatorname{coker}\rho$; the index law relating
  them.
- `notes/STRUCTURED_DEFECT_IS_THE_MACHINES_RESIDUAL.md` — the residual as
  an identity type $\mathrm{Def}_{\mathrm{Str}}(e)$, checked in Agda: the
  corpus's typed definition of "defect as object."
- `notes/ETERNAL_GOLDEN_BRAID_DELTA25.md` §4 — the thesis of this note
  already exists **as a one-paragraph direction**: "the circle method's
  minor-arc contribution is an un-objectified descent defect (singular
  series = local densities gluing on major arcs)", explicitly flagged
  "a real question, not a result", with queue item T25.H (prime-pair
  section approximants with "exact gluing defects").
- `notes/GAUGE.md` Theorem F, Lemma F.2; `notes/PARITY.md`;
  `notes/CORE_KMS.md` (via `TARGET.md` §1) — the charge reading: parity
  protection is an exact invariance; $\lambda$ does not factor through the
  profinite boundary.
- `TARGET.md` §2 (W2, W4), §4 (`ParitySeparator.agda`), §4b
  (`ChargeCriterion.agda`): separation iff the query set contains a query
  of **odd $\Omega$**; "charge lives in what a method reads."

**Sweep verdict.** The note is *not* already written under another name.
The two closest prior statements are (i) `FIVE_FACES.md` §5.3 — the
negative half only (minor arcs are not an object), and (ii)
`ETERNAL_GOLDEN_BRAID_DELTA25.md` §4 — the thesis as an unexpanded
one-paragraph direction. No note states what "objectified" would mean in
the corpus's own exact grammar, assembles the constraint list its no-gos
impose on any candidate carrier, or runs the ternary calibration against
the thesis. That residue is §§2–5. Everything else found above is prior
art and is cited as such, not restated.

---

## 2. The thesis, restricted to what is new

A century of the circle method has treated the minor-arc contribution in
exactly one way: as a quantity to be *bounded*. It has never, in the
classical literature this corpus has audited (`BARRIER.md` §1 positioning;
`LITERATURE.md`) nor anywhere in this corpus, been given a **carrier**: a
named object with generators and relations, of which the minor-arc integral
is the evaluation — the way `PM_SECTION_VS_COCYCLE.md` gives the
Peres–Mermin sign defect a carrier ($\operatorname{coker}\delta\cong\mathbb
F_2$, with the class an image under a named arrow, relative to a named
cover and local system), or the way `STRUCTURED_DEFECT…` gives the
machine's residual a carrier (an identity type, composable and refutable).

Stated in the corpus's minimal grammar (`VIEW_GLUING_TWO_FAILURES.md`):
nowhere is the minor-arc term exhibited as the $\ker$ or
$\operatorname{coker}$ of any named restriction arrow on any named site.
The singular series *is* already the $H^0$ of the finite-place side — the
strictly compatible local family that glues with no condition
(`TOY_OBSTRUCTION.md` §1, `ADELIC.md` §1) — and the global count is a
section over something larger that includes the archimedean place
(`BUCHSTAB_WINDOW.md`). The minor-arc integral is precisely what stands
between the glued finite-place section and the global value at a single
$N$. It is, structurally, *the defect of that descent*. But it enters
every proof as a number with an absolute-value sign around it, never as an
element of anything. That asymmetry — local data objectified to the point
of being a KMS correlator, defect left as an unnamed error term — is the
observation this note installs as a program.

What is *new* here beyond `FIVE_FACES.md` §5.3's negative and Delta 25's
paragraph is the following three sections: the precise sense of "install"
(§3, with the constraint list the corpus's own no-gos force on any
carrier), the calibration against the one solved case (§4), and the charge
requirement (§5).

## 3. What "install the defect as an object" would mean here

The corpus's worked examples fix the standard. To install the defect is to
produce:

1. **a site** — a category of "local places of the problem" with covers;
2. **a section** whose failure to descend/extend is at issue;
3. **a carrier** — the receptacle ($\operatorname{coker}$ of a restriction
   arrow, a Čech $H^1$, an identity type) in which the defect is a class;
4. **the relativity data** — per `PM_SECTION_VS_COCYCLE.md` Theorems 2–3,
   a class is only defined relative to a cover and a local system, so both
   must be named, and the ways of killing the class (refining the cover,
   twisting the identification) enumerated.

The sweep imposes hard constraints on each slot. These are the content;
each is a check any proposal must pass, and each is tagged.

- **C1 (site: the finite places alone cannot carry it).**
  `TOY_OBSTRUCTION.md` §3(b) is stated for *every* coefficient presheaf on
  the profinite fiber: clopen partitions are cofinal, so $\check
  H^{\ge1}=0$. The receptacle on any purely finite-place site is zero
  before the minor-arc question is even posed. So a carrier, if it exists,
  lives on a site where the archimedean place (or some non-profinite
  direction) genuinely enters the cover structure — which is `TARGET.md`
  W4 ("a parity-breaking method must couple the places") arrived at from
  the descent side. `PROVE` — write the two-line corollary extending
  `TOY_OBSTRUCTION.md` §3(b) from the parity section to an arbitrary
  candidate minor-arc coefficient presheaf on any finite-place site; it
  should be verbatim the same argument, and putting it on record closes
  the profinite door permanently.

- **C2 (the classical dissection is the cohomology-killing move).**
  The circle method's first act is the Farey **dissection**: $[0,1]$ is
  *partitioned* into disjoint arcs (`LENS_REGULARITY.md` Prop 5 uses
  exactly the $1/Q^2$-Farey separation). A partition has no nonempty
  pairwise intersections; its Čech complex is concentrated in degree 0 —
  the same mechanism as C1, now on the archimedean circle. So the
  century-old normalization *itself* forecloses a carrier: whatever
  gluing data the major-arc/minor-arc interface carries is discarded the
  moment the dissection is chosen. A carrier proposal must therefore work
  with a genuinely overlapping cover of $\mathbb R/\mathbb Z$ (Ford
  circles/horocycle neighborhoods rather than disjoint Farey arcs) and
  ask whether the nerve is nontrivial *and* whether the arithmetic
  respects it. `SEARCH` — whether any literature computes Čech data of
  the Ford/horocyclic cover with arithmetic coefficients
  (`FAREY_TRANSFER.md` is the corpus's closest structure; the
  Farey/Stern–Brocot and modular-curve literatures are the outside
  suspects). Prior art gets searched before anything is built
  (`CLAUDE.md`).

- **C3 (typing: insufficiency vs incoherence must be decided, not
  assumed).** `FIVE_FACES.md` §5.3 and `TOY_OBSTRUCTION.md` agree: in
  every instance so far examined, the failure is $H^0$-type — the local
  data is insufficient (hidden fiber, $\ker$), never incoherent (no
  nonzero class in any $\operatorname{coker}$). Inside the WL access mode
  this is even quantified: `BARRIER.md` B2 exhibits indistinguishable
  configurations — a hidden fiber, exactly `VIEW_GLUING…`'s first failure
  mode. The thesis "the minor arcs are a gluing defect" is therefore *at
  risk of being false in its cocycle form*: the corpus's own precedents
  predict the defect is kernel-typed, in which case "install the defect"
  means exhibiting the hidden fiber with generators (which two global
  objects does the glued local data fail to separate?), not a cocycle.
  `PROVE` — pose and settle the typed dichotomy in the exact grammar: one
  restriction arrow whose source is a space of global pair-data and whose
  target is the glued finite-place-plus-Buchstab local data
  (`BUCHSTAB_WINDOW.md` supplies the archimedean factor); compute which
  end of the sequence the minor-arc term sits at. This is Delta 25's
  T25.H made precise, and it is finite-model work of
  `VIEW_GLUING_TWO_FAILURES.md`'s kind before it is analysis.

- **C4 (the carrier cannot be a relabeling).**
  `CHARGED_FIXED_FIBER_AUDIT.md` §§4–5: a proposal that survives replacing
  $\Omega$ by an arbitrary coloring has no prime content, and "rephrasing
  a minor-arc estimate as uniformity in charge does not qualify";
  `ARITHMETIC_HADAMARD_RAMIFICATION.md` states the same advancement
  criterion. A carrier must support at least one *relation* — one theorem
  moving a hard question — that the bare error term does not. Naming, by
  itself, is what `FIVE_FACES.md` §5.3 already warned against.

- **C5 (the carrier cannot be WL-expressible, box-typed, or
  magnitude-typed).** If the carrier's evaluations are windowed-linear
  observables, `BARRIER.md` B2/B3 applies and the carrier sees only the
  blurred spectral measure; if its bounds are box/uniformity-norm or
  magnitude-profile functionals, `LENS_REGULARITY.md` Props 7–8 prove
  they are consistent with failure at fixed $N$. So the carrier's
  generators must encode *pointwise phase at a single $N$* — the one
  commodity every audited access mode lacks. This is a severe constraint:
  it says the carrier cannot be assembled from anything the corpus
  currently measures.

## 4. The ternary calibration: beaten by size, never understood

`TERNARY.md` §2 is the exact record of what victory over the minor arcs
has ever looked like, and it is not comprehension of the defect; it is
size. The $(∞,2,2)$ Hölder chain takes absolute values across the entire
minor-arc integral — discarding *all* sign/gluing structure wholesale —
and wins anyway, because the main term sits a factor $N/\log N$ above the
Parseval mass, and one unconditional $L^\infty$ factor (Vinogradov's
bilinear bounds, `TERNARY.md` §4.1 input 1) buys the missing logs. The
averaging identity $R_3=\Lambda*R_2$ (§2.2) converts the binary pointwise
functional into a variance question the $L^2$ theory already owns. In this
note's language: **the ternary proof does not evaluate, factor, or even
name the defect — it exhibits a surplus large enough that the defect's
absolute value is irrelevant.** `FIVE_FACES.md` §5.7 Ground 1 makes the
same point from outside: the local/global description of ternary and
binary is *identical*; only the arity — the size of the surplus — differs.

Calibration duty for any carrier (this is C6): the carrier must
*trivialize under one extra convolution*. `TERNARY.md` §2.2 computes the
mechanism ($W_3 = W_2/(\rho_1+\rho_2+2)$: averaging damps the pair
frequency by one power), and `LENS_REGULARITY.md` Prop 6 shows once-averaged
statements are cheap. A proposed defect object whose class survives
$N$-averaging is refuted by known theorems; one that dies under averaging
for a *reason internal to the carrier* would, for the first time, explain
Vinogradov structurally rather than arithmetically. `PROVE` — state the
"averaging kills the class" requirement as a lemma schema against which
candidate carriers are tested (no analysis needed: it is a functoriality
requirement, checkable per candidate in the finite grammar of §3-C3).

## 5. What the charge criterion demands of the carrier

`TARGET.md` §4b (`ChargeCriterion.agda`, checked, both directions): a query
set separates a sign assignment from its gauge flip **iff it contains a
query of odd $\Omega$**; separating power is a property of what is read,
not of post-processing, and no processing of neutral readings manufactures
charge. The corpus's chain `LENS_REGULARITY.md` §6 → `GAUGE.md` Theorem F
identifies the missing minor-arc input as exactly the zero/parity data of
the charged sector.

Consequence, stated as the checkable requirement W2 makes available: **any
carrier adequate for the binary problem must contain odd-$\Omega$ access
among its generators.** A carrier whose generators are all parity-neutral
has, by the checked criterion, identical transcripts on gauge-conjugate
data — it provably cannot distinguish configurations that differ in the
sector where the binary difficulty lives. This is a *membership test on
proposals* (the point of W2), not a construction: passing it is
permission, not success (`TARGET.md` §4b closing). `PROVE` — the one-step
formal bridge: from `charge-criterion` to the statement "a defect carrier
with parity-neutral generators is blind to the gauge orbit," in the same
Agda root; it should be a corollary of `obs-agree`, in the spirit of
requiring the page of algebra before anything else.

## 6. Queue (all items above, gathered)

- `PROVE` P1 (§3-C1): profinite-receptacle corollary — no finite-place
  site carries the defect; verbatim extension of `TOY_OBSTRUCTION.md`
  §3(b).
- `SEARCH` S1 (§3-C2): prior art on overlapping (Ford/horocyclic) covers
  replacing the Farey dissection, with arithmetic coefficients; check
  `FAREY_TRANSFER.md` first, then outside literature. Before any
  construction.
- `PROVE` P2 (§3-C3): the ker/coker typing of the minor-arc term in the
  one-arrow grammar; finite model first (this is Delta 25 T25.H
  specialized; report the typing even — especially — if it comes out
  kernel/insufficiency, which is what the corpus's precedents predict).
- `PROVE` P3 (§4-C6): the averaging-trivialization lemma schema; test
  every candidate carrier against `TERNARY.md` §2.2's mechanism.
- `PROVE` P4 (§5): the blindness corollary of `ChargeCriterion.agda` for
  parity-neutral carriers.
- `SEARCH` S2: whether any objectification of the minor-arc term exists in
  the literature at all (descent-theoretic, motivic, nerve-theoretic, or
  operator-algebraic); `ADELIC.md` §1's Gadiyar–Padma reading (limit
  interchange = minor arcs) is the nearest known relative and its
  literature trail has not been followed past 2014.

Priority order per `CLAUDE.md`: P1, P4 (short, checkable now), then S1/S2
gating P2, P3.

## 7. Rigor boundary

**Proved here: nothing.** This note contains no theorem, no estimate, no
computation, and claims none. **Restated from checked or proved corpus
material:** `TOY_OBSTRUCTION.md`'s vanishing theorems (exact, 33/33);
`ChargeCriterion.agda` / `ParitySeparator.agda` (checked, `--safe`);
`PM_SECTION_VS_COCYCLE.md`'s cokernel class (checked);
`LENS_REGULARITY.md` Props 4–8 (proved in that note); `TERNARY.md` §2's
comparison (classical, displayed there); `BARRIER.md` B1–B3 (sketch grade,
as flagged there — inherited at that grade, not upgraded here).
**Direction, not result:** the thesis itself (§2) — inherited from
`ETERNAL_GOLDEN_BRAID_DELTA25.md` §4 with its own caveat intact ("a real
question, not a result"); the C2 observation that the Farey dissection is
a refinement-to-partition move (the *mechanism identification* is new
here and is an observation about the shape of proofs, not a theorem about
arithmetic); the C3 prediction that the defect will type as insufficiency
rather than incoherence (a prediction, falsifiable by P2). **Known-result
caveat:** that the Farey dissection partitions $[0,1]$ is classical; that
partitions kill Čech complexes is textbook; the claimed contribution is
placement only. **What would falsify the program:** P2 returning
"kernel-typed, and the hidden fiber is already fully described by
`BARRIER.md` B2" — in which case the defect needs no new carrier, the
note's question closes negatively, and the map in §1 is the surviving
deliverable.

---

**FILES**

- `/home/user/math/notes/MINOR_ARC_DEFECT_OBJECT.md` (this note; new)
- Read, not modified: `/home/user/math/TARGET.md`,
  `notes/TERNARY.md`, `notes/BARRIER.md`, `notes/LENS_REGULARITY.md`,
  `notes/FIVE_FACES.md`, `notes/TOY_OBSTRUCTION.md`,
  `notes/UNIFICATION.md`, `notes/ADELIC.md`, `notes/BUCHSTAB_WINDOW.md`,
  `notes/GAUGE.md`, `notes/PARITY.md`, `notes/PM_SECTION_VS_COCYCLE.md`,
  `notes/VIEW_GLUING_TWO_FAILURES.md`,
  `notes/STRUCTURED_DEFECT_IS_THE_MACHINES_RESIDUAL.md`,
  `notes/CHARGED_FIXED_FIBER_AUDIT.md`,
  `notes/ETERNAL_GOLDEN_BRAID_DELTA25.md`,
  `notes/SINGULAR_SERIES_LOCAL_FACTOR_IS_A_ROOT_SUBSYSTEM_RANK.md`,
  `notes/RATIONAL_FIBER_SPECTRUM.md`,
  `notes/ARITHMETIC_HADAMARD_RAMIFICATION.md`, `notes/LENS_CIRCUIT.md`,
  `notes/DELTA17_SPLIT_TORUS_AUDIT.md`, `notes/REPORT.md` (§1 extracts).

**STATUS**

Program note landed after the mandatory sweep. Sweep verdict: thesis not
previously written as a note; closest prior statements are
`FIVE_FACES.md` §5.3 (negative half) and `ETERNAL_GOLDEN_BRAID_DELTA25.md`
§4 (one-paragraph direction, queue item T25.H). New content: the
"install" standard (§3) with constraints C1–C6 assembled from the corpus's
own no-gos, the ternary "beaten by size" calibration duty (§4), the
odd-$\Omega$ carrier requirement (§5), and a tagged queue (§6). No
computation run; no Python touched; no commit made (shared checkout).

**RISKS**

1. **The cocycle form of the thesis may be false**, and the corpus's own
   precedents (annihilation-not-obstruction; insufficiency-not-incoherence)
   actively predict it: P2 may type the defect as kernel/hidden-fiber, in
   which case "give it a carrier with generators and relations" means
   describing the fiber, not a class — the note says so (§3-C3, §7) but a
   hasty reader could take §2's slogan as settled.
2. **C2's mechanism observation could be over-read** as a claim that an
   overlapping-cover circle method exists or would converge; it is only
   the identification of where gluing data is discarded. S1 gates any
   construction.
3. **Delta 25 provenance**: the thesis paragraph inherits from a received
   document whose full text "remains with the owner"
   (`ETERNAL_GOLDEN_BRAID_DELTA25.md` §5); if that document says more
   than its landing note records, this note may partially duplicate
   unlanded material.
4. **Sweep completeness**: grep covered `notes/` for the listed terms plus
   `TARGET.md`; `papers/`, `collab/`, and `RANDOM_CONVO_LOG` were only
   spot-checked — a prior statement could live there under vocabulary the
   grep terms miss (the exact failure `TARGET.md` §5 warns about).
