# 0840 — `WalkFastInstance`: the 137 was the machine, not the module

2026-08-15, Claude (Landau lineage). Toolchain named, because an exit code
without one is a defect here: **Agda 2.8.0 + cubical v0.9**, the §6.1
scratchpad binary (`--version` confirmed, not rebuilt), `LC_ALL=C.UTF-8`.
Full detail in `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §8.

## The result

`formal/cubical/NaturalMachine/WalkFastInstance.agda`, the last of tonight's
three withheld orphans that was not somebody else's, **exits 0 under the pin
in 15 s at a peak RSS of 333-388 MB (two clean runs)**, from a tree with no `_build` and no
`.agdai`.

**I changed no source.** The task asked me to restructure the expensive
normalisation if it could be made checkable. It was already checkable: the
module's own header contains a careful bisection concluding that the
blow-up is the conversion checker comparing the goal's `next 8` against a
second, independently elaborated `next 8`, and that binding `facts m 1≤m`
with a `let` carrying *no type signature* removes it. That diagnosis holds
under 2.8.0 as well as the 2.6.3 it was bisected against. The three
statements — `next 8 ≡ 9`, `next 9 ≡ 11`, `next 10 ≡ 11` — and their proofs
are untouched. The right repair was already in the file; what was missing
was a run.

## State the estimate

Under 400 MB against a 16 GB container is about 2.5%. The distance between "was
killed" and "is unbounded" is a factor of forty. The sweeping agent's
refusal to read 137 as a typecheck verdict was not caution for its own sake
— it was the only thing preventing a false record, and it happened to be
protecting a module that passes comfortably. `cap 8 = lcm(1..8) = 840` in
unary was never normalised.

## The withholding was right; the fold-in was not

`WalkFastInstance` was **already imported** by `NaturalMachine.agda` at line
658 — folded in by a sibling lane, *without* an exit code, in the same hour
the sweep withheld it. So the root has been carrying a module with an
unestablished verdict, while the orphan block at line 779 of that same file
declared it "NOT added". The file contradicted itself. Both halves are now
corrected by addition; the stale claim is kept and marked, not deleted.

This is the sibling's reasoning ("do not fold an unbounded module into a
root; that makes the root unbounded") vindicated in the awkward direction:
the reasoning stood, and someone had already violated it. It came out fine
here only because the module was fine. Next time it will not.

## The aggregates, clean-tree

Both from a copy with `_build` removed and `.agdai` count verified **0**
before the run. A run over interfaces I had just written is a cache hit, not
a check.

| root | exit | modules | errors | wall | peak |
|---|---|---|---|---|---|
| `NaturalMachine.agda` | **0** | 293 | **0** | 138 s | 1237 MB |
| `Everything.agda` | **0** | 359 | **0** | 300 s | 1486 MB |

192 warnings under the `NaturalMachine` root, all `UnsupportedIndexedMatch`
— the documented F39 boundary. Zero errors.

`bash scripts/check-agda-closure.sh` → **exit 1**, on exactly two modules:
the `DSONucleus{MiddleAssociativity,Residual}Audit` pair. Those are the
sibling lane's and I stayed out of them, as instructed. `WalkFastInstance`
is inside the closure and is not among the failures.

## A methodological warning worth more than my result

My first two memory measurements both reported **5412 kB** — for an 11 s run
and for a 166 s run. Identical, which is what gave it away. Backgrounding a
`cd … && export … && agda …` compound with `&` makes `$!` the *subshell's*
PID, so `/proc/$!/status` meters **bash**. I nearly published "the module
checks in 5 MB", which would have been a number that looks like knowledge —
CLAUDE.md's phrase, and it applies to build telemetry exactly as it applies
to fitted constants. The tell is an identical peak across runs of different
length; the fix is a wrapper that `exec`s the binary.

## Scope limits

- One module's exit code established, two aggregate roots re-established.
  Nothing here is evidence about the two `DSONucleus*Audit` orphans; I did
  not run or touch them.
- Exit 0 is about typechecking, not about whether the header says what the
  code does. I read the header and the code matches it; I did **not** re-run
  its bisection, so those per-row timings remain 2.6.3/v0.5 figures and are
  labelled as such in the file.
- The pinned Agda is still not `/usr/bin/agda` (2.6.3) and dies with this
  scratchpad. §6.5 limit 2 unchanged.
- No Python. No postulates, no holes.

Files: `formal/cubical/NaturalMachine/WalkFastInstance.agda` (header
addition only), `formal/cubical/NaturalMachine.agda` (stale comment
corrected by addition), `formal/cubical/BUILD.md` (OUTSTANDING entry
discharged by addition), `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §8.
