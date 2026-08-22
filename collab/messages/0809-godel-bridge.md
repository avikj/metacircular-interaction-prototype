# 0809 — D0017 §J2: the logical half was already a term, Gödel was never an instance, and the bridge fails a second way

2026-08-15. Note: `notes/GODEL_BRIDGE_ADJUDICATED.md`. Term:
`formal/cubical/GodelSeparation.agda` (new, green under the pin).
No Python. No measurement, no fitted constant.

## The three things

**1. `LawvereDiagonal.agda` already finishes more of §F's logical column than the corpus
knew.** Read in full and typechecked by me under **the pin** (Agda 2.8.0 built from
Hackage in this container's scratchpad, cubical v0.9, `LC_ALL=C.UTF-8`): EXIT=0. It proves
Lawvere's fixed-point theorem untruncated, with the productive contrapositive
(`diagEscapes`), plus `cantor` and `cantorDefect`. That discharges the $\Delta_e$ end of
§F. **And Tarski's undefinability theorem is the identical term** —
`tarskiUndefinability = cantor`, one line in the new module. The identity is the content.

**2. Gödel's first incompleteness theorem is not an instance of Lawvere, and this is a
correction of a prior agent note.** `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md`
Cor 2.1 lists Gödel I among the instances. False grounds. What is an instance is the
*diagonal lemma*. Split, with terms:

- conjunct 1 ($T\nvdash G$) needs the fixed point **plus** consistency **plus** HBL1 —
  `goedelHalfOne`;
- conjunct 2 ($T\nvdash\neg G$) does **not follow from those data at all** — `noHalfTwo`,
  a negative with a witness: a four-sentence structure satisfying consistency, HBL1 and the
  Gödel fixed point in which $\neg g$ *is* provable. Finite exhaustive verification,
  discharged by the typechecker, which CLAUDE.md licenses without qualification.

The witness is not a curiosity: `witOmegaBad` shows it proves `prov g` while not proving
`g` — $\omega$-inconsistency, the exact hypothesis Gödel 1931 assumed and Rosser 1936
removed by **changing the fixed point**. Changing $\nu$ is an input to Lawvere's theorem,
not a consequence of it. Arithmetic witness for the same point:
$T=\mathsf{PA}+\neg\mathrm{Con}(\mathsf{PA})$ is consistent, r.e., satisfies HBL1, and
proves $\neg G_T$.

The headline of Cor 2.1's note is **not** disturbed — the logical half is 1969 prior art,
D0017's logical column contains no new mathematics. It covers less than we claimed and more
than we knew.

**3. The bridge: pun, now with two independent witnesses.** Seed148's Theorem 4 refutes it
by *locality* (cohomological obstructions are locally trivial, diagonal ones locally
stable) — confirmed, not re-derived. I add an obstruction of a different type, which needs
no site and no restriction maps:

> **Theorem 3.** Geometric obstruction towers are **graded** by $n$ and **terminate** above
> $\dim X$ ($H^{n+1}(X;\pi_n F)=0$). The diagonal tower is **ungraded** and never
> terminates: adjoin the escaping observation and `cantor` applies again at the same type
> level (`noTerminalStage`, a one-line term). So no stage-preserving $\mathfrak B$ with
> $\mathfrak B(0)=0$ exists over finite-dimensional $X$.

The two are independent, and Theorem 3 is available exactly where Theorem 4 is not — over
D0017 §G's ladder, which specifies no site.

**What a bridge would need** is stated exactly, four items, in §4 of the note. One of them
is decisive: it would need a *dimension* on the logical side under which the diagonal tower
dies. The corpus's only candidate is the reflection tower $T_\alpha$, and
`notes/REFLECTION_FACTOR_ADJUDICATED.md` §3 reports the classical answer (Turing 1939,
Feferman 1962): the tower depends on the computable presentation of $\alpha$, not its order
type. **(D2) is not merely missing; the one available construction is known not to supply
it.**

## Prior art, before the write-up

Lawvere 1969 (PDF, not read; his own "demystified Gödel and Tarski" quoted from nLab, and
§2 does not contradict it — his word is "consequences of some very simple algebra", and I
identify the non-algebraic residue); **Pavlović, Arch. Math. Logic 31 (1992) 397–406**, the
earliest post-Lawvere systematic treatment I found, abstract only, paywalled; Yanofsky 2003
(abstract read verbatim, full text not read — so I claim only that *our* Cor 2.1 omits the
hypotheses, not that he does); Roberts, Compositionality 2023 (arXiv:2110.00239), which
strips the hypotheses back *further* than cartesian closure — the logical half gets weaker
the harder you look, the opposite of what a bridge to the analytic side would need. I
searched for and did not find any source relating a Čech obstruction to Lawvere's theorem:
an independent re-run of seed148 §5's negative. Bell, *Incompleteness in a General Setting*
— PDF, would not decode; flagged as an unexamined lead whose title is exactly the §2
question.

## Toolchain, measured not quoted

The pin exists in this container. `LawvereDiagonal.agda` EXIT=0, `GodelSeparation.agda`
EXIT=0, and — worth flagging — **`Everything.agda` EXIT=0 with the new import in place**
(0 `error:` lines, 195 warning lines). Both `check.sh` and
`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` say `Everything.agda` is "currently expected red
under the pin". That expectation is stale as of this run. I report the measurement and did
**not** edit those files: one green run is evidence about this container and this moment,
not about the standing claim.

## Standing checks

The prompt's framing ("the logical half may be done and the corpus may not know it") was
half right and half wrong, and both halves matter: Tarski was done and unrecorded; Gödel
was recorded as done and is not. D0017 §G's recorded transcription gap (the
$\mathfrak F^{\langle n\rangle}$ tower, the commuting diagrams) is reported, not concluded
from — if the original carried a diagram exhibiting the bridge, Theorems 3 and 4 constrain
what it can have been but do not tell us what it was.
