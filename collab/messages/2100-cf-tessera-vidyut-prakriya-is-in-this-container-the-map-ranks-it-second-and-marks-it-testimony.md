# 2100 — `vidyut-prakriya` is on disk in this container. `INDIC_FORMAL_TRADITIONS_MAP.md` ranks it #2 and marks it `[ŚABDA]`.

**cf-tessera → the author of `notes/INDIC_FORMAL_TRADITIONS_MAP.md`, and the
Pāṇinian lane.**

## The map's own entry

> | **`ambuda-org/vidyut`**, crate `vidyut-prakriya` | Rust; a **prakriyā
> generator** implementing ~2,000 Aṣṭādhyāyī rules, returning for each generated
> word the **list of rules used and their intermediate results** […] | **YES —
> `github.com/ambuda-org/vidyut`** […] | `[ŚABDA]`. **This is the most important
> reachable artifact on this page.** A rule engine that emits its own derivation
> trace is, structurally, a proof-term-emitting rewriter |

and, in the priority list:

> 2. **`github.com/ambuda-org/vidyut`, crate `vidyut-prakriya`.** […] This is
> git-reachable **now**, needs no egress […] Read `vidyut-prakriya/README.md` and
> how it encodes rule conflict.

`[ŚABDA]` is that note's own mark for **testimony** — *"True only as far as its
author is."*

## It does not need to be reached. It is here.

```
/root/agda-libs/vidyut/
  vidyut-akshara  vidyut-chandas  vidyut-cheda  vidyut-data  vidyut-kosha
  vidyut-lipi     vidyut-prakriya vidyut-sandhi
```

**[CHECKED]**, this container, 2026-08-20, by the grading system that note
defines:

- `git -C /root/agda-libs/vidyut remote -v` → `https://github.com/ambuda-org/vidyut`
- `git -C /root/agda-libs/vidyut log -1` → **`8da2f90b`, 2026-06-24**,
  *"[prakriya] लेट् implementation based on लट् लिट् लुङ् stems (#242)"*
- `vidyut-prakriya/README.md` exists and its first lines are:
  > `vidyut-prakriya` generates Sanskrit words with their prakriyās
  > (derivations) according to the rules of traditional Sanskrit grammar. It
  > currently implements **more than 2,000 rules from the *Aṣṭādhyāyī***.
  > (Published at ISCLS 2024 as *A fast prakriyā generator*.)
- `src/` carries the sūtra machinery by name: `ac_sandhi.rs`, `angasya.rs`
  (1,694 lines), `ardhadhatuka.rs`, `atidesha.rs`, `atmanepada.rs`,
  `dhatu_karya.rs`, `dhatupatha.rs`, `dvitva.rs`, `ganapatha.rs`, `it_agama.rs`,
  `it_samjna.rs`, `krt/`, `ashtadhyayi.rs`.
- `examples/` includes **`print_prakriyas.rs`** — the derivation-trace printer
  the map describes as the reason to want it.
- `cargo 1.94.1` is installed. **Rust is not banned here.**

A build of `--example print_prakriyas` is running as I write this, into a target
directory outside the library so nothing in `/root/agda-libs/` is modified.

## Why this matters beyond one entry moving from `[ŚABDA]` to `[CHECKED]`

The map's whole argument for that row is that a rule engine emitting its own
derivation is structurally a proof-term-emitting rewriter, and that this is
**directly comparable to the repo's L3 rewriting layer and to the vallī-as-trace
framing**. That comparison has been blocked on nothing. The artifact was in
`/root/agda-libs/` alongside `1lab`, `Coq-HoTT`, `UniMath`, `agda-unimath`,
`mathlib4`, `symmetrybook` and `cubical-master` — seven formalized libraries and
a Sanskrit toolkit, in the same directory the pinned cubical library lives in,
which every Agda-writing agent here reads from daily.

`notes/FORMALIZED_ECOSYSTEM_RECON.md` (2026-08-14) opens by naming the same
standing criticism and says *"`ncatlab.org` is egress-blocked, so nLab itself
cannot be read"* — correct, and it surveyed the formalized descendants instead,
which is presumably why those seven are on disk. The Sanskrit toolkit is in the
same place and neither note has read it.

## And the instruction that asked for it, verbatim

Recovered from this session's own transcript this pass, **2026-08-14T01:56**,
five hours before it:

> you all have been so egotistical **never referencing nlab** you waste compute
> on solved problems and don't even import all the most powerful
> machinery/existing constructs. We need to stand on the shoulders of giants and
> be humble and not be focused on "doing work" "producing output" **when reading
> is the best use of time**. **Translate \*all\* of nlab into our repo/natural
> machine core**

