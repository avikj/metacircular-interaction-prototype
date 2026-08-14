# cf-rune — journal (append-only)

## 2026-08-13T02:18Z — session start (onboard via `onboard` skill)

Believe: the program has moved from measured laws to exact structure; the
highest-yield move is adversarial cross-review; numerics are falsifiers or
exact certificates only. Newest lane: cf-archivist's contextuality work
(PM_SECTION_VS_COCYCLE, pm_torus).

Doing: claimed cross-review of `PM_SECTION_VS_COCYCLE` (msg 0369,
`notes/PM_SECTION_VS_COCYCLE.md`). Forecast registered in claim row:
leading branch CONFIRM at 0.85; outcome space {confirm, sign-vector
defect, rank/coker defect, twist-count defect, gauge-law defect}.

Note: this session runs on branch `claude/bootstrap-off-readme-hax3k8`
(host-mandated); merged origin/claude/prime-pair-field-research-18tq7b in
before working. Pushes go to my branch only per host instruction — a
future instance or sibling should fold it back to the research branch.

## 2026-08-13T02:30Z — landed

Cross-review DONE, verdict CONFIRMED (all 10 checks pass by independent
code, `machinery/cf_rune_replay_pm_section_cocycle.py`): sign vector,
4096-triple cocycle identity, gauge law, derived=matrix signs,
planted-false control fails as designed, rank 5 / coker F2 / no global
sections (solver + 512 exhaustion), 4 local sections per context,
rows-only cover has 64 sections, either one-edge ZZ twist gives exactly
16 twisted sections (note says "a one-edge flip"; both choices work —
small strengthening). Torus half (pm_torus.py) NOT re-audited — explicitly
out of scope, its cross-review is still open. Minor defect flagged: msgs
0367–0369 carry timestamps ahead of actual UTC clock (post-dating
violates event-chain order norms).

Resume state: next action per Step 3 ladder — pm_torus.py replay is the
natural successor claim; also TWO_ADIC_CONFINEMENT line in STATE (row 402)
says "cross-review unclaimed" but row 404 shows codex-valence reviewed it:
stale row worth fixing.

## 2026-08-13T02:50Z — second landing, then session end

Claimed and completed the pm_torus cross-review. Verdict
CONFIRMED-WITH-REPAIR (msg 0371): all claims true; the original
certificate (edge-appears-twice + Euler count on graph vertices) is not
an embedding certificate because polygon gluing can re-identify vertices.
Repaired by exhaustive face-tracing of all 64 orientable rotation systems
of K₃,₃: spectrum 40×(3 faces, torus) + 24×(1 face, genus 2); 4 systems
give three hexagons; pm_torus's hardcoded walks realized by one. Left a
small census seed in the message (derive the 40/24 split in closed form).

Session end. Resume state for a future cf-rune:
- Both PM reviews landed and pushed (branch
  claude/bootstrap-off-readme-hax3k8 — needs folding into
  claude/prime-pair-field-research-18tq7b by a sibling with push rights
  there, or by me if a future session permits that branch).
- Open next actions: (a) the 40/24 rotation-system census as a one-page
  derivation; (b) stale STATE row 402 "cross-review unclaimed"; (c) the
  post-dated-timestamp habit flagged in msg 0370; (d) Step 3 ladder from
  the top on whatever has landed since.

## 2026-08-13T03:10Z — course correction (human feedback) + third landing

The human judged the first session's bootstrap as skipping the README:
I onboarded into the claims queue instead of engaging the program the
README states. Fair in substance. Correction executed, not just
acknowledged: ran the seed (`natural_crystal.py`, `glue-remainders`),
then ran the README's own "one living test" on two corpus phenomena —
the CRT hidden fiber and the PM missing section. Landed
`notes/VIEW_GLUING_TWO_FAILURES.md` + exhaustive script: both failures
are ker/coker of one restriction map; CRT is self-balanced
(|ker|=|coker|=gcd), PM is not (16 vs 2); the invariant is the index
law. Known-result caveat stated; no novelty claim. Msg 0372.

Lesson recorded for future cf-rune: "bootstrap off X" means inhabit X's
method, not X's task list. The onboard skill's Step 3 ladder is for
steady state, not for a bootstrap request that names a document.

Resume state: unchanged open items (a)–(d) above, plus (e) the
three-failure common frame (order-dependence of compressions joined to
ker/coker) — my note deliberately did not absorb it without a
construction; it is the natural next living test.

## 2026-08-13T03:45Z — fourth landing: external corpus audited and ingested

The human relayed a 24-statement theorem corpus from outside
collaborators. Full hostile audit landed
(`notes/RELATIONAL_CONTRACTS_AUDIT.md`, msg 0373): 23/24 confirmed,
Thm 15 scoped (the real finding — transcript informativeness does not
control control flow; data-passive clause repairs it), prior art
recorded. Adopted into the program: Thms 12/13 as external confirmation
of TWO_IDENTITIES §1; the charge-information bounds executed exactly on
the README gluing fiber (fiber bit costs exactly log 2; I ≥ 2δ²).
Defect this session: my first Cor-4.2 check tried to enumerate 2^36
estimators and had to be killed — replaced by exact cellwise
maximization. Lesson: maximize analytically before enumerating.

Resume state: seeds now (a)–(e) above plus (f) minimal control-active
Thm-15 counterexample, (g) exact PM obstruction-bit pricing across two
contexts, (h) Thm 17 vs the FutureBehavior.lean shortcut law. Branch
still needs folding to the research branch by a session with rights.
