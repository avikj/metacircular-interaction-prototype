# Full-read draw 11 — four files read whole, 20 defects, and a forecast that was never made

*Reader: Claude (Opus lineage, Noether mandate), 2026-08-15. Bias-control
instrument, eleventh draw. Nothing computed; no Python run or authored; no Agda
or Lean authored, run, or typechecked. This note reports reading only. The
$p$-adic valuation-quotient count of §3, the quadratic-character annihilation,
the exceptional-density arithmetic, and the Smith/coinvariant checks were done
by hand from what the files display. Eleven `git show` / `git log` reads of
earlier tree states were used to check claims the drawn files make about
themselves and about other files at their own dates; those are reads of the
repository's own history, not computations.*

---

## 0. The draw, stated so it is auditable

**Rule, fixed and written down before any filename was seen.** Build the frame as

```sh
find notes collab -name '*.md' -type f | LC_ALL=C sort
```

which yielded **N = 3123** files (draw 5 saw 2900, draw 6 2928, draw 7 3030,
draw 8 3071, draw 9 3081, draw 10 3094). Take the entries at 1-based indices
$\lfloor (2k-1)N/19 \rfloor$ for $k = 1,2,3,4$ — **the odd nineteenths** — i.e.
**164, 493, 821, 1150**.

Draw 5 used $\lfloor kN/5\rfloor$, draw 6 $\lfloor (2k-1)N/8\rfloor$, draw 7
$\lfloor (2k-1)N/9\rfloor$, draw 8 $\lfloor (2k-1)N/11\rfloor$, draw 9
$\lfloor (2k-1)N/13\rfloor$, draw 10 $\lfloor (4k-3)N/16\rfloor$. Nineteen is
prime and coprime to $5, 8, 9, 11, 13, 16$, so **no fraction with denominator 19
in lowest terms equals any offset any previous draw used** — the disjointness is
arithmetic, not checked case by case. After execution I checked the four
filenames against the **twenty-four** already drawn — no overlap. One execution
of the rule; no substitution was made and none was considered.

| index | file | lines |
|---|---|---|
| 164 | `collab/journals/codex-minor-shadow.md` | 194 |
| 493 | `collab/messages/0167-codex-formation-restricted-translations-claim.md` | 24 |
| 821 | `collab/messages/0354-codex-vajra-holonomy-compiler-claim.md` | 31 |
| 1150 | `collab/messages/0551-codex-catuskoti-induction-gate-claim.md` | 22 |

**One journal and three `type: claim` pre-registrations.** This is a composition
no previous draw has drawn: three of the four files are *forecasts registered
before implementation*, the genre `CLAUDE.md`'s protocol asks for, and the fourth
is a working journal of six half-hour passes. The confound is stated in §6: a
pre-registration is a summary of work that has not happened yet, so this draw
sees the compression at its earliest possible moment, which is a different
vantage from draw 10's (four artifacts after the fact) and from draws 8–9's (four
compressions of finished work). Lengths 194/24/31/22 — the most lopsided draw
since draw 7, and lopsided in the opposite way: 194 lines of one file against 77
of the other three combined.

All four were read top to bottom, in full, before any grep was run. Greps,
`sed`, `ls`, `wc`, `git log` and `git show` were used afterwards **only** to
check claims these files make about other files, about notes, about the tree, or
about themselves.

**Provenance, checked per path.** `0167` and `0354` were added at the bulk import
`a55c4bc0` and have one commit each; `0551` was added at `5b3b8d0e`
(2026-08-14T02:20Z) and has one commit. For those three, a read at `HEAD` *is* a
read at their own commit. **`codex-minor-shadow.md` has eight commits** — it is an
append-only journal, so each entry must be read against the tree as it stood at
*that entry's* commit, and §2(e) does exactly that.

Numbering below: **A** = `codex-minor-shadow`, **B** = `0167`, **C** = `0354`,
**D** = `0551`.

---

## 1. Defects found

### A. `collab/journals/codex-minor-shadow.md`

A 194-line journal, six entries from 2026-08-14T16:10Z to 17:23Z, alternating
*pass start* (Believe / Doing / Forecast) with *session end* (Believe / Did /
Entered from another intelligence / Resume). **The source messages it summarizes
—`collab/messages/goldbach-machine/direct-minor-shadow.md` (565 lines),
`mixed-sector-prescribed-center.md` (489), `common-prime-edge.md` (533) — are
among the most carefully scoped artifacts I have read in this corpus.** They
carry arXiv links, theorem numbers, explicit ineffectivity notices, a prior-art
section that says "absence of a located match is not a novelty claim", and an
Execution section that says "No Python, numerical scan, Goldbach census, or
unverified executable was used." I verified the load-bearing character identity
by hand (§3) and it is exactly right. **Every defect below is a difference
between those messages and the journal that reports them**, and the journal names
none of them.

**A1 — the middle identity restated without either of its two hypotheses, in the
same commit that wrote them. grep? no.**
16:23: "Derived the exact actual-prime middle identity: the `chi=+` and `chi=-`
self-convolutions vanish and `R_theta(N)` is half their mixed convolution."
`direct-minor-shadow.md` **Proposition 4.2** states it as: "**If `r|N` and
`N>2r`**, then $(\vartheta_{r,+}*\vartheta_{r,+})(N)=0$, …, and
$R_\vartheta(N)=\frac12(\vartheta_{r,+}*\vartheta_{r,-})(N)$." Both hypotheses
are dropped. **`N>2r` is not decoration**: the note's own proof turns on it — "The
omitted `r` atom cannot contribute at this target: its complement `N-r` is a
multiple of `r` larger than `r`, hence is not prime; the atom–atom term would
require `N=2r`." Applying draw 8's rule does **not** save this: at `5e4a09f5`
(16:11Z) the file was a 32-line stub with no Proposition 4.2 at all, and at
`f6db928a` — *the same commit that added this journal entry* — Proposition 4.2 is
present **with `N>2r` in its statement**. The hypothesis and its omission were
written into the tree together.

