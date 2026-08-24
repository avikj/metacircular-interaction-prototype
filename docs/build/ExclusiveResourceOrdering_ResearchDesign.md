# Exclusive-Resource Ordering — a research-design map of the one open frontier

*Design exploration, not a result. The whole chain-analysis
(`docs/LANDSCAPE.md` §4) isolated exactly one honest open problem;
this document attacks it with only the corpus's own checked machinery
and is explicit about where the machinery runs out. Every load-bearing
clause cites a checked term or a named in-tree spec. It states one
conjecture as an Agda type and does **not** claim to have proved it.
Nothing here is adopted from an external system. Marks: ☑ checked term,
◆ design synthesis, **?** genuinely open.*

---

## 0. The problem, restated precisely

Four facts about this substrate, each already a theorem or a named spec,
partition the state of a decentralized proof-carrying network into
sectors of decreasing tractability:

1. **Validity is free.** A transition carries its proof; the receiver's
   kernel re-judges it locally (`Punaragamana/Carrier.agda` ☑ — base +
   carried + witness, the witness re-run at the receiver;
   `IndraJala §1`). No quorum decides whether a theorem is true. A false
   claim costs the receiver one refusal; Byzantine actors can only donate
   compute. **Consensus is not needed for validity, ever.**

2. **Most state is order-free.** Checked terms are immutable content-keyed
   values; strikes are additive; journals append-only; the crystal union
   is a join-semilattice merge (`Sangha §0.2` ◆). Order-free state
   converges by merge with no election.

3. **Independent claims must stay unordered.** Forcing a sequence on two
   genuinely simultaneous standpoints is a *proven* error:
   `Saptabhangi.क्रम-सह-भेदः` ☑ makes `saha` (simultaneous) irreducible to
   `krama` (sequential), and `Saptabhangi.दुर्नयः` ☑ proves any two-valued
   verdict on the threefold seed collapses a distinction. Two individually
   valid conflicting transitions that arrived without a determined order
   are an `avaktavya` (the fourth koṭi), not a fork to resolve.

