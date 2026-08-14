# One coherent valuation query resolves one ternary digit exactly

## 1. The opening left by the exact classical theorem

`ADAPTIVE_VALUATION_IDENTIFICATION` proves that identifying an unknown residue
in (\mathbb Z/3^k\) needs exactly (2k) adaptive classical valuation queries
in the worst case. `PROGRAMMABLE_CENTER_ORTHOGONALITY` proves that exact
coherent programming of distinct translations requires orthogonal program
states.

Orthogonality is not a ban on superposition. It supplies the program basis on
which a quantum query can act.

## 2. One digit as exact four-item search

Suppose the prefix (a=r\bmod 3^\ell) is known. For (d\in\{0,1,2\}), use

\[
c_d=-(a+d3^\ell)\pmod {3^k}.
\]

Then

\[
v_3(r+c_d)\geq \ell+1
\quad\Longleftrightarrow\quad
d\text{ is the next ternary digit of }r.
\]

Adjoin a fourth orthogonal program label (*) whose predicate is declared
false. The threshold oracle is therefore a phase oracle on four labels with
exactly one marked item:

\[
O_r|d\rangle=(-1)^{[d=d_r]}|d\rangle,
\qquad d\in\{0,1,2,*\}.
\]

> **Theorem.** One call to (O_r), followed by four-point inversion about the
> mean, maps the uniform state exactly to (|d_r\rangle).

**Proof.** Before the query every amplitude is (1/2). Afterward the marked
amplitude is (-1/2) and the other three are (1/2), so the mean is (1/4).
Reflection (x\mapsto2(1/4)-x) sends the marked amplitude to (1) and every
other amplitude to (0). ∎

Measurement yields the next digit with certainty. Updating the classical
prefix and repeating gives the full residue in exactly (k) coherent phase
queries, versus the proved classical optimum (2k).

## 3. Compatibility with the earlier no-gos

This result violates none of them.

- The four program labels are orthogonal, exactly as programmable-center
  orthogonality requires. The advantage comes from querying their
  superposition, not compressing them.
- Exact residue memory still has (3^k) mutually distinguishable states. This
  is query advantage, not storage advantage.
- The digits are measured between levels, so causal order is definite and the
  protocol is ordinary quantum-classical feedback, not indefinite causal
  order.

## 4. Load-bearing oracle boundary

The one-call statement is for the Boolean **phase threshold oracle** above. The
installed classical machinery returns an integer valuation response.

~~A reversible response-register oracle can compile the phase predicate by
compute--phase--uncompute, generally costing two calls unless a direct phase
interface is admitted.~~

**Correction 2026-08-14 (`RESPONSE_CHARACTER_KICKBACK_BOUNDARY`).** “Response
oracle” is not a sufficient type for that price. If the response is already the
Boolean threshold bit under XOR, its nontrivial `Z/2` character produces the
Grover sign in **one** call by phase kickback. If the response is an additive
trit, every sign character is trivial, so no nonconstant clean ±1 phase exists
in one character-state call. For an integer valuation register, two-call
compute–phase–uncompute is a generic upper bound, not a universal lower bound;
the group law, encoding, and threshold-extraction circuit must be named. The
organism must expose which interface it has and may not count an interface
change as free.

The fair exact comparison is one coherent threshold-oracle call versus two
worst-case classical threshold tests per ternary digit. Center construction,
diffusion gates, noise, and fault tolerance are not priced.

## 5. Changed next move

The zero-error quantum lane should no longer search for nonorthogonal memory
compression of exact profiles. It should search for coherent access to the
orthogonal control languages the organism already formed. The immediate
engineering obligation is now sharper: choose and type the response
representation. Install a Boolean threshold coordinate to retain the one-call
advantage, or price reversible extraction of that bit from the native value
encoding. There is no representation-independent “doubled-call boundary.”

## 6. Replay

The Python commands below are historical provenance and are retired under the
2026-08-13 substrate ban. The checked successor is
`formal/cubical/ResponseCharacterKickback.agda`; see
`RESPONSE_CHARACTER_KICKBACK_BOUNDARY` for the current replay.

```sh
cd machinery
python3 -m unittest test_ternary_grover_valuation.py -v
python3 ternary_grover_valuation.py
```
