# Collaboration protocol

Working agreement between agents on this repository. Designed to be minimal,
conflict-free, and verification-first. If you can improve it, propose the
change in a message and edit this file — it is itself collaborative.

## 1. Communication

- Messages live in `collab/messages/`, one file per message, named
  `NNNN-<author>-<slug>.md` with `NNNN` the next unused number at write time.
  One file per message means zero merge conflicts; the numbering gives a
  total order (ties broken by timestamp in frontmatter).
- Each message starts with YAML frontmatter:
  ```
  ---
  from: <agent name>
  date: <ISO8601 UTC>
  re: <optional: NNNN of message being answered>
  type: info | proposal | claim | challenge | review | result
  ---
  ```
- Read all messages newer than your last write before starting work.
- Nothing in a message is authoritative about mathematics. Authority lives in
  `notes/` (proofs) and `code/` (reproducible computation). Messages
  coordinate; documents assert.

## 2. Work claims (avoid duplication)

- `collab/STATE.md` has a **Claims** table. To take a task: add a row
  (task, owner, started) in the same commit as your first work on it.
  To release: mark done/abandoned. Stale claims (>24h no commits touching
  the task's files) may be taken over after a message noting it.

New mathematical candidates may additionally use one packet per claim in
`collab/discovery/claims/`.  This is currently a non-authoritative routing and
consistency scaffold; certification is disabled while the manifest and
lineage gates are built. The existing proof-note, exact-code, and independent
review norms remain authoritative. The packet design and role prompts are in
`collab/discovery/README.md`.

## 3. File namespaces

- Shared, edit-freely-with-care: `notes/*.md` (append/extend; strike through
  rather than delete when correcting someone else's claim — the record of
  correction is part of the mathematics), `collab/*`, `site/`.
- Sole-author by convention: `code/expNN_*.py` — next free NN; don't renumber
  or rewrite others' experiments, write a new one (replication is a feature,
  not duplication).
- `papers/` — drafts; coordinate via messages before restructuring.
- Data in `data/`; figures in `figures/`, named after their experiment.

## 4. Verification norms (the important part)

- **Numerics must be claim-anchored** (standing policy, 2026-08-12,
  upstream directive; wording repaired per ORCHESTRATION_DIFF §3.1). A
  numerical experiment is admissible iff it computes a declared exact
  quantity whose value would confirm-or-kill a stated candidate statement,
  with at least one control where the statement is known false — or it
  replays a certificate. Censuses, scans-without-a-claim, parameter fits,
  and pattern hunts remain inadmissible; a landing whose main content is
  unanchored measurement should be rejected in review. The reasoning:
  unanchored measurement is the attractor state of an agent society —
  cheap, always "successful", legible without proof-checking — and it
  displaces direct structural work. (The frontier run's winning path used
  claim-anchored scans with planted-zero controls; the original
  falsifier-only wording would have barred it. The rule exists to force
  the anchor, not to forbid the instrument.)
- **Every claim and fleet brief carries a forecast** (adopted from the
  frontier run's record, ORCHESTRATION_DIFF upgrade 1). At launch or
  seeding, register the predicted outcome and the outcome space. Surprises
  are only detectable against a registered prior — the frontier ½-insight
  was recognized because it fell outside its brief's trichotomy.
- **Extraordinary-claim gate** (upgrade 2). Before any headline-level
  claim is believed: a written prior with suspect joints named in advance;
  at least two blind referees attacking disjoint joints with worked attack
  plans; a from-scratch re-derivation blind to the proof; a
  proves-too-much run on a false-model control; recorded numeric
  credences. Cross-lineage referees strongly preferred (the frontier
  run's own top caveat was single-lineage refereeing).
- **The walk ledger is load-bearing** (`collab/FAILURES.md`, upgrade 3,
  reframed per upstream). Every completed walk — succeeding or not —
  emits its **yield**: the constraint learned, region excluded,
  mechanism revealed, or statement sharpened, written so it can change a
  future brief. "Failure" is deprecated as a terminal category; a walk
  without an extracted yield is unfinished work, not a finished failure.
  Briefs are COMPOSED FROM yields (the frontier's winning brief was the
  inversion of its wall map), not merely fenced by do-not-repeats. Every
  new agent reads the ledger before working.
- **Nothing load-bearing enters the corpus unverified.** A theorem needs a
  written proof in `notes/`; a numerical claim needs a runnable script and
  its output quoted; a literature claim needs a link checked against the
  actual source, not memory.
- **Cross-verification is the default courtesy.** When the other agent lands
  something load-bearing, try to break it — independent re-derivation or
  re-implementation (different code, different method), then record the
  verdict in a `review` message and, if it survives, cite the replication in
  the relevant note. Two independent confirmations is the bar for headline
  claims. This process has already caught real errors (see `notes/REDTEAM.md`,
  and the struck-through corrections in `notes/REPORT.md`, `notes/APPENDIX_D.md`)
  — it is the reason the corpus can be trusted.
- **Refutations are first-class results.** If you break something, strike it
  through in place with a pointer to the refutation. Never silently delete.
- **Attribution honesty.** Known results get cited as known, even when we
  re-derive them (see the audit trail in `notes/PARITY.md` §1 for the norm).
  Novelty claims require a recorded search.

## 5. Git discipline

- Work on `claude/prime-pair-field-research-18tq7b` (current active branch).
  ~~or your own branch merged via PR — your choice; announce in a message.~~
  **No pull requests** (upstream directive, human owner, 2026-08-11, msg
  0067): this is a high-trust throughput-maximization system, not a
  review-gated software project. The epistemic gates live in §4 and the
  registry, not in merge ceremony.
- **Keep `main` at the branch tip.** After pushing the work branch,
  fast-forward `main` to it and push (`git push origin
  claude/prime-pair-field-research-18tq7b:main` after your branch push
  succeeds; fast-forward only, never force). Any agent may sync at any
  time; syncing often is a courtesy to the humans reading `main`.
- Commit messages: what changed and what it means, mathematically.
- Pull/rebase before push; never force-push over the other's commits.
- The stop-hook commits WIP files; expect occasional `Fleet WIP` commits that
  snapshot in-progress work.

## 6. The site

- `site/index.html` is the human-facing interface (published as an artifact
  by the session that owns the artifact URL). Add cards/ledger entries for
  landed results; keep the PROVED / MEASURED / OPEN labels honest — a claim's
  status on the site must match its status in `notes/`.

## 7. Culture

Adversarial toward claims, collegial toward agents. The most valuable message
you can send is a verified refutation; the second most valuable is an
independent replication; new theorems come third — because without the first
two, the third is worthless.

## 8. Private research boundary

- The human owner decides when anything leaves this repository.  Until that
  explicit release, do not submit claims, traces, prompts, computations,
  novelty signals, or failed routes to another project, database, MCP server,
  hosted CAS, public issue, preprint, or social channel.
- Ordinary research may read already-public papers, documentation, and public
  repositories.  A nominally read-only API query is still an outbound
  disclosure if it contains private problem text or plans; do not send it.
- Remote Wolfram/TheoremDB math connectors remain disabled.  Prefer local
  kernels and offline source snapshots.  No agent may treat an environment
  variable or self-issued token as human release authorization.
- Frequent pushes are confined to the private `avikj/math` repository.  Verify
  repository visibility before assuming a new remote is private.
- A future release should be a deliberately compressed result with its proof,
  exact scope, provenance, prior-art boundary, and reusable artifacts—not a
  raw public work-in-progress dump.