4. **Only exclusive-resource writes need a single-valued outcome.** Two
   spends of one coin are *not* two coexisting nayas: they contend for one
   cell whose invariant — no value created or destroyed — admits at most
   one. This is `ahiṃsā = conservation` (`EkatvaMatra` ☑ support layer;
   the growth laws' "no destructive update"). The invariant *declares* the
   two post-states different-and-exclusive (`CRYSTAL.md §3.2` distinction
   compilation: a required separation), so here — and only here — a
   single-valued outcome, i.e. a total order on the conflicting writes, is
   genuinely forced.

The classical way to buy that single-valued outcome is **consensus over a
known membership** (a validator set, a stake registry, Hedera's Governing
Council — `Hedera_OnThePrimitive.md §4`). This substrate **refuses known
membership** as a constitutional matter, and the refusal is a theorem, not
a preference:

> **Theorem F, applied to the store** (`Sangha §0.1`, `GAUGE.md`): a
> *unique* equilibrium annihilates every charged sector. One authoritative
> store / one canonical validator set is one KMS state; whatever its
> consensus cannot see, nothing downstream ever sees
> (`Pratyabhijna.network-no-decision` ☑ via `IndraJala §7`). A council is
> a unique-equilibrium governance layer, hence the annihilation failure
> mode, not the foundation.

So the residue, stated once and exactly:

> **THE OPEN PROBLEM. Achieve a single-valued outcome on the conflicting
> writes to an exclusive resource (a coin spent once), among mutually
> distrusting parties of *unknown* membership, without reintroducing a
> known validator set / canonical store.**

Everything downstream is candidates for this one line.

---

## 1. Why the usual dissolution does not reach this sector

The corpus dissolves distributed-systems problems with one move: *the
problem existed to protect a node from a claim it could not afford to
check; here checking is one kernel run, so the problem evaporates*
(`IndraJala §1`). That move works on **false** claims. It does not touch
the double-spend, and naming why is the whole diagnosis:

> **A double-spend is not a false claim. It is two individually TRUE
> claims whose conjunction violates conservation.**

Each spend, in isolation, carries a valid witness and passes local
recheck. Verification asymmetry (`IndraJala §1`) never bites, because
neither claim is refutable. What is violated is a global *conjunction*
property — that no *second* valid spend of the same source exists — and a
self-certifying Carrier witnesses a **positive** (`f base ≡ carried`),
never the **absence of a sibling**. This is the precise reason this sector
is the residue and the other three are not: the obstruction is not trust,
it is that the invariant is a negative existential over a set no single
node holds.

---

## 2. The candidates, each assessed honestly

### 2.1 Candidate A — permissionless virtual voting (Hedera without a council)

**The mechanism.** `Hedera_OnThePrimitive.md §1` establishes, and it is
sound: a total order over a shared content-addressed event-DAG is a *pure
deterministic fold* `O : DAG → Order`, computed identically at every node
with zero vote messages, because the DAG is shared and the fold is
deterministic (the determinism is exactly the `canon`+hash identity law,
`IndraJala §2`). This is **representable** in our primitive and
**unobstructed** — a fold over the L2 e-graph with a `canon` tie-break. It
is consistent with `Pratyabhijna` (`Hedera §1.3` ☑): ordering folds what
is *already visible*, it never resolves a blindness.

**Where it is honest and where it is not.** The fold is not the hard part.
The hard part is that virtual voting's fairness and finality guarantees
are proved *for a known participant set* — "famous witnesses" and
"strongly-see" are quantified over the members, and the aBFT bound is a
fraction of *known* stake. Drop known membership and you must answer:

- **What weights the fold, Sybil-resistantly?** A node forks itself into
  10⁶ identities for free unless weight is scarce. The two scarce things
  in the wild are a **token** (PoS — reintroduces a stake registry, i.e. a
  known-membership charge) and **burned compute** (PoW — reintroduces a
  cost this constitution spent its whole history refusing, and buys
  nothing mathematical).

- **The proposed native answer: proof-of-useful-work — weight = verified
  contributions** (a node's mass = the theorems/edges it has landed and
  others cite). Assess honestly: this is attractive because the corpus
  *already* has the mass measure — `Nirjara`'s मात्रा counts the sūtras
  that WRITE, `PCite` makes cited work cost-stable (`IndraJala §5` ☑), and
  `Obstruction.curriculum` weights a residual by how many parents it
  unblocks. But it does **not** provide Sybil resistance for *ordering*,
  and the reason is exact:

  - **Nothing-at-stake.** Verified contribution is *non-rival*
    (`PramanaSankramana §3` ☑ `अक्षयः`: a proof term carries no linear
    restriction, one receipt enters two composites and both stand). A
    weight that cannot be *spent* cannot be *slashed*; a voter with
    unslashable weight can vote for every fork at no cost. Non-rivalry —
    the very property that makes knowledge good money-substitute
    (`PramanaSankramana §4` `अनृणम्`, no counterparty) — is precisely what
    disqualifies it as *ordering* weight. The property that makes it
    excellent for the knowledge sector makes it useless for the exclusive
    sector. This is not a fixable detail; it is the two sectors having
    opposite requirements.

  - **Sybil via contribution-transfer.** Contributions are content, and
    content is copyable/citable; a cartel can concentrate or launder
    citation-mass (the `Bittensor` weight-copy failure, `LANDSCAPE.md §2`).

  **Verdict on A:** representable, elegant as a *fold*, and the right
  realization *once a legitimate weighting exists* — but permissionless
  Sybil resistance is not delivered by any native quantity, because every
  native quantity here is non-rival by construction and ordering needs a
  rival (slashable) one. A honestly names this as A's wall; it does not
  scale it.

### 2.2 Candidate B — the resource as a CONSERVED CHARGE (the most native angle)

This is the angle worth the most ink, because it *reframes* the problem
into the corpus's deepest checked object rather than importing consensus.

**The reframing.** Stop asking "which of the two writes comes first"
(an ordering question, `krama`) and ask "is conservation violated"
(a charge question). `GaugeOrbitClasses` ☑ gives the template: a
conserved quantity is a **character** — `val` is a homomorphism into a
2-element group (`val-⋆` ☑), disjoint charge commutes, and a *violation*
of a conservation law is *locally detectable* as non-neutrality of a
query (`charge⇒separator⋆` ☑ constructs the detecting procedure; its
converse `neutral⇒no-separator⋆` ☑ certifies honest blindness). If
double-spend could be cast as **charge non-conservation**, the witness of
a *valid* spend would carry the proof that the source was not already
spent — making exclusivity a **Carrier property, not a consensus
property.**

**The fibre-law reading, made precise.** Model a coin as a source and a
spend as a transport `spend : Source → Sink`. Two readings of the fibre,
from `Carrier.agda` ☑ and `Sankramana_…` ☑:

- Bind the **output** and the fibre is `singl (spend src)` —
  **contractible** — so the carried datum rides free: `Source ≃ Carrier
  spend`. This is the "spend owes no residual" case: a *clean* spend.
- Bind the **input** (the source cell) and the fibre is
  `fiber spend snk` — and it is contractible **iff** the flow is fibrewise
  transitive and one-orbit (`Sankramana_…` ☑: `अवतीर्णः` is an equivalence
  ⟺ surjective + `उभय-सङ्क्रमणम्`, two-sided reachability). Non-contractible
  fibre = **more than one** thing maps here = the loss `SankramanaSesa`
  charges.

Now the double-spend, in this language: **two transports claiming the same
source fibre.** A single, exclusive spend is exactly the demand that the
source's spend-fibre be *contractible* — one inhabitant. Two distinct
spends `s₀ , s₁ : fiber spend src` are two points of that fibre; if the
fibre is contractible they are joined by a path (identified — the same
spend up to gauge), and if it is *not* contractible the plurality is
**visible as a non-trivial fibre**, i.e. as an `avaktavya`
(`Saptabhangi`), never as a silent fork. This is the "plurality-blocks-
collapse" the task points at: the two spends cannot *both* have
contractible residual, so a double-spend is structurally a
**conservation/charge anomaly** — a non-contractible source fibre — rather
than an ordering ambiguity to be voted on.

**Why this is the most native angle.** It replaces "order the writes"
(pays the `दुर्नयः` cost, needs global agreement) with "the valid-spend
witness *is* the certificate that the source fibre stayed contractible"
(local, self-certifying, in the Carrier form the whole substrate already
runs on). Conservation is the end; order was only ever the means
(`Hedera §2.3`). If exclusivity is a conserved charge, order is not
needed — the *witness carries it*.

**The wall, named exactly — and it is the honest core of this document.**
Contractibility of `fiber spend src` is a statement about **all** spends
of `src`. A Carrier certifies `spend base ≡ carried` — a positive fact
about *this* transport. It cannot, from inside itself, certify that *no
other* point inhabits the same fibre: that is a negative existential over
a set the node does not hold. Concretely: node U holds spend `s₀`, its
witness valid; node V holds `s₁` of the same coin, its witness equally
valid. Each fibre-point is real; the *non-contractibility* only exists in
the union `{s₀, s₁}`, which neither node has. By
`Pratyabhijna.network-no-decision` ☑ / `GaugeOrbitClasses` §5 ☑, an
observer sees exactly the coset of its query-set annihilator — U is
*blind* to `s₁` if `s₁` is outside U's charge cone. So:

> **The conserved-charge reframing is faithful and clarifying — it converts
> the ordering problem into a conservation-violation problem — but it does
> NOT dissolve it. It recovers the SAME open problem in cleaner clothes:
> "detect the non-contractible source fibre" = "agree that no second spend
> exists" = "agree on a shared-DAG prefix over unknown membership."** The
> charge is genuinely conserved and genuinely local *once both transports
> are in one node's view*; making both be in one view is exactly the
> residue.

That is progress, not a solution: it tells us the theorem to aim at is
about **a witness of fibre-contractibility that survives the merge**, not
about a voting protocol. Candidate B is where the concrete conjecture (§4)
lives.

### 2.3 Candidate C — accept the avaktavya (application-level resolution)

**The move.** For *some* exclusive resources, record the double-spend as a
genuine `saha`/`avaktavya` — two simultaneous standpoints — and resolve it
**downstream**, by an application rule (first-to-finalize-in-a-dependent-
transaction), never by a global order on the spends themselves. The two
spends coexist as nayas in the DAG (`IndraJala §1`; `Sangati §2` — hold
the fork, transport don't vote); the *consumer* of the coin picks a branch
by refusing to build on an unconfirmed one, and the unchosen branch decays
by the eviction/non-hoarding law (`Sangha §2` aparigraha: a receipt
routing nothing decays out of the store).

**When it is acceptable.** Exactly when the exclusivity invariant is
enforceable at the point of *downstream consumption* rather than at the
point of spend — i.e. when a later party who needs the coin exclusive can
себя re-check the whole cited fibre before relying on it. This is the
`śraddhā`-as-credit model (`Sangha §1`): the gold window never closes, the
consumer re-verifies locally, and a fork nobody built on is inert. For
low-value, high-locality, single-consumer resources (a nonce, a
capability handed to one downstream, a lease with a natural terminator)
this is correct and pays no ordering cost.

**When it is NOT acceptable — stated honestly.** When the resource must be
globally exclusive *at spend time* among parties who never meet the
downstream consumer — bearer money in an open economy, where the two
recipients of a double-spend are mutually invisible and both act
irreversibly before any common downstream exists. There, "resolve
downstream" fails because *there is no common downstream*, and deferring
the resolution is just relabelling the unsolved problem. `Saptabhangi`
does not license holding *this* fork: the invariant here *declares* the
separation required (`CRYSTAL.md §3.2`), so holding it open is not honoring
a genuine `avaktavya` — it is refusing a distinction the task-family
demanded. C is right for the resources whose exclusivity is *local to a
consumer* and wrong for the resources whose exclusivity is *global at
spend*.

**Verdict on C:** a real and under-appreciated *narrowing* — it removes
from the hard sector every exclusive resource that has a single natural
downstream consumer, which is more of them than the money framing suggests.
It does not touch the residual bearer-money case, and pretending it does
would be the `दुर्नयः` wearing humility.

---

## 3. The honest verdict

- **Candidate A** (permissionless virtual voting) is the correct *fold*
  and the wrong *weighting*: every native scarce quantity here is non-rival
  (`PramanaSankramana §3` ☑), and ordering needs a rival, slashable weight.
  Its wall is Sybil resistance, and no corpus machinery scales it.
- **Candidate C** (accept the avaktavya) legitimately *shrinks* the hard
  sector to globally-exclusive-at-spend resources with no common
  downstream, and is the right answer everywhere else. It does not solve
  the residue; it removes everything but the residue.
- **Candidate B** (conserved charge) is **the most promising**, not because
  it solves the problem but because it *correctly reformulates* it into the
  corpus's deepest checked object. It converts "order the conflicting
  writes" (a `दुर्नयः`-risking global vote) into "the valid-spend witness
  certifies the source fibre stayed contractible" (a local Carrier
  property), and it names the exact wall: a Carrier cannot certify the
  *absence of a sibling*, so double-spend detection reduces — cleanly,
  provably — to the same shared-prefix-agreement residue, now stated as a
  question about **merge-stability of a fibre-contractibility witness**.

The value of B is that it turns a vague "needs consensus" into a sharp,
checkable target. That target is the conjecture below.

---

## 4. The concrete next step — a conjecture stated as a type

The target B isolates: **is fibre-contractibility of a coin's spend a
witness that survives the join-semilattice merge — either agreeing, or
exhibiting the conflict as a non-contractible fibre (an `avaktavya`) rather
than a silent double-spend?** If yes, double-spend detection is a Carrier
property under merge, and the exclusive sector needs no global order — only
the merge already in the substrate (`Sangha §0.2`). This does NOT defeat
the §1/§2.2 wall (the merge must still *reach* both spends); it isolates the
purely local half so the remaining global half is exactly "gossip both
spends into one view," the smallest honest residue.

Stated as an Agda type to be proved later (a **conjecture**, unproved,
marked **?**; it type-checks as a signature, its inhabitant is the open
work):

```agda
{-# OPTIONS --cubical --safe #-}
module ExclusiveResourceOrdering_Conjecture where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isProp ; isContr)
open import Cubical.Data.Sigma
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁)

-- A coin's spend-flow: sources, and the spend map into sinks.
module _ {Source Sink : Type} (spend : Source → Sink) where

  -- A ledger view is the set of spend-witnesses a node currently holds
  -- for a given source: points of the input-bound fibre (Sankramana_…).
  Spend : Source → Type
  Spend src = Σ[ snk ∈ Sink ] (spend src ≡ snk)   -- = singl, per Carrier.agda

  -- EXCLUSIVITY as a conserved charge: the source's spend-fibre is
  -- contractible — exactly one spend, "owes no residual" (SankramanaSesa).
  Exclusive : Source → Type
  Exclusive src = isContr (Spend src)

  -- A node view = the fibre-points it can see (its charge cone,
  -- GaugeOrbitClasses §5). Merge is union of views.
  View : Source → Type
  View src = Spend src → Type          -- membership predicate over spends

  _⊔_ : {src : Source} → View src → View src → View src
  (u ⊔ v) s = ∥ (u s) ⊎′ (v s) ∥₁     -- join-semilattice merge (Sangha §0.2)
    where open import Cubical.Data.Sum renaming (_⊎_ to _⊎′_)

  -- THE CONJECTURE (unproved).  A "finalized" spend carries an Exclusive
  -- witness; and merging two views EITHER preserves Exclusive (they agree)
  -- OR the merged fibre is provably non-contractible — a detectable
  -- avaktavya (Saptabhangi), never a silent second spend.  I.e. double-
  -- spend detection is stable under the substrate's own merge, so the
  -- exclusive sector needs the merge, not a global order — REDUCING the
  -- residue to "gossip both spends into one view."
  MergeExhibitsConflict : Type₁
  MergeExhibitsConflict =
    (src : Source)
    → (u v : View src)
    → ∥ Exclusive src                              -- the merge still certifies one spend
      ⊎′ (Σ[ s₀ ∈ Spend src ] Σ[ s₁ ∈ Spend src ]  -- …or exhibits two, and
            ¬ (s₀ ≡ s₁))                            -- their distinctness IS the alarm
      ∥₁
    where open import Cubical.Data.Sum renaming (_⊎_ to _⊎′_)
          open import Cubical.Relation.Nullary using (¬_)
```

**What proving it would establish, and what it would NOT.** An inhabitant
of `MergeExhibitsConflict` would show that once two conflicting spends are
in one merged view, the conflict is *never silent* — it is either
reconciled (contractible, one spend) or surfaced as a distinct pair, i.e.
a typed `avaktavya` the application layer can resolve (Candidate C's
downstream rule, now with a *checked* trigger). It would make double-spend
**detection** a property of the merge, discharging the entire *local* half
of the problem inside the substrate. It would **not** — and no type over a
single node's `View` can — guarantee that the merge *reaches* both spends;
that is the irreducible global residue (§1, §2.2), and honesty requires it
stay outside the conjecture. The conjecture's worth is precisely that it
draws the line: everything on its side is provable native machinery;
everything past it is the one true open frontier, now minimal and
sharply stated as *reachability of both spends in one view* — a gossip
property, not a consensus one.

**The honest open remainder, one line, unchanged from `LANDSCAPE.md §4`
but now located:** guaranteeing that a permissionless gossip layer brings
both conflicting spends into *some* common view before either is relied
upon — without a known membership to bound propagation — is the residue
the fibre law does not, by §1's argument, afford on its own. Whether it is
achievable at all without a rival scarce quantity (A's wall) or is
provably impossible (a Theorem-F-flavored no-go on permissionless
gossip-completeness) is the next thing to settle, and it is genuinely
open.

---

## 5. Summary

| candidate | native? | what it buys | its wall |
|---|---|---|---|
| A · permissionless virtual voting | fold yes, weight no | a deterministic total order *given* legitimate weight | Sybil resistance; every native quantity is non-rival (`PramanaSankramana §3` ☑) |
| B · conserved charge (**most promising**) | fully | reframes order → conservation; makes the *local* half a Carrier property | a Carrier cannot witness the absence of a sibling (§2.2) |
| C · accept the avaktavya | fully | removes every locally-consumed exclusive resource from the hard sector | fails for globally-exclusive-at-spend money with no common downstream |

**Most promising: B.** **Concrete conjecture to prove:**
`MergeExhibitsConflict` (§4) — that the substrate's own join-semilattice
merge either preserves a coin's spend-fibre contractibility or exhibits the
double-spend as a distinct pair (a typed `avaktavya`), never a silent fork
— discharging the local half of double-spend detection inside checked
machinery and reducing the open frontier to its irreducible minimum:
permissionless gossip-completeness (both spends reaching one view), which
remains genuinely open and may carry its own no-go.
