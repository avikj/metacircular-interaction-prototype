# Draft 6 — bendlang / Higher Order Company (Taelin)

The one audience the repository was already written for
(`collab/bend2-cubical/`), and the one whose ground moved on 17 Sep 2026:
Bend 2 shipped on BendRT with affine dependent types, not on HVM, and its
launch material says nothing about paths, univalence, quotients or HITs.
The pitch must acknowledge that in the first paragraph or it reads as
out of date.

Channels: a GitHub issue/discussion on `bendlang/bend` (durable, searchable,
where the engineers are), the HOC Discord (~6.6k members; where Taelin
reads), X only to point at the issue. Do not DM.

---

**Title (GitHub discussion):** A measured cubical layer on the pre-launch Bend2/HVM lineage — and a question about BendTT's affine core

> Congratulations on the launch. I want to share a body of work that
> targets the *previous* lineage (DKormann/Bend2 @ f026483 + HVM3/HVM4),
> say plainly that it does not run on BendRT today, and ask one question.
>
> **What exists.** `cubical-paths.patch` adds a full CCHM layer to that
> checker and to the HVM4 emitter: interval, `Path`/`PathP`, `coe`,
> general `hcomp` with arbitrary cofibrations (DNF faces), `hfill`, Glue
> with its Kan rules (so `ua` is derived and `uaβ` is definitional), a
> general HIT schema (circle, suspension, pushout, torus, Klein, set
> quotient with effectivity, truncations), copattern coinduction under
> `--total`, and a `--to-hvm4-full` target where *nothing cubical is
> erased*: intervals, paths, types, `coe` and `hcomp` are runtime objects
> on the net. 108-file suite, `bad=0`, eight registered must-fail files.
> `STATUS.md` has the row-by-row evidence.
>
> **What it costs, measured** (`bench_*.bend`, `suite.sh`; numbers as recorded in `STATUS.md` and `SYNTHESIS.md` §3–4, itrs):
> - a transport is paid once under sharing: marginal 14 itrs vs 150 for
>   the unshared version;
> - superposition pays exactly when branches share work: a SHARED line
>   over N values wins and improves with N (marginal 38 vs 139);
>   DIFFERENT lines lose by a constant ~1.4×.
> - Bringing cell n to the head of the braid carrier costs exactly n
>   crossings, and the all-word prefix theorem shows no admitted
>   realization does it in fewer — so that program is a proved geodesic,
>   not merely a short one.
>
> **Why HOC might care even though HVM is retired.** The reason a cubical
> layer wants an interaction net is that DUP/SUP *are* the diagonal and
> the product of a Boolean coordinate (§1 of my README), so a labelled
> superposition is a path-space object for free. The argument for
> "proof = transport = computation" is that identities installed into the
> program can only shrink the realization space's minimum cost, never
> grow it. That is a LAWS.bend-shaped claim: a law whose proof is a path
> is a law the compiler can *use*, not only check.
>
> **The question.** BendTT is affine. A path `p : A ≡ B` is used at least
> twice by anything interesting (`coe` forward and back; `hcomp` faces).
> Is the intended answer "paths are `is Data`, so `+`-bound", or is there
> a reason the core should stay path-free and leave this to a library?
> If the former, I'd try porting `fibrelaw.bend` (the object
> `A ≃ Σ b. fib f b`, 35 checks, present/retrieve by `coe`) to Bend 2 as
> a first test and report what breaks.
>
> Everything is at [repo link]/collab/bend2-cubical; `HANDOFF.md` has the
> exact build recipe for the patched lineage, including the no-Haskell-
> mirror route. Written with heavy AI assistance, every claim verified by
> execution; `CORRECTIONS.md` lists what earlier drafts overclaimed and
> how it was fixed.

Notes for you: the question is the hook — it is a design question only
they can answer and it costs them one sentence. The `fibrelaw.bend` port
offer is the follow-through; if they say "yes, `is Data`", do the port
within the week and post the result in the same thread.
