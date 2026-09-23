# Boolean preimage fibre: Bend/HVM execution receipt

The executable adapter is `collab/bend2-cubical/preimage_algebra.bend`.
It uses the repository's native `Carrier(A,B,f)` and `carry_transport`,
with

```text
preimage : Bool[] -> Bool
preimage xs = fold-xor xs false
```

The returned value is the carried source, Boolean image, and a
`Path(Bool, preimage source, image)`.  The source is never reconstructed
from a verdict: it is retained by the carrier and the witness is the
transport receipt.  This is the same shape used by
`collab/bend2-cubical/mining/MiningClaim.bend`, whose predicate is the
full 64-round SHA-256d Bitcoin acceptance predicate from
`MiningSha256.bend`.

## Checked and executed

Using Bend2 `f026483` and the repository HVM4 executable:

```text
✓ every definition is [total] or [productive]
4-bit source [True,False,True,True] -> True
  Itrs: 862   Heap: 8744
8-bit source [True,False,True,True,False,True,False,True] -> True
  Itrs: 1469  Heap: 10584
16-bit source [True,False,True,True,False,True,False,True,
               True,False,False,True,False,True,False,False] -> True
  Itrs: 2657  Heap: 14184
```

The output is HVM's native interaction counter (`-s`), not a host-side
step estimate.  The checked term is the same carrier transport that
appears in the SHA mining source; only the Boolean map is made small
enough for this local receipt.  The measured count grows linearly with
the source length for this fold (the map's recursive work and the
carrier/runtime boundary are both traversed once per bit).  It is not a
claim about the cost of the 192-round SHA instance: that cost is the
compiled full SHA term and must be measured after its literal constants
and conformance gate are emitted.

The result is a concrete preimage-algebra execution: the observable
Boolean is a projection of a value whose source and equality path remain
in the net.  Discarding the carrier would turn this into an ordinary
predicate and lose exactly the fibre data the calculus is intended to
retain.

## Full SHA-256d execution

I then generated the literal Bend constants directly from
`formal/cubical/Sha256.agda` (the Node helper is not required), compiled
`MiningSha256.bend` and `MiningClaim.bend`, and executed a full-runtime
HVM4 gate on the Bitcoin genesis header.  The three returned bits were:

```text
[ SHA256d(genesis) = known digest,
  genesis satisfies the target,
  Carrier restoration returns the exact genesis header ]
= [True, True, True]
```

The native HVM4 receipt was **26,553,327 interactions** and
**110,810,865 heap nodes** in 0.385 seconds.  This traverses two complete
SHA-256 invocations (three 512-bit compression blocks), all 64 rounds per
block, and the carrier restoration path.  The digest comparison is against
the canonical reversed-byte genesis digest; the target check uses the
genesis compact target.
