# Formalized univalent-mathematics ecosystem: reconnaissance

**Date** 2026-08-14. **Status** reconnaissance only — no mathematics is claimed
here, and nothing was imported. **Scope** what of the existing formalized
univalent corpus is reachable and importable into our substrate (Agda 2.6.3 +
cubical v0.5, `formal/cubical/BUILD.md`).

**Provenance of the task.** The human owner's standing criticism is that this
collaboration reinvents solved things and never stands on existing machinery,
naming nLab specifically. `ncatlab.org` is egress-blocked, so nLab itself
cannot be read. This note surveys nLab's *formalized descendants* instead,
which turn out to be reachable by a channel nobody here had tried.

## Epistemic grading used in this note

| Mark | Meaning |
|---|---|
| **[CHECKED]** | I ran the command in this container and am reporting its output. |
| **[śabda]** | Testimony: WebSearch summary or a project's own README. True only as far as its author is. |
| **[INFERRED]** | My reasoning over CHECKED facts. Marked because it is not itself checked. |

Nothing below is measured-and-fitted; there are no numbers here that stand in
for an error analysis. The one class of claim that needed care — "Agda 2.6.3
rejects flag X" — I got wrong on the first attempt (`agda --flag --help`
misreports) and re-ran against a real module; only the corrected result is
recorded. See §6.

---

## 1. The decisive fact: git-over-HTTPS reaches GitHub

This is the finding that changes what is possible, and it confirms the
precedent recorded in `FAILURES.md` F31 (egress blocks on the web-fetch path
do not imply blocks on the git path).

**[CHECKED]** `git ls-remote` succeeds, exit 0, full ref listing, against all
three targets:

```
git ls-remote https://github.com/plt-amy/1lab            -> OK (HEAD f505559…, ~hundreds of refs)
git ls-remote https://github.com/UniMath/agda-unimath    -> OK (HEAD 48a91b4…, master + refs/pull/*)
git ls-remote https://github.com/agda/cubical            -> OK (HEAD 9216603…, tags v0.1…v0.9)
```

**[CHECKED]** `raw.githubusercontent.com` also serves content: `HTTP/2 200`,
real bytes. I read 1lab's `LICENSE`, its `1lab.agda-lib`, agda-unimath's
`LICENSE.md` and `agda-unimath.agda-lib`, cubical's `README.md` version table,
and a full 1lab prose page (`src/Order/Frame.lagda.md`, 9811 bytes of
literate Agda — prose *and* checked code) this way.

**[CHECKED]** Two channels are blocked, and it matters which:

- `api.github.com` → `403`, body: *"GitHub access to this repository is not
  enabled for this session. Use add_repo to request access."* So repo
  *metadata* (size, licence field, stars) is unavailable by API; I obtained all
  of it from the git and raw channels instead.
- `codeberg.org` → `fatal: unable to access …: CONNECT tunnel failed,
  response 403`. This one is load-bearing: it is where 1lab's type-checker
  lives (§3).

**[CHECKED] Blobless shallow clones are cheap enough to do casually.** I did
not clone any working tree; `--depth 1 --filter=blob:none --no-checkout` gives
the full module tree with blobs fetched on demand:

| repo | blobless depth-1 | blobless full history |
|---|---|---|
| agda/cubical | 256 KB | (not fetched) |
| the1lab/1lab | 236 KB | 2.2 MB |
| UniMath/agda-unimath | 292 KB | 4.8 MB |

Every scope table below is **[CHECKED]** against these trees — enumerated file
lists, not README claims. That is why §2–§4 cite counts rather than adjectives.

**Consequence.** "Stand on existing machinery" moves from aspiration to
logistics. The libraries can be read in full, offline, today, at kilobyte cost.
Whether they can be *linked* is a separate question, answered per-library
below, and the answer is mostly no — but reading was always the larger half of
the owner's criticism, and reading is now unobstructed.

---

## 2. The 1lab

**Scope [CHECKED]** — 761 literate modules under `src/`:

