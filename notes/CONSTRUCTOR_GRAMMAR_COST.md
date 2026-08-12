# A small constructor grammar does not make its world free

Fix a base `b>=2`. Start with the empty word `epsilon` and admit the `b`
unary constructors

\[
A_d(w)=wd,\qquad 0\le d<b.                               \tag{1}
\]

The constructor *schema* has `b+1` declarations under the explicit convention
that the seed and each digit constructor cost one declaration. This convention
does not pretend to be a machine-independent bit encoding. It lets us compare
five quantities that must not be conflated.

## Exact accounting theorem

Let `T_{b,k}` contain every digit word of length at most `k`, connected by its
constructor edge from its prefix.

**Theorem.** The following costs are exact.

1. Schema declarations: `b+1`, independent of `k`.
2. Address length and constructor calls for one depth-`k` word: exactly `k`.
3. Depth-`k` words: `b^k`.
4. Nodes in the fully materialized shared prefix tree:

   \[
   |T_{b,k}|=1+b+\cdots+b^k={b^{k+1}-1\over b-1}.        \tag{2}
   \]

5. Constructor calls needed to materialize that tree once:

   \[
   |T_{b,k}|-1={b(b^k-1)\over b-1}.                     \tag{3}
   \]

6. Any fixed-length binary name capable of selecting every one of the `b^k`
   leaves has worst-case length at least

   \[
   \lceil\log_2(b^k)\rceil.                              \tag{4}
   \]

*Proof.* A depth-`i` word makes `b` independent choices, hence there are
`b^i`; summing gives (2). Every nonroot node has exactly one incoming
constructor edge, proving (3). A single leaf follows its unique root path of
length `k`, proving item 2. Finally `L` bits have at most `2^L` distinct fixed
length names, so `2^L>=b^k`, proving (4). ∎

Thus a constant-size law can define an exponentially large reachable world,
but it does not execute the paths, materialize their results, or specify which
result is meant for free.

## Syntax is not arithmetic value

Interpret a word by positional evaluation

\[
V(d_1\cdots d_j)=\sum_{i=1}^j d_i b^{j-i}.               \tag{5}
\]

Across all depths through `k`, the image is exactly
`{0,...,b^k-1}`, containing `b^k` arithmetic values. Therefore evaluation
identifies exactly

\[
{b^{k+1}-1\over b-1}-b^k={b^k-1\over b-1}               \tag{6}
\]

syntactic nodes beyond one representative per value. The fibers are visible:
zero has `k+1` names `epsilon,0,...,0^k`; a positive integer with canonical
base-`b` length `ell` has `k-ell+1` names, obtained by leading zeros.

At depth exactly `k`, in contrast, padded positional evaluation is a
bijection from the `b^k` words to `{0,...,b^k-1}`. The ambiguity is introduced
by joining several construction depths, not by positional notation itself.

## Observation adds a fourth cost

If the machine retains only value modulo `m`, the generated values expose

\[
\min(m,b^k)                                                \tag{7}
\]

distinct observed states, because the interval begins at zero. This retention
cost is neither the `b+1`-constructor schema, nor the `k`-step causal address,
nor the cost (3) of materializing the world.

For the binary mod-3 crystal in `ARITHMETIC_WITNESS_CRYSTAL.md`, depth two is
the first depth exposing all three residues. The constructor grammar has not
grown; the observer state has. Once those three states are retained, the
state-dependent suffix operation becomes lawful. The full cost vector is
therefore

```text
rule schema | causal address | executed calls | materialized world |
arithmetic quotient | observer quotient.
```

A theorem or program may compress one coordinate without compressing the
others. This is the exact caution needed by constructor-grammar formation: a
short generative law is real knowledge, but its outputs and the distinctions
needed to act on them remain physical/computational obligations.

Two simultaneous results complete the local comparison. The shortest-path
construction in `CONSTRUCTOR_GRAMMAR_FORMATION.md` prices the work of *forming
a rule* inside a declared grammar. `NAMING_RULE_REVERSIBLE_MEMORY.md` prices
the exact persistent state needed when the rule itself varies over a finite
family. The present theorem prices execution and the generated positional
world for one fixed grammar. None subsumes the others; together they prevent
formula length, formation distance, runtime, output multiplicity, and
reversible uncertainty from being reported as one number.

## Rigor boundary

All formulas are elementary exact statements under the declared unit-cost
model. No Kolmogorov-complexity claim is made; schema-description length
depends on a language. No claim is made that materializing the full tree is
necessary for a particular task. On the contrary, the point is that a task
may retain only the quotient (7), while causal addresses still regenerate any
needed representative. The executable exhaustively replays the formulas only
on small controls; the proof establishes them for every `b,k`.

Run:

```bash
python3 machinery/constructor_grammar_cost.py
cd machinery && python3 -m unittest test_constructor_grammar_cost -v
```
