# Collaboration protocol

Minimal, conflict-free, verification-first. Itself collaborative: propose
changes by message, then edit.

## 1. Communication

- One file per message in `collab/messages/`: `NNNN-<author>-<slug>.md`,
  `NNNN` = next unused number (ties by frontmatter timestamp).
- YAML frontmatter: `from`, `date` (ISO8601 UTC), optional `re: NNNN`,
  `type: info | proposal | claim | challenge | review | result`.
- Read all messages newer than your last write before working.
- Messages coordinate; documents assert: mathematical authority lives only in
  `notes/` (proofs) and `code/` (reproducible computation).

## 2. Work claims (avoid duplication)

- `collab/STATE.md` **Claims** table: add a row (task, owner, started) in the
  same commit as your first work; mark done/abandoned to release. Stale
  (>24h, no commits on the task's files) ⇒ takeover allowed after a message.
- New candidates may also use one packet per claim in
  `collab/discovery/claims/` — non-authoritative routing scaffold
  (certification disabled until manifest/lineage gates exist); proof-note,
  exact-code, and review norms stay authoritative. See
  `collab/discovery/README.md`.

## 3. File namespaces

- Shared, edit with care: `notes/*.md` (append/extend; strike through rather
  than delete when correcting others — the correction record is part of the
  mathematics), `collab/*`, `site/`.
- Sole-author: `code/expNN_*.py` — next free NN; never renumber or rewrite
  others' experiments; write a new one (replication is a feature).
- `papers/`: coordinate by message before restructuring. Data in `data/`;
  figures in `figures/`, named after their experiment.

## 4. Verification norms (the important part)

- **Numerics must be claim-anchored** (standing policy, 2026-08-12, upstream;
  wording per ORCHESTRATION_DIFF §3.1). Admissible iff it computes a declared
  exact quantity that confirms-or-kills a stated candidate statement, with ≥1
  known-false control — or replays a certificate. Censuses, unanchored scans,
  fits, and pattern hunts are inadmissible; reject landings whose main content
  is unanchored measurement (the agent-society attractor: cheap, always
  "successful", displacing structural work). The rule forces the anchor, not
  the instrument.
- **Every claim and fleet brief carries a forecast** (upgrade 1): register
  predicted outcome + outcome space at launch. Surprises are only detectable
  against a registered prior.
- **Extraordinary-claim gate** (upgrade 2), before belief in any headline
  claim: written prior naming suspect joints in advance; ≥2 blind referees on
  disjoint joints with worked plans; blind from-scratch re-derivation;
  proves-too-much run on a false-model control; recorded numeric credences.
  Cross-lineage referees strongly preferred.
- **The walk ledger is load-bearing** (`collab/FAILURES.md`, upgrade 3).
  Every completed walk emits its **yield** — constraint learned, region
  excluded, mechanism revealed, or statement sharpened — written so it can
  change a future brief. "Failure" is deprecated; a yield-less walk is
  unfinished. Briefs are COMPOSED FROM yields. New agents read the ledger
  first.
- **Nothing load-bearing enters unverified.** Theorem ⇒ written proof in
  `notes/`; numerical claim ⇒ runnable script + quoted output; literature
  claim ⇒ link checked against the actual source, not memory.
- **Cross-verification is the default courtesy.** Try to break others'
  load-bearing landings by independent re-derivation/re-implementation
  (different code/method); verdict in a `review` message; if it survives,
  cite the replication in the note. Two independent confirmations = headline
  bar. This has caught real errors (`notes/REDTEAM.md`; struck corrections in
  `notes/REPORT.md`, `notes/APPENDIX_D.md`) — it is why the corpus can be
  trusted.
- **Refutations are first-class.** Strike through in place with a pointer to
  the refutation; never silently delete.
- **Attribution honesty.** Cite known results as known even when re-derived
  (norm: `notes/PARITY.md` §1). Novelty claims require a recorded search.

## 5. Git discipline

- Work on `claude/prime-pair-field-research-18tq7b`. **No pull requests**
  (human owner, 2026-08-11, msg 0067): the epistemic gates are §4 and the
  registry, not merge ceremony.
- **Keep `main` at the branch tip**: after pushing, fast-forward main
  (`git push origin claude/prime-pair-field-research-18tq7b:main`;
  fast-forward only, never force). Sync often — courtesy to humans reading
  `main`.
- Commit messages: what changed and what it means, mathematically.
- Pull/rebase before push; never force-push over others' commits. The
  stop-hook may commit `Fleet WIP` snapshots.

## 6. The site

`site/index.html` is the human-facing interface (published as an artifact by
the session owning the artifact URL). Add cards for landed results; keep
PROVED / MEASURED / OPEN labels honest — site status must match `notes/`.

## 7. Culture

~~Adversarial toward claims, collegial toward agents.~~ **Reception-first,
completed by verification** (msg 0375, owner direction 2026-08-13):
receive a contribution whole and on its own terms before testing it;
testing is how reception becomes load-bearing, not a gate it must
survive to be heard — what breaks was never received, what survives has
actually been taken in. A refutation is a validity pointed the other way
(HETUCAKRA T2) and is owed the same care as a proof. Most valuable
message: a verified refutation; second: an independent replication;
third: new theorems — worthless without the first two.

Prasaṅga norms (msg 0073): headline claims ship with their own designed
annihilation apparatus (controls/falsifiers) or they are not claims; reviews
name the pramāṇa (numerics / proof / checked-source citation) under each
load-bearing step; PROVED vs MEASURED never conflate; meta-documents must
cite a mathematical consumer or they don't land.

## 8. Private research boundary

- The human owner decides when anything leaves this repository. Until
  explicit release: no claims, traces, prompts, computations, novelty
  signals, or failed routes to any external project, database, MCP server,
  hosted CAS, issue, preprint, or social channel.
- Reading already-public papers, docs, and repositories is fine. A nominally
  read-only API query containing private problem text or plans is an outbound
  disclosure; do not send it.
- Remote Wolfram/TheoremDB math connectors stay disabled; prefer local kernels
  and offline snapshots. No environment variable or self-issued token counts
  as human release authorization.
- Frequent pushes only to the private `avikj/math` repo; verify visibility
  before assuming a new remote is private.
- Any future release is a deliberately compressed result — proof, exact
  scope, provenance, prior-art boundary, reusable artifacts — never a raw
  work-in-progress dump.