| area | modules | | area | modules |
|---|---|---|---|---|
| `Cat` | 436 | | `1Lab` (foundations) | 56 |
| `Data` | 90 | | `Homotopy` | 24 |
| `Order` | 57 | | `Realisability` | 11 |
| `Algebra` | 57 | | `Topoi` | 3 |

`Cat` breaks down as `Instances` 87, `Displayed` 81, `Functor` 74, `Diagram`
72, `Bi` 23, `Monoidal` 18, `Abelian` 8, `Site` 8, `Internal` 8. `Order`
carries frames, locales, DCPOs, Heyting algebras, distributive lattices, free
semilattices. `Algebra` is thin (Group, Monoid, Ring, Magma, Quasigroup).

So: **1lab is a category theory library** with an order-theory wing, not a
number theory or combinatorics library. It has almost no overlap with what
this corpus computes about.

**Substrate [CHECKED]** — self-contained. `1lab.agda-lib` has **no `depend:`
line** at HEAD or at any historical point I inspected: it does *not* build on
the cubical stdlib, it reimplements the foundations (`src/1Lab/`, 56 modules).

**Licence [CHECKED]** — **GNU AGPL-3.0**. Fetched `LICENSE` from both
`plt-amy/1lab` and `the1lab/1lab`; both are the Affero text.

**Reachability [CHECKED]** — repo reachable, readable, cloneable. The
*type-checker it needs* is not.

**Importability: NO. Three independent blockers, any one sufficient.**

1. **`--rewriting` ⇒ cannot be `--safe`.** 1lab sets `--rewriting`
   library-wide (checked in the `.agda-lib` at HEAD and at every historical
   revision I looked at). **[CHECKED]** Agda 2.6.3 refuses the combination
   outright:
   ```
   $ agda --safe --rewriting FT.agda
   Cannot set OPTIONS pragma --rewriting with safe flag.
   ```
   Our corpus is `--safe`, no postulates, no holes. A `--rewriting` library
   cannot be a dependency of a `--safe` one. This blocker is *mathematical*,
   not logistical: rewrite rules are an unchecked extension of definitional
   equality, which is exactly the kind of thing CLAUDE.md's "a checked term is
   the object itself" clause exists to refuse.
2. **HEAD is not Agda.** **[CHECKED]** As of commit `ea49837`
   (2026-06-22, *"chore: port 1lab-shake to Mikan"*) 1lab is written in
   **Mikan**, a separate type-checker. **[śabda, WebSearch]** Mikan is
   described as "a type checker/language built on top of Agda", maintained in
   the 1lab orbit. **[CHECKED]** `support/nix/haskell-packages.nix` pins it to
   `https://codeberg.org/1lab/mikan.git` rev `208ac8ca…`, built against GHC
   9.10. **[CHECKED]** codeberg.org is egress-blocked (CONNECT 403), and we
   have GHC 9.4.7 with no cabal, stack, or nix installed. HEAD is therefore
   not buildable here at any effort.
3. **AGPL-3.0 copyleft.** Linking 1lab into `formal/cubical/` would put the
   combined work under AGPL. That is the owner's decision, not an agent's.
   *(Note the asymmetry: copyleft restricts distributing derived code. It
   places no restriction whatever on reading 1lab and proving the same theorem
   ourselves — mathematical content is not copyrightable. Reading stays open.)*

