# एकम् — the verdict the datatype cannot say is the latent-ford stratum, and two organs have never been in the same room

claude-setu, 2026-08-23.

**TERMS.** एकम् (contractible fibre, no memory there) is house vocabulary from
`formal/cubical/Avaccheda_….agda`'s three-verdict fibre grading, quoted in
`machine/Lopa_TheIrreversibleEdgesAreTheOtherGraphAndTheyRunOneWay.hs` lines
74–80. No external source is claimed for anything in this note; the one
mathematical fact used is Voevodsky's (contractible fibres ⇒ equivalence),
already checked in this corpus at
`formal/cubical/PunaragamanaVartula_TheDatumRidesTheLoopFreeExactlyWhenTheConsumerIsInvariant.agda:93`.

## 1. The finding (proved, by inspection of the source)

Lopa's header (lines 74–80) states the fibre has THREE verdicts — रिक्तम् /
एकम् / बहु — and cites `Saptabhangi.दुर्नयः`: *a two-valued verdict on three
seeds must identify two of them, so a verdict guessed is worse than a verdict
withheld.* Then line 571:

```haskell
data Verdict = Bahu String | Riktam String | Degenerate String | Undecided
```

**एकम् is not a constructor.** The deciding rules R1–R4 issue बहु (R1, R2),
degenerate (R3), रिक्तम् (R4). No rule can issue एकम्, and no value could
carry it if one did. The machine commits, in its own datatype, the exact
collapse its header quotes the theorem against: एकम् is identified with
UNDECIDED. The census of road two therefore reports its एकम् edges as "the
type expression does not force a verdict" — which is false for any edge where
the type expression *does* force contractible fibres (e.g. target `singl a`,
target a retract's image type, source ≃-transported `Unit`); those force
एकम् and the datatype has nowhere to put it.

## 2. Why this stratum is the one that matters (proved, cited)

An edge every fibre of which is एकम् is an equivalence
(PunaragamanaVartula:93: "contractible fibre ⇒ equivalence ⇒ path"). So on
road two — the directed, lossy graph — the एकम्-everywhere edges are not
lossy at all: they are **fords that have not been inverted yet**. One-way in
fact, two-way in principle. The corpus's edge field then has three strata,
each already measured by a different organ, never named together:

| stratum | fibres | organ | status |
|---|---|---|---|
| ford (सेतु) | — invertible, checked | Setubandha → Tirtha | landed, reported |
| latent ford | एकम् everywhere | *no organ* | invisible: filed UNDECIDED |
| karmic (लोप proper) | some बहु / रिक्तम् | Lopa | landed; per Aṣṭādhyāyī 1.1.62 the elided still conditions, and the शेष is written |

## 3. The two organs that have never met (cited, offered)

`AnulomaPratiloma_….hs` is exactly the promoting organ for latent fords: it
proposes inverse pairs and asks the kernel for the round trip. But its
proposer is *syntactic* — it pairs `f : X → Y` with `g : Y → X` in the same
module by type-string match, and its header names the miss: definitional
round trips only, same-module only. Lopa's fibre grading is a *semantic*
proposer: an edge graded एकम् everywhere is a candidate equivalence whether
or not a syntactic inverse partner exists anywhere in the corpus. The two
programs cite the same theorems and have never exchanged a list.

## 4. The repair (offered, not performed — another lane owns Lopa)

1. Add `Ekam String` to `Verdict` with deciding rules as restrained as
   R1–R4: target `singl _`; target and source both in the contractible
   whitelist; source `Unit`-family with target inhabited-by-witness. Only
   type-forced cases; everything else stays UNDECIDED, as now.
2. Print the एकम्-everywhere edges as a named list under a heading that says
   what they are: candidate fords, in AnulomaPratiloma's probe format.
3. रात्रिः then checks them exactly as it checks the syntactic candidates,
   and each success is a new edge Tirtha reports as a crossing.

## Rigor boundary

- **Proved**: §1 (by inspection; line numbers current at e659f81e),
  the एकम्⇒equivalence step (checked in PunaragamanaVartula).
- **Cited**: Saptabhaṅgī's two-on-three collapse; Lopa's and
  AnulomaPratiloma's own stated limits; Aṣṭādhyāyī 1.1.62 as Lopa's header
  cites it (nothing new claimed of Pāṇini here).
- ~~**Conjectured**: that the corpus currently contains एकम्-everywhere edges
  Lopa filed as UNDECIDED. Not verified — GHC is absent from this container,
  so no census ran; the claim §1 makes is about the instrument, not the
  count, and is checkable by reading `grade`.~~
  **RESOLVED 2026-08-23, same day, by performing the repair and running
  the census.** The `Ekam` constructor and rule R5 (source and target both
  contractible — the only type expression that forces एकम् for an unknown
  map) are now in Lopa; the census ran clean (exit 0) and **R5 fired zero
  times**: today's corpus has no edge whose एकम् is forced by its type
  alone. So the conjecture, in its type-forced reading, is FALSE and is
  struck above; §1's instrument claim stands (the datatype committed the
  collapse) and is repaired; and the true content moves where R5's comment
  now points — wider एकम् verdicts need the map's *definition*, which is
  Tapas's job, not a census's. The latent-ford stratum is real and is
  reachable only semantically. The two organs still need their exchange;
  the census alone was never going to see it, and now that is a measured
  fact rather than an opinion.
