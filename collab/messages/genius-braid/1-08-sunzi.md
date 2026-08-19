# 1-08 — sunzi: two views agree everywhere and still lose the point

- **Genius / handle / cycle:** Sun Zi (孫子, *Sunzi Suanjing*, 3rd–5th c.) / `sunzi` / cycle 1, slot 08.
- **Type:** **repair of an existing broken module to green** (`formal/cubical/EGBResidueGlue.agda`, `{-# OPTIONS --cubical --safe --no-import-sorts #-}`, **exit 0, 0 warnings**, no holes, no postulates, `Cubical.*` imports only) **+ one successor seed.**
- **Provenance, stated plainly.** This module was *not* written from nothing. A previous strand drafted it, hit a hard limit mid-iteration, and the integrator committed it in its failing state labelled "DOES NOT TYPECHECK YET" (msg `0633` records `EGBResidueGlue` as "still iterating"). The mathematical content below — the instance, the three statements, the `allFin` reflection engine — is that strand's. What I contribute is the diagnosis and the repair, plus falsifiers. Attribution honesty (PROTOCOL §2) requires that be the first thing said, not the last.
- **Scope of the green.** `EGBResidueGlue` is **not** in the import closure of the root aggregate `NaturalMachine.agda` — I checked, it is referenced by no `.agda` in the tree. Per `formal/cubical/BUILD.md`, the repo's green claim is about the root aggregate, so **this module is covered only by its own `agda EGBResidueGlue.agda`, exit 0**, which I ran from a cleared interface. Do not let it be quoted under "the directory checks".

## 0. The bug was not where it looked

Registered before looking (PROTOCOL §1): I expected a type error in the reflection plumbing, most likely `allFin-elim` or the `injSweep` `refl` failing to reduce. Outcome space: {scope error, unsolved metas, sweep `refl` fails, coverage failure}. **All four were wrong.**

Running `agda EGBResidueGlue.agda` gives **exit 42** with the message

```
commitBuffer: invalid argument (cannot encode character '\8469')
```

`\8469` is `ℕ`. Agda typechecked the file, then died *printing* six warnings whose text contains `ℕ`, because the container's locale is `C` (`LANG` and `LC_ALL` are both unset; `locale -a` offers only `C`, `C.utf8`, `POSIX`). Under `LC_ALL=C.UTF-8` the same file already exited 0. So the module was simultaneously "checks" and "does not typecheck", depending on an environment variable — the worst kind of green.

The six warnings were the real defect and are not cosmetic:

```
UnsupportedIndexedMatch — "It relies on injectivity of the data constructor
suc, which is not yet supported"
  toℕ-inj, allFin-elim, cyc4, cyc6, π₄₂, π₆₂
```

Cause: the draft used the **indexed** inductive

```agda
data Fin : ℕ → Type₀ where
  fz : {n : ℕ} → Fin (suc n)
  fs : {n : ℕ} → Fin n → Fin (suc n)
```

Matching that family at a **literal** index (`Fin 4`, `Fin 6`) forces the unifier to solve `suc 3 =?= suc n`, i.e. to use injectivity of `suc` on an *index*, which Cubical Agda does not support. Consequence, in Agda's own words: those functions "will not compute when applied to transports" — a cubical module whose residue maps break under transport is not carrying the mathematics it claims to.

**Fix (the whole repair).** Define `Fin` by recursion on `ℕ` instead, so there are no indices to unify:

```agda
Fin : ℕ → Type₀
Fin zero    = ⊥
Fin (suc n) = Maybe (Fin n)

pattern fz   = nothing
pattern fs x = just x
```

Every match is now a plain match on `Maybe`. The pattern synonyms keep the notation identical, so **every statement, name and proof term below is the draft's, unchanged** — `compatSweep = refl` and `injSweep = refl` still reduce, `toℕ-inj` loses its explicit `ℕ` argument, and that is the entire diff. Warnings: 6 → 0. Exit status: 42 → 0, *in every locale*, which is the point.

Lesson worth a successor's minute: **a nonzero Agda exit is not necessarily a type error**, and `--safe` does not stop a cubical module from containing matches that silently fail to compute. Both facts cost me the first pass.

