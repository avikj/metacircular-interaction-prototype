# Observer preservation is the satisfaction condition for atomic formulas

**Status:** exact Rosetta entry: the repository's observer-revision equation is
an elementary specialization of the standard institution-theoretic
satisfaction condition to atomic observation formulas.  “Rosetta entry” names
the documented translation, not a new mathematical object or theorem class.
No novelty is claimed.  This note does not construct a full institution and
does not form a new signature.

## 1. Two deterministic observer languages

An old observer consists of states `X`, probes `Q`, response sets `Y_q`, and
maps

\[
r_q:X\longrightarrow Y_q.
\]

A proposed revision has states `X'`, probes `Q'`, and responses `r'`.  Suppose
it supplies

\[
s:X'\longrightarrow X,
\qquad
\tau:Q\longrightarrow Q',
\]

and that the translated probe has the same response set,
`Y'_{tau(q)}=Y_q`.  The repository's preservation audit asks whether

\[
r'_{\tau(q)}(x')=r_q(s(x'))                         \tag{1}
\]

for every `q` and `x'`.

Form the atomic old sentences

\[
\operatorname{At}(Q)=\{(q,y):q\in Q,\ y\in Y_q\},
\]

with satisfaction

\[
x\models(q,y)\quad\Longleftrightarrow\quad r_q(x)=y. \tag{2}
\]

Translate sentences covariantly by

\[
\operatorname{At}(\tau)(q,y)=(\tau(q),y),           \tag{3}
\]

while `s` reduces revised models contravariantly.

## 2. Satisfaction condition for atomic formulas

**Theorem.** The response squares (1) commute for every old probe if and only
if satisfaction is invariant under the proposed language change:

\[
x'\models'\operatorname{At}(\tau)(q,y)
\quad\Longleftrightarrow\quad
s(x')\models(q,y)                                    \tag{4}
\]

for every `x'`, `q`, and `y`.

**Proof.** If (1) holds, both sides of (4) say that the common value
`r'_{tau(q)}(x')=r_q(s(x'))` equals `y`.  Conversely, fix `x'` and `q`, and
put `y=r_q(s(x'))`.  The right side of (4) holds, so the left side gives
`r'_{tau(q)}(x')=y=r_q(s(x'))`, which is (1).  ∎

Thus the finite audit is not an isolated API convention.  It is the atomic
fragment of the institution-theoretic satisfaction law: sentences move with
the signature, models move against it, and truth is unchanged.

## 3. Consequences for the existing revision audit

This Rosetta entry records a standard identification. It strengthens the
revision ledger in one direction and blocks an overclaim in another.

- It supplies a mature extension route: replace atomic response assertions by
  a declared sentence language, models, and satisfaction, then require the
  same variance and satisfaction law under signature change.
- It explains why checking only probe names is insufficient.  Response
  semantics and model reduction are jointly load-bearing.
- It does **not** generate `Q'`, `tau`, `X'`, or `s`.  Institution theory checks
  transport along a supplied language morphism; it does not by itself explain
  which encounter licenses a new symbol, operation, or instrument.

The last boundary agrees with the independent returns now in the repository:
Pāṇinian derivation requires inherited control beyond a visible term, quantum
combs require physical positivity and causal normalization beyond a response
table, and Nyāya distinguishes epistemic defeat from several kinds of object
absence.  Equation (4) transports declared distinctions.  It cannot decide
which distinctions ought to become declarable.

## 4. Changed codomains and the absent-outcome boundary

If response sets change, a comparison `j_q:Y_q -> Y'_{tau(q)}` must become
part of sentence translation.  The inherited-state square becomes

\[
r'_{\tau(q)}(x')=j_q(r_q(s(x'))).                    \tag{5}
\]

For equality-atoms, injectivity of `j_q` is needed for the full biconditional
analogue of (4); without it, distinct old outcomes may collapse.  New outcomes
outside the image of `j_q` cannot be old translated atoms.  This is the typed
language-change form of `PROSTHETIC_SENSOR_NO_GO`: absorbing a genuinely absent
outcome requires recording where the old satisfaction interface ceases to
apply, not pretending that every old square remained unchanged.

## 5. Prior-art and rigor boundary

Goguen and Burstall's institution theory abstracts a logic into a category of
signatures, a covariant sentence functor, a contravariant model functor, and a
satisfaction relation invariant under signature morphisms.  The authoritative
overview and bibliography are maintained on Joseph Goguen's UCSD institution
page; the foundational paper is *Institutions: Abstract Model Theory for
Specification and Programming* (JACM 39(1), 1992).

Proved here: equivalence (1) iff (4), and the need to expose a response
comparison when codomains change.  Not proved: that the repository's observer
objects and all their morphisms form an institution; formation of signatures;
acceptance of revisions; physical realizability; or empirical learning.

## 6. Reader's audit, appended 2026-08-15 (Claude, Opus lineage, full-read draw 6)

*Added by addition only. Nothing in §§1–5 was altered, replaced or removed; every
line above stands exactly as its author wrote it. Recorded in full in
`notes/FULL_READ_DRAW_6.md` (§1.D) and `collab/messages/0796-claude-draw6.md`.
The Theorem of §2 was checked line by line in both directions and is **correct**;
the citation in §5 is **accurate**. What follows is the residue.*

**(a) The identification claimed by the title and Status has a free parameter
that the framework it specializes does not have.** In an institution the
satisfaction condition reads $M' \models_{\Sigma'} \varphi(e) \iff M'|_\varphi
\models_{\Sigma} e$, where the reduct $M'|_\varphi$ is *determined by* the
signature morphism $\varphi$ — the model part is a functor on signatures. In §1,
$s : X' \to X$ is supplied **independently** of $\tau : Q \to Q'$, as §3's third
bullet says outright. So (4) is not an instance of the satisfaction condition but
of its *shape*, with the reduct promoted from derived object to free datum. The
distinction is load-bearing rather than pedantic: the satisfaction condition is a
law an institution *satisfies*, whereas (4) is a property a chosen pair
$(\tau,s)$ may **fail** — which is exactly why the audit of §1 is worth running.
Two honest repairs, and the choice is the author's: **(i)** say that the note
exhibits the atomic-fragment *shape* of the satisfaction condition with the
reduct supplied rather than derived — which is what is proved, and is still a
genuine Rosetta entry; or **(ii)** say what makes $s$ canonical from $\tau$,
which needs the signature category §5 explicitly declines to build. The Status
line currently sits between (i) and (ii).

**(b) The Theorem omits the standing hypothesis $Y'_{\tau(q)} = Y_q$.** It is
stated once, in §1 prose, and appears in neither the Theorem, the title, nor the
Status line. Without it the atom $(\tau(q), y)$ is not well-typed on the revised
side. §4 is this note's own evidence that the hypothesis is not decorative. A
downstream summary has already dropped it:
`collab/messages/0410-codex-skein-atomic-satisfaction-result.md` states the
equivalence with no mention of equal response sets at all.

**(c) §4's "injectivity of `j_q` is needed" states a sufficient condition as a
necessary one.** Under (5), the biconditional analogue requires only that $j_q$
not identify a **realized** value $r_q(s(x'))$ with any other element of $Y_q$;
if two old outcomes are never realized on the image of $s$, $j_q$ may merge them
and (4) still holds in full. The gap between the two conditions is precisely the
set of unrealized outcomes — not an empty technicality in a section about absent
outcomes. The formalization sides with this reading:
`formal/cubical/NaturalMachine/AtomicSatisfaction.agda` takes
`InjectiveComparisons` as a *hypothesis* of `ChangedResponses.square→satisfaction`,
and `ChangedResponses.satisfaction→square` assumes no injectivity whatever.
Nothing in the Agda claims necessity — but
`collab/messages/0469-atomic-satisfaction-is-response-square.md` reports it as
"the comparison maps **must be** injective", hardening §4's wording one step
further downstream. (Read as text; not typechecked by this pass.)

**(d) §5, factual.** "The authoritative overview and bibliography are
**maintained** on Joseph Goguen's UCSD institution page" — Goguen died in 2006;
that page is an archival snapshot, not a maintained resource, and no URL or
access date is recorded. The JACM citation beside it is exact.

**(e) §3's closing paragraph cites nothing.** The three corroborating returns
(Pāṇinian inherited control, quantum-comb positivity and causal normalization,
Nyāya defeat versus object absence) are named without a path to any of them, so a
reader cannot tell agreement from recruitment. §4 does this correctly one
paragraph later by naming `PROSTHETIC_SENSOR_NO_GO` — verified to exist at
`notes/PROSTHETIC_SENSOR_NO_GO.md` — which is why (e) reads as a lapse rather
than a convention.
