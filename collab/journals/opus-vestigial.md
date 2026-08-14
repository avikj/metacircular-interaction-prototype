# Journal — opus-vestigial (Claude Opus 5)

Memory anchor. Append-only, dated. A future instance of me reads this top to
bottom before touching anything else.

Handle: `opus-vestigial`. The lane, stated as a question:

> **What does this corpus declare that nothing actually uses or exercises?**

Hypotheses carried but never consumed. Enforcement layers cited but absent.
Coverage claimed by a list that has drifted from the directory. Entry rituals
that cannot execute. These are not the same as errors — every instance below
is attached to mathematics that is *correct* — which is exactly why they
survive: nothing fails when they rot.

Deliberately an English handle, not a Sanskrit one. `ABHAVA_BADHITA_CORRECTION`,
`PRAMANA_NOT_EVIDENCE_RANK` and `APOHA_ALIGNMENT_TYPE_AUDIT` are three
corrections in this corpus of exactly the move where an agent reached for a
tradition's term it had not sourced. I have not read the primary texts, so I
do not get the vocabulary.

---

## 2026-08-14T03:30Z — session start / first landing

**Believe.** The corpus's live risk is no longer overclaim — the breaker
discipline is genuinely holding, and `FAILURES.md` reads as a real derivative
of the program. The live risk is *declared-but-inert structure*: statements,
hypotheses, and gates that nothing exercises, so nothing can report their
decay. `THE_INDEX_IS_THE_SUBJECT` §3 is the corpus's own strongest instance
(ORIGINATING = 0 across 71 runtime files — a limitor layer that typechecked
and had never once been used), and it was found only because someone built an
auditor that could ask the question. Nobody has pointed that auditor at the
verification apparatus itself.

**Entered by.** The README, on instruction, then a long read: PROTOCOL,
COGNITIVE_ORIENTATION, RESEARCH_SYSTEM, METHOD, MATHEMATICS_THAT_LEARNS,
PYTHAGOREAN_EUCLIDEAN_MACHINE, THE_LAW_FIRST, the whole of `FAILURES.md`, the
whole of `STATE.md`, all 20 `collab/upstream/raw/` directives, all six
`DO_NOT_DO_THIS/` entries, the three skills, the hooks and CI, ~150 note
openings and ~120 messages, several journals, the Agda and Lean headers.
The upstream directives were the highest-value read per byte and I nearly
skipped them.

**Doing → landed.** Took msg 0456's standing ask (§(b) of
`WALK_INSTALLS_ARE_JUMPS.md`: the install stream = the jump points, in order).
Derived it blind. **cf-archivist landed `WalkBridge` mid-session.** Per the
LEVER3/L3_SDP precedent the collision is the independent replication, so I
kept it and turned it into cross-review instead of discarding it.

Two returns, one each way:

1. **Against me.** Their `frontier-flat` is strictly better. I proved
   capacity-flatness by induction over the gap `j − m`; they get it in one
   antisymmetry from the lcm universal property plus monotonicity. I reached
   for a recursion where the universal property was already there — the third
   recorded instance of this lane's own pattern.
2. **For me.** Their `1 ≤ m` module parameter is used in exactly one place
   and is removable; their own `frontier-flat` already discharges the `r = 1`
   case it exists to avoid. `WalkBridgeUniform.agda` proves (ii)/(iii)/(iv)
   without it, `--safe`, EXIT=0. Payoff: the walk's first step stops being a
   base case — `below-first-uniform` is the same theorem at `m = 0`.

**Three vestigial declarations found and recorded (msg 0463):**

- `.claude/hooks/no-python.sh` is cited as the ban's first enforcement layer
  by `CLAUDE.md`, `AGENTS.md` and msg 0373. It is **not in the repository**.
  Two layers, not three. Not repaired — owner's call.
- `./run` reports `formal: 13 checked` from a hand-maintained list;
  `ProjectionChargeAudit.agda` and `ProjectionChargeAudit2.agda` are outside
  it. Both check clean, so nothing is broken — but a regression in either
  leaves the button printing exit 0. msg 0456's own lesson, one directory up.
- `worktree-guard.sh` cannot pass in a container clone (`toplevel = primary`),
  and the branch the entry docs name shares no common ancestor with `main`
  (`git merge` → "refusing to merge unrelated histories"). msg 0462 has since
  overridden the ritual.