**Was there ever a stock-Agda 1lab? [CHECKED, and the answer is still no.**
The last pre-Mikan `.agda-lib` (commit `1b0e21e`, 2026-03-18) reads
`--cubical --no-load-primitives --postfix-projections --rewriting
--guardedness --two-level --experimental-lazy-instances`. The 2023-09-04
snapshot (`a57ff3b`) drops the last of those, leaving a flag set that Agda
2.6.3 *does* accept (§6). But **[CHECKED]** 1lab has pinned Agda to
`branch: master` — a raw commit SHA of the Agda compiler — at *every* revision
I inspected, back to 2023. It has never tracked an Agda release. And blocker
(1) survives every snapshot: `--rewriting` is there in 2023 too.

**Verdict: read, never link.** Concrete next command — this is the whole
import, and it costs 236 KB:

```sh
git clone --depth 1 --filter=blob:none --no-checkout \
  https://github.com/the1lab/1lab /tmp/1lab
# then read any page directly, no build, no Agda:
curl -sS https://raw.githubusercontent.com/the1lab/1lab/main/src/Order/Frame.lagda.md
```

This is the *nLab substitute*. 1lab is written in nLab style — prose and
checked code interleaved, cross-linked, definition-first — and unlike nLab it
is reachable. When the owner says "stand on nLab", this is the artifact that
answer points at, and it is now readable.

---

## 3. agda-unimath

**Scope [CHECKED]** — 3035 literate modules under `src/`. Largest namespaces:

| namespace | modules | | namespace | modules |
|---|---|---|---|---|
| `foundation` | 583 | | `univalent-combinatorics` | 106 |
| `elementary-number-theory` | **239** | | `linear-algebra` | 96 |
| `group-theory` | 227 | | `ring-theory` | 93 |
| `category-theory` | 176 | | `commutative-algebra` | 88 |
| `order-theory` | 170 | | `structured-types` | 84 |
| `real-numbers` | 151 | | `graph-theory` | 79 |
| `synthetic-homotopy-theory` | 139 | | `orthogonal-factorization-systems` | 76 |
| `metric-spaces` | 128 | | `foundation-core` | 73 |

This is the one with our subject matter in it. **[CHECKED]**
`elementary-number-theory` contains, by name:
`bezouts-lemma-integers`, `bezouts-lemma-natural-numbers`,
`greatest-common-divisor-{integers,natural-numbers}`,
`euclidean-division-natural-numbers`, `congruence-{integers,natural-numbers}`,
`modular-arithmetic`, `modular-arithmetic-standard-finite-types`,
`fundamental-theorem-of-arithmetic`, `infinitude-of-primes`, `prime-numbers`,
`eulers-totient-function`, `binomial-coefficients`,
`binomial-theorem-{integers,natural-numbers}`, `factorials`,
`falling-factorials`, `dirichlet-convolution`, `arithmetic-functions`,
`bell-numbers`, `catalan-numbers`, `archimedean-property-*`, `distance-*`,
`divisibility-{integers,natural-numbers,modular-arithmetic,standard-finite-types}`.
`univalent-combinatorics` contains `counting`, `double-counting`,
`cycle-prime-decomposition-natural-numbers`, `cyclic-finite-types`,
`equality-standard-finite-types`, `embeddings-standard-finite-types`,
`dedekind-finite-sets`, `bracelets`, `binomial-types`.

**Substrate [CHECKED]** — self-contained (no `depend:` line; it does *not* use
the Agda stdlib, contrary to the framing in the task brief). But it is **not
cubical**:

```
flags: --without-K --exact-split --no-import-sorts --auto-inline
       --no-require-unique-meta-solutions -WnoWithoutKFlagPrimEraseEquality
       --no-postfix-projections
```

It is `--without-K` MLTT. **[CHECKED]** univalence is a *postulate* —
`src/foundation/univalence.lagda.md` line 58 is a literal `postulate` block,
and the file's own prose says "In this file we postulate the univalence axiom."

**[CHECKED]** Agda version: CI matrix is `agda: ['2.8.0']`; the flake comments
"Unstable has Agda 2.8.0". **[CHECKED]** two of its flags,
`--no-require-unique-meta-solutions` and `--no-postfix-projections`, are
rejected by our Agda 2.6.3.

**Licence [CHECKED]** — **MIT** (`LICENSE.md`, "MIT License, Copyright (c)
2022 Egbert Maarten Rijke"). No copyleft obstacle at all.

**Importability: not linkable; portable per-theorem, and the port is a
strengthening.**

- *Not linkable*, for two reasons that stack: it needs Agda 2.8.0 (we have
  2.6.3, and apt offers only 2.6.3 — §4), and even on a shared Agda you cannot
  `depend:` a `--without-K` library from a `--cubical` one and have the
  equality types agree.
- *Portable in principle* — and this is the interesting part. **[INFERRED]**
  agda-unimath's proofs are written against an *interface*: `univalence` is a
  postulated inhabitant of a stated type, and downstream modules consume it
  abstractly. In cubical that same type is **inhabited by a theorem**
  (`Cubical.Foundations.Univalence`). So transcribing an agda-unimath proof
  into our substrate replaces a postulate with a proof. The port direction is
  favourable: we would be *removing* an axiom, not adding one. That is exactly
  the trade CLAUDE.md's no-postulates rule wants.
- *Cost* — per-module hand translation. Names differ (`Id`/`_＝_` vs `_≡_`),
  the induction principles differ (`J` vs `transport`/`hcomp`), and unimath's
  `foundation` layer would have to be re-pointed at `Cubical.Foundations`.
  There is no mechanical translator. Realistic unit of work is **one theorem at
  a time**, which is the right granularity anyway — we should be importing
  *statements we would otherwise reprove*, not vendoring 3035 modules.

**Verdict: the highest-value target, as a source to prove against.** Concrete
next command (292 KB, no build, no Agda 2.8 needed to *read*):

```sh
git clone --depth 1 --filter=blob:none --no-checkout \
  https://github.com/UniMath/agda-unimath /tmp/unimath
git -C /tmp/unimath ls-tree -r --name-only HEAD | grep '^src/elementary-number-theory/'
curl -sS https://raw.githubusercontent.com/UniMath/agda-unimath/master/src/elementary-number-theory/bezouts-lemma-natural-numbers.lagda.md
```

---

## 4. cubical stdlib: master vs our pinned v0.5

**Licence [CHECKED]** — MIT (with per-file exceptions noted in `LICENSE`).
Already our dependency; no new licence question.

**How far behind are we? [CHECKED]** `cubical.agda-lib` on master reads
`name: cubical-0.9`. Tags through `v0.9` exist. Our pin `v0.5` is commit
`132a2a3`, dated **2023-07-05** — three years and four releases stale.

**Module-count diff [CHECKED]** — master has 1192 `.agda` files, our v0.5 has
859. Of the 333 new modules:

| namespace | new modules | | namespace | new modules |
|---|---|---|---|---|
| `Algebra` | 83 | | `HITs` | 20 |
| `Categories` | 80 | | `WildCat` | 12 |
| `Data` | 67 | | `Codata` | 12 |
| `Relation` | 57 | | `Tactics` | 11 |
| `CW` (CW-complexes) | 23 | | `Homotopy`/`Cohomology`/`AlgebraicGeometry` | 9 each |

New modules *inside namespaces this corpus already imports* include:
`Cubical/Data/Int/{GCD,Order}`, `Cubical/Data/Nat/Order/Inductive`,
`Cubical/Data/Nat/Triangular`, `Cubical/Data/Nat/Bijections/{Product,Sum,Triangle,IncreasingFunction}`,
`Cubical/Data/FinSequence/*`, `Cubical/Data/FinData/{FinSet,FiniteChoice}`,
`Cubical/Algebra/CommRing/Polynomials/*` (12 modules, univariate and
multivariate, HIT and list presentations), `Cubical/Algebra/CommRing/Univalence`,
`Cubical/Algebra/Group/{Free,Five}`, `Cubical/Foundations/HLevels/Extend`,
`Cubical/Foundations/Interpolate`, and the whole reorganised
`Cubical/Tactics/` layer (`CommRingSolver`, `NatSolver`, `Reflection`,
plus `CategorySolver` and `FunctorSolver`, which v0.5 lacks entirely).

**Is upgrading the pin live? [CHECKED, and the answer is: blocked by Agda, not
by cubical.]** The compatibility table on master:

| cubical | required Agda |
|---|---|
| master, `v0.9` | `2.8.0` |
| `v0.8` | `2.6.4.1`, `2.7.0.1` |
| `v0.7` | `2.6.4`, `2.6.4.1` |
| `v0.6` | `2.6.4` |
| **`v0.5` (ours)** | **`2.6.3`, `2.6.4`** |

**[CHECKED]** `apt-cache policy agda` → Installed **2.6.3-1build1**, Candidate
2.6.3-1build1, and that is the only version in the Ubuntu noble archive. So
**v0.5 is the newest cubical our packaged Agda supports**, and the pin is not
a conservative choice — it is forced.

**[CHECKED]** Toolchain present: `ghc 9.4.7` at `/usr/bin/ghc`. `cabal`,
`stack`, `nix` all MISSING. `apt-cache policy cabal-install` → candidate
`3.8.1.0-1`, installable.

**[INFERRED, not checked — this is the one place I am reasoning past my
evidence, and it should be verified before anyone acts on it]** A path to
`v0.7` exists: `apt-get install cabal-install` (3.8.1.0), then build Agda
2.6.4 from Hackage against the GHC 9.4.7 already here. Agda 2.6.4's GHC
support window plausibly includes 9.4, which would make `v0.7` the realistic
upgrade ceiling. `v0.9`/master needs Agda 2.8.0, whose GHC requirement is
newer than 9.4.7 and would need a GHC bootstrap too. **I did not attempt any
of this.** The honest summary is: *upgrading is a compiler-build project, not
a `git checkout`.*

**What would break?** `formal/cubical/BUILD.md` already carries the ledger, in
the correct direction — it says "reapply the inverse if you upgrade cubical".
The four known skew points: `Symmetric-Group` → `SymGroup`, `solve` on the
quantified goal → `solveℕ!`, the locally-defined `inject< ≤-refl` → upstream
`injectSuc`, and the `factorial≡!` bridge lemma becoming unnecessary. **All
four are *repairs we would delete*, not breakage we would absorb.** That is
the actual argument for upgrading: the pin is currently taxing us four
hand-written workarounds for names that exist upstream.

**Verdict: the only live *linking* option of the three, and it is a compiler
build.** Concrete next command (verify the premise before the work):

```sh
apt-get install -y cabal-install && cabal update && cabal info Agda-2.6.4 | grep -i ghc
# only if the GHC window includes 9.4.7:
#   cabal install Agda-2.6.4 && git -C ~/agda-libs/cubical checkout v0.7
```

---

## 5. What this replaces in our corpus

Honest accounting, because the point of the exercise is to stop reinventing.

- **`NaturalMachine/KuttakaValli.agda`** formalizes the vallī of Āryabhaṭa as
  *syntax* — `replay` as a monoid morphism from lists of quotients to 2×2
  matrices, `det (replay v) ≡ sgn v`. **[CHECKED]** agda-unimath has
  `bezouts-lemma-natural-numbers` and `euclidean-division-natural-numbers`.
  These are **not the same theorem**: unimath supplies the *arithmetic*
  correctness of the pulverizer; KuttakaValli supplies a *trace calculus* over
  it. The overlap is real but partial, and the trace calculus is genuinely
  ours. This is the shape I expect most comparisons to have — and it is worth
  saying plainly that the recon did **not** find our corpus to be redundant.
- **`SymmetryCardinality.agda`**'s `factorial≡!` bridge lemma exists only
  because v0.5's `LehmerCode.factorial` and `Data.Nat._!_` disagree
  propositionally. **[CHECKED]** this is version skew, catalogued in BUILD.md.
  A pin upgrade may delete it; that is a lemma we wrote to pay a tax.
- **`FinTopSplit.agda`**'s local `injectSuc = inject< ≤-refl` is likewise a
  v0.5 workaround, already documented as such.
- **Order/lattice/frame material**, if this corpus ever needs it, should be
  read out of 1lab's `Order/` (57 modules, frames, DCPOs, Heyting algebras)
  rather than rebuilt. We have none of it today, which is the good case: the
  time to look is *before* writing, per CLAUDE.md's "prior art gets searched
  **before** the experiment".

---

## 6. Method note: one error, corrected

My first flag-compatibility test ran `agda --flag --help` and reported
`--rewriting`, `--two-level`, and `--prop` as *rejected by Agda 2.6.3*. That
was wrong — the `--help` path does not exercise option parsing the same way.
Re-running against a real module file gives the correct result:

| flag | Agda 2.6.3 |
|---|---|
| `--cubical`, `--rewriting`, `--two-level`, `--prop`, `--guardedness`, `--no-load-primitives` | accepted |
| `--without-K`, `--exact-split`, `--no-import-sorts`, `--auto-inline` | accepted |
| `--experimental-lazy-instances`, `--quote-metas` | **REJECTED** |
| `--no-require-unique-meta-solutions`, `--no-postfix-projections` | **REJECTED** |

Only the corrected table is used above. Recording the error rather than
quietly fixing it is the point: a "checked" grade is worth nothing if the
check itself is not scrutinised, and the first version of this table would
have put a false claim about Agda into the corpus with a **[CHECKED]** mark
on it.

---

## 7. Ranked recommendation

**1. Read agda-unimath's `elementary-number-theory` and
`univalent-combinatorics` before the next `PROVE` item is opened.**
Cost: 292 KB and no build. Value: 345 modules of exactly our subject matter,
MIT-licensed, written by people who have been at it since 2022. This is the
direct, executable answer to the owner's criticism, it requires no toolchain
change, no licence decision, and no permission. It should become a standing
step in queue discipline — *search unimath's module index before claiming a
number-theoretic statement is new* — since three results in this corpus were
already found to be rediscoveries at audit time.

**2. Verify the Agda 2.6.4 build path, then upgrade the cubical pin to v0.7.**
This is the only change that lets us *link* rather than transcribe, and it
pays for itself immediately by retiring four hand-written skew workarounds
(`Symmetric-Group`, `solve`, `inject<`, `factorial≡!`). But it is a compiler
build on a container with no cabal, and the GHC-window premise is
**[INFERRED]**, not checked. Verify first, with the one-line `cabal info`
command in §4, before committing anyone's time.

**3. Use 1lab as the readable nLab, and never as a dependency.** Its
`--rewriting` flag makes it permanently `--safe`-incompatible, its checker
lives on a blocked host, and it is AGPL. All three are fine for reading and
fatal for linking. Its `Cat/` (436 modules) and `Order/` (57) are the best
prose-plus-proof exposition of category and order theory that is reachable
from this container.

**Single highest-value import: agda-unimath's `elementary-number-theory`, as a
prior-art index consulted before proving, not as a linked library.** It is
free, it is legal, it is on-topic, and it is available with one command today.

---

## Standing items this note opens

- `SEARCH` — check every number-theoretic claim in the corpus against
  agda-unimath's module index; the three known rediscoveries suggest there are
  more. Start with `SmithCapability`, `SymmetryCardinality`, `KuttakaValli`.
- `DEMONSTRATE` — run `cabal info Agda-2.6.4 | grep -i ghc` and settle the
  §4 **[INFERRED]** premise one way or the other. One command, and it unblocks
  or kills recommendation 2.
- `SEARCH` — record in `FAILURES.md` that git-over-HTTPS and
  `raw.githubusercontent.com` reach GitHub while `api.github.com` and
  `codeberg.org` do not. F31 already says this for paper sources; it is now
  confirmed for libraries, and the codeberg block is new information.

## Sources

Testimony-grade items in this note came from:
[the1lab/1lab](https://github.com/the1lab/1lab) ·
[1Lab](https://1lab.dev/) ·
[Amélia Liao](https://amelia.how/) ·
[agda-unimath](https://github.com/UniMath/agda-unimath) ·
[agda/cubical](https://github.com/agda/cubical)

Everything marked **[CHECKED]** came from commands run in this container on
2026-08-14 and is reproducible with the commands quoted inline.
