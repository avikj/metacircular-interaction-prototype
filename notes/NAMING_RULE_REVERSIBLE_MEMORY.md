# Reversible memory counts naming behaviors, not formula symbols

Let `I` be a finite address set, `A` a finite alphabet, and
`F subseteq A^I` a family of naming rules.  A memory encoding assigns a density
operator `rho_f` to each `f in F`.  Exact random access means that for every
address `i` there is a channel `D_i` whose classical output is `f(i)` with
probability one on input `rho_f`.

## Theorem (exact naming-memory dimension)

The minimum Hilbert-space dimension of an exact random-access memory for `F`
is

\[
\boxed{|F|}.                                                     \tag{1}
\]

Here `F` means distinct functions, not syntactically distinct programs.

*Proof.* Take distinct `f,g in F`.  Some address `i` satisfies
`f(i) != g(i)`.  The channel `D_i` maps `rho_f,rho_g` to different deterministic
classical outputs, hence to states with orthogonal support. Fidelity cannot
decrease under a quantum channel, so the input fidelity is zero; equivalently
the supports of `rho_f` and `rho_g` are orthogonal. This holds for every
distinct pair, so the ambient Hilbert space contains at least one nonzero
orthogonal support per function and has dimension at least `|F|`.

Conversely, use an orthonormal basis `|f>` indexed by `F`.  At address `i`, a
controlled classical lookup copies `f(i)` to the output while retaining
`|f>`.  This is an isometry and attains dimension `|F|`. ∎

The theorem is representation-independent: an explicit table, expression,
grammar, circuit, or short program can share a memory state exactly when it
defines the same function on the declared address set. A name compresses
reversible state only by restricting which behaviors remain possible.

## Arithmetic example: affine rules on five residues

Let `I=A=F_5`. The unrestricted family of tables `F_5 -> F_5` has

\[
5^5=3125
\]

members, so exact random access to an arbitrary table needs dimension 3125.
Now restrict to the generated affine rules

\[
f_{a,b}(i)=ai+b\pmod 5,\qquad (a,b)\in F_5^2.                  \tag{2}
\]

They are all distinct: `f(0)=b`, and then `f(1)-f(0)=a`. Hence the affine
family has exactly 25 behaviors and needs dimension exactly 25. Two queries,
at addresses `0` and `1`, reconstruct its compact coordinates `(a,b)`.

This is a genuine 3125-to-25 state reduction, but its cause is exact: the rule
admits only 25 of the 3125 possible tables. The five-dimensional address
register is a separate resource supplied to each query. For one fixed public
rule, `|F|=1` and the persistent program carries no variable state at all;
only query, output, and execution resources remain. Counting the written
symbols of that fixed rule as memory would mix description cost with state
uncertainty.

## Relation to generated objects

An explicit list of outputs is not intrinsically more expensive when the list
is fixed and public: it too can be hard-wired. The comparison becomes
mathematical only after declaring a family of possible lists and an access
task. Under exact random access, the theorem gives the complete state cost.
Formation time, gate count, temporary workspace, sequential-only access, and
the cost of constructing the query address remain independent coordinates.

Replay:

```sh
cd machinery
python3 -m unittest test_naming_rule_memory.py -v
python3 naming_rule_memory.py
```

## Rigor boundary

Finite families, exact zero-error readout, and a separately supplied classical
address are assumed. The result does not cover approximate random-access
codes, average-case distributions, gate complexity, thermodynamic work,
Kolmogorov complexity, or infinite grammars. It is an application of standard
perfect distinguishability/data processing, not a novelty claim.
