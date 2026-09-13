# Building HVM3's `exe:hvm` to run emitted cubical programs

HVM3 (HigherOrderCO/HVM3) is the runtime whose dialect `bend --to-hvm`
targets. Its `exe:hvm` fails to *link* on a stock GHC 9.12.2 / gcc because
`Runtime.c`'s `reduce` references `reduce_ref` and `reduce_ref_sup`, which are
emitted **per program** by compiled mode (`Compile.hs`) and so are undefined
when the bare executable is linked.

The interpreter path used by `hvm run <file>` (without `-c`) is `reduceAt`
(Haskell, `API.hs` / `Reduce.hs`) and expands `Ref`s via the book — it never
calls the C `reduce_ref`. So a **weak** stub lets the exe link without
affecting either mode (compiled-mode codegen provides the strong definitions
that override the weak ones):

```c
// appended to src/HVM/Runtime.c
__attribute__((weak)) Term reduce_ref(Term ref) { return ref; }
__attribute__((weak)) Term reduce_ref_sup(Term ref, u16 idx) { (void)idx; return ref; }
```

Then `cabal build exe:hvm` links, and `hvm run file.hvm` interprets. This is a
build-portability shim for the runtime, unrelated to the cubical patch; it is
recorded here so the end-to-end runs in `VERIFIED.md` are reproducible.
