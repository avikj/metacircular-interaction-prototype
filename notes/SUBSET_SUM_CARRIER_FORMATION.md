# A composable subset-sum carrier, and the label obstruction

The strict cancellation hierarchy proves that no bounded list of scalar
residuals serves every finite addition context. At finite prime-power depth
there is nevertheless an exact composable carrier. Its size and sufficiency
depend on whether contexts retain the identities of their inputs.

Fix (m=p^k), put (R=\mathbb Z/m\mathbb Z), and let
(a=(a_1,\ldots,a_n)\in R^n).

## The symmetric carrier

In the integral group algebra (\mathbb Z[R]), write (X^rX^s=X^{r+s}) and
define

\[
P_a(X)=\prod_{i=1}^n(1+X^{a_i}).                       \tag{1}
\]

**Theorem 1 (subset-sum distribution).** The coefficient of (X^r) in
(P_a) is exactly

\[
\#\{I\subseteq\{1,\ldots,n\}:\sum_{i\in I}a_i=r\text{ in }R\}. \tag{2}
\]

**Proof.** In expanding (1), choose (1) or (X^{a_i}) from each factor.
The choices are subsets (I), multiplication adds their exponents in (R),
and collecting equal exponents gives (2). ∎

Thus every statistic depending only on the distribution of subset-sum
residues factors through (P_a). In particular it determines how many
subsets have each truncated sum valuation (\min(v_p(\sum_{i\in I}a_i),k)),
with residue zero supplying the depth-(k) stratum. It does not identify
which subset has which value.

The carrier composes exactly. If (a\sqcup b) is a disjoint union of input
families, then

\[
P_{a\sqcup b}=P_aP_b.                                  \tag{3}

In coefficient coordinates this is cyclic convolution modulo (m). More
universally, (1) is the unique monoid homomorphism from finite residue words
under concatenation into the multiplicative monoid of (\mathbb Z[R]) that
sends the one-letter word (r) to (1+X^r). This is proof compilation: after
two carriers have formed, every aggregate subset-sum response of their union
is obtained by one exact convolution rather than revisiting the original
subsets.

## The label obstruction

Suppose instead that the action language contains a named context (C_I) for
each labeled subset (I\subseteq\{1,\ldots,n\}), with response

\[
C_I(a)=\sum_{i\in I}a_i\in R.                           \tag{4}

**Theorem 2 (no unlabeled compression).** Every carrier sufficient for all
labeled responses (4) determines the entire terminal residue tuple (a\in
R^n).

**Proof.** The admitted singleton contexts give
(C_{\{i\}}(a)=a_i) for every coordinate. Hence equality of carrier values,
followed by sufficiency, forces coordinatewise equality. ∎

The symmetric polynomial is therefore not sufficient for labeled contexts.
Already

\[
P_{(1,2)}=P_{(2,1)},                                    \tag{5}

\]

while the response of the labeled singleton ({1}) is respectively (1)
and (2) modulo every (m>2). The obstruction is not a bad polynomial
encoding; permutation invariance deliberately quotients the labels that the
named action language still uses.

## Observable formation event

The strict hierarchy asked for a carrier that composes across arity. Equations
(1)--(3) supply one only after an exact change of task:

```text
labeled contexts: terminal residue tuple is irreducible (singletons recover it)
       |
       | forget which subset produced which response
       v
symmetric contexts: group-algebra polynomial composes by convolution
```

This is a genuine transferable observable for the symmetric task: adding a
new input multiplies by one factor (1+X^a), and every future aggregate
subset-sum valuation query is answered from the updated carrier. It is not a
conservative replacement for the labeled observer. The permutation collision
(5) is the exact transport defect and records which capability was exchanged
for compression.

The swarm's terminal-trace no-go fits the same boundary. A completed nested
residue trace compresses to its terminal labeled residues because all earlier
charts are reductions. The polynomial performs a further quotient only when
the task itself is invariant under relabeling. Acquisition history and input
identity are two different things that may be forgotten, each requiring its
own factorization proof.

## Rigor boundary

Proved: coefficient identity (2), composition (3), its free-monoid universal
property, labeled irreducibility, and the permutation counterexample.
`machinery/subset_sum_carrier.py` executes cyclic convolution and exact labeled
queries; its tests independently enumerate small subset distributions as
falsifiers/replays.

Not proved: that (P_a) is injective on residue multisets—it need not be for
the theorem; minimality among all carriers for valuation distributions; a
compression for labeled valuation-only responses, which are coarser than the
labeled residue responses treated in Theorem 2; or formed-world internal
minimality before critical witnesses arrive.
