# The walk is optimal, and the proof now rests on primality alone

**Status:** eleven checked modules forming one chain, re-elaborated after
all edits (sources touched to defeat the interface cache). Exit 0 each,
`--safe`, no postulates, no holes — Agda 2.6.3 / cubical v0.5, the
container, not the repository pin.
**Sources:** Āryabhaṭa, *Āryabhaṭīya* 2.32–33 (499) — kuṭṭaka, the
multipliers. Piṅgala, *Chandaḥśāstra* (c. 300–200 BCE) — naṣṭa, uddiṣṭa,
saṅkhyā. Virahāṅka (c. 600–800) — mātrāmeru.

---

## What was quoted, and is now proved

`TheGapWasAUnitsError` established that the walk's storage is the logarithm
of its workload, and listed two things it *quoted* rather than proved:

1. **pigeonhole** — that an injective map out of `n+1` elements needs `n+1`
   targets, which is what makes `lcm(S) > n` a *lower bound* and hence
   makes "optimal" mean anything;
2. **the CRT count** — that the walk's residue vector has exactly `cap k`
   values, rather than a number that happens to equal `cap k`.

Both are terms now, and the second is general rather than frontier-8-only.

## The chain

| link | statement | module |
|---|---|---|
| Euclid's algorithm over ℤ | the multipliers exist | `Cubical.Data.Int.Divisibility.bézout` |
| distinct primes are coprime | `IsPrime p → IsPrime q → p ≢ q → isGCD p q 1` | `DistinctPrimesAreCoprime` |
| ℕ → ℤ | that becomes a Bézout certificate | `CoprimePowersN.isGCD→Bez` |
| certificates compose | `Bez a b → Bez (a^m) (b^n)` — one ring identity | `CoprimePowers` |
| ℤ → ℕ | the certificate is an `isGCD _ _ 1` | `CoprimePowersN.Bez→isGCD` |
| iterated CRT | `Coprimes ms → Fin (∏ ms) ≃ residue vector` | `CRTChain` |
| pigeonhole | any lossless scheme needs `card X` outcomes | `LosslessLowerBound` |
| optimality | so an optimal scheme's count is a minimum | `OptimalObservation` |

Every link checked. **The walk's residue count now rests on primality of
its installs and nothing else** — and `WalkPrimePowers.installs-are-prime-powers`
supplies that, already checked, from before this session.

## The one asymmetry worth naming

Going **to** a certificate needs the Euclidean algorithm. Everything
downstream of **having** one is three lines and a transfer.

That is not an accident of formalisation. It is Āryabhaṭa's own division of
labour: the kuṭṭaka is the work, and what it returns — the multipliers — is
what composes. `CoprimePowers.bez-mul` is a single polynomial identity,

```
(ax + by)(au + cv) = a·(axu + cxv + byu) + (bc)·(yv),
```

and it is the whole reason coprimality of powers follows from coprimality
of bases with no primality anywhere in sight.

## Optimality, defined rather than asserted

`OptimalObservation` makes it a definition —
`Optimal X Y obs = Injective obs × (card Y ≡ card X)` — and proves it
forces minimality among all lossless schemes. Three instances, none of them
previously compared:

| scheme | equivalence | date |
|---|---|---|
| Piṅgala's uddiṣṭa, inverted by naṣṭa | `Vak n ≃ Fin (saṅkhyā n)` | c. 300 BCE |
| Virahāṅka's mātrāmeru | `Metre n ≃ Fin (mātrā n)` | c. 600–800 |
| the walk at frontier 8, by CRT | `Fin 840 ≃ residue vector` | — |

Piṅgala's `2ⁿ`, Virahāṅka's mātrāmeru and the walk's 840 are not counts
that happen to be small. They are **minima**, and one four-line theorem
proves all three.

## And what the identification loses

`UnivalenceErasesTheAlgorithm`: by `ua` these three are *equal as types*
(`Vak 1 ≡ Metre 2` is checked), and `uaβ` proves transport along that path
is the equivalence and nothing beneath it. The three enumerations are three
algorithms — halving, recursion on shorter durations, coprime splitting —
and the path keeps none of that.

Which is `notes/THE_TOWER_OF_DESCRIPTION.md`'s subject: univalence sits at
level 1, and the algorithms live below it, in the fibre the identification
collapses.

## Verification

```
CRTChain EXIT=0     CoprimePowers EXIT=0    BezoutIsGCD EXIT=0
DistinctPrimesAreCoprime EXIT=0             CoprimePowersN EXIT=0
WalkObservationCount EXIT=0                 LosslessLowerBound EXIT=0
OptimalObservation EXIT=0                   PingalaIsOptimal EXIT=0
UnivalenceErasesTheAlgorithm EXIT=0         TheTower EXIT=0
```

## Not claimed

- That the walk's residue count at a **general** frontier is a single
  term. The arithmetic obstacle is gone; assembling the install list into
  a `CRTChain.Coprimes` is a different induction and is not done.
- That `bez-mul` needs primality. It does not, and that is the point:
  coprimality of powers is an identity, and primality enters only to
  produce the base certificate.
- Anything about the walk's growth **rate**. `ψ(k) ≈ k` is Chebyshev, is
  not used anywhere in this chain, and belongs to the analytic lane.
