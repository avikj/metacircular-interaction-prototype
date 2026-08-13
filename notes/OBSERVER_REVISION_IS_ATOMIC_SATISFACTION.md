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
