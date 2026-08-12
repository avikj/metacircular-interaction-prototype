# The smallest arithmetic witness crystal

Consider an integer read in binary. Retain only its remainder

\[
r\in\mathbb Z/3\mathbb Z=\{0,1,2\}.
\]

Appending a digit `d` changes the remainder by

\[
A_d(r)=2r+d\pmod 3.                                      \tag{1}
\]

Begin with a blind observer: it gives the same answer on all three states.
Its predictive quotient therefore has one state. Now admit one earned
observable

\[
q(r)=[r=0],                                               \tag{2}
\]

the question “is the binary integer divisible by 3?”

## The witness forest

Pairs `(0,1)` and `(0,2)` disagree immediately under `q`, so they are roots.
The remaining pair `(1,2)` does not. But appending `1` sends it to

\[
(A_1(1),A_1(2))=(0,2),                                   \tag{3}
\]

which is a root. Thus its shortest distinguishing experiment is the one-digit
word `1`. Reverse BFS gives the complete proof forest

```text
(1,2) --append 1--> (0,2) --look--> different
                         (0,1) --look--> different
```

Consequently all three residues are predictively distinct. This is the
smallest possible nontrivial propagation example: with only two states, a
nonconstant new Boolean observation already separates the sole distinct pair
at depth zero, so no predecessor witness can occur.

## The operation that becomes lawful

After the split, the machine can choose a shortest binary suffix making the
current integer divisible by 3:

\[
C(0)=\epsilon,\qquad C(1)=1,\qquad C(2)=01.              \tag{4}
\]

Indeed, (1) verifies each case. For example

\[
7=(111)_2\xrightarrow{\;1\;}(1111)_2=15,
\qquad
8=(1000)_2\xrightarrow{\;01\;}(100001)_2=33.
\]

This policy could not exist on the old one-state quotient. A fixed suffix
`w` of length `k` acts as

\[
r\longmapsto 2^k r+[w]_2\pmod 3.                         \tag{5}
\]

Because `2` is invertible modulo `3`, (5) is a bijection. It cannot send all
three old-indistinguishable residues to `0`. The new observation therefore
does not merely add a label: it licenses a state-dependent arithmetic action
that was mathematically impossible to define on the old quotient.

The causal chain is exact:

```text
divisibility observation
  -> two immediate pair seeds
  -> reverse-BFS witness for the hidden pair
  -> three predictive states
  -> shortest suffix-to-divisibility operation.
```

## Rigor boundary

Everything above is an elementary theorem about the three-state action (1).
The executable artifact performs the reverse BFS, replays every certificate,
and executes the compiled completion operation. “Earned” here means admitted
as a new exact observable; the artifact does not yet discover divisibility by
3 from an unexplained encounter. No claim of novelty is made for binary
divisibility automata or breadth-first distinguishing sequences. The result is
their assimilation into the repository's observation-refinement loop.

Run:

```bash
python3 machinery/arithmetic_witness_crystal.py
cd machinery && python3 -m unittest test_arithmetic_witness_crystal -v
```