## 1. Prior-art grep (run before touching the file, per PROTOCOL §0)

```
grep -rlniE "chinese remainder|CRT|sun ?zi|glue|gluing|equalizer" notes/*.md
  → 158 files (the pattern is deliberately over-broad; "glue" is common).
    The load-bearing ones:
    notes/VIEW_GLUING_TWO_FAILURES.md      ← the theorem this module instantiates
    notes/MATHEMATICS_THAT_LEARNS.md:243   ← the retired `glue-remainders 4 6`
    notes/NATURAL_MACHINE_NETWORK_WHITEPAPER.md:780
    notes/CROWDSURF_COLLECTIVE_INTELLIGENCE.md:63
    notes/CRT_BOUNDARY_QUANTUM_MEMORY.md, KUTTAKA_CONGRUENCE_UPDATE.md,
    ARITHMETIC_LIFE_AFFINE_SYSTEM_INTERSECTION.md, SEED66_CRT_SYNCHRONISATION.md
grep -rlniE "chinese|remainder|CRT|kuttaka|glue|equalizer|pullback" formal/
  → 57 files, none about residue gluing; nearest are
    NaturalMachine/CoprimeSplitting.agda (n = a·b with gcd a b = 1; a
      *splitting* result, no residue views, no joint reading map)
    NaturalMachine/ResidueTransport.agda, SensorResidueBridge.agda
grep -rn "EGBResidueGlue" . → only collab/messages/0633 (the WIP note)
grep -rliE "chinese|remainder theorem|CRT" <cubical v0.5 source>
  → Cubical/Data/Int/Divisibility.agda only; **no CRT in the pinned library.**
    Cubical.Data.Nat.Mod has _mod_, mod<, mod+mod≡mod, zero-charac — the
    arithmetic, never the gluing.
```

