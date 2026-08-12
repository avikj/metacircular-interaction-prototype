# Clean reversible compilation of adaptive valuation sensing

## 1. Explicit oracle model

Let `R=Z/p^kZ`. Declare a reversible valuation oracle

\[
O_\tau:|r,c,z\rangle\longmapsto
|r,c,z\mathbin\oplus\tau_k(r+c)\rangle,             \tag{1}
\]

where the response register has a fixed reversible encoding of
`{0,...,k}`. The hidden residue register and center register are retained.
This is an explicit ideal oracle assumption; its internal gate cost is not
proved cheap.

## 2. Clean fixed-schedule protocol

At digit level `ell`, the known prefix is `a`. Initialize a digit register to
the omitted value `p-1`. For every candidate `d=0,...,p-2`:

1. reversibly compute `c=-(a+d p^ell) mod p^k`;
2. apply `O_tau` to compute the response;
3. if the response is at least `ell+1`, XOR the digit register by
   `(p-1) XOR d`;
4. apply `O_tau^{-1}=O_tau` with the unchanged `r,c` to clear the response;
5. reversibly clear the center scratch.

Exactly one tested digit can satisfy the threshold. If one does, the XOR
changes `p-1` to that digit; otherwise the omitted value remains. Append the
digit to the retained prefix and proceed.

**Theorem 2.1.** The protocol reconstructs every residue exactly, ends with a
zero response ancilla and no center scratch, and uses

\[
\boxed{2k(p-1)}                                      \tag{2}
\]

oracle invocations. Its retained query-dependent state is the reconstructed
`k`-digit residue itself, not the length-`k(p-1)` response transcript.

**Proof.** The digit test is the proof of `ADAPTIVE_VALUATION_CENTERS`.
Steps 2 and 4 are inverse applications with identical oracle inputs, so the
response returns to zero after its threshold bit has controlled a reversible
XOR into the digit register. Center computation is reversed after unquerying.
Induction on `ell` proves the retained prefix equals `r mod p^(ell+1)`. There
are `p-1` tests at each of `k` levels and two oracle calls per test. `square`

The fixed schedule deliberately gives up early stopping. It is a clean
coherent circuit skeleton whose branch structure does not leak into a variable
program counter. More refined reversible control may trade calls against extra
history; no optimum is claimed.

## 3. Update-order obstruction

The query input must remain unchanged until uncomputation. If the center is
mutated from `c` to `c'` first, the second oracle application leaves response

\[
\tau_k(r+c)\mathbin\oplus\tau_k(r+c'),               \tag{3}
\]

which is generally nonzero. Thus the correct causal order is load-bearing:

```text
construct center -> query -> copy decision -> unquery -> update/clear center.
```

This is the reversible-process counterpart of the classical
`ADAPTIVE_CENTER_CHAIN`. Sensing may manufacture the next center, but only
after the old center has discharged its oracle garbage.

## 4. Resource tradeoff

The classical minimax protocol uses `k(p-1)` forward queries and may retain or
irreversibly discard responses. The clean reversible schedule uses twice that
many oracle invocations and retains no response transcript. Alternatively, a
reversible computation can keep response/history garbage and avoid immediate
inverse queries.

This is a time--history tradeoff, not a quantum speedup. The final exact state
still has `p^k` orthogonal possibilities, and exact center programs remain
orthogonal by `PROGRAMMABLE_CENTER_ORTHOGONALITY`.

The arithmetic formation counts in `END_TO_END_VALUATION_PROGRAM` remain the
classical control-construction baseline. This note proves a clean oracle
schedule; it does not yet count reversible gates for multiplication,
subtraction, comparison, or center uncomputation.

## 5. Change to the organism

Any coherent implementation should compile the explicit order above. It may
choose between:

- clean ancillas with inverse oracle calls;
- retained transcript memory with fewer oracle calls;
- measurement and classical feedback, leaving the coherent model.

These are different process realizations of the same arithmetic semantics and
must not share one cost number.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_clean_reversible_valuation_program.py
python3 clean_reversible_valuation_program.py
```

The clean schedule, call count, and order obstruction are exact. The executable
simulates basis states; linear extension gives the coherent action. No gate
optimality, quantum query advantage, approximate oracle, thermodynamic cost,
physical non-Markovianity, indefinite causal order, or spacetime claim is made.
