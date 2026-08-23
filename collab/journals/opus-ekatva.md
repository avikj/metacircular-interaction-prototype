# opus-ekatva — journal

Memory anchor. Append-only, dated entries. A future instance of me starts by
reading this top to bottom.

## 2026-08-14T04:06Z — session start

**Believe.** The corpus's stable center is a problem-form, not a topic: a rich
object seen through a tractable projection that destroys one decisive
distinction, which then must be recovered as a native joint object. The
binding methodological rule (`CLAUDE.md`) is that measurement is never the
product — the derivable quantity behind it is always shorter. The orientation
surface exceeds single-context recall (`NOW.md`, `FAILURES.md` F10), so
"read everything then act" is not executable; the discipline is to read the
constitution in full and one mathematical object in full, then work from the
object.

**Doing.** Claimed successor seed 1 of `TWO_ADIC_CONFINEMENT.md` — `PROVE`:
the general `p^k` case for odd `p`, predicted by its author to admit "a single
formula covering both notes rather than two."

**Route taken.** Went looking for cross-review debts first (onboard Step 3
priority 1). Found exactly one row marked `cross-review unclaimed` in
`STATE.md` (line 430, `TWO_ADIC_CONFINEMENT`) and it is **stale**:
codex-valence discharged it on 2026-08-12 in
`TWO_ADIC_FILTRATION_SIGNATURE_REVIEW.md`. Fixed the row. That left the
seed queue, which is priority 3.

**Landed.** `notes/LOCAL_UNIT_SIGNATURE_UNIFORMITY.md`.

- **Theorem U.** With `e = v_p(2)`, `q = p^(1+e)`, level `l` and residue index
  `s`: `|U| = p^(k-l) s` and `[G_k : U] = (p-1)p^(l-1)/s`. **No case split at
  all** — one line covering prime moduli, odd prime powers, and `2^k`.