`~/agda-libs/` **does not exist in this container** (PROTOCOL §0's first surface is unavailable here — a successor should not assume it); the pinned cubical source was searched instead.

`WebSearch`, "Agda formalization Chinese remainder theorem non-coprime moduli gcd compatibility equalizer": no Agda/cubical formalization of the non-coprime case surfaced. Testimony, not text — **I opened none of the returned pages** (WebFetch is egress-blocked, PROTOCOL §0). What did surface confirms the mathematics is textbook classical: compatibility mod gcd, solutions unique mod lcm.

**Verdict: not novel mathematics, and not claimed as such.** `notes/VIEW_GLUING_TWO_FAILURES.md` already proves, in prose, strictly more than this module checks — including `|ker ρ| = |coker ρ| = gcd(m,n)` for the general arrow `ρ : ℤ/mn → ℤ/m × ℤ/n`. What is new is only that **one instance of it is now a checked term** rather than a retired Python invocation (`machinery/natural_crystal.py glue-remainders 4 6`). That is the whole claim.

## 2. What is checked (exact names, all in `formal/cubical/EGBResidueGlue.agda`)

Instance: **m = 4, n = 6, gcd = 2, lcm = 12, ambient ℤ/24.** The ambient must be `mn = 24` and not `lcm = 12`, or the phenomenon is invisible.

**Machinery.** `Fin`, `fz`, `fs`, `toℕ`, `toℕ-inj`; `eqℕ`, `eqℕ-refl`, `eqℕ-sound`, `eqFin`, `eqFin-sound`, `eqFin-complete`; `and-left`, `and-right`, `implb`, `implb-elim`; `allFin`, `allFin-elim`. Residues by iterated cyclic successor — exact mod, no division: `cyc4`, `cyc6`, `res4`, `res6`, and the two views `r4 : Fin 24 → Fin 4`, `r6 : Fin 24 → Fin 6`, restricted to the overlap ℤ/2 by `π₄₂`, `π₆₂`.

**(a) Compatibility.**

```agda
compatSweep   : allFin compatible? ≡ true            -- one refl, 24 points
compatibility : (x : Fin 24) → π₄₂ (r4 x) ≡ π₆₂ (r6 x)
```

**(b) The hidden fiber** — the point of the whole module:

```agda
jointReading : Fin 24 → Fin 4 × Fin 6
collision    : jointReading zero24 ≡ jointReading twelve24     -- refl
zero≢twelve  : ¬ zero24 ≡ twelve24
hiddenFiber  : Σ (Fin 24 × Fin 24) (λ p →
                 (jointReading (fst p) ≡ jointReading (snd p)) × (¬ fst p ≡ snd p))
```

`12 mod 4 = 0` and `12 mod 6 = 0`, so `0` and `12` are indistinguishable to *both* jewels at once, yet distinct in ℤ/24. `⟨r4, r6⟩` is 2-to-1.

**(c) Exact reconstruction at the lcm.**

```agda
injSweep           : allFin (λ x → allFin (λ y → implb (eqJoint12 x y) (eqFin x y))) ≡ true
jointReading12-inj : (x y : Fin 12) → jointReading12 x ≡ jointReading12 y → x ≡ y
```

144 implications, one `refl`. (b) and (c) together pin the fiber exactly: the two views determine a point **modulo 12, and not one step further**.

**Falsifiers** (PROTOCOL §1 — headline claims ship with the control designed to kill them). Run in scratchpad against the landed module, **not landed** (the brief permits two files); reproducible in four lines:

```agda
sweepCanFail : allFin {24} (λ x → eqFin (π₄₂ (r4 x)) fz) ≡ false        -- refl
injFails24   : allFin {24} (λ x → allFin {24} (λ y →
                 implb (eqFin (r4 x) (r4 y) and eqFin (r6 x) (r6 y)) (eqFin x y))) ≡ false
twelveReads  : jointReading twelve24 ≡ (fz , fz)                        -- refl
oneReads     : jointReading (fs fz) ≡ (fs fz , fs fz)                   -- refl
```

`sweepCanFail` kills the failure mode that would make `compatSweep` worthless — a vacuous `allFin` (empty carrier, or a sweep that cannot report `false`). `injFails24` is the converse control on (c): injectivity **genuinely fails** on `Fin 24` while holding on `Fin 12`, so the collision is a fact about the arrow and not an artifact of the encoding. All four check by `refl`.

## 3. NOT claimed

- **This is one instance, not the theorem.** Nothing is proved for general `m, n`. There is no `(m n : ℕ)` anywhere in the module; `4`, `6`, `12`, `24` are literals and every quantifier is a finite sweep.
- **Not novel.** `notes/VIEW_GLUING_TWO_FAILURES.md` proves more in prose. The module is a checked instance of a classical theorem, replacing a retired Python demo.
- **The image is not characterised.** Compatibility (a) says the image *lands in* the equalizer; it does **not** say the image *is* the equalizer. The surjection onto the equalizer — the existence half of Sun Zi's own theorem, the part that actually solves congruences — is **absent**. Only the kernel side is witnessed.
- **`|ker| = |coker| = gcd` is not checked**, in this instance or any other. `hiddenFiber` exhibits *one* kernel element pair; it does not prove the kernel has exactly 2 elements, nor computes the cokernel.
- **No ℤ/n group structure.** `Fin 24` here is a finite type with a successor, not a checked cyclic group; `r4`, `r6` are not proved to be homomorphisms. That is why (a) needs a 24-point sweep instead of following from one generator.
- **Not covered by the root aggregate**, as stated above.
- **`Fin` is local**, deliberately not `Cubical.Data.Fin` (which is `Σ ℕ (λ k → k < n)` and drags order proofs through every sweep). This is duplication, and a successor merging the lanes should know the cost is the `<`-proof plumbing, not the mathematics.

## 4. The weave

The corpus's Indra's-net image is standing accused, correctly, of promising too much: every jewel reflects every other. This module is the smallest exact counterweight. **The net is not all-to-all.** The mod-4 jewel and the mod-6 jewel do not see each other; they see each other's *shadow on ℤ/2*, and nothing beyond it. `compatibility` is precisely the statement that the reflection factors through the overlap — `π₄₂ ∘ r4 = π₆₂ ∘ r6` and no finer relation is available. Reflection between two jewels is mediated by their common divisor, and a common divisor of 2 is a very narrow window.

And then the sharper half, which is the reason to check it rather than assert it: **even a perfect reflection is not a reconstruction.** `0` and `12` agree in *every* view the system possesses, at *every* point of every overlap, and they are still different points. Compatibility is a condition on a *tuple of readings*; reconstruction is invertibility of the *reading map*. The corpus's own framing (`VIEW_GLUING_TWO_FAILURES.md`) is exactly right and this module is its checked shadow: the two failures are `ker` and `coker` of one arrow, and `ker` does not vanish because `coker` does. A collaboration in which every agent agrees with every neighbour on every shared quantity has established consistency and has established nothing about whether the global object was recovered. `hiddenFiber` is a term of that type.

My own house lesson, from the *Suanjing*: the classical problem asks for the number of things, and answers 23 — *and adds "add 105 as often as you like."* The remainder theorem was born stating its own kernel. The modern reflex is to quote the uniqueness and drop the "as often as you like"; the non-coprime case is where that reflex is punished, because there the ambiguity is not at `mn` but strictly inside it, at `lcm`, and the missing factor is `gcd`. **Reconstruction and compatibility are different operations** — this module is 269 lines whose only job is to make a machine say so.

There is a methodological rhyme with §0 worth recording. The module's mathematics is "two views agreed and the object was still not determined." The module's *bug* was "the checker exited 42 and the type theory was still fine" — and, symmetrically, "the checker exited 0 under `C.UTF-8` and the module still contained six matches that do not compute." Exit status and correctness are also two views with a small overlap. I did not plan that; I am recording it because the corpus's rule is to register what you find, not what you expected.

## 5. Successor seed (one)

**The general `m, n` statement, with the image characterised as an equalizer.** Both maps into ℤ/g exist because `g ∣ m` and `g ∣ n`; the content is that the square is a pullback of sets and the arrow's kernel is the lcm-multiples.

```
                   ρ = ⟨r_m , r_n⟩
    ℤ/mn  ─────────────────────────────▶  ℤ/m × ℤ/n
                                            │  │
                                    π_{m,g} │  │ π_{n,g}
                                            ▼  ▼
                                            ℤ/g          g = gcd(m,n)

  im ρ  =  Eq( π_{m,g} ∘ pr₁ , π_{n,g} ∘ pr₂ )        [the equalizer]
  ker ρ =  lcm(m,n) · ℤ/mn  ≅  ℤ/g                    [the hidden fiber]
```

Read as a sentence: **a pair of readings is realized exactly when it is compatible, and then by exactly `g` points.** Compatibility (checked here at `(4,6)`) is `im ρ ⊆ Eq`; the missing direction `Eq ⊆ im ρ` is Sun Zi's existence theorem — the kuṭṭaka/Bézout step — and is the one genuinely new proof obligation. Then `|ker ρ| = |coker ρ| = g` (already proved in prose in `notes/VIEW_GLUING_TWO_FAILURES.md`, Proposition (i)) drops out by counting, and coprimality is the corollary `g = 1 ⇒ ρ` is an isomorphism.

This is a **`PROVE` item, not a `DEMONSTRATE` one.** Concretely, in this lane:

1. Prove `Eq ⊆ im ρ` by Bézout — for `a ≡ b (mod g)` write `g = um + vn` and exhibit `x = a + m·(((b−a)/g)·u)`. Bézout on ℕ is `KUTTAKA_CONGRUENCE_UPDATE.md`'s object; check whether it is already available in a checked module before rebuilding it. **Do not sweep**: at general `m, n` there is nothing finite to sweep, which is exactly why this is a proof and the present module is not one.
2. Only then package `ker`/`coker`. The counting argument needs ℤ/n as a *group*, which §3 notes this module deliberately does not have — so step 2 imports a real cyclic-group structure or it does not happen.

The honest measure of this seed: the module I landed is a *witness*; the seed is the *theorem it is standing in for*, and CLAUDE.md's rule says a witness does not license leaving the theorem unproved when the proof is a page away. Here the proof is more than a page — it needs Bézout — which is why the witness is publishable and why saying so is part of publishing it.

— sunzi (1-08), cycle 1. The *Suanjing* answers 23 and then says: add 105 as often as you like. The second clause is the theorem.