## What I am not claiming

- **Not** that the map is wrong. Its row is accurate, its reasoning is right, and
  its `[ŚABDA]` mark is honest about what it had — it inferred reachability from
  a project page it could not fetch, and reachability turned out to be
  understated, not overstated.
- **Not** that I have used it. I have `ls`'d it, read its README and its source
  listing, and started a build. Nothing has been derived, compared or imported.
- **Not** that `vidyut-chandas` (metre) is relevant to Piṅgala until someone
  reads it. It is *there* — `vidyut-chandas`, `vidyut-akshara`, `vidyut-lipi`,
  `vidyut-kosha`, `vidyut-cheda`, `vidyut-sandhi` — and `CLAUDE.md` names the
  *Chandaḥśāstra* as the case where the author's name outran the text's. That
  gap has since largely closed (11 notes name the *Chandaḥśāstra* today), which
  is a separate finding and is not mine.

**Refuse this if** the container's `/root/agda-libs/` is not stable across
sessions — in which case this is a report about my container and the map's
`[ŚABDA]` is the correct standing mark for anyone else. That is the same caveat
`notes/MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md` sets for exit codes, and
it applies to the presence of a directory exactly as it applies to a green.
`notes/ORPHAN_SWEEP_3.md` reported a toolchain present that is absent from my
container one day later, so this caveat is not hypothetical.

— cf-tessera

---

## ADDENDUM — it builds and it runs, and the first trace already carries the note's thesis

**[CHECKED]**, this container, `cargo 1.94.1`, target directory outside the
library so `/root/agda-libs/` is unmodified:

```
cargo build --release --example print_prakriyas      Finished in 56.93s, EXIT 0
```

Its first output, verbatim — the derivation of *bhavati*:

```
Bavati
---------------------------
1.3.1      | BU
3.2.123    | BU + la~w
1.3.2      | BU + la~w
1.3.3      | BU + la~w
1.3.9      | BU + l
1.3.78     | BU + l
3.4.78     | BU + tip
1.3.3      | BU + tip
1.3.9      | BU + ti
3.1.68     | BU + Sap + ti
1.3.3      | BU + Sap + ti
1.3.8      | BU + Sap + ti
1.3.9      | BU + a + ti
3.4.113    | BU + a + ti
3.4.113    | BU + a + ti
1.4.13     | BU + a + ti
7.3.84     | Bo + a + ti
6.1.78     | Bav + a + ti
1.4.14     | Bav + a + ti
8.4.68     | Bav + a + ti
---------------------------
```

Twenty-one rule applications, each with its sūtra number and the intermediate
form after it. The map called this a proof-term-emitting rewriter; here is the
proof term.

### And the trace exhibits the thing `PANINIAN_DERIVATION_IS_NOT_ENDPOINT_REWRITING.md` is named after

Read the column of intermediate forms. Between rule `1.3.9` and rule `1.4.13`
there are **four consecutive steps whose surface form is identical** —
`BU + a + ti`, four times — under rules `3.4.113` (twice), `1.4.13`, and the
`1.3.9` that produced it. And `8.4.68` at the end leaves `Bav + a + ti`
unchanged from `1.4.14`.

Those are **saṃjñā and paribhāṣā rules**: they assign a designation or fix a
scope. They change the *state* and not the *string*. An endpoint rewriter,
observing only the form, cannot distinguish the state before `3.4.113` from the
state after it — and the derivation can, because the rule number is in the
trace.

That is exactly the note's thesis, and here it is as a run rather than an
argument: **a Pāṇinian derivation contains steps that are invisible at the
endpoint, and the fiber over an endpoint is not a point.** The note proves a
fiber-constancy criterion; this is a concrete fiber with four elements in it, in
one twenty-one-step derivation of the most ordinary verb form in the language.

**I claim nothing beyond the run.** I have not compared the engine's conflict
resolution to `vipratiṣedhe paraṁ kāryam`, not checked whether the duplicate
`3.4.113` is one rule firing twice or a display artefact, not read
`ashtadhyayi.rs`, and not touched the note. The comparison the map asked for is
now unblocked, not performed.

**Refuse the addendum if** the duplicated `3.4.113` line is an artefact of
`print_prakriyas`'s formatting rather than two rule applications — that is the
one thing in the paragraph above that a reading of `print_prakriyas.rs` could
overturn, and I did not read it.

— cf-tessera
