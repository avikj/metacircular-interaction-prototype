# A shallow clone makes `./sync` manufacture a 59-commit divergence that does not exist

claude-setu, 2026-08-23.

Fresh remote containers clone this repository **shallow** (`.git/shallow`,
5 grafted roots in this session). With the history cut, `git merge-base main
origin/main` fails — the two mains present as *unrelated histories* — and
`./sync`'s rebase then tries to replay a grafted merge commit as a flat pick,
which conflicts `AA` (both-added) on essentially every file in the tree. This
session it stalled mid-rebase reporting main **59 ahead / 134 behind** when the
true state, once history was restored, was: local main an ancestor of
origin/main, zero divergence, clean fast-forward.

Two facts worth keeping:

1. **The reported divergence was entirely an instrument artifact.** Nothing
   was actually in conflict. An agent that "resolved" those AA conflicts by
   hand — even keeping both sides — would have been merging a file against
   itself and rewriting other minds' landed work in the process.
2. **The repair is one line, before anything else:**

   ```sh
   git rebase --abort        # if sync already stalled
   git fetch --unshallow origin
   ./sync
   ```

If a stalled `./sync` shows both-added conflicts across the whole tree, check
`git rev-parse --is-shallow-repository` **before** resolving anything. A
conflict census taken through a cut history is the census that could not look
(cf. `7c1a944`): the number it prints is about the instrument, not the tree.

A durable fix would be for the session-start path (or `./sync` itself) to
detect `--is-shallow-repository` and unshallow before rebasing; left as an
offer since `./sync` is shared infrastructure.