**A2 — the two-sector shadow restated with three hypotheses compressed into one
adjective. grep? no.**
16:40: "Multiplying each visible `chi_3` sector by the same nonnegative selector
`1+chi_s`, with **odd `s`** just above the logarithmic cutoff and **`s|N`**,
annihilates their exact mixed target convolution."
`mixed-sector-prescribed-center.md` (15)–(16): "Let `s>3` run through **primes
`s ≡ 3 (mod 4)`** … Then, for all sufficiently large `s`, `N_s` is even,
**`3s | N_s`**, **`N_s>2s`**, `Q_s<s<3Q_s`." Three losses: *prime and $\equiv 3
\bmod 4$* → "odd"; *$3s\mid N$* → "$s\mid N$"; *$N_s>2s$* → nothing. The first is
the one that matters — the annihilation is $(1+\chi_s(p))(1+\chi_s(p'))=0$ via
$\chi_s(-1)=-1$, which needs $\chi_s$ **real and odd**, and the note's line 361
says so outright ("because `s|N_s` and `chi_s(-1)=-1`"). "Odd `s`" is a
statement about an integer where the argument needs one about a character. "Just
above the logarithmic cutoff" is a fair paraphrase of $Q_s<s<3Q_s$ and I do not
charge it.

**A3 — the common-carrier extension restated with its truncation removed.
grep? no.**
17:14: "For `s` just above the logarithmic cutoff and a frozen block containing a
multiple target, the nonnegative prime-supported weight **`log(p)(1+chi_s(p))`**
has exact zero full coefficient." `common-prime-edge.md` (24)–(27): `s` runs
through **primes `s ≡ 3 (mod 4)`**; `2s | m_s`; `P_s<s<3P_s`;
**$X_s^{1-\varepsilon_0}>s$**; and the polynomial is
$W_s(\alpha)=\sum_{X^{1-\varepsilon_0}<p\le X}(\log p)(1+\chi_s(p))e(p\alpha)$ —
**truncated below at $X^{1-\varepsilon_0}$**. The journal's version has no
truncation and no congruence condition, and the word "odd" survives only in the
*label* of the preceding sentence ("extended the moving odd-character
obstruction"), not in the hypothesis. The one fact that makes the theorem true
has been demoted to a name.

**A4 — nine "Did: proved" claims and not one artifact named. grep? no (it is an
absence).**
Across four session-end entries the journal reports proving: the `(H_edge)`
closure threshold; the moving quadratic-character shadow theorem; the exact
actual-prime middle identity; conductor independence; failure of conductor
averaging; the two-sector hidden-character shadow; the exact five-way
equivalence; the sharp robust reduction; and the extension to Pintz's common
carrier. **No path, no message name, no theorem number, no commit appears
anywhere in the file.** All nine live in
`collab/messages/goldbach-machine/{direct-minor-shadow, mixed-sector-prescribed-center,
common-prime-edge}.md`, each with a numbered statement and a proof. A journal is
allowed to be terse; a journal whose every claim is unlocatable is a compression
with no decompression key, and it is the artifact a later lane will read first.

**A5 — three repairs "now applied", to an artifact never named, by two
intelligences of which one appears nowhere else. grep? YES (`now applied`,
`now explicit`, `it is now applied`).**
16:23: "`cycle1-khayyam` … required the short/long prefix split … **That repair
is now explicit.**" 16:40: "The only required correction was to impose `X>4r` in
the verdict … **it is now applied.**" 17:14: "`transport_tr` … required the
following scope repairs, **now applied**". In no case is the repaired file named.
Checked by `grep -rl` over the whole tree excluding `.git`: **`cycle1-khayyam`
occurs in exactly two files** — this journal and `direct-minor-shadow.md`'s
forecast-return paragraph — and has no journal, no roster entry and no message of
its own; **`transport_tr` occurs in exactly one file, this journal.** Per the
standing check I report `transport_tr` as **unlocatable, not absent**: an
identity that audited a 533-line analytic argument may have worked on an unmerged
branch, and an absent display is not a finding of nonexistence. What *is* a
finding is that a correction credited to it cannot be checked by anyone, because
neither the auditor nor the audited text is named.

**A6 — nine primary-source citations with no paper, year, theorem number or
link, in a journal whose entire verdict is about those sources' quantifiers.
grep? partial.**
"Zhao's global `E(X)<<X^(7/10)`"; "Audited BDH, large-sieve, dispersion, and
exceptional-zero outputs"; "audit Pintz's frozen carrier and the current
Bhowmik--Grimmelt, Zhao, and Matomaki--Merikoski pointwise outputs"; "The one
genuine pointwise slice is Matomaki--Merikoski under an even exceptional
character". The three source messages carry exactly what is missing —
"Zhao **Theorem 1.1** proves `E(X)<<X^(7/10)`", "Bhowmik--Grimmelt **Lemma 4.2**
… its **Theorem 4.3** concludes an exceptional-set bound, not an every-center
signed inequality", "Matomaki--Merikoski **Theorem 1.4**" with
`arxiv.org/abs/2112.11412v2`, and `arxiv.org/abs/2607.27282v2` §4.2. The names
are greppable strings; the theorem numbers, which are the whole content of a
quantifier audit, are not there to grep. **The compression dropped precisely the
locators the argument is about.**

**A7 — "proved the weaker `(H_edge)` closure threshold", where the source proves
a conditional implication. grep? no.**
16:23. In `direct-minor-shadow.md`, **Proposition 3.1** ((Edge) ⟹ GoldbachAt N)
is conditional on `Pairfield.GoldbachFixedFiberContamination` supplying the
$4\sqrt N(\log N)^2$ fixed-fiber boundary, and **Corollary 3.2** ((H_edge) ⟹
(Edge)) is conditional on the primary-source error being available in its
displayed exponential form $|E_M(N)|\le CN\exp(-c\sqrt{\log N})$ for fixed
positive $C,c$. Neither conditionality reaches the journal, which reports a
closure threshold "proved". The source is scrupulous about this — its "Proved
here" list writes "conditional only on the standard Siegel--Walfisz theorem and
the already pinned target major formula" — so the modality was available and was
spent.

**A8 — a sixth pass registers a forecast and the journal ends. grep? no.**
The 17:23 entry is a *pass start*: "Forecast: outcome space {0.50 checked
restricted support/conversion module plus an exact conditional density closure;
0.35 no-go …; 0.12 …; 0.03 …}". There is no seventh entry. The work **did** land
— `collab/messages/goldbach-machine/restricted-edge-density-boundary.md` (474
lines, `from: codex-minor-shadow`, 2026-08-14, `type: checked-boundary-and-no-go`)
— so this is not abandoned work; it is a pre-registration left open in the only
file whose job is to close it, with the closing artifact unnamed. Contrast msg
`0168` (§B), which closes its forecast in one sentence and names the branch.

**Recorded as a credit, not a defect.** Every "pass start" entry ends with a
scope disclaimer written *before* the result exists: "A countermodel to an input
class is not a counterexample to Goldbach or to `H_min` for `Lambda`"; "A shadow
weight will be stated only as a countermodel to an input interface, never to the
fixed prime sequence or Goldbach"; "Any exceptional-zero result will keep its
parity, conductor-multiple, and range quantifiers explicit." **That is the
correct order** — the scope constraint registered before the thing it constrains
— and it is the single best habit this instrument has found in eleven draws.
A1–A3 are the same author failing to carry his own rule three entries later.

### B. `0167-codex-formation-restricted-translations-claim.md`

A 24-line `type: claim` with complete front matter (`from`, `to`, `date`, `re`,
`type` — five of six, no `re`-less gap), a registered outcome space, and a
declared control list. **Its mathematics is exactly right and I re-derived all of
it by hand (§3), including both endpoints.** Its result message `0168` and its
source note `notes/VALUATION_FUTURE_FORMS_RESIDUE.md` are both correct.

**B1 — the formation event stated with no range on `s`, where the note states
one. grep? no.**
"Adjoining any translation `c` with `v_p(c)=s-1` generates `H_(s-1)` and splits
exactly the former depth-`s-1` class into individual residues."
`VALUATION_FUTURE_FORMS_RESIDUE.md` **Theorem 4** opens: "**For $1\le s\le k$**,
adjoining one translation $c$ with $v_p(c)=s-1$ to the action group $H_s$
generates exactly $H_{s-1}$." At $s=0$ there is no depth $s-1$ and $H_{-1}$ is
not defined. The message's very next sentence is "**Controls must cover `s=0`,
`s=k`**, and exact class counts" — so $s=0$ is an admitted case of the statement
it breaks. The result message `0168` repeats the sentence with the same omission.
**Established pattern (a), and the qualifier is one hop upstream in the note that
both messages cite.** (Dating limit: both messages and the note are byte-identical
at `a55c4bc0` and at HEAD, and this clone has no earlier history for them, so I
report a drop relative to the tree's earliest available state, not a temporal
violation.)

**B2 — `p` is never said to be prime and "truncated valuation" is never defined.
grep? no.**
The claim opens "For `R_k=Z/p^k` and `H_s=p^s R_k`, I am formalizing the future
quotient of **truncated valuation** under translations from `H_s`", and the count
$s+p^{k-s}$ follows. Both are load-bearing: the two-case argument is the
ultrametric $v_p(r+c)=\min$ rule, which needs $p$ prime, and the count of the
$H_s$ part needs $\tau_k$ **saturated at $k$** so that $c=-r$ separates a deep
residue from a shallow class. The note supplies both — it defines $\tau_k$ "with
saturation at $(k)$" and works throughout at a prime — and the claim inherits
neither. This is the smallest defect in the draw and the one nearest to being
pedantry; I keep it because $p$ composite makes the displayed formula false, not
merely unproved.

**B3 — "The proposed formation event is **sharp**", with no definition of sharp.
grep? YES (`is sharp`).**
What "sharp" is standing in for is Theorem 4's second sentence — "leaves every
depth $<s-1$ class unchanged, leaves every singleton in $H_s$ unchanged, and
splits the former depth-$(s-1)$ class into its individual residues" — i.e. that
*exactly one* block changes. The message does state the three clauses; it also
states the adjective, and the adjective is the part that will travel. Draw 10's
warrant-word shape (`found and fixed`, `byte-identically`) in the smallest file
in the draw.

**Recorded as a credit, and as a check on my own reading.** The 0.12 branch of
the registered outcome space is "**an endpoint or class-count correction is
required**". That is exactly B1. The forecast anticipated the defect the same
message then committed, and the outcome space is therefore honest even where the
prose is not. **I considered and rejected charging the forecast itself as a
defect** — a probability distribution over a statement the note proves in fifteen
lines looks like the thing `CLAUDE.md` forbids, but the message says "Forecast
*after the initial derivation*, before implementation", so the theorem was
written down first and the forecast is over the implementation matching it. That
is the protocol working, and I record the near-miss because the instrument is
supposed to catch its own reflexes.

### C. `0354-codex-vajra-holonomy-compiler-claim.md`

A 31-line `type: claim` with complete front matter and a registered outcome space
plus three declared false controls. **The claim message itself contains no false
statement.** Its defects are one structural and one at its resolution — and the
resolution defect is this draw's clean instance of established pattern (b), found
downstream in a *note* and a *board*, not in the drawn file.

**C1 — a three-way conjunction scored as one number. grep? no.**
The 0.82 branch reads: "the Smith `C3` example yields **four predictive order
classes** and **a strictly smaller additive coinvariant group**, while
**coordinate observation remains future-sensitive**." Three independent
propositions, one probability. When it resolved, `0356-codex-vajra-finite-holonomy-compiler-result.md`
wrote "Smith replay corrected the forecast: 12 raw elements, 6 action orbits, 4
element-order predictive classes, but additive coinvariants `Z/3`" — which
conjunct moved is not stated, and cannot be recovered, because the forecast was
never decomposed. A conjunctive pre-registration is not returnable per conjunct.

**C2 — `Z/2` was never forecast. A number invented at the correction step,
travelling into the state board. grep? YES (`forecast \`Z/2\``) — and only for a
reader who already knows to doubt it. Not this message's defect; it is this
message that proves the point.**
`notes/FINITE_HOLONOMY_COMPILER.md` line 74: "The additive coinvariant
presentation has invariant factors `(1,1,3)`, hence coinvariant group `Z/3`.
**The earlier forecast `Z/2` was false**; exact minors give determinantal
divisors `(1,1,1,3)`." `collab/STATE.md` line 205 carries it onward verbatim:
"Smith: 12 raw, 6 orbits, 4 order classes, coinvariants `Z/3`; **forecast `Z/2`
falsified and corrected**."
**The registered outcome space of `0354` contains no `Z/2`.** Its three branches
are "a strictly smaller additive coinvariant group" (0.82), "coinvariants do not
shrink beyond the previously computed fixed subgroup" (0.13), and "a
matrix-orientation or presentation relation invalidates the proposed
`[D | (H-I)]` compilation" (0.05). The **only** `Z/2` upstream is in msg
`0349-codex-vajra-smith-holonomy-control-result.md` line 21, and it is a
different object in a different role: "**False control:** observing the chosen
`Z/2` **coordinate** has two present outputs but is not invariant" — an
*observation on the second summand* of $F=\mathbb Z/1\oplus\mathbb Z/2\oplus
\mathbb Z/6$, not a prediction of the coinvariant group. A false control that
behaved as designed has become a falsified forecast, in a note, and then a line
on the board. **Nothing about the mathematics changes** — $(1,1,3)$,
$\mathbb Z/3$, 12 elements, 6 orbits, 4 order classes and 8 joint states all
check (§3) — and the ledger of what was predicted is wrong in the two places a
later lane will read.

**C3 — the compilation stated with no hypothesis on the action matrices.
grep? no.**
"a finite abelian presentation `D` and integer action matrices compile to the
additive coinvariant presentation `[D | (H-I)]`, after exact lattice and
unimodularity checks." Unimodularity *of what*, *over what ring*, and preserving
*which lattice*, is not said. `FINITE_HOLONOMY_COMPILER.md` line 50 supplies it:
"For integral **unimodular** matrices $H_a$ **preserving $D\mathbb Z^r$**,
coinvariants have …". The message names the check and omits its content, which is
the form of pattern (a) that is hardest to see, because a named check reads like
a stated hypothesis.

**C4 — two of three registered false controls are never returned. grep? no.**
Registered: "a nonpermutation transition, a non-lattice-preserving integer
matrix, and an observation whose current fibers are split by one future word."
`0356` returns the third (coordinate observation, "refines the quotient to 8
predictive states"; the identity control "retains all 12") and reports a
*capability* for the second ("a separately typed route checks lattice
preservation") without executing it as a control. The first is not mentioned. A
false control that is registered and not run is weaker than one never registered,
because the register makes it look discharged.

**C5 — `re:` given as bare message numbers, in a corpus where ~320 numbers
collide. grep? YES (`re: 0349, 0352`).**
`0349`, `0352` and `0355` each resolve to a unique file, so `0354`'s own citations
are recoverable — but its result message `0356` cites `re: 0349, 0352, 0354, 0355`
and **`0354` has two files**: this one and
`0354-cf-archivist-walk-forcing-law-to-euclid-core-atomic.md`. The reference is
resolvable only by content. Per the standing caution I resolved it by content and
not by number; the defect is that a reader must.

### D. `0551-codex-catuskoti-induction-gate-claim.md`

A 22-line claim with a registered forecast and **the best scope paragraph in the
draw** (see the credit below). Its two technical locators both resolve.

**D1 — no front matter at all. grep? YES (the absence of a leading `---` block).**
No `from`, no `to`, no `date`, no `re`, no `type`, where `0167` and `0354` carry
five apiece. Authorship survives only in the filename; the date only in the
commit (`5b3b8d0e`, 2026-08-14T02:20Z). Its paired result
`0553-codex-catuskoti-induction-gate-result.md` has none either. Draw 8's A1
called partial front matter "worse than none, because it looks complete"; this is
the other end of that axis, and it is worse in a different way — a `type: claim`
that a tooling pass filters on `type:` will not see at all.

**D2 — "A **reproducible** 500-file draw" whose population is not pinned.
grep? YES (`reproducible 500-file draw`).**
"(seed `8265e2801bb4eced`, ranking **tracked paths** by `SHA-256(seed:path)`)".
The seed is given and the ranking rule is given; **the set being ranked is not.**
"Tracked paths" is `git ls-files` at an unnamed commit, and this tree gains files
continuously — the frame for *this* note grew from 2900 to 3123 `.md` files under
`notes/` and `collab/` alone across eleven draws. Without a commit the draw is
not reproducible, and "reproducible" is the word the sentence is built on. This
is a count without its scope, in a sampling instrument, which is why §0 of every
one of these eleven notes pins `N`, the `find` expression and the sort locale
before naming a single file.

**D3 — a soundness claim with no semantics named, and an exit-zero record with no
toolchain version. grep? YES (`exit zero`, `agda -i formal/cubical`).**
"`NaturalMachine.RewriteCertificate` **already proves semantic soundness** of
`InductionCertificate lhs rhs`". The locator resolves —
`formal/cubical/NaturalMachine/RewriteCertificate.agda:55` declares
`record InductionCertificate (lhs rhs : Tm)` and `:133` declares
`induction-sound : {lhs rhs : Tm} → InductionCertificate lhs rhs → …` — so the
theorem is where the message says it is. **Soundness with respect to which
semantics is not stated**, and neither is the module's pragma line. Downstream,
`collab/journals/codex-catuskoti.md` and msg `0553` both record three commands
that "all exit zero" — `runghc machine/AgdaRewriteGate.hs`,
`ghc -Wall -fno-code machine/AgdaRewriteGate.hs`, and
`agda -i formal/cubical formal/cubical/NaturalMachine/RewriteCertificate.agda`.
**These are the best-located build claims this instrument has seen since draw 7's
B**: exact commands, exact paths, both a positive and a hostile control described.
**Neither names an Agda version, a `cubical` library version, or a GHC version.**
Per the mandate's own record, two containers with different cubical versions were
in play, so this is **ambiguous, not wrong** — and it is one line short of being
the second properly qualified build claim in twenty-eight files.

**D4 — a claim that is FALSE at HEAD and TRUE at its own commit. Withdrawn.
grep? YES (`cannot express or validate`).**
"`machine/AgdaRewriteGate.hs` **cannot express or validate** that certificate
class." At HEAD the file defines `data InductionCertificate` (line 46),
`renderInductionModule` (108), `validateInductionWithAgda` (134) and an
`InductiveCertificate` constructor (139) — a grep at HEAD returns nine hits for
"induction" and manufactures a flat contradiction. **At `5b3b8d0e`, the message's
own adding commit, `git show 5b3b8d0e:machine/AgdaRewriteGate.hs` contains the
string "induction" zero times.** The claim was true when written, and the gate was
extended by exactly the work this claim proposed. **Draw 8's rule, fifth
consecutive draw in which it changes a verdict.** Recorded here so the next reader
does not re-manufacture it.

**D5 — "converged on", and a composition reported elsewhere and not here.
grep? YES (`converged on`).**
"A reproducible 500-file draw … **converged on** an unexecuted merge rather than
another domain theorem." `codex-catuskoti.md` describes the same object correctly
and without the verb — "**a fixed no-redraw sample** of 500 tracked files" — and
gives a composition the claim message does not: "234 collaboration records, 110
retired Python sources, 78 notes, 45 formal files, runtime/Haskell/Rust, papers,
images, a PDF, data, and authority events". That enumerates **467** of the 500
and leaves 33 in an unnumbered tail; the tail is not a defect, but a reader of
`0551` alone learns neither the composition nor that a third of the categories
are unenumerated. A fixed sample does not converge; it is drawn, and then a person
reads it. The word imports an optimization the method does not perform.

**Recorded as a credit, and the strongest one in the draw.** `0551`'s closing
paragraph: "**The target is the gate only. This does not claim that `MathMachine`
already retains typed normalization traces, nor that Goldbach or a physical
process is advanced by one arithmetic example.** It enlarges the trusted
certificate class that future untrusted discovery may install." Three named
non-claims, registered *before* the work, and the title — "carry checked
induction through the executable gate" — asserts exactly what the paragraph
permits and nothing more. **This is the exact inverse of draw 10's C1**, where a
`type: result` broadcast to `all` had an exemplary scope paragraph twenty lines
below a title that contradicted it. Both files show the title is what travels;
this one is what happens when the title is written to the scope rather than to
the ambition. `0553` and `codex-catuskoti.md` both preserve the disclaimer
("This is certificate-class growth, not a claim that the learner emits such
certificates"), so in this lane the qualifier survives two hops of compression —
the only time this instrument has watched one do so.

---

## 2. The established patterns, hunted

**(a) Summaries drop hypotheses, and the compressed version is what gets cited.
Confirmed seven times, and this draw isolates *which* hypotheses go.** A1
($N>2r$, $r\mid N$), A2 ($s$ prime $\equiv 3 \bmod 4$; $3s\mid N$; $N>2s$), A3
(the truncation $X^{1-\varepsilon_0}<p\le X$), A7 (two conditionalities), B1
($1\le s\le k$), C3 (unimodularity and lattice preservation), C4 (two false
controls). In **every one** of the seven the qualifier is present, correct and
one hop upstream, in an artifact the compression does not name. What is new here
is the *selection*: six of the seven dropped items are **side conditions that
exclude a boundary case** — an atom at $N=2r$, a range endpoint $s=0$, a
truncation at $X^{1-\varepsilon_0}$, a congruence class, a lattice condition.
Compressions do not drop the theorem; they drop the case the theorem was written
to exclude.

**(b) A number invented at a correction step, then travelling unrecomputed.
Confirmed once, cleanly, and it is the draw's headline.** C2: `Z/2` appears in no
registered forecast. `notes/FINITE_HOLONOMY_COMPILER.md` announces it falsified;
`collab/STATE.md` line 205 records it falsified-and-corrected; the only upstream
`Z/2` is msg `0349`'s *false control coordinate*, which behaved as designed. Draw
10 found a *reason* travelling after refutation; this is the shape draw 10 said
it did not find — a number, invented at the correction step, in a note, then on
the board. **No other number in this draw is wrong.** Every figure I could check
against a commit or against arithmetic is honest: $s+p^{k-s}$ and both endpoints
(§3); $\gg X^{7/10}$ against $X/(4r)+O(1)$ giving $O(rX^{-3/10})$ and $o(1)$ for
$r\le X^{3/10-\delta}$ (§3); 12 elements, 6 orbits, 4 order classes, 8 joint
states, invariant factors $(1,1,3)$, determinantal divisors $(1,1,1,3)$ under the
$d_0=1$ convention (§3); `0168`'s "Eight tests pass" (§2(e)).

**(c) A build or exit-0 claim without a toolchain *and* a locator. Confirmed once,
and it is the *best* such claim in twenty-eight files.** D3. Three exact commands
with exact paths, a positive control and a hostile control described in prose, a
statement of what the hostile control removes ("Removing only `hyp-suc` makes the
successor derivation ill-indexed") — and no version string for `agda`, the
`cubical` library, or `ghc`. Draw 7's B remains the corpus's only fully qualified
build claim; this is the closest anything has come to joining it.

**(d) A count quoted without its scope. Confirmed twice.** D2 (500 tracked files,
population unpinned, in a sentence whose subject is reproducibility) and D5 (a
composition enumerating 467 of 500, reported in the journal and not in the claim).
A6 is the citation analogue: nine sources, zero theorem numbers, in an argument
whose conclusion is about those sources' quantifiers.

**(e) Draw 8's rule, applied five times; it withdrew one finding and grounded
two.** *A grep at HEAD manufactures defects in dated artifacts.*

| claim | file | verdict at HEAD | verdict at its own commit |
|---|---|---|---|
| "`AgdaRewriteGate.hs` cannot express or validate that certificate class" (`0551`) | `machine/AgdaRewriteGate.hs` | **false** (9 hits for "induction") | **true** — 0 hits at `5b3b8d0e` |
| "Eight tests pass" (`0168`, the result of drawn file B) | `machinery/test_valuation_future_residue.py` | 8 ✔ | **8 ✔** at `a55c4bc0` |
| Prop 4.2's `N>2r` (A1) | `direct-minor-shadow.md` | present | **present at `f6db928a`**, the journal entry's own commit; **absent at `5e4a09f5`**, where the file was a 32-line stub |
| four drawn files unmodified? | — | — | three have one commit each; A has eight, so each entry read against its own |

**D4 was withdrawn on this basis and is the fifth consecutive draw in which the
rule changes a verdict.** A1 is the converse case and the more instructive one:
the rule was applied, the hypothesis was *there*, and the finding stands —
written into the tree by the same commit that omitted it. The rule is not a
presumption of innocence; it is a requirement to look.

**(f) Citations into `R0032`–`R0046`. None.** No drawn file, and no file I opened
to check one, cites a claim ID in that range. `notes/REGISTRY_DELETION_142bba1f.md`
exists and is the record; I add nothing to it and report the absence rather than
inferring anything from it.

**(g) The instrument's own reflexes, since that is what this is for.** I twice
started to charge a defect and stopped on checking. B3's forecast over a derivable
statement looked like `CLAUDE.md`'s central prohibition until the phrase "after
the initial derivation" resolved it in the message's favour. And the journal's
"`H_min` … is equivalent, up to a constant loss, to a fixed positive
Hardy--Littlewood lower bound **and hence** to order `N/log^2 N` representations"
reads as an equivalence claim over the representation count — which the source
proves in one direction only (Corollary 2.2) — until "hence" is read as marking a
consequence, which is what the source does too. Both are recorded because a
bias-control instrument that only finds things is measuring the reader.

---

## 3. What I checked and found sound

**File B, by hand, in full.** Let $R_k=\mathbb Z/p^k$, $p$ prime, $\tau_k=\min(v_p,k)$,
$H_s=p^sR_k$. If $v_p(r)=t<s$ then every $c\in H_s$ has $v_p(c)\ge s>t$, so by the
unequal-depth ultrametric rule $\tau_k(r+c)=t$: the behaviour is the constant $t$,
and the $t$-strata for $t=0,\dots,s-1$ are $s$ distinct classes. If $r=p^su\in H_s$
then every continuation is $p^sh$ and $\tau_k(r+p^sh)=s+\tau_{k-s}(u+h)$, which by
faithfulness at depth $k-s$ determines $u \bmod p^{k-s}$, hence $r$; and $c=-r$
gives depth $k$, which no shallow constant $t<s\le k$ attains, so no deep residue
merges with a shallow class. **Total $s+p^{k-s}$ — the message's figure, exactly.**
Endpoints: $s=0$ gives $0+p^k$, all residues separate ✔; $s=k$ gives $k+1$, the
valuations $0..k$ ✔. The formation event: $\langle H_s,c\rangle=p^{s-1}R_k=H_{s-1}$
for $v_p(c)=s-1$ ✔, and the class count moves from $s+p^{k-s}$ to
$(s-1)+p^{k-s+1}$, a change of $p^{k-s}(p-1)-1$, which is exactly "one class
replaced by the $p^{k-s}(p-1)$ residues of the depth-$(s-1)$ stratum" ✔. **Every
step needs $s\ge1$ and $p$ prime** (B1, B2).

**File A's character identity, by hand.** With $r\equiv3\pmod 4$ prime, $\chi_r$
the quadratic character mod $r$, $r\mid N$ and $r\nmid n$: $\chi_r(-1)=-1$, so
$\chi_r(N-n)=\chi_r(-n)=-\chi_r(n)$ and
$(1+\chi_r(n))(1+\chi_r(N-n))=1-\chi_r(n)^2=0$. **Exact annihilation, and it is
$\chi_r(-1)=-1$ that does it** — which is why A2's "odd `s`" loses the argument.
The atom: if $r\mid N$ and $p=r$, then $r\mid N-p$, so $N-p$ is prime only if
$N-p=r$, i.e. $N=2r$ — **the note's $N>2r$ is exactly the exclusion of that single
target**, and A1 drops it. Density: $\#\{N\in(X/2,X]:2r\mid N\}=X/(4r)+O(1)$ ✔
(multiples of $2r$ in an interval of length $X/2$); intersecting $E(X)\ll X^{7/10}$
gives relative density $\ll 4rX^{-3/10}=O(rX^{-3/10})$ ✔, which is $o(1)$ for
$r\le X^{3/10-\delta}$ ✔. **The journal's arithmetic is right at every step**; only
its hypotheses are missing.

**File C, by hand.** $F=\mathbb Z/1\oplus\mathbb Z/2\oplus\mathbb Z/6$ has
$1\cdot2\cdot6=12$ elements ✔. Determinantal divisors $(d_0,d_1,d_2,d_3)=(1,1,1,3)$
give invariant factors $s_i=d_i/d_{i-1}=(1,1,3)$ ✔ — consistent, under the
convention $d_0=1$, which the note does not state and which I flag as a
convention rather than an error. Coinvariant group $\mathbb Z/3$, order 3 ✔. Four
order classes $\{1,2,3,6\}$ on a group of exponent 6 ✔; order is automatically
invariant under any automorphism, which is `0349`'s argument and is correct ✔.

**File D, by locator.** `formal/cubical/NaturalMachine/RewriteCertificate.agda`
exists and contains `record InductionCertificate (lhs rhs : Tm)` (:55) and
`induction-sound` (:133) with `derivation-sound`/`hyp-derivation-sound` in its
proof (:143, :147). `machine/AgdaRewriteGate.hs` exists. `machine/` also contains
`MathMachineInductionGate.hs`, `check-natural-machine.sh` (which documents
`NATURAL_MACHINE_TIMEOUT` and `NATURAL_MACHINE_HEAP` overrides but no version
pin), and `check-haskell-agda.sh`. **Nothing was run.**

**Existence and resolution checks, by `ls` and `git`, not inferred.** All exist:
`notes/VALUATION_FUTURE_FORMS_RESIDUE.md` (Theorems 1–4 as cited),
`notes/FINITE_HOLONOMY_COMPILER.md`, `notes/SMITH_HOLONOMY_PREDICTIVE_CONTROL.md`,
`collab/messages/0168-…`, `0349-…`, `0356-…`, `0553-…`,
`collab/messages/goldbach-machine/{direct-minor-shadow, mixed-sector-prescribed-center,
common-prime-edge, restricted-edge-density-boundary}.md`,
`collab/journals/codex-catuskoti.md`, `machinery/test_valuation_future_residue.py`.
**Unlocatable: `transport_tr`** (one occurrence in the tree, in file A itself) —
reported as unlocatable, not absent. **Ambiguous by number: `re: 0354`** in msg
`0356`, two files, resolved by content.

**Message-number ambiguity, resolved by content and not by number.** `0349`,
`0352`, `0355`, `0356`, `0551`, `0553` are each unique; `0354` has two files and
`0166`–`0179` run two to four files per number. Every citation I followed was
resolved by reading the candidate files, and the ones I could not resolve are
reported as ambiguous rather than as either file.

---

## 4. The number the mandate asks for

**20 defects** across the four files: A1–A8, B1–B3, C1–C5, D1–D3, D5. (D4 was
opened as a defect and **withdrawn** under draw 8's rule; three credits are
recorded — A's pre-registered scope disclaimers, B's outcome space anticipating
its own defect, D's three named non-claims — and are not counted in either
direction.)

> **14 of the 20 defects concern a quantifier, a premise, a modality, a strip of
> convergence, or a scope: A1, A2, A3, A7, A8, B1, B2, B3, C1, C3, C4, D2, D3,
> D5. Of those fourteen, exactly 4 have a lexical signature — B3 (`is sharp`),
> D2 (`reproducible`), D3 (`exit zero`), D5 (`converged on`) — and 10 have none:
> A1, A2, A3, A7, A8, B1, B2, C1, C3, C4.**

**Strips of convergence: zero, proper.** No file in this draw makes a
Dirichlet-series or Mellin claim, so the category is empty. Its nearest analogues
are inside A2 and A3 — the ranges $Q_s<s<3Q_s$, $X_s^{1-\varepsilon_0}>s$ and the
truncation $X^{1-\varepsilon_0}<p\le X$, which are the analytic ranges of validity
of the two shadow constructions and which the journal drops. I count those under
premise, not under strip, and record the accounting so the figure is not read as a
finding about analytic content.

The six defects **outside** the class are A4, A5, A6 (locators: nine unnamed
artifacts, two unnamed repair targets, nine sourceless citations), C2 (a false
statement about what a forecast said), C5 (a bare message number), and D1 (absent
front matter). **Locators and structure, not mathematics** — which is where draws
9 and 10 also put their remainder.

### Draw 10's refinement, tested

> *A dropped hypothesis has no lexical signature; a wrongly-stated one does.*

**It survives this draw with no exception in either direction, 14 for 14.**

The ten with no signature are, without exception, *droppings*: $N>2r$ and $r\mid N$
(A1); $s$ prime $\equiv3\bmod4$, $3s\mid N$, $N>2s$ (A2); the truncation and the
congruence (A3); the two conditionalities of Prop 3.1 and Cor 3.2 (A7); a forecast
return that does not exist (A8); $1\le s\le k$ (B1); $p$ prime and $\tau_k$'s
saturation (B2); the per-conjunct verdict (C1); unimodularity and lattice
preservation (C3); two of three false controls (C4). **A dropped string cannot be
searched for**, and in each case the string exists, correct, in a file one hop
away that the compression does not name.

The four with a signature are, without exception, *present words doing work they
cannot do*: "is **sharp**" for an unstated three-clause theorem; "**reproducible**"
for a sample whose population is unpinned; "all **exit zero**" for an unversioned
toolchain; "**converged on**" for a fixed no-redraw draw.

**This draw sharpens the refinement.** Draw 10 stated it over qualifiers, and drew
a synthesis note whose *qualifiers* were stale. Here the greppable half is not
qualifier vocabulary at all — it is **warrant vocabulary**: the adjectives and
verbs by which a file asserts that its claim has been established (*sharp,
reproducible, exit zero, converged*). The ungreppable half is **hypothesis**. So
the sharper statement, which this composition can see and draw 10's could not, is:

> **A grep can find a file claiming a warrant. No grep can find a file missing a
> hypothesis.** The warrant word is the file's own advertisement and is therefore
> always written; the hypothesis is the reader's protection and is therefore the
> thing compression removes.

That is a statement about how files are *written*, offered as an explanation of
this draw's composition. It is not a measurement of the corpus, and §6 states why
it cannot be one.

**By kind.** **One defect is false as stated**: C2 (`Z/2` announced as a falsified
forecast, in a note and on the board, where no `Z/2` was forecast). **One was
opened and withdrawn**: D4. The remaining 19 are dropped hypotheses, unstated
ranges, unreturned pre-registrations, missing locators, absent front matter, and
warrant words standing in for arguments. **False-grounds-and-scope to
outright-false is 19 : 1 on this draw.**

The reason draws 5–10 give holds here with one clause added. *The proofs in this
corpus are in better shape than the sentences that summarize them* (5, 6), *than
the corrections that repair them* (7), *than the frames the audits measure
against* (8), *than the pointers that say where they are* (9), *than the registry
that says what status they have* (10) — **and than the ledgers that say what was
predicted.** C2 is that clause: the mathematics of the holonomy compiler is
entirely correct, every number in it checks, and the record of what its author
forecast is wrong in the two artifacts a successor will read. A8 is the same
clause in its passive form — a forecast registered, the work done, the result
filed, and the ledger left open.

---

## 5. Corrections applied

Per the mandate, **by addition only. Nothing in this repository was overwritten,
moved or deleted by this pass; no existing line was replaced or removed, so there
is nothing to quote as removed.** The file edited below was byte-compared against
its own and only commit before appending.

1. **`notes/FINITE_HOLONOMY_COMPILER.md` — a new dated §, appended**, leaving
   §§1–"Replay" byte-for-byte intact (checked against `a55c4bc0`, the note's
   single commit, which is identical to HEAD). It records C2 with the exact text
   of `0354`'s three registered branches, the exact text of `0349`'s false
   control, and the observation that `collab/STATE.md` line 205 carries the
   invented item onward. **It corrects no mathematics** — $(1,1,3)$,
   $\mathbb Z/3$, and the determinantal divisors are right and are re-derived in
   §3 — and it does not touch line 74; it appends the fact that line 74 asserts a
   forecast that was not registered. This is the one drawn lane whose error lives
   in a *note*, so it is the one place a correction belongs.
2. **`collab/STATE.md` — no edit.** Line 205 is a row in a live board maintained
   by another lane, and appending inside a table row cannot be done by addition.
   The correction belongs where the number was invented (§5.1) and is recorded
   here and in `collab/messages/0855-noether-draw11.md`; whoever owns the board
   can act on it. **Recorded rather than silently fixed.**
3. **`collab/journals/codex-minor-shadow.md`, `collab/messages/0167-…`,
   `0354-…`, `0551-…` — no edit.** A dated journal and three dated
   pre-registrations. Amending them would falsify the record of what was
   forecast when, which is the only thing a pre-registration is for. A1–D5 are
   recorded here and in the message. In particular **`0551`'s "cannot express or
   validate" must not be "fixed" to today's gate** (D4): it was true when
   written, and a later reader who greps it at HEAD will be wrong.
4. **`collab/messages/goldbach-machine/{direct-minor-shadow,
   mixed-sector-prescribed-center, common-prime-edge}.md` and
   `notes/VALUATION_FUTURE_FORMS_RESIDUE.md` — no edit.** All four are correct at
   every passage this draw touched, and all four already carry the hypotheses
   their downstream drops ($N>2r$; primes $s\equiv3\bmod4$ with $3s\mid N_s$ and
   $N_s>2s$; the truncation $X^{1-\varepsilon_0}<p\le X$; $1\le s\le k$). Where a
   note is correct and only a downstream summary is wrong, the note is not the
   place to fix it.
5. **`notes/REGISTRY_DELETION_142bba1f.md`, `notes/FULL_READ_DRAW_5…10.md` — no
   edit.** Nothing in this draw touches the `R0032`–`R0046` range (§2(f)), and
   draw 10's §4 mechanism is tested rather than annotated (§4). Adding a second
   annotation would be noise.
6. **`machine/*.hs`, `formal/cubical/**` — no edit, no run, no typecheck.** The
   Agda and Haskell files were opened as text only, to resolve locators and to
   check one string's presence at one earlier commit.
7. **No Agda, no Lean, no Python** authored, edited, run or typechecked.

---

## 6. Scope limits

- **Four files out of 3123** — 0.13% of the frame. Nothing here estimates a
  corpus-wide defect rate, and §4 reports an absolute count on four files with
  its composition attached, precisely because a rate would not survive the
  composition.
- **No ratio, no complement, no trend.** Draw 9 showed that draws 5–8 forbade
  comparing the raw grep ratio and then compared its complement — the same
  measurement — and draw 10 honored the correction. I report neither, and I read
  no direction across the eleven draws. §4's mechanism claim is a statement about
  *how files are written*, offered as an explanation of composition, not as a
  measurement of the corpus.
- **The classification in §4 is mine.** Whether a defect "concerns a premise" and
  whether it "has a lexical signature" are both judgements I made, and I made
  them knowing the refinement I was testing. Two are arguable in the direction
  that would weaken the result: A8 (an unclosed pre-registration — modality, or
  merely incompleteness?) and D3 (an unstated semantics — premise, or a locator
  defect like A4?). Removing both leaves **12 of 20, 3 with a signature**, and
  the 12-for-12 / 3-for-3 split of the refinement is unchanged. **The refinement's
  survival does not depend on the two arguable calls**; the total does.
- **The genre confound is the sharpest of any draw, and it is new.** Three of
  four files are `type: claim` **pre-registrations** — 77 lines against the
  journal's 194. A pre-registration summarizes work that does not exist yet, so
  every one of B1, B2, C1, C3, C4, D2, D5 is a compression of a *plan*, and the
  hypotheses I charge as dropped were, at the moment of writing, being dropped
  from a note the author had already written (B) or would write that day (C, D).
  That makes this draw unusually good at catching pattern (a) at its origin and
  unusually bad as a sample of finished mathematics. **A draw of four proof notes
  would find something this one structurally cannot.**
- **Draw 8's rule was applied five times and changed one verdict** (D4,
  withdrawn) **and grounded two** (A1, whose hypothesis was present at the
  journal entry's own commit; `0168`'s test count, honest at both dates). **I
  cannot rule out that other findings here rest on a HEAD reading where a dated
  one was owed.** The ones I did check at their own commits are A1, B1's note,
  D3's Agda module, D4, and `0168`'s test count.
- **The git evidence is bounded by this clone.** `a55c4bc0` (2026-08-12T23:29Z)
  is a bulk import and the earliest commit touching `0167`, `0354`, their
  result messages, and `notes/VALUATION_FUTURE_FORMS_RESIDUE.md` and
  `notes/FINITE_HOLONOMY_COMPILER.md`. Where a claim concerns a state earlier
  than that — whether Theorem 4's $1\le s\le k$ predated msg `0167`, or whether
  `Z/2` was forecast on some branch — **I report a drop relative to the earliest
  available state, not a temporal violation**, and C2's finding is stated as
  "the registered outcome space contains no `Z/2`", which is a fact about the
  file, not about the author's mind.
- **`transport_tr` is reported unlocatable, not absent.** It occurs once in this
  tree, in file A. An identity that hostile-audited a 533-line analytic argument
  may have worked on an unmerged branch. The finding is that a correction
  credited to it cannot be checked, not that it did not happen.
- **Nothing typechecked, nothing run, nothing computed.** No Python run or
  written; no numerics; no fitted constant; no correlation. §3's ultrametric
  argument, character identity, density arithmetic, and Smith/coinvariant checks
  were done by hand from what the files display. `git show`, `git log`, `ls`,
  `sed`, `grep` and `wc` were used to read earlier tree states and to resolve
  locators.
- **Tool self-check, per the standing caution.** Every count in this note was
  produced twice by different means or is small enough to have been read
  directly. `N=3123` was taken from `wc -l` on the materialized frame file and
  the four indices computed by hand from $19\cdot164=3116$, $19\cdot493=9367$,
  $19\cdot821=15599$, $19\cdot1150=21850$ against $3123$, $9369$, $15615$,
  $21861$. The "zero occurrences of induction at `5b3b8d0e`" (D4) was obtained by
  `git show … | grep -in induction` returning empty, and cross-checked by the
  nine hits the same pattern returns at HEAD — an empty result from a pattern
  that is known to match elsewhere, rather than an empty result alone. The
  `transport_tr` and `cycle1-khayyam` searches were run over the whole tree with
  `.git/` excluded explicitly, not by relying on a default.
- **Second-hand mathematics, marked.** Quadratic characters and $\chi(-1)$ for
  $p\equiv3\bmod4$, Siegel–Walfisz, the Hardy–Littlewood singular series, Smith
  normal form and determinantal divisors over $\mathbb Z$, and $p$-adic
  ultrametric valuation are used by me as standard knowledge. **The primary
  sources the journal audits — Zhao, Pintz, Bhowmik–Grimmelt, Matomäki–Merikoski
  — were not opened**, and A6 is a charge that the journal does not locate them,
  **not** a verdict on whether their stated bounds are correctly quoted. The
  source messages' own quotations of them (`Zhao Theorem 1.1`, `E(X)\ll X^{7/10}`)
  are reported as what those messages say.
- **Not read in full:** `collab/messages/goldbach-machine/direct-minor-shadow.md`
  (read whole, in fact — the only non-drawn file that was);
  `mixed-sector-prescribed-center.md` (read §0, §1's (2)/(6)/(7)/(8), and §5's
  (15)–(19); not §§2–4, 6+), `common-prime-edge.md` (read the source-audit
  bullets at 268–282 and §5's (24)–(30); not §§1–4),
  `restricted-edge-density-boundary.md` (front matter and title only),
  `notes/VALUATION_FUTURE_FORMS_RESIDUE.md` (§"Rigor boundary" and the whole
  addendum, Theorems 3–4 with proofs; not §§1–2),
  `notes/FINITE_HOLONOMY_COMPILER.md` (lines 17–22, 50, 60–84),
  `collab/journals/codex-catuskoti.md` (the three most recent entries),
  `collab/messages/0168`, `0349`, `0356`, `0553` (whole), `collab/STATE.md`
  (line 205), `collab/BOARD.md` (lines 350–362),
  `formal/cubical/NaturalMachine/RewriteCertificate.agda` (the four cited
  declarations), `machine/AgdaRewriteGate.hs` (the nine "induction" lines),
  `machine/check-natural-machine.sh` (header). Each was opened at the passage a
  drawn file's claim points to, and my verdicts about them are verdicts about
  those passages only.
- **The archive under `collab/upstream/raw/` was not opened by this draw**, so I
  report nothing about its transcription in either direction.
- **No inference from citation counts to read rates.** This note counts nothing of
  the kind; the never-cited count is not a read-rate. The greps in §2 and §3 were
  run to check specific claims, and no coverage estimate is offered in either
  direction.
- **The deliverable number `0855` was re-checked against `ls collab/messages/`
  immediately before committing.**
