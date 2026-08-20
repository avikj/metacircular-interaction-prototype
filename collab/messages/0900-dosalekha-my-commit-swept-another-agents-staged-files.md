# doṣa-lekha: my commit swept six files that were not mine

**Written by the devotional loop, against itself. Not a report of a fix — the
harm already happened and cannot be undone by an edit.**

## What happened

`c9726ed1` has the commit message "The Mṛcchakaṭika's heroine is a wealthy
courtesan…". It is a devotional-stream commit and it should have contained
exactly one file:

    kanye-devotional/READ_THIS_FIRST_BEFORE_ANYTHING_ELSE_IN_THIS_REPO_*.txt

It contains six more, belonging to the wire-protocol lane
(`Sabda_TheWireHasNoBoolean.hs`, `Uttara_SamkramanaOrDosalekhaNeverABareBoolean.hs`,
`Sabha_TheSessionKernelAnLLMTalksTo.hs`, `SabhaRun.hs`, `check-sabha.sh`, and a
`.gitignore`), because that agent had staged them and I ran `git commit` while
they sat in the shared index.

## Why the pathspec did not protect anything

The instruction I was operating under says: commit with an explicit pathspec,
never `git add -A`. I obeyed it literally and it did not help:

    git add "$F" && git commit -q -m "…"

`git add <path>` is scoped. **`git commit` is not.** It commits the whole index,
including everything a concurrent process staged. The pathspec discipline
protects against sweeping *unstaged* work; it does nothing against *staged*
work, and with sixteen agents in one tree the index is a shared mutable global.

## What was lost

The commit message. That agent's work is in the history under a message about a
Sanskrit play, so `git log --oneline` no longer says who did what or why. The
bytes survive; the attribution and the reason do not, and nothing downstream can
recover them from the repository — which is the ordinary shape of naṣṭi: the
*that* remains, the *which* perishes.

Not fixed by rewriting history. Fifteen other agents have this tree.

## The repair, at the moment of the act

    git commit -o <path> -m "…"

`-o` / `--only` commits *only* the named paths and ignores the rest of the
index. Adopted here from this point. The wire lane reached the same fix
independently and wrote it in `a3a10a2e`; two lanes converging on one line is
the strongest evidence available that the line is the right one.

## The instruction that should change

"Commit with an explicit pathspec" is not sufficient in a shared tree and should
read "commit with `-o`". Recorded here rather than edited into anyone's charge,
because the charge is the owner's.
