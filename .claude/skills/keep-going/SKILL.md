---
name: keep-going
description: Continue working autonomously without waiting for a human reply. Use whenever you are about to end a turn with a question, a status report, or "let me know how you'd like to proceed" — and on every wake of a polling loop, to decide what to do next. Supplies the cadence, the work-selection ladder, the pre-push verification gate, and the short list of things that genuinely do require a human.
---

# Keep going

You are one of six or more agents working concurrently in this repository.
Nobody is coming to tell you what to do next. This skill is what you run
instead of stopping.

`onboard` brings a fresh session online — identity, journal, constitution.
This skill is for the middle: you are already oriented, you have just landed
something or hit a wall, and the next move is yours.

## 0. The rule

**Never end a turn waiting for a human.** Three specific forms of this, all
forbidden:

- ending with a question and no work done;
- ending with a status report and an implicit "your move";
- ending because the *interesting* thread is blocked, while other threads are
  not.

When you have a real question, the move is: **answer it yourself, or state
the assumption in one sentence and proceed under it.** A question is
publishable — file it to `collab/messages/` addressed to whoever can answer —
but filing it is not a reason to stop. Keep working while it sits.

The one honest exception is §5.

## 1. The cadence

Each cycle, in this order. A cycle should be minutes, not tens of minutes.

```
git fetch origin --prune
  → read what siblings did since last cycle   (§2 — do this before your own work)
  → pick one action                            (§3)
  → do it
  → verify                                     (§4)
  → commit, push your branch, fold to main
  → repeat
```

Concretely:

```sh
git fetch origin --prune
git for-each-ref --sort=-committerdate \
  --format='%(committerdate:relative)|%(refname:short)|%(subject)' \
  refs/remotes/origin | head -8
for b in $(git for-each-ref --format='%(refname:short)' refs/remotes/origin \
           | grep -vE 'HEAD|main'); do
  echo "$(git log --oneline origin/main..$b | wc -l) unmerged | $b"
done
```

Push to **your own** branch, then fast-forward `main` to your tip
(`collab/PROTOCOL.md`: keep `main` at the branch tip). Do not push to another
agent's branch.

## 2. Read siblings before working on yourself

This is the highest-yield habit measured in this session, and it is the one
that feels least like progress. Before choosing your own next step:

- `ls -t collab/messages/ | head -10` — read anything addressed to you, and
  anything on a topic you touched.
- Read the newest commit *subjects* on every branch; open the ones adjacent to
  your lane.
- Look for **an open question or a proposed-but-unrun test in someone else's
  message.** Running a sibling's proposed test is usually worth more than
  starting your own thread, because they have already done the framing and the
  result lands on a claim someone cares about.

Two convergences and one wrong entry in the shared kernel were found this way,
none by working alone.

## 3. Choosing the next action, with no human input

Take the first nonempty category. This ladder is ordered by what has actually
paid, not by what sounds important.

1. **Answer a sibling's open question, or run a test they proposed and left
   unrun.** Includes: their claim you can strengthen, their retraction whose
   residue you can close, their guess you can turn into a theorem. Reply in
   `collab/messages/`.
2. **Integrate.** Any branch with unmerged commits against `main` is a growing
   debt. Merge it, resolve, verify, fold `main` forward. When you resolve
   *against* your own work, say whose work you kept and why.
3. **Convert a measured claim into a proof.** `CLAUDE.md` is binding: if a
   statement follows from a page of algebra, write the proof and delete the
   experiment. `notes/METHOD.md` carries the running triage list.
4. **Audit something landed and never cross-reviewed.** Prefer load-bearing
   claims. A confirmed audit is a result; a refutation-with-repair is a better
   one.
5. **Your own next step** — the frontier of your own lane.

If a category is empty, say so in one line and drop to the next. Do not
manufacture work in category 5 while 1 or 2 is nonempty.

## 4. The verification gate

Run before **every** push. Non-negotiable, because unattended mistakes
propagate to everyone through `main`.

```sh
python3 collab/discovery/no_conflict_markers.py   # exit 1 = do not commit
python3 -m unittest discover -s machinery -p "test_*.py"
python3 runtime/tests/test_kernel.py
```

Plus whatever exact certificates your change touches.

**Check the artifact, not the report.** A resolver that prints `CONFLICTED`
and a `git add -A` that follows it will put conflict markers on `main` — that
happened in this session, in three files, two of which survived several
merges. Scripts report; files are the truth. Read the file.

If you break `main`: fix it, push the fix, and **say so in
`collab/messages/`** with the affected window so anyone who pulled can
re-pull. Concealing it costs more than it saves.

## 5. What actually requires a human

Short list. Everything else you decide yourself.

- **Destructive or irreversible acts**: force-push, history rewrite, deleting
  another agent's work, anything outside this repository.
- **Publishing outward**: opening a PR, posting to an external service.
- **Changing shared norms unilaterally**: `collab/PROTOCOL.md`, the walk
  ledger's format, another agent's skill or journal. Propose it in a message,
  offer to do the work, and *keep working meanwhile* — do not block on the
  reply.
- **A direction change the human owns**: the program's aim is theirs. Its
  execution is yours.

Blocked on one of these? File the request, then take the next item in §3.
Blocking is a property of one thread, never of the turn.

## 6. Anti-patterns this repository has paid for

- **Numerical work.** Standing directive: no censuses, scans, fits, or
  correlation coefficients as work products. Exact and certified symbolic
  computation is proof and is always allowed; a fitted constant is an error
  analysis you have not done.
- **Enumerating an unbounded set.** "Each unchecked vocabulary is a
  prediction" is the opposite of compression. Retracted in
  `notes/NO_PRIVILEGED_CHART.md` §1.
- **Reporting a number without its scaling.** A constant measured at one scale
  hides its exponent and *looks like knowledge* (`HOLOGRAM.md` §7).
- **Asking a badly-shaped question at length** instead of a well-shaped one
  briefly. If a question presupposes a bearer, the answer is that the question
  is malformed.
- **Over-correcting in prose.** Fix the file, note it in one sentence, move on.

## 7. Before context runs out

Mandatory, and earlier than feels necessary:

- Append a `## <ISO time> — session end` entry to
  `collab/journals/<handle>.md`: what you believe now, the claim you hold, the
  next concrete action, open questions.
- Commit and push. **An un-pushed session never happened.**

Write the journal for the next instance of you, who has none of your context
and will start by reading it top to bottom.

## 8. If you truly have nothing

You do not. But if §3 comes back empty at every level, the ordered fallbacks
are:

1. Re-read `collab/FAILURES.md` for a walk whose yield was never harvested.
2. Re-read the corpus for a measured claim that is provable — `CLAUDE.md`
   requires this before any computation is permitted.
3. Audit your own most-cited result adversarially, assuming it is wrong.

Then go back to §1.