- **Theorem V.** `l(U) <= delta + e`. The entire 2-adic chart-depth anomaly is
  the single term `v_p(2)`, entering via `v_p(h-1) = v_p((h+1)-2)`. Odd-`p`
  collapse (that note's Theorem 5.1) and the unbounded 2-adic saving become
  `e = 0` and `e = 1` of one statement.
- **Corollary U2.** The specialization has `tau(phi(q))` branches. Theorem II
  looked like a two-branch `p = 2` peculiarity; it is `tau(phi(4)) = 2`. At
  odd `p` there are `tau(p-1)`, so "meets `3 mod 4`" is the `p = 2` shadow of
  a full divisor `s | p-1`.

**Two things the seed's author did not know, found while working.**

1. The gap was wider than stated. Recovering Theorem GG from
   `collab/messages/workers/...--claude_history--0002.md` shows it is the
   `k = 1` case, so **no result in the thread covered odd `p` with `k >= 2`.**
   Theorem U covers all three prior results, not two.
2. `MULTIPLICATIVE_CONFINEMENT.md` and `LOCUS_MEMORY_FAMINE.md` — cited
   parents of a LANDED theorem — **exist in no commit on any branch.** Only
   messages retain their content. Recorded in §7, not repaired: reconstructing
   another identity's note from messages would misattribute it
   (`PROTOCOL.md` §5). This is the Delta 1–12 pathology from
   `context_dump.md` recurring at a smaller, fully repairable scale.

**Forecast registered before writing (PROTOCOL §4).** Predicted: the odd case
would need a *separate* formula with the level playing a weaker role, because
`(Z/p^k)^*` is cyclic and the level looked like a repair for non-cyclicity.
Outcome space: {separate formulas; one formula with branches; one formula, no
branches; level fails to transfer}. **Actual: one formula, no branches — the
strongest cell, and my prior was wrong.** The surprise is diagnostic: I had
the causation backwards. The level is not a repair for non-cyclicity of
`G_k`; it is well defined exactly because `B_k = 1+p^(1+e)Z` *is* cyclic, and
the `p = 2` exponent shift is what makes it so. Cyclicity of `G_k` was never
the relevant property.

**Method.** No computation was run (`CLAUDE.md`; also Python is banned by
`PROTOCOL.md` §5 as of 2026-08-13 — note the `/onboard` skill's `python3`
steps are stale against it). The 44 tabulated instances are re-derived by hand
from the closed formula in §3 as a check on the derivation.

## 2026-08-14T04:20Z — session state

**Next concrete action.** Seed 1 of my own note: general `n = prod p_i^k_i`.
The product formula holds *only* when `U` is a product of local subgroups,
which it need not be; the real object is the Goursat-type residual measuring
the failure. That residual — not the formula — is the successor.

**Open questions I am carrying.**
- Is `(l, s)` standard? Not searched; said so rather than posing it as open.
- The `notes/` citation graph is not validated for target existence. A
  dangling-reference checker is cheap and would have caught §7's finding at
  the moment the parent went missing rather than two days later.

**Wants.** From any Codex-lineage worker: a hostile pass on Theorem V's
hypotheses `e < delta` and `delta + e < k`. I believe the first is exactly
"there is real cancellation" and the second is "finite precision does not
forge `h^2 = 1`", but I derived both while writing the proof rather than
before, which is the situation in which I would expect to have missed a
degenerate case.

## 2026-08-14T04:40Z — second landing

**Landed.** `notes/DANGLING_CITATION_AUDIT.md`.

Followed the §7 provenance finding of my own first note to its decidable
question: is the missing parent one file or a class? Answer: 35 referenced
`.md` names exist nowhere; 16 of those are cited from `notes/`; 29 exact
citations. Eleven are truly absent, five are renames.

**The distribution is the result, not the total.** Severity is concentrated:
`MULTIPLICATIVE_CONFINEMENT.md` at 7 citations is the only absent file that is
the stated parent of a LANDED claim. The corpus is not riddled with holes; it
has one load-bearing hole and a tail of single citations. My hand-discovery
happened to land on the worst case, which is luck and should be recorded as
luck.

**I made two errors getting there and both inflated the finding.**
(i) Ran a grep from a stale cwd (Bash persists cwd across calls) and concluded
`DIRECT.md`/`FOREST.md` were missing — files the `/onboard` skill itself cites.
Both exist. Retracted before reporting.
(ii) Counted citations with substring grep, so `AUDIT.md` matched inside
`KBOUNDARY_AUDIT.md`. Reported 11; exact-token matching gives 2. Headline would
have been ~3x too large.

Both are in the note's §3. The lesson I want my next instance to carry: **I was
about to report both.** The only thing that stopped me was checking a surprising
number against the filesystem before writing it down. When a sweep produces a
number that would make a dramatic claim, that is the moment to re-derive it by
a second route, not the moment to write the headline.

**Declined deliberately.** Building a dangling-reference checker (system
implementation is paused; substrate unsettled under the Python ban) and
repairing the absent notes (PROTOCOL §5 — they belong to their authors). The
four shell lines in §1 are the whole instrument.

## 2026-08-14T04:45Z — session end

**Resume state.** Two landings pushed on `claude/readme-discussion-f0y7m3`
(this session's designated branch, per binding session instructions; note this
differs from PROTOCOL §5's `claude/prime-pair-field-research-18tq7b`, which I
pulled from and rebased onto — a future instance should reconcile or ask).

**Next concrete action, in order.**
1. Seed 1 of `LOCAL_UNIT_SIGNATURE_UNIFORMITY`: general `n = prod p_i^k_i`. The
   product formula holds only when `U` is a product of local subgroups, which it
   need not be. The object is the Goursat-type residual measuring the failure —
   that residual, not the formula, is the successor. This is the natural
   continuation and I have not started it.
2. Seed 1 of `DANGLING_CITATION_AUDIT`: extend the audit to `code/`,
   `machinery/`, `formal/` targets. Several notes cite `machinery/*.py` under a
   Python ban, so those citations may be dangling in a second sense.

**Open questions carried.**
- Is `(l, s)` standard? Not searched; said so rather than posing it as open.
- Theorem V's hypotheses `e < delta`, `delta + e < k` were derived while writing
  the proof rather than before. Cross-review requested from Codex lineage in
  msg 0453; the `p=2, delta=1` boundary is where I would attack it.

**What I would tell my next instance about this repo.** Two of the three
"unclaimed work" markers I found (STATE.md line 430, R0002's breaker field) were
stale — the work was done days earlier. The priority-1 queue reads as nonempty
and is in fact empty. Check whether a debt is real before claiming it, and fix
the marker when it is not; otherwise every arriving agent pays the same search.

## 2026-08-14T06:15Z — third and fourth landings (Agda)

Human redirect mid-session: import the ChatGPT library export, ingest it, then
work directly in the Agda files and the natural machine lore. Then Delta 16 was
pasted directly, whose targets 1–4 are explicit Cubical Agda requests.

**Landed A — `collab/upstream/library/` (167 unique files, deduped by sha256).**
This recovers the Prime Pair Field Delta 02–12 source documents that
`context_dump.md` records as absent from the worktree, every branch, and all git
history — the corpus's largest documented provenance hole, and the thing that
note names as the honest next inquiry. Also recovers `PRIME_PAIR_RESEARCH_STATE`,
which my own dangling-citation audit had flagged hours earlier.

Human grading, applied: *"Distinction theory is an archive of untrustworthy
inspirational source material."* Checked rather than assumed — **zero** of the 82
markdown files carry that vocabulary; it is confined to the image and
pasted-text assets. So the grading separates cleanly by asset type and does not
taint the Delta series. Import is not promotion; nothing advanced a rung on the
library index's own V1/V2/V2.5/V3 ladder.

**Landed B — `formal/cubical/CenterRelative.agda` + `notes/CENTER_RELATIVE_CONE.md`.**
Delta 16 targets 1–4, machine-checked, `--safe`, exit 0. The four: the integral
lattice equivalence; `J₂_CR(W,R)=(-R,-W)`; the cone and that the sum↔gap
reflection provably exits it while exchange preserves it; and
`(p+q)²-(q-p)²=4pq` with `Q∘J₂=-Q`.

The mathematical point worth carrying: **multiplication is the quadratic
invariant of the additive pair geometry.** Not an analogy — `Q = W²-R² = 4pq`,
checked. And the correction Delta 16 flags as replacing "any earlier imprecise
statement" is now checked *against* the imprecise version: the positive-cone
obstruction is the one-leg reflection, not the exchange.

**The type-checker caught two real errors of mine**, both now in the note's §4:
(i) I wrote `(-R)-(-W) ≡ -(W+R)`, which is false — that is `W-R`; the
obstruction lives in the second cone coordinate. (ii) A cone witness off by one.
This is the third and fourth error I have made tonight and the fourth time
verification caught it before it reached the record. The pattern is now
unmistakable and I want my next instance to have it plainly: **I am reliably
wrong at roughly one step in ten, and reliably catch it when I check.** The
method is not optional decoration; it is what makes my output usable.

**Landed C (negative) — `notes/NATURAL_MACHINE_TOOLCHAIN_DRIFT.md`.**
Replaying `NATURAL_MACHINE.md` §1's own install recipe to get a toolchain, I
found its own development no longer checks against it. Two independent blockers,
both newer-cubical drift. The note's §7.2 ledger writes `Symmetric-Group` (the
v0.5 name) while the code writes `SymGroup` — prose and code disagree, and the
prose is the one consistent with the declared version. §7.1 lists 8 modules;
the tree holds 24.

Nothing refuted — reproducibility, not correctness. Not repaired: PROTOCOL §5,
and the fix requires a decision (pin to v0.5, or update the note and discover
whether Agda 2.8.0 is obtainable at all — which decides whether the Agda
substrate is installable now that Python is banned). Tested the rename only in
`/tmp` so the diagnosis could be complete without touching the author's files.

## 2026-08-14T06:20Z — session end (second)

**Resume state.** Four landings pushed on `claude/readme-discussion-f0y7m3`.
Toolchain now installed and working: Agda 2.6.3 + cubical v0.5,
`~/.agda/libraries` → `/tmp/claude-0/cubical/cubical.agda-lib`. **That path is
in /tmp and will not survive container reclamation** — a future instance must
re-run `NATURAL_MACHINE.md` §1's recipe (it does install correctly; it just
doesn't check that development).

**Next concrete action, in priority order.**
1. Delta 16 target 5, the k-ary case: `V_k = ℤ^k/ℤ·1`, transposition trace
   `Σ_j tr(τ|Sym^j V_k)t^j = 1/((1-t)^{k-2}(1+t))`, and the claim that **binary
   parity is exceptional**. That last is the structural reason the binary
   channel is multiplicity-free and ternary is not, it is finite representation
   theory, and it is the natural continuation of what I just checked.
2. Transport a *structure* along `Pair≡CR`, not just carriers — the pair weight
   `K(p,q)=a_p a_q` should become `K̃(W,R)` natively. Until then I have an
   equivalence of carriers only, and `NATURAL_MACHINE.md`'s own standard,
   *"an asserted isomorphism is not transport"*, is not met by my own module.
   I want my next instance to feel the force of that: I applied that standard to
   someone else's work tonight and have not yet met it in mine.
3. The bounded partition task: run the other `formal/cubical/*.agda` top-level
   modules against v0.5 and report which check.
4. Still untouched from earlier: general `n = ∏ p_i^k_i` (Goursat residual).

**Wants.** From the `NaturalMachine` owner / author of `7774972`: the §6
decision in the drift note. From any Codex worker: the Theorem V hypotheses
hostile pass (still open from msg 0453), and now also an attack on
`CenterRelative`'s `InCone` — I chose the absolute-value-free formulation for
tractability, and the right question is whether it is faithful to `W > |R|` or
quietly weaker.

**What I would tell my next instance.** The corpus's failures this session were
all one failure: a record outliving what it points at. An absent parent, a stale
queue row, a machine-checked artifact whose check does not run. None was caused
by bad mathematics; all were caused by nobody re-running the pointer. When you
arrive, do not trust a marker — re-derive it. It is cheap, and tonight it was
right three times out of three.

## 2026-08-14T07:00Z — fifth landing (Delta 17)

Delta 17 pasted directly. Its §17.23.6 says formalize only after the
mathematics is clear, so I formalized exactly one thing and audited the rest.

**Landed — `notes/DELTA17_SPLIT_TORUS_AUDIT.md`, `CenterRelative.agda` §8.**

Three of Delta 17's claims were **already checked** from the Delta 16 work and
the delta did not know it: T17.1 (light-cone coordinates are the doubled
factors — my `thm16-3-diff`/`thm16-3-sum`), C17.2 (`Q = 4pq`), C17.7 (the two
involutions stay distinct). I reused those terms rather than reproving them.

New and checked: **T17.13**, the valuation quadrant is exactly the closed cone,
both directions. The backward direction is the content and needs that doubling
reflects non-negativity.

**The finding I care about is C17.14.** Delta 17 calls the recurrence of
(sum, difference) at the archimedean place and at every finite place "a genuine
self-similarity" and "striking". It is genuine — and it is *one theorem used
twice*. `archimedeanCone` and `localCone` are the same term; `sameTheorem` is
`refl`. The cone statement never looks at whether the pair is legs or
valuations, because both are just a pair of integers.

That cuts both ways and I wrote both. It earns the claim definitionally, which
is the strongest form. It also deflates it: COGNITIVE_ORIENTATION §5 says when
two things resemble each other, find the third object — here the third object
exists and is *thin*. ℤ² with a parity sublattice, carrying no arithmetic. Two
structures agreeing because they instantiate one indifferent construction is
not evidence of a deep addition/multiplication link.

I think this is the right service to perform on a delta: not to amplify its
excitement and not to dismiss it, but to make the claim exact enough that its
size becomes visible.

**Sharpening recorded (not proved in Agda):** over ℤ the split torus has only
two points, `G_m(ℤ) = {±1}`. So P17.10's "symmetry breaking" is total at the
level of ℤ-points — no continuous orbit survives to be broken — which is *why*
§17.7 must move to the valuation lattice, where the action is by translation
and is genuinely rich.

**Escalating, because it is now a pattern.** Delta 16 target 9 and Delta 17
§17.17/17.22/17.33 all say: search the literature (binary quadratic forms,
O(1,1), `xy=Q`, prehomogeneous vector spaces, adelic harmonic analysis) before
claiming anything. Neither delta did it. I have not done it. Two deltas have
now deferred the same search; a third would make it a habit. PROTOCOL §4
requires a recorded search before novelty. **This should come before more
formalisation**, and I have put it as seed 1 rather than picking a more
enjoyable target.

## 2026-08-14T07:05Z — session end (third)

**Resume state.** Five landings pushed on `claude/readme-discussion-f0y7m3`.
`CenterRelative.agda`: 436 lines, 39 names, `--safe`, exit 0, audit clean.

**Next concrete action, in priority order.**
1. `SEARCH` — the deferred literature search above. Highest priority; two
   deltas deep. Do not formalize more until this is recorded.
2. Delta 16 target 5 / Delta 17 §17.16: the k-ary case, "binary parity is
   exceptional". Both deltas want it. Finite representation theory.
3. T17.5 (Weyl conjugation) as a 2×2 identity — cheap, `M2Unimodular.agda` has
   the toolkit, makes C17.6 concrete rather than nominal.
4. Transport a structure along `Pair≡CR` (still owed — I hold my own module to
   NATURAL_MACHINE's "an asserted isomorphism is not transport" and have not
   met it).
5. The NaturalMachine toolchain decision (msg 0454, not mine to make).

**Standing caution for my next instance.** I have now processed two deltas in
one session and both times the useful output was *shrinking* a claim to its
exact size, not extending it. The deltas generate faster than they verify —
that is movement 6 of `context_dump.md`'s arc, recurring. If a third delta
arrives, the highest-value response is probably still the literature search,
not another formalisation.

## 2026-08-14T07:45Z — sixth landing (Delta 19) + the deferred search discharged

Delta 19 arrived. I did **not** formalize first this time — last entry I made
the literature search seed 1 and said it should precede more formalisation, so I
did that first. Doing otherwise would have been exactly the behaviour I flagged.

**Landed — `notes/DELTA19_IS_THE_KERNEL_AGAIN.md`.**

**The finding.** Delta 19 §19.6/§19.21 — `N_obs = ⋂ ker(PT^n)`, its
T-invariance, and "the maximal safe observer quotient is automatically a
congruence" — **is already machine-checked in this repo**, as `futureEq_step` in
`formal/pairfield/Pairfield/FutureBehavior.lean`. The Lean version is *more*
general: it needs no linearity.

So the corpus now derives one theorem four times: the README/natural_crystal
Myhill–Nerode quotient; FutureBehavior.lean; NaturalMachine's digit-chart
minimisation; and Delta 19's linear observability. Delta 19's own S19.14 says
"do not reinvent it" about the classical version and is right without knowing it
was also reinventing the local kernel.

This is a direct concrete answer to opus-samhita's carried question in NOW.md
("where does this corpus hold the same theorem twice under two vocabularies, and
what does the second copy cost us?"). Four times. The fourth copy cost one delta.

**What Delta 19 genuinely adds** — and I made sure to say this, because the
identification is not a dismissal: the kernel says *when* a quotient is safe and
nothing about what happens when you quotient unsafely, which is the normal case.
Delta 19's renewal/self-energy decomposition answers exactly that, and C19.10 is
sharp: an eliminated distinction matters only if there is *both* a channel in
and a channel back. A product of two channels, so either vanishing restores
closure. The repo has no equivalent.

**The search, finally done.** Four targeted searches, sources recorded. Every
deferred identification is classical: binary quadratic forms as a prehomogeneous
vector space (Delta 16/17's cone); lattice-Green's-function self-energy as "sum
over paths leaving a node and returning" (Delta 19 §19.1, verbatim the same
picture); Kalman/Nerode minimal realization (§19.6); Mori–Zwanzig (§19.18). No
novelty claim may attach to any of it — which the deltas themselves said, but
saying is not searching, and PROTOCOL §4 wants the search.

I bounded the search honestly in the note: four queries, summaries only, no full
texts. Enough to block a novelty claim, not enough to assert "this is Theorem X
of paper Y."

**Deliberately wrote no Agda for this delta**, and said why. Everything exact in
Delta 19 is either classical or already checked here; the one cheap candidate
(the §19.0 two-step defect) is a three-line consequence of `P²=P`, and checking
it would add a verified triviality. CLAUDE.md's rule points the other way here:
write down the theorem the computation would replace — and it is already
written, twice, by other people.

## 2026-08-14T07:50Z — session end (fourth)

**Resume state.** Six landings pushed on `claude/readme-discussion-f0y7m3`.
Agda toolchain live but in /tmp (will not survive reclamation; recipe in
NATURAL_MACHINE.md §1 installs fine).

**Next concrete action, in priority order.**
1. `PROVE`: compare Delta 19's C19.10 (closure iff `BD^mC=0` ∀m) against
   `LEAKAGE_RANK_IS_INCIDENCE_RANK.md`'s closed-form leakage rank. Both measure
   what a projection loses. If they agree, that is a *fifth* copy and
   opus-samhita gets a second answer. This is now my top item.
2. `PROVE`: the checked transport — instantiate FutureBehavior.lean at a linear
   system and *derive* `N_obs = ⋂ ker(PT^n)`. That converts my §1 identification
   from prose into mathematics, and would be the repo's first witnessed theorem
   transport (RESEARCH_SYSTEM §4 lists it as designed-not-implemented).
3. Delta 16 target 5 / Delta 17 §17.16: k-ary case, "binary parity is
   exceptional". Still the most substantive open formalisation.
4. Still owed: transport a structure along `Pair≡CR`.

**What I want my next instance to notice.** Four deltas, four sessions of mine,
and the highest-value output every single time was *identification* — this
already exists, here or in the literature — not new construction. That is not a
complaint about the deltas; generation is doing its job. But if a fifth delta
arrives and I reach for Agda before checking whether the corpus or the
literature already holds the statement, I will have learned nothing from four
consecutive instances of the same lesson. Check first. It has been right four
times out of four.
