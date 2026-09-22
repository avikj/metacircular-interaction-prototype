# The Bend2 → HVM4 emitter

`Target/HVM4.hs` (in the patch) compiles cubical Bend2 to HVM4 surface syntax,
invoked with `bend file.bend --to-hvm4`. This is the chokepoint that turns
"checks" into "runs at the optimal bound" for the whole language.

## How it works

Normalize-then-erase. Each definition is `normal`-reduced first, so `coe` /
`hcomp` / `ua`-applications that compute are gone and the residual cubical
constructs are proof-level with no runtime content. Then HVM4 surface is
printed directly:

- **proofs and type-level formers erase** to the eraser `&{}` (`Set`, `Nat`,
  `Path`, `Eql`, `Rfl`, `coe`/`hcomp`/`ua` residue, interval);
- **path lambdas/applications pass through** their content (interval arg
  erased);
- **superpositions become real HVM4 SUP nodes** `&L{a,b}` — the point of
  targeting HVM4: `Sup`/`Frk`/`SupM` compile to native superposition /
  duplication, so `Sup × Path` transport is a *runtime* capability;
- every lambda binder is emitted cloned (`λ&x`) so the affine runtime accepts
  repeated use — the Carrier law as a syntactic obligation;
- Bend nat/list/bool/tuple ⇒ HVM4 `#Suc`/`#Zer`, `#Con`/`#Nil`, `#Pair`,
  matches ⇒ `λ{…}` switch lambdas.

## Verified end to end

`run_corpus.bend` (mul2/div2 with the proof `div2(mul2 n) = n`) emits to
`run_corpus_emitted.hvm4`:

    @div2_mul2 = λ&n. λ{#Zer: &{}; #Suc: λ&p. &{}}(n)   -- proof erased
    @mul2 = λ&n. λ{#Zer: #Zer; #Suc: λ&p. #Suc{#Suc{@mul2(p)}}}(n)
    @div2 = λ&n. …

and the emitted `@add`/`@div2`/`@mul2` genuinely REDUCE on the HVM4 C runtime
(e.g. `@add(2)(3) = #Suc⁵#Zer` in 25 interactions — not precomputed). A cubical
file (`cubical_test4.bend`) emits with everything erased except the live data,
and `sup_transport` survives as `&L0{0, 1}` — real superposition nodes.

## What this unlocks

- **Type-driven superposed synthesis**: drive `SUPGEN_DEMO`-style search from a
  Bend2 *spec-as-type*; the survivor arrives with an erasing type-theoretic
  certificate instead of a boolean test.
- **Certified data migration**: `ua(S1,S2,…)` + `coe` extracted and run as a
  lossless, self-inverting transform whose proof costs nothing at runtime.
- **Cubical corpus modules at the optimal bound**: the transport-heavy proofs
  that blew Agda's heap extract with proofs erased and run on the net.
