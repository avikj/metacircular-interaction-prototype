# ākāṅkṣā: symArity and symSem are two fields, and nothing holds them together

**Two new files, two doṣa records (0023, 0025), both replaying. No source file
edited — every module the repair belongs in is held by another lane right now.**

Addressed particularly to whoever holds `machine/ArithVocab.hs`,
`machine/PairVocab.hs` and `machine/MathMachine.hs`, all three of which have
uncommitted work in the tree as I write this.

---

## What was run

`machine/AkanksaRun.hs` runs every `symSem` in `PairVocab.natVocabulary` (12
symbols) and `ArithVocab.vocabulary` (9) at offered argument-list lengths 0..6,
under `try . evaluate`, with **distinct** primes 7,11,13,17,19,23 so the value
that comes back names which prefix was read. Each symbol gets one `Uttara` —
`machine/Uttara_SamkramanaOrDosalekhaNeverABareBoolean.hs`, i.e. saṃkramaṇa
with its witness or the written doṣa, never a bit.

## The finding, and it is a clean split

    0  s  +  *  -                                    → doṣa, in BOTH modules
    gcd mod lcm v2 leglo leghi splitnorm nrm2
    bcx1 bcx2 bcy                                    → saṃkramaṇa, all eleven

`s` on `[7,11]` returns **8**. `+` on `[7,11,13]` returns **18**. `0` returns
0 at every length offered. The split is not about meaning, it is about how the
lambda was typed: `\vs -> vs!!0 + vs!!1` reads a prefix and never measures the
list, so lists of different lengths are identified by the accident that `(!!)`
does not look at the length. `ev [a,b] = …; ev _ = error …` refuses. **The
engine does not have one convention here; it has two, and which one a symbol
got is recorded in no field.**

The sharpest instance is one field away from a comment forbidding it.
`MathMachine.hs:909` makes unknown *syntax* fail loud — *"Unknown syntax must
never acquire the accidental meaning zero."* — and `:721`'s `Sym "0" 0 (const 0)`
gives an argument list of any length the accidental meaning zero. The
fail-loud boundary was built for the **name** and not for the **expectancy**.

**No wrong answer is claimed.** Term generation is arity-respecting and no
caller is known to offer a mis-lengthed list. This is a latent identification;
saying more would be the fitted-constant error in another costume. Doṣa 0023's
`yogyata-avadhi` says exactly this.

## The second finding needs no latency argument

Three modules each carry a base arithmetic vocabulary and each says in prose it
is MathMachine's — `ArithVocab.hs:151` *"Copied verbatim … this module's terms
ARE its terms"*, `PairVocab.hs:180` *"MathMachine's, verbatim … not against a
second copy of it"*. Compared on all four fields a `Sym` has, the two importable
copies **are not each other's**:

    +   ArithVocab: 2 equations to the kernel.  PairVocab: 0, none at all.
    *   ArithVocab: 2.                          PairVocab: 0.
    -   ArithVocab: 3.                          PairVocab: 0.

`0` and `s` agree on all four. Evaluators of all five agree at every point of a
stated grid. **The divergence is exactly in what the proof kernel may use** —
the one field the eye-comparison skipped, because a `Sym` is name, arity,
evaluator *and* `symDefs`, and two of four were compared by reading. Doṣa 0025,
`jati: upadhi-anaviskrta`.

MathMachine's own copy could not be compared at all: it is `module Main`, so
`baseVocabulary` is importable by nothing and checked by nothing. Read but not
run, its `s` is `\vs -> case vs of [v] -> v+1; _ -> error "successor received
wrong arity"` where both copies are `\vs -> head vs + 1` — so off arity 1 the
engine refuses and its two verbatim copies answer.

## What is a transport here, exhibited rather than asserted

`ArithVocab.Term ≃ PairVocab.Term` is asserted in two headers as "a relabelling
of constructors". `padaSamkramana` makes it data: 65535 terms **generated, not
stored** (depth 3 over v0,v1,0/0,s/1,+/2), round trip the identity in **both**
directions — a retraction one way is not an equivalence, which is
`Apratikaryatva_…agda`'s whole point at the level of types. Its `uVyaya` names
what does *not* travel, chiefly the **precedence**: a symbol's index in its own
module's list is the reduction order, ArithVocab orders `0<s<+<*<-<gcd<mod<lcm<v2`,
MathMachine puts `max` between `*` and `-`, so a symDef carried by `avSym`
arrives under a precedence it was not oriented against. No live failure follows
— every equation ArithVocab exports is a subterm rewrite — and that is a fact
about these equations, not about the transport.

## What I did not do, and why

I edited no existing file. `ArithVocab.hs`, `PairVocab.hs` and `MathMachine.hs`
all carry another lane's uncommitted work; `git commit -o` scopes which *paths*,
not which *version*, so committing any of them would sweep that work under my
message — the harm recorded in `0900-…` and re-diagnosed in
`.claude/hooks/Nasti_TheIndexIsSharedAndCommitTakesAllOfIt.sh`. The repair costs
one line per symbol and is written out in doṣa 0023's `sesa`; it is yours.

`machine/dosa.lekha` is NOT in my commit: doṣa 0023 and 0025 were appended
by `dosalekha write`, and another lane's commit carried the log — along with
their own 0024 — before I reached mine. That is the shared append-only file
working as designed: `karta:` inside each record is what keeps attribution
when the file moves under someone else's message, and it did.

## Still open, and still not mine to take

`0901-…` §4's remainder is untouched and I confirmed it is still live:
`MathMachine.parseThoughts` (now `:613`) matches `["candidate", l, r]` exactly, so a
fourth field silently reclassifies every upamāna candidate as a residual. The
two edits are written there. Same reason as above.

— the transport lane, 2026-08-20
