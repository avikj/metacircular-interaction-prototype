# Delta 18's falsifiable target is false, and the replacement is one line of grading

**Author:** cf-sakshi, 2026-08-14.
`formal/cubical/NaturalMachine/BuchstabDegree.agda`, `--cubical --safe`,
**no postulates, no holes**; `NaturalMachine` root green (exit 0).

## 0. The question, and why it was ranked first

Delta 18 lists three programs at the end. Two are translations expected to
succeed. One is marked falsifiable:

> **Buchstab target.** Embed outward child-selected dynamics into the full
> Hecke/Bruhat–Tits adjacency process, then identify $Q$ as the
> parent/forbidden/order-forgetting sector. Question: does the least-prime
> stopped kernel equal an excursion–return/memory correction after eliminating
> those branches? **This is falsifiable.**

`collab/orchestration/delta-coverage.md` put it first on the strength of that
last sentence alone. A negative answer to a falsifiable question is worth more
than three successful translations, because the translations were never at risk.

**The answer is no.** And the reason is available before any computation, which
is the outcome CLAUDE.md's rule asks for: the theorem the experiment would have
replaced is shorter than the experiment.

## 1. What T18.4 actually requires

The excursion–return identity is

$$K_t K_s - K_{t+s} = -\,P\,T_t\,Q\,T_s\,i,\qquad Q = 1 - iP,$$

and it is a statement about a **sector**. It presumes $i : S \to U$, $P : U \to S$
with $P \circ i = \mathrm{id}_S$, and it measures the failure of the ambient $T$
to restrict to the sub*space* $S$. `ExcursionReturn.agda` checks it in exactly
that generality, over an arbitrary ring, and `ExcursionReturn` §2 checks that the
right observer equivalence is the kernel of the observability map (T18.5/T18.6).

The hypothesis $P \circ i = \mathrm{id}_S$ is not decoration. It is what makes
$Q$ idempotent and the identity exact. Anything called "the $Q$ sector" must be
the complement of an actual retract.

## 2. Child selection is not of that form

On the rooted $(q+1)$-regular tree, put $\ell(v)$ = distance from the root. The
child operator $C$ and the parent operator $D$ satisfy

$$\ell(Cv) = \ell(v) + 1, \qquad \ell(Dv) = \ell(v) - 1, \qquad A = C + D,$$

so the full adjacency $A$ — Delta 18's "full Hecke/Bruhat–Tits adjacency
process" — is the sum of a degree $+1$ and a degree $-1$ operator, and Buchstab's
child-selected evolution is $K_t = C^t$, of degree $+t$.

"Eliminating the parent branches" therefore does not project onto a subspace. It
**keeps the degree $+1$ part of $A$ and discards the degree $-1$ part**. There is
no $S$, no $i$, no $P$, and no $Q$; there is a grading and a truncation of it.

This is not a quibble about formalism, because the grading has its own theorem
and it says something different. `ChargeGrading.agda` C15.25:

> the sector $X_c$ is closed under a degree-$\delta$ map exactly when
> $c + \delta \equiv c$ — and over $\mathbb{N}$, which is cancellative, only when
> $\delta = 0$.

Combined with T15.22 (degrees add under composition, `shift-comp`): $K_t = C^t$
has degree $t$, so **for every $t \ge 1$ there is no level sector for $K_t$ to be
the compression of.** Not "the compression has a defect" — there is no candidate
sector at all. That is the falsification, and it is three lines given the module
landed an hour earlier.

## 3. The finite witness

The structural argument is complete, but a claim of falsity should come with the
smallest object that exhibits it, so a reader can disbelieve the argument and
still be forced. Three levels of the $q=2$ rooted tree, seven vertices, exact
$\mathbb{N}$ arithmetic, everything by `refl`:

| | at the root |
|---|---|
| $A^2\delta_r$ | $2$ (`A²r≡2`) |
| $C^2\delta_r$ | $0$ (`C²r≡0`) |

$A^2 \ne C^2$, checked as `child-kernel≢walk`. And the difference is not an
excursion into a forbidden fibre: `A²≡C²+return`, verified at **every** vertex,
decomposes it as $CD + DC + D^2$, of which only $DC$ — descend, come back — is
nonzero at the root, contributing exactly $q = 2$ (`return-at-root`).

So the discrepancy is counted by the tree's branching number. It is a property of
$A$ containing $D$ at all, not a memory of an eliminated state.

## 4. What Delta 18 merged

The phrase "the parent/**forbidden**/**order-forgetting** sector" is doing two
jobs, and this is where the target went wrong. The corpus has both defects and
they are different objects:

| | defect | lives in | checked at |
|---|---|---|---|
| sector not invariant | $-PT_tQT_si$ | `ExcursionReturn` | T18.4/T18.5/T18.6 |
| operation not degree-zero | $c + \delta \ne c$ | `ChargeGrading` | C15.25, T15.22 |

Delta 18's own "New synthesis" paragraph — *ambient dynamics + non-invariant
selected sector + effective projected dynamics + excursion–return defect* — is
correct for the archimedean cone (selection A) and for fixed charge (selection C).
It is **not** correct for the tree orientation (selection B), which is the one it
flagged as falsifiable. Two of the three arithmetic selections have the claimed
common skeleton; the third has a different one. That the document itself
predicted which one was at risk is worth recording.

## 5. Rigor boundary

**Proved:** the grading argument of §2 (given C15.25 and T15.22, both checked
terms); every entry of §3; the decomposition of §4's first row (checked in
`ExcursionReturn`) and second row (checked in `ChargeGrading`).

**Refuted:** the specific identification Delta 18 offered — that the
child-selected kernel is T18.4's excursion–return correction for a parent sector.

**NOT refuted, and the distinction matters:** that Buchstab evolution has a
memory correction of *some* kind. What is shown is that the *branch selection*
contributes a grading truncation rather than a sector defect. The **stopping**
rule — least-prime ordering — is a separate selection, it is not modelled here at
all, and whether it carries a genuine T18.4 defect on top of the grading one is
open. That is the honest successor question, and it is sharper than the original
because half of the original has been removed from it.

**Not claimed:** anything about infinite trees or $\ell^2$ spectra. The finite
truncation suffices for a falsification and nothing here needs more; a positive
claim would have needed the analysis, which is why the negative was the cheap one
to run first.
