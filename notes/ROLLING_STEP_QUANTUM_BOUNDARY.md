# Rolling power updates are reversible only on their promised state space

## 1. Two different updates

`ROLLING_POWER_CENTER` proposes replacing the retained ladder
`1,p,...,p^k` by a current step `s=p^ell`, updated by multiplication by `p`.
There are two mathematically different state spaces nearby:

1. a generic modular register `s in R_k=Z/p^kZ` with update
   `M_p(s)=ps mod p^k`;
2. the promised ladder state `(ell,p^ell)`, `0<=ell<k`, with transition
   `(ell,p^ell)->(ell+1,p^(ell+1))`.

The first is many-to-one. The second is injective because the promise/level is
part of the state.

## 2. Exact generic dilation cost

**Theorem 2.1.** For `0<=j`, coherent overwrite by

\[
M_{p^j}:s\longmapsto p^j s\pmod {p^k}                              \tag{1}
\]

on the full modular register needs minimum environment dimension

\[
\boxed{p^{\min(j,k)}}.                                             \tag{2}
\]

**Proof.** If `j<=k`, the kernel of multiplication by `p^j` consists of the
`p^j` multiples of `p^(k-j)`. Every nonempty fiber is one coset of this kernel
and has size `p^j`. If `j>=k`, the map is constant zero and its single fiber
has size `p^k`. The coherent quotient-dilation theorem identifies maximum
fiber size with minimum environment dimension. `square`

Thus each unsaturated rolling overwrite exports one additional base-`p` digit
to the environment. After `j` updates the exact garbage alphabet has grown to
`p^j`; after `k` it contains the entire original register. A closed unitary
cannot implement the generic overwrite in place.

## 3. Promise-indexed escape

On the declared ladder locus

\[
L=\{(ell,p^ell):0<=ell<=k\},                                      \tag{3}
\]

the preterminal transition is injective. Encoding the level `ell` (or an
equivalent causal promise) makes it a shift along distinct basis states, which
can be extended to a permutation/unitary after specifying endpoint behavior.
No `p`-dimensional garbage is forced on this restricted domain.

The promise is load-bearing. Forgetting `ell` and interpreting `s` as an
arbitrary modular value changes the operation back to (1). Nor may the
terminal state blindly update: `p^k=0 mod p^k`, so saturation requires a halt
flag, a larger integer register, or an explicitly extended cycle.

This is not a contradiction. Reversible cost is relative to the admitted
state space and transition, exactly as predictive memory is relative to future
instruments.

## 4. Change to the organism

The rolling representation is a valid memory optimization only as a typed
promise-indexed process. Its state must retain at least:

- the current ladder level or an equivalent invariant;
- the unsaturated/halt condition;
- the integer or modular interpretation of the step register.

A generic coherent implementation must not compile `s<-p*s mod p^k` as an
in-place unitary. It must either export one p-ary digit per update, preserve the
input, or use the promised ladder encoding.

This changes the next comparison. The full ladder and rolling ladder should be
compared as two reversible representations:

- retained ladder: more persistent power objects, fewer recomputations;
- promised rolling level: small live state plus repeated multiplication;
- generic modular rolling: apparent small state but accumulating environment
  garbage, hence not the intended optimization.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_rolling_step_quantum_boundary.py
python3 rolling_step_quantum_boundary.py
```

The fiber theorem and promise distinction are exact. Tests exhaust finite
maps. No gate-count lower bound, optimal reversible encoding, approximation,
thermodynamic erasure, quantum speedup, causal-order superposition, or
spacetime claim is made.
