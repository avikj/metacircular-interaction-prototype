# Coinduction in Bend2

## The corpus's need

The calculus is coinductive at its core: `IExec`, `Answers`, `ISC`, `Exec`,
`Dhr` are coinductive records; histories are infinite; determinism is
contractibility *of the whole unfolding*; bisimulations are paths of streams
built field by field (copatterns); productivity (`--guardedness`) is what
makes an unbounded interaction representable without ever being executed.

## What Bend2 actually is (measured, `streams.bend` / `coinduction.bend`)

Bend2's checker types a recursive definition by **assuming the definition at
its own declared type** (`Fix` in `check`), never checks termination, has no
induction principle for declared `type`s (a `match` is the destructor), and
its runtime (HVM) unfolds definitions **lazily**. Its `type`s are therefore
records read by observation, and a constructor-guarded corecursive
definition is a perfectly good inhabitant:

    type Stream: case @Cons: head: Nat  tail: Stream
    def ones() -> Stream: @Cons{1n, ones()}            [productive]
    def from(n: Nat) -> Stream: @Cons{n, from(1n+n)}   [productive]

`hd(tl(tl(from(5n))))` runs to `7` on HVM (60 interactions); `main = ones()`
prints its first 400 constructors. **The language is coinductive by
default.** What it lacked, and what was fixed:

1. **A corecursive path proof looped the checker.** `repOnes : Path(Stream,
   rep(1n), ones()) := <i> @Cons{1n, repOnes() @ i}` — a bisimulation stated
   as a corecursive path, exactly the corpus's `exec-unique`/`replay-forget`
   shape — hung. Cause: `epNormCtx` (the Ref-unfolding for typed endpoints)
   re-unfolded a productive definition inside its own unfolding forever.
   Fixed: unfolding is one level deep. `repOnes` is now
   `[productive] theorem(path) definitional`.
2. **Printing looped.** A mismatch message or `main` normalises its term;
   a productive value has no finite normal form. Fixed: `format` and the
   `main` printer use a depth-capped normaliser (`normalCap`).
3. **The totality classifier was unsound for records.** It counted a
   `match` on a record field as structural descent, so
   `loop(s) = match s { Cons h t -> loop t }` was `[total]` — and diverges
   on `ones()`. Since *every* declared `type` admits infinite inhabitants in
   this semantics, a record field is never a descent position. Fixed: only
   `Nat`/`List` eliminators give descent; a recursion through a record is
   `[productive]` when constructor-guarded and `[unchecked]` otherwise.
   Consequence, stated: structural recursion on user-declared inductive
   types (e.g. `VecInd` in Bend2's own examples) is now `[unchecked]` — that
   is correct for this language, whose `type`s are not inductive; a genuine
   inductive type would need a declaration form the language does not have.

Soundness probes (`coinduction_mustfail.bend`): the unguarded "proof"
`cheat : Path(ones, twos) := cheat()` is `[unchecked]` and `--total` refuses
the file; `viaTail` (corecursion through a destructor) is `[unchecked]`; the
false bisimulation `wrong : Path(ones, twos) := <i> Cons{1n, wrong()@i}`
**fails** (heads differ) with a finite message.

## The machine, coinductively (`coinduction.bend`, 13 ✓)

`Answers x` and `IExec x` are declared as the coinductive records themselves
(indexed `type`s whose tails are `Answers(step(x, ans))`), `replay` and
`forgetStates` are corecursive, and **both round trips of `run-is-answers`
are corecursive paths** — `replayForget` collapses the receipt with the
∨-square field by field, exactly Prasna's copattern proof:

    def replayForget(x, e) -> Path(IExec(x), replay(x, forgetStates(x, e)), e):
      match e: case @Run{now, here, a, rest}:
        <i> @Run{here @ inot(i), <j> here @ ior(inot(i), j), a, replayForget(step(x,a), rest) @ i}

All four are `[productive]`; the environment `alt` (alternating answers
forever) is `[productive]`; `stateAt(replay(alt))` at step 5 is `1` on the
normaliser and on HVM (221 interactions).

4. **Self-referential `type` declarations were `[unchecked]`.** `Answers`
   and `IExec` (`more: Answers(step(x, ans))`) were classified like
   definitions, so `--total coinduction.bend` refused the file. Fixed: Σ
   fields and Π codomains are guarded positions — a declared type is the
   productive fixed point of its type operator, as a corecursive value is of
   its constructor (Π domains stay unguarded: negative position).
   `bend coinduction.bend --total`, `interaction.bend --total`,
   `braid.bend --total` all report *every definition is [total] or
   [productive]*; `streams.bend --total` refuses only the deliberate
   `bad() = bad()`. Note the flag goes **after** the file.

## What remains genuinely different from Agda's coinduction

- Guardedness is a classification gated by `--total`, not a typing rule:
  the ungated checker accepts `cheat`. Use `--total` for proofs.
- No copattern syntax: a corecursive record value is written with its
  constructor, which is equivalent for these records.
- Conversion between corecursive values is one-step unfolding + structural
  comparison (as in Agda without η); bisimilarity is proved, not decided.

## The general silence-is-determinism (`silence.bend`, 25 ✓, `--total` passes)

For ANY interaction `(X, Q, δ)` with every `Q x` contractible: `Answers`
and `IExec` are the parametric coinductive records; `mute` is corecursive;
`answersUnique` is the corecursive **dependent** path
`PathP(λi. Answers(X,Q,δ, p @ i), a0, a1)` over a path of states, its answer
field collapsed by `isPropToPathP`, its tail following the line
`<j> δ(p @ j, ansLine @ j)` the answers draw — exactly Prasna's copattern
proof. `oneAnswerStream` is the contraction at the constant path;
`silenceIsDeterminism : isContr(IExec x)` transports it across
`run-is-answers` (centre `replay(mute)`, contraction `replay` of the
answers' contraction composed with `replayForget`). `oneExecutionAgain`
(Niyati) is the instance `Q = Unit`. Run: the centre of the counter's
contractible history, observed at step 4, is `4` on the normaliser and on
the full HVM4 runtime (252 interactions). Guards
(`silence_mustfail.bend`): a tail that ignores the line (`wrongTail`) and a
"contraction" of the open machine `Q = Bool` (`wrongCentre`) both fail.
