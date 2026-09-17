# The Bend2 â’ HVM4 emitter

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
- **superpositions become real HVM4 SUP nodes** `&L{a,b}` â” the point of
  targeting HVM4: `Sup`/`Frk`/`SupM` compile to native superposition /
  duplication, so `Sup — Path` transport is a *runtime* capability;
- every lambda binder is emitted cloned (`Î»&x`) so the affine runtime accepts
  repeated use â” the Carrier law as a syntactic obligation;
- Bend nat/list/bool/tuple â’ HVM4 `#Suc`/`#Zer`, `#Con`/`#Nil`, `#Pair`,
  matches â’ `Î»{â¦}` switch lambdas.

## Verified end to end

`run_corpus.bend` (mul2/div2 with the proof `div2(mul2 n) = n`) emits to
`run_corpus_emitted.hvm4`:

    @div2_mul2 = Î»&n. Î»{#Zer: &{}; #Suc: Î»&p. &{}}(n)   -- proof erased
    @mul2 = Î»&n. Î»{#Zer: #Zer; #Suc: Î»&p. #Suc{#Suc{@mul2(p)}}}(n)
    @div2 = Î»&n. â¦

and the emitted `@add`/`@div2`/`@mul2` genuinely REDUCE on the HVM4 C runtime
(e.g. `@add(2)(3) = #Sucâµ#Zer` in 25 interactions â” not precomputed). A cubical
file (`cubical_test4.bend`) emits with everything erased except the live data,
and `sup_transport` survives as `&L0{0, 1}` â” real superposition nodes.

## What this unlocks (now mechanical, not blocked)

- **Type-driven superposed synthesis**: drive `SUPGEN_DEMO`-style search from a
  Bend2 *spec-as-type*; the survivor arrives with an erasing type-theoretic
  certificate instead of a boolean test.
- **Certified data migration**: `ua(S1,S2,â¦)` + `coe` extracted and run as a
  lossless, self-inverting transform whose proof costs nothing at runtime.
- **Cubical corpus modules at the optimal bound**: the transport-heavy proofs
  that blew Agda's heap extract with proofs erased and run on the net.

## Known edges (next passes)

- Sig-encoded user constructors emit as `#Pair`; a type-directed pass would
  recover named constructors (the HVM3 target's `extractTypeDef` shows how).
- `Fix` emits a let-style self-reference; wiring it to HVM4's `@fix` combinator
  for top-level recursive refs is cleaner. Top-level `@name` recursion already
  works (functions reference themselves by `@name`), which covers the corpus.
- normalize-at-emit precomputes closed mains (0 interactions); an
  erase-without-full-normalize mode would leave the computation for the runtime
  where that is the point.
