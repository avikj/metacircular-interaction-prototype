# Addition-chain predictive memory: a checked two-history boundary

## Exact finite result

`formal/pairfield/Pairfield/AdditionChainPredictiveMemory.lean` gives a
proof-relevant grammar for persistent addition histories.  A legal history
starts at `[1]`; each step appends a fresh sum of two values already present in
the trace.  The following histories are checked directly against that grammar:

\[
A=[1,2,3,6],\qquad B=[1,2,4,6].
\]

Both have endpoint `6`, but their formed-value sets have symmetric difference
exactly `{3,4}`.  More generally, the leaf proves

\[
m\in F_L\mathbin{\triangle}F_R
\quad\Longleftrightarrow\quad
\operatorname{available}(L,m)\ne\operatorname{available}(R,m).
\]

Thus the direct probes at `3` and `4` separate these two histories in opposite
directions.  This is an availability statement relative to persistent formed
sets: it does not infer a cost model or a preferred probe.

## Endpoint loss and the exact coding lower bound

The declared profile is the pair of Boolean availability answers at `3` and
`4`.  On the two-history type `Bool`, the profile map is injective, whereas the
endpoint map is constant.  Consequently there is no function from endpoint
alone that decodes this profile.

The coding theorem is stated independently of any particular encoder.  If

```text
encode : Bool -> Code
decode : Code -> Bool x Bool
```

replays the declared profile for both histories, then `encode` is injective.
For finite `Code`, this gives `2 <= Fintype.card Code`.  The Bool identity
encoder attains the bound, so one classical bit is necessary and sufficient
for this exact two-history/profile problem.

## Persistence control

Garbage-collecting both histories to `[6]` makes their declared profiles
definitionally equal and the resulting profile map noninjective.  The checked
lower bound therefore concerns retained predictive distinctions; it is not a
claim that an endpoint-only semantics secretly contains them.

## Novelty and scope fences

`CachePathOrder` supplies a generic order on option sets, and
`Swarm.S13OptionSpread` supplies a different finite spread calculation.  This
leaf adds neither generic architecture nor an analytic estimate.  Its
nonduplicate content is the checked addition-chain grammar, the exact
symmetric-difference characterization of direct probes, the endpoint
no-decoder, and the decoder-relative cardinality theorem with attainment.

No claim is made about shortest or optimal addition chains, arbitrary future
tasks or costs, classification of all histories, automatic probe selection,
quantum/process-tensor memory, thermodynamic memory, or the correctness of a
garbage collector.  A larger operational theorem would have to declare its
future observations and persistence policy explicitly.

## Literal Draw 7 provenance

The no-redraw encounter froze origin commit
`63244e542a7c2277f496a6cfbb810c5b0e02dae1`, tree
`92fd2271c05fe2d0873f67275467aa0acf94fd7a`, and a C-sorted frame of 1,072
tracked semantic `.agda`, `.lean`, and `.md` paths under `formal/`, `notes/`,
and `papers/`, excluding build products and this identity's six prior sampled
objects.  The frame SHA-256 was
`5c5e6f9c2b2e0c51a22fcfbb7a93dacb49a1aaefed4a1b1cf3eaa32130e9954a`.
With rejection limit `4294966928`, the sole `/dev/urandom` uint32
`1915523966` was accepted with zero rejections at zero-based index 398
(position 399), selecting `notes/ADDITION_CHAIN_PROCESS_MEMORY.md`, blob
`eae0ce12e4af3401bbddc7f4465537ae833fa00d`.

Focused replay:

```sh
cd formal/pairfield
lake env lean Pairfield/AdditionChainPredictiveMemory.lean
```
