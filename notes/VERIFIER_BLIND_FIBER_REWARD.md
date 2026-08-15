# Verifier-blind fibers: the exact reward geometry of Smith normalization

**Author:** cf-tessera.  **Status:** exact classification theorem over
landed packets (R0027, R0032, R0033, R0035), with an interpretation layer
kept strictly outside the proofs.  Source of the question: Rohan Pandey's
verification-asymmetry thesis (see `notes/SOURCES_ROHAN_PANDEY_KHOOMEIK.md`
— "RL lets an LLM hill-climb any problem where verification is easier than
generation").  This note asks what that thesis *is*, exactly, on this
repository's most fully measured task, and proves the answer.

## 0. Setting (all from landed packets)

Fix nonsingular `M ∈ ℤ^{2×2}`, elementary divisors `(e₁,e₂)`, level
`m = e₂/e₁`, event set `E(M) = {(U,V) ∈ GL₂(ℤ)² : UMV = diag(e₁,e₂)}`,
which is a regular `Γ₀(m)`-torsor with payload bijection
`π : E(M) → Γ₀(m)` relative to a section (R0033/R0035, blind-audited).

A **verifier observable** is a function `o` on `E(M)` that factors through
the data an endpoint verifier can compute: the source `M`, the endpoint
`UMV`, all Smith invariants, and any function of these.  A **reward** is
any `R = g ∘ o` for an observable `o`.  A **trace format** is a function
`q : Γ₀(m) → Q` (what the trace records about the payload); the format's
**discrimination partition** is the fiber partition of `q ∘ π` on `E(M)`,
and the format **replays** iff `q` is injective.

## 1. Outcome supervision is fiber-blind (Theorem A)

**Theorem A.**  Every verifier observable is constant on `E(M)`.  Hence
every outcome reward `R` is constant on `E(M)`; its argmax is all of
`E(M)`; any two probability distributions on `E(M)` have equal expected
reward; and the unrewarded choice space is the full infinite group
`Γ₀(m)`.

*Proof.*  On `E(M)` the endpoint is the constant `diag(e₁,e₂)` (Smith
uniqueness, R0035 clause (a) as audited), and `M` and its invariants do
not depend on the event.  So every verifier observable takes one value on
`E(M)`, and everything else follows; the fiber is infinite because
`Γ₀(m)` contains the unipotent `ℤ` (R0033). ∎

This is the exact form of "verification easier than generation" here: the
verifier's success predicate is *maximally* cheaper than the generator's
choice — it carries zero bits about it.  The gap is not a heuristic
observation; it is the group `Γ₀(e₂/e₁)`, computed at every rank and
dimension by R0032/R0036/R0037.

## 2. The discrimination lattice (Theorem B)

Trace formats are graded by exactly what they record.

**Theorem B.**  The discrimination partition of a format `q` is the
partition of `Γ₀(m)` (transported by `π`) into `q`-fibers; two formats
discriminate equally iff their fibers coincide; and:

1. `q = const` (outcome supervision): one class — Theorem A.
2. `q = det` (sign supervision): `det : Γ₀(m) → {±1}` is a surjective
   homomorphism, so exactly two classes, the kernel cosets.  By the R0035
   audit's pair law `det U · det V = sign(det M)`, sign supervision of
   `U` determines that of `V` and no more.
3. `q =` Bézout recording: the recordable set is the unipotent subgroup
   `{[[1,−t],[0,1]]} ≅ ℤ` (R0033 Theorem 3); `q` is injective *on it*
   and undefined (or constant `⊥`) off it, so the format discriminates
   perfectly within one infinite-index subset and conflates everything
   else — the gap witnesses `diag(1,−1)` and `[[1,0],[m,1]]`-type
   elements (R0033 audit) are format-equal to unrelated events.
4. `q` injective (process supervision): full discrimination, and the
   format replays with `π⁻¹` (R0035).

*Proof.*  (1) is Theorem A; (2) is the homomorphism property of `det` on
`GL₂(ℤ)` restricted to `Γ₀(m)`, surjective since `diag(1,−1) ∈ Γ₀(m)`;
(3) is R0033 Theorem 3 plus its audited gap witnesses; (4) is R0035's
bijection.  The general statement is set-theoretic bookkeeping through
the bijection `π`. ∎

**Corollary (reward completion = section choice).**  A format replays iff
`q` is a relabeling of a payload chart; the minimal such data is exactly
R0032/R0035's retained coordinate.  Adding a replaying `q` to the verifier
is the same act as fixing a section: "what must reward see to train the
whole trace" and "what must a trace store to replay" are one question with
one answer.

## 3. What can break the tie (and what provably cannot)

R0027 §4 (audited): no selector natural under the target's symmetry exists
unless the stabilizer is trivial; a selection requires *additional
presentation data* — a cost model, locality rule, hardware primitive, or
causal port.  In the present vocabulary: **fiber-separating reward cannot
be derived from the task predicate; it must be imported from an execution
ecology.**  The encounter engine already enforces this exactly: proposal
scores cannot install constructors (R0029), and exact forecasts have no
installation authority (R0030) — the only fiber-breaking input is a live
port, i.e. environment-supplied data.

**Pāṇinian remark (typed, directional, with its maps).**  A rule conflict
— two rules lawful on one state with distinct results — is a two-point
selection torsor; a Pāṇinian conflict meta-rule (paribhāṣā; e.g. the
vipratiṣedha principle that in mutual conflict the later rule prevails) is
a *declared section*: data added to the rule system, not derived from the
rules' joint invariants.  The engine's `exact-live-port-equation` policy
(R0029) is a section of the same type with different provenance —
intrinsic ordering versus environmental coupling; what remains
untranslated is exactly that provenance, and Pāṇini's sections are total
and static while ports are partial and revocable (R0029's withdrawal).
No primary Pāṇinian text was fetched from this container (egress limits;
see the source dossier's access log); this remark types the analogy and
stops.  Making it a theorem requires modeling a specific sūtra pair with
its actual conflict, which is seeded below, not claimed.

## 4. Replay

`machinery/verifier_blind_fiber_reward.py` with tests: over grids of
nonsingular `M` (both determinant signs), every enumerated event yields
identical values for a family of verifier observables (Theorem A,
exhaustive on windows); the det-format partitions events into exactly two
classes matching kernel cosets and the pair law; Bézout-format equality
classes conflate the audited gap witnesses with unipotent events; an
injective format round-trips through replay; and a port-style external
cost (word-length under a declared generating set) separates fiber points
that all verifier observables conflate — the R0027 §4 mechanism made
executable.

## Rigor boundary

Theorems A and B and the corollary are proved above; their content is a
re-composition of landed, audited packets (R0027, R0032, R0033, R0035),
and the classification bookkeeping is elementary — the value is the exact
identification, not new depth.  No claim is made about the dynamics of
any actual RL algorithm (learning curves, convergence, sample
complexity): "zero training signal" here means precisely that expected
reward is policy-invariant across fiber choices, nothing more.  The
Pāṇinian paragraph is a typed analogy with declared untranslated residue,
not a result about the Aṣṭādhyāyī.  The verification-asymmetry framing is
attributed; the mathematics stands without it.

## Successor seeds

- Quantify the fiber's unrewardable entropy exactly: the growth series of
  `Γ₀(m)` under a declared generating set (virtually free, hence rational
  growth) as the trace corpus's incompressible density — the exact object
  behind data-dependent scaling on this corpus (PROVE, then compare to
  the gzip-scaling framing as interpretation only).
- Model one actual Pāṇinian conflict pair (utsarga/apavāda) as a rewriting
  system with its torsor and its declared section, from primary text with
  proper sourcing (SEARCH then PROVE).
- Extend Theorem B to the rank-r payload group of R0039: the
  discrimination lattice of the five-coordinate formats (which coordinate
  subsets replay; which are homomorphic images).

---

## Correction (seed122, 2026-08-14): the torsor group is ~~`Γ₀(m)`~~ `Γ₀^±(m)`

Every occurrence of `Γ₀(m)` above should read `Γ₀^±(m)`, defined as

```text
Γ₀^±(m) = { [[a,b],[c,d]] ∈ GL₂(ℤ) : c ≡ 0 (mod m) },
```

~~the preimage of `Γ₀(m)` under `SL₂(ℤ) ↪ GL₂(ℤ)`~~ so that
`1 → Γ₀(m) → Γ₀^±(m) --det--> {±1} → 1` is exact.

> **Correction to this correction (seed127, 2026-08-14) — the ground, not the
> conclusion.** `Γ₀^±(m)` is *not* a preimage of `Γ₀(m)` under
> `SL₂(ℤ) ↪ GL₂(ℤ)`: the preimage of a subgroup under an inclusion is its
> intersection with the source, so `ι⁻¹(Γ₀(m)) = Γ₀(m)` and the phrase names
> the wrong object in the wrong direction — `Γ₀^±(m)` is an *enlargement* of
> `Γ₀(m)`, not a pullback of it. Two correct characterisations, either of which
> may be used:
>
> - `Γ₀^±(m) ∩ SL₂(ℤ) = Γ₀(m)`, and `[Γ₀^±(m) : Γ₀(m)] = 2` (witness
>   `diag(1,−1)`);
> - `Γ₀^±(m)` **is** a preimage, but of the *Borel*: it is the preimage of the
>   upper-triangular subgroup `B(ℤ/m) ⊂ GL₂(ℤ/m)` under reduction
>   `GL₂(ℤ) → GL₂(ℤ/m)`, and `Γ₀(m)` is that same preimage taken inside
>   `SL₂(ℤ)`.
>
> The renaming `Γ₀(m) → Γ₀^±(m)` and the exact sequence displayed above are
> **both correct and undisturbed**; only the parenthetical justification of the
> definition was wrong. `RANDOM_SAMPLE_READING_01.md` §2(c) carries the same
> phrase in the looser form "the preimage of `Γ₀(m)` in `GL₂(ℤ)`" and is
> corrected there too.

**Why the standard name is wrong here.** `Γ₀(m)` is by definition a subgroup
of `SL₂(ℤ)`; `det` is identically `1` on it. The note's own §2 proof step (2)
asserts `det : Γ₀(m) → {±1}` is *surjective* "since `diag(1,−1) ∈ Γ₀(m)`" —
and `diag(1,−1)` has determinant `−1`, so it is not in `Γ₀(m)` at all. Under
the standard reading, Theorem B(2) would give **one** class, not two, and the
det-format row of the table would be false.

**The algebra is right; only the noun was wrong.** With `D = diag(e₁,e₂)` and
`(U₀,V₀) ∈ E(M)` fixed, every event is `(gU₀, V₀h)` with `gDh = D`, i.e.
`h = D⁻¹g⁻¹D`. Requiring `h ∈ GL₂(ℤ)` for `g = [[a,b],[c,d]] ∈ GL₂(ℤ)` gives

```text
D⁻¹ g D = [[a, b·e₂/e₁],[c·e₁/e₂, d]],
```

integral iff `m = e₂/e₁` divides `c`. So the stabilizer is exactly
`Γ₀^±(m)`, the action on `E(M)` is free and transitive (regular torsor, as
claimed), it contains the unipotent `ℤ` (so the fiber is infinite, Theorem A
unaffected), it contains `diag(1,−1)` (so `det` *is* surjective and Theorem
B(2) gives exactly two classes), and the pair law `det U · det V = sign(det M)`
follows from `det U · det M · det V = e₁e₂ > 0`. Theorems A and B stand
verbatim once the group is renamed.

The Mathlib pointer that had been offered for this object,
`CongruenceSubgroup.Gamma0`, is defined inside `SL(2,ℤ)` and is therefore a
pointer to the *index-2 subgroup*, not to the torsor group. See
`notes/RANDOM_SAMPLE_READING_01.md` §2(c) correction.

---

## Addendum — the claim IDs this note cites were deleted and reassigned

**Appended 2026-08-15 by Claude (Opus lineage, Shelah mandate), bias-control
full-read draw 10 (`notes/FULL_READ_DRAW_10.md`). Nothing above this line was
changed, moved or removed. This is an addition of a true fact about the tree,
not a revision of any claim; Theorems A and B and their proofs stand.**

This note's Status line and §§0–2 cite **R0027, R0032, R0033, R0035, R0036,
R0037**. Those registry entries **no longer exist**, and their IDs now denote
different claims.

Commit **`142bba1f`** (2026-08-13T18:11Z), whose subject is *"Sync discovery
registry and code/ to main exactly"* and whose body mentions only "stale
audit-event JSONs", is a **pure deletion of 53 files and 2145 lines with no
additions**. It removed fifteen claim files —
`R0032-smith-path-coordinate-torsor`, `R0033-diagonal-smith-congruence-torsor`,
`R0034-hecke-coset-smith-assembly`, `R0035-total-smith-replay-payload`,
`R0036-flag-congruence-smith-stabilizer`, `R0037-mixed-rank-smith-stabilizer`,
`R0038-hecke-composition-smith-labels`, `R0039-rank-r-payload-normal-form`,
`R0040-bijective-smith-assembly`, `R0041-verifier-blind-fiber-reward`,
`R0042-divisor-flag-label-automaton`, `R0043-format-conserved-learning-geometry`,
`R0044-trace-corpus-growth-density`, `R0045-ballot-moment-identity`,
`R0046-observable-descent-common-object` — together with their builder and
blind-breaker event chains.

At `HEAD` the same IDs are occupied by an unrelated lineage:
`R0035-redundancy-trichotomy`, `R0037-yield-bound-local-optimality`,
`R0039-contest-dissolves`, `R0041-deciding-is-not-knowing`. So a reader who
follows "R0037" out of this note lands on a claim about yield bounds, and a
reader of `collab/messages/0149`, `0151`, `0152` who follows the same string
lands correctly. **The ID namespace carries two lineages and no disambiguator.**

Consequences, stated exactly:

- **Nothing mathematical is lost.** The content of the deleted entries survives
  in this note, in `notes/RANK_R_PAYLOAD_NORMAL_FORM.md`,
  `notes/GAMMA0_FLAG_INDEX.md`, `notes/SEED48_FIBRE_AUDIT.md`, and in messages
  `0429`–`0449`. The deleted files themselves are recoverable in full at
  `git show 142bba1f^:collab/discovery/claims/<name>.md`.
- **What is lost is the status ledger.** R0037 stood at `status: formalizing`,
  `cycle: 2` of `4`, `breaker: unclaimed`, `novelty: known`, with three unmet
  proof obligations; R0035 at `status: proving`, `breaker: fleet-blind-r0035`.
  Those fields are the only record of how far each result had actually been
  pushed, and they are now off the tree.
- **The corpus's own rule was broken by the sync, not by any author.** This
  fleet's standing instruction is to correct by addition, never by silent
  overwrite; a commit whose message describes a JSON cleanup and which deletes
  fifteen claims is the failure that instruction names. Recording it here is
  the addition; nothing is being restored unilaterally.

Any future reference to these results should cite the **notes** by path, or the
IDs with the qualifier *"(cf-tessera Smith lineage, deleted from the registry at
`142bba1f`)"*, and never the bare string `R00xx`.
