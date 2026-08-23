# अर्पित-अनर्पित — both lanes' bottomless results price a withheld structure, and both asserted forms are already in this corpus

**Term and source.** *arpita* / *anarpita*, the asserted and the withheld
aspect. Umāsvāti, *Tattvārthasūtra* 5.31, *arpitānarpitasiddheḥ* —
"establishment is by the asserted and the unasserted aspect", c. 2nd–5th
c. CE. Nothing here is attributed to that sūtra beyond the distinction
it names. The distinction is the whole content of this note.

**The claim, in one sentence.** The sieve lane's unbounded rank bill and
the spectral lane's exponential depth law are both bounds on a chosen
observation class rather than on their objects, in each case the corpus
already holds a theorem giving the object a far smaller description, and
the gap between the pair is the same bit in both lanes.

## The two pairs

**Sieve lane.**

- *Withheld.* `no_fixed_uniform_squarefreeChargeCube_rank` — no finite
  number of separable channels serves all finite sets of squarefree
  prime places. The family is chosen before the modulus, so it must
  serve every place the level carries.
- *Asserted.* `squarefreeChargeCube_rankExactly n` — rank exactly n, and
  under `PrimeChargeKuznetsovRankBridge`'s per-modulus coordinate family
  n = ω(q), at most (1+o(1))·log q/log log q with normal order log log q
  (Hardy and Ramanujan, 1917). Doubly logarithmic against unbounded.

**Spectral lane.**

- *Withheld.* Theorem K′ (`HOLOGRAM.md` §7):
  X_needed(T) = exp(Θ(T^{1/2} log^{3/2} T)). Its own honesty ledger
  states the limitor: *"the SRF bound is minimax over arbitrary
  measures, while the atoms are the sumset of N(T) generators, so K′
  bounds structure-blind recovery of the sumset, not recovery of
  {γ} — which is Theorem I1's content seen from the other side."*
- *Asserted.* Theorem I1 (`INVERSE.md` §1): for positive locally finite
  measures with support bounded below, μ\*μ = μ′\*μ′ ⟹ μ = μ′, by
  Titchmarsh's integral-domain theorem in three lines, **with no density
  hypothesis whatsoever**. The sum spectrum *determines* the zeros.

## Why they are one bit

Theorem I1 says the map μ ↦ μ\*μ has trivial fibres on that class. By
`NaturalMachine/QuotientFiberLaw.agda` an observation class sees exactly
a quotient and cannot see the fibre — and here the quotient **is** the
object, so at that class there is no obstruction at all. K′ quantifies
over a coarser class, minimax over arbitrary measures, whose fibres are
not trivial, and its exponential is the price of that coarseness. The
corpus states this itself, in the ledger clause quoted above; what is
added here is only the consequence, which the clause leaves standing
unread: **K′ is a conditioning statement, not an information-theoretic
one.** Uniqueness is unconditional; only stability is at issue.

The sieve pair has the same shape with different words. The uniform
family is a coarser observation class than the per-modulus family; the
charge tensor is the same object under both; and the unbounded rank is
the price of the coarser one. `ChhayaGarbha` §6 isolated the difference
as a quantifier order, and `garbha.dhara`, handed the two arms as a
residue, returned a stream whose born nayas share one base standpoint
and differ only by arpita and anarpita.

So both lanes carry the same pair — a structure the object has, and a
bound that declines to assert it — and in both lanes the asserted form
was proved first and is the older result. What differs is only that on
the sieve side the two forms sit in adjacent Lean modules, and on the
spectral side they sit in two notes that cite each other in a
subordinate clause.

## What this changes in `ChhayaGarbha` §3

§3 recorded that the lanes differ in topology: sieve-side the bulk is
precompact under reciprocity, spectral-side it is infinite. That record
stands as a record of the *bounds*. What this note adds is that neither
bound is a property of its object at the class where the object's own
structure is asserted, so the topology difference is a difference
between two chosen classes and not yet a difference between the two
arithmetics. Whether a difference between the arithmetics survives the
assertion on both sides is the open question, and it is a sharper one
than §4's, because both asserted forms now exist to be compared.

## Rigor boundary

- **Kernel-checked**: `squarefreeChargeCube_rankExactly`,
  `no_fixed_uniform_squarefreeChargeCube_rank` (Lean, in `Pairfield.lean`'s
  import closure); `formal/cubical/OjaYugma_...agda` for the charge's
  identification with the parity character (`--cubical --safe`, exit 0).
  Not rebuilt here — no Lean toolchain in the container these were read
  from; the Lean claims are read from source and the last recorded build
  is the *"Lean lane closes: 194/194 reachable"* commit.
- **Proved, classical, fully attributed in place**: Theorem I1
  (`INVERSE.md` §1 — Titchmarsh 1926, Weiss 1968, with
  Gorenflo–Hofmann 1994 strictly stronger, and Lambek–Moser 1959 for the
  discrete case).
- **Derived scaling law, not a theorem about primes, per its own note**:
  Theorem K′ (`HOLOGRAM.md` §7), with its stated hypotheses (RH, simple
  zeros, a Gonek-type input) and its stated limitor.
- **Cited from the corpus, not this note's observation**: that K′ bounds
  structure-blind recovery of the sumset rather than recovery of {γ}.
  `HOLOGRAM.md` §7's ledger says it.
- **This note's own step**: that the sieve pair and the spectral pair are
  the same bit, and that K′ is therefore a conditioning statement rather
  than an information-theoretic one. Both are readings of theorems, not
  new theorems, and no map between the lanes is exhibited.
