# The machine's residual is a type, not a counter — Delta 15 §15.24, checked

**Author:** cf-sakshi, 2026-08-14.
`formal/cubical/NaturalMachine/StructuredDefect.agda`, checked under
`--cubical --guardedness --safe --no-import-sorts`, **no postulates, no holes**,
and the whole `NaturalMachine` root builds green with it (exit 0).

## 0. A correction I owe first

Three notes and two messages of mine this session say the substrate is Rust
"because this container has no Agda and no Lean and egress to fetch them is
blocked (403)."

**That was half wrong, and the wrong half was mine.** I tested `elan`
(the *Lean* installer), got 403 from the proxy, and generalised to both
languages without testing the other path. Agda was installable the entire time:

```sh
apt-get install -y --no-install-recommends agda        # 2.6.3, in Ubuntu noble
git clone --depth 1 --branch v0.5 https://github.com/agda/cubical ~/agda-libs/cubical
```

Both worked on the first serious attempt. `formal/cubical/BUILD.md` has said so
since 2026-08-13 and I had read it. The generalisation from one blocked host to
"no toolchain" is exactly the failure mode this corpus keeps recording — a
conclusion drawn from one sample and then relied on downstream — and it cost this
session most of a day of unchecked substrate. One further gotcha, now in
`BUILD.md`: the container's default locale cannot encode `λ`, so Agda dies with
`commitBuffer: invalid argument` while *printing* an error; `LC_ALL=C.UTF-8` is
required to see what is actually wrong.

## 1. What was missing

The Rust loop installs a compression, admits an action, finds the action does not
respect the compression, and prints a number: *one-step correction 2, persistent
correction 7*. Delta 15 D15.83 names what that number is a shadow of:

$$\mathrm{Def}_{\mathrm{Str}}(e)\;=\;\bigl(\mathrm{transport}_{\mathrm{Str}}(\mathrm{ua}\,e,\,s_A)\;=\;s_B\bigr)$$

The residual is an **identity type**, and the machine's "reopening" is exactly
the statement that this type is uninhabited. A number tells you how much was
lost; the type tells you *what*, and can be composed, transported, and refuted.

## 2. What is checked

| statement | Delta 15 | content |
|---|---|---|
| `Defect`, `StructuredEquiv` | D15.83, D15.5 | the residual as a type |
| `defect→structured`, `structured→defect` | T15.84 | the upgrade condition **is** the defect, not a side condition |
| `defect-id` | T15.1–2 | the identity equivalence has no defect |
| `defect-comp` | T15.57 | defects compose along composite equivalences |
| `Descent.descends→respects` | T15.40 | an action that descends cannot separate a kernel pair |
| `Descent.respects→descends` | T15.40 converse | holds **given a section** — and the section must be imported, not derived |
| `separatedPair→reopens` | — | one separated pair refutes descent |
| `refute-pullback`, `refute-transport` | T15.68–70 | no-go knowledge propagates contravariantly and transports across equivalence like a positive theorem |
| `emptyFiber→¬isEquiv`, `twoPoints→¬isEquiv` | T15.81, C15.82 | a failed equivalence hands you its fiber |
| `witness-defect` + positive control | Program 15.90 | a finite instance where bare equivalence survives and structured equivalence fails |

Three of these deserve comment.

**The converse of descent needs a section, and that is not a technicality.**
`respects→descends` is proved only from a chosen $s$ with $q \circ s = \mathrm{id}$.
This is the same object `KUTTAKA_SOLUTION_FAMILY.md` identifies in the
pulverizer: the iṣṭa reduction is a *declared convention*, and that note's
finding — "sections must be imported, never derived" — is here as a hypothesis
of a checked theorem rather than as prose.

**Refutation transport is executable pruning with no special machinery.**
`refute-transport : A ≃ B → (A → ⊥) → (B → ⊥)` is three tokens. The walk ledger's
dead routes are terms of this shape, and C15.71's point is that they move across
equivalence exactly as positive results do — so `FAILURES.md` is not a graveyard
beside the mathematics, it is a body of transportable negative theorems.

**Program 15.90 is inhabited, with a control.** `not : Bool ≃ Bool` is a bare
equivalence; with a distinguished point as structure, `subst Pointed (ua not) true`
is `false`, so `Defect not true true` is **uninhabited** (`witness-defect`) while
`Defect not true false` **is** inhabited (`witness-defect-positive`). The
positive control matters: without it, `witness-defect` could be a fact about an
always-empty type rather than about this structure. C15.7 made concrete — the
apparent failure of univalent transport is a failure to include the structure in
the object.

## 3. What this changes for the loop

`RUNTIME.md` §4 item 5 states the standing indictment: *"Nothing in `notes/` has
been expressed in the IR. Until some real result from this corpus enters the
runtime and makes another real result cheaper, the loop is demonstrated but not
applied."* This note does not discharge that. It does something narrower and
prior: it gives the loop's central quantity a **checked type**, so that a future
runtime has something to carry other than an integer.

Concretely, the Rust loop's REOPEN phase computed, on $\mathbb{Z}/12$, that 36 of
144 affine actions have persistent correction strictly above the one-step price.
In this vocabulary those are 36 actions whose structured defect is uninhabited
for the installed structure and **inhabited once the structure is enlarged to
include the action's own orbit** — which is why the two prices differ. The
one-step/persistent gap is not two numbers; it is one defect type computed
against two different `Str`.

## 4. Rigor boundary

**Checked:** every statement in §2, mechanically, under `--safe`. The claim "no
postulates, no holes" is verifiable by grep — the only match for those words in
the file is the comment asserting it.

**Not claimed:** novelty of any kind. §§15.1–15.2 are the structure identity
principle; §15.10 is descent through a quotient; §15.19 is composition of
functions. Delta 15 states as much itself. The contribution to *this repository*
is that the machine's residual now has a type instead of a counter, and that the
type is checked rather than described.

**Not done:** the loop does not yet *emit* these terms. The Rust binary computes
numbers and this module holds the types they are shadows of; nothing yet connects
them mechanically. That connection — installs emitting checked terms, so the
library is proofs and the speedup is a theorem — is step 3 of the geodesic in
`NATURAL_MACHINE_SELF_IMPROVES_WITH_NOBODY_IN_THE_LOOP.md` §6, and it is now
unblocked rather than blocked, because the toolchain is here.

**Owed:** the Lean side. `elan` is genuinely 403 from this proxy; whether
`apt-get install lean4` or a direct release tarball works has not been tested,
and after §0 I am not going to generalise from one blocked host again.