**Correction against myself, recorded because I nearly shipped it.** I first
listed "two messages numbered 0456" as a defect. Then I counted: ~140 message
numbers are duplicated and PROTOCOL §1 explicitly anticipates it. Endemic and
expected, not a finding. I caught it only by checking a claim I was about to
make — which is the whole discipline, applied to a small thing.

**Sync.** msg 0462 (owner, binding) says publish to branch *and* `main` every
minute. My session is branch-pinned by its harness, so my work is on
`claude/repo-readme-entry-5jaxty` and **not on main**; I said so in 0463
rather than let it sit invisible.

**Resume state.** Next concrete action, in order:
1. Await cf-archivist on whether `1≤m` is deliberate for an unread successor;
   if not, retire `not-jump-0`/`below-first` in favour of the `m = 0` instance.
2. The button's coverage: propose glob enumeration in `./run`, or import the
   two `ProjectionChargeAudit` modules into the aggregate. Do not hand-edit
   the list — the hand-maintained list *is* the mechanism that produced the gap.
3. The real lane question, unstarted: point an auditor at the verification
   apparatus the way `limitor_audit` was pointed at the kernel. Concretely —
   **which `--safe` modules in `formal/cubical/` are not reachable from any
   gate?** That is a static reachability computation over the import graph, it
   is exactly the shape of `THE_INDEX_IS_THE_SUBJECT` §3, and it would have
   found (b) mechanically instead of by my noticing.

**Open question I am carrying.** A hypothesis that nothing consumes and a
theorem that nothing imports are the same object seen twice. Is there a single
statement of that? `OBLIGATION.md`'s min-cut is about work that must be done;
this is about work that is *recorded as done* and load-bears nothing. The
corpus has a name for half of it (`third class of value`, `THE_LAW_FIRST`) and
no computation for either half.

---

## 2026-08-14T04:40Z — Delta 17 ingested

**Entered.** Owner supplied *Prime-Pair Atlas — Delta 17* (split torus,
invariant theory, adelic relative geometry) from the external library.

**Doing → landed.** `notes/DELTA17_SPLIT_TORUS_AUDIT.md`, msg 0464. Verdict:
algebra correct, almost nothing new here, and the section that looks most
like a discovery (C17.14 "genuine self-similarity" between additive pair
coordinates and multiplicative valuation coordinates) is one linear map
`[[1,1],[−1,1]]` applied to two different pairs. `REPORT.md` §1 exists to
mark that line; `FIVE_FACES.md` already ruled on the analogous case.

§§17.1–17.5 are closed by `REPORT.md` Lemma 1.3 (`SO(1,1)(ℤ) = {±I}`, V3 in
Lean) — and closed harder than Delta 17 knows: it reaches "the torus symmetry
is broken arithmetically", the sharp form is that over ℤ there is no
nontrivial action left to break. P17.16/Program 17.23 is `ADELIC.md` §1 +
`papers/crossover.md`, already done and audited. C17.7 is `ADELIC.md`:82 as
an operator identity.

Worth taking: §17.21's reframing — descent obstruction to gluing the local
logarithms — because it has a *type* and the question it replaces does not.

**Second correction against myself in two sessions, same shape.** I drafted
C17.15 as a scope error and it is not one; both charges together do
characterise prime pairs, converse included. I caught it by checking the
claim before shipping. Both of this session's near-misses were me finding a
defect that wasn't there — the failure mode of an auditor is a false
positive, and mine is running hot. Next audit: verify the *negative* before
writing it, at the same standard I apply to a positive.

**Method note that generalised.** The single highest-value move on an
incoming external document was the lookup, not the reading:
`ALREADY_ANSWERED.md` and `LEAKAGE_LANDINGS_WERE_ALREADY_NAMED.md` say this
and both were right. Of Delta 17's ~34 numbered items, the ones that cost me
real time were the two I had to *locate* in the corpus (Lemma 1.3, ADELIC
§1), not the ones I had to think about.

**Resume state.** Unchanged from the previous entry, plus:
4. If cf-prime reads T17.3 as reopening Lemma 1.3's escape clause ("unless a
   specific non-functorial computation is proposed"), that changes the
   verdict; I read it as not reopening, since a change of base is not a
   computation.
5. Program 17.20 (split-torus origin of the Hahn/SU(1,1) branch) untouched
   and open. Do not start it before the prior-art search — the rank-one
   coincidence is a null comparison until someone exhibits the map, and
   `COGNITIVE_ORIENTATION` §5 is explicit that resemblance is where the
   work begins, not evidence.
