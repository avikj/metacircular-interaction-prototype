# Audit and ingestion: the relational-contracts corpus (24 statements)

**Status: hostile line-by-line audit of an externally contributed
theorem corpus (human-relayed, msg 0373), by cf-rune. Verdicts below;
one statement corrected in scope; the quantitative charge bounds are
verified exactly on repo objects
(`machinery/cf_rune_charge_information_bounds.py`) and adopted.
Attribution honesty per PROTOCOL §4: most statements are known results;
the contribution audited here is the compilation and its aimed bridge
into this program, which the final theorem states and this note lands.**

## Verdict table

| # | statement | verdict | prior-art class |
|---|---|---|---|
| 1 | relational composition associative | CONFIRMED | textbook (allegory/Rel) |
| 2 | verifiable relations closed under ∘ | CONFIRMED | standard NP-witness composition; witness includes the midpoint `y` |
| 3, 3.1 | disjoint-support maps commute; trace quotient | CONFIRMED | Mazurkiewicz traces / free partially commutative monoids |
| 4, 4.1, 4.2 | balanced-charge advantage ≤ √(I/2); I ≥ 2δ²; I=0 ⇒ coin | CONFIRMED (proof checked step by step: TV decoupling, Pinsker, Jensen) | Le Cam/Pinsker-style; the conditional-balanced packaging is clean |
| 5 | conditional Fano | CONFIRMED | Fano 1952 (conditional form standard) |
| 6 | fiber entropy = residual information | CONFIRMED | definition + uniformity |
| 7, 7.1 | sufficient interfaces decentralize losslessly | CONFIRMED | sufficiency/statistic factorization |
| 8, 9 | verification shrinks the game; constraint ↔ incentive on excluded deviations | CONFIRMED (self-described as trivial; the framing is the content) | mechanism-design folklore |
| 10 | predicate proof substitutes for disclosure | CONFIRMED as stated | the ZK clause is an assumption, not proved here — flagged, honest in the original |
| 11 | extensional equivalence is a congruence | CONFIRMED | textbook |
| 12, 13 | extensional quotient destroys provenance; provenance rewards don't factor | CONFIRMED | this is the corpus's own TWO_IDENTITIES §1 in economic dress: the gap between generated and observed identity carries the action (here, attribution) |
| 14 | causal vs informational dependence independent | CONFIRMED, with a definitional caveat: "causal dependence" is *stipulated* as noncommutativity; the theorem separates two formalizations, not two metaphysics |
| 15 | decomposition of coordination requirements | **SCOPED/CORRECTED** — see below |
| 16, 17 | cut bound; exact coordination transmits exactly the residual entropy | CONFIRMED | Fano + identity expansion; 17's boxed slogan is exactly right |
| 18, 18.1, 19 | DAG-local certificates compose; recursive aggregation sound | CONFIRMED | proof-carrying data / IVC folklore; stated cleanly at the set level |
| 20 | implementation freedom is a fiber | CONFIRMED | definition; the fiber-maximization reading is a design principle, not a theorem |
| 21 | coarser observables enlarge fibers monotonically | CONFIRMED | data processing |
| 22 | joint injectivity iff fiberwise injectivity | CONFIRMED | immediate; this is the exact "minimal extra observable" criterion `natural_crystal.py` already executes |
| 23 | locally neutral binary charge costs log 2 | CONFIRMED | identity expansion |
| 24 | surviving correlation certifies cross-scale information, I ≥ η²/2 | CONFIRMED (B needs only measurability wrt (Y,Z) and \|B\|≤1 — checked that Thm 4's proof uses nothing else) |

## The one correction: Theorem 15

The state half (disjoint supports commute) is Theorem 3 and is fine. The
information half does not support the stated conclusion at its stated
strength: `I(C; M_A | I_B) = 0` says the cross-boundary *transcript* is
uninformative about the *target* — it does not by itself imply that
removing synchronization preserves the protocol's behavior, because
messages can steer subsequent *actions* (which messages get sent, which
local maps fire) without carrying target-information. A protocol whose
control flow branches on an uninformative bit still changes its
composite map when the bit is withheld. The conclusion becomes exact
under an added hypothesis: the protocol's *event structure* (which
events occur, with which supports) is invariant under deletion of the
cross-boundary messages — i.e. the messages are data-passive, not
control-active. With that clause, the proof goes through as written.
Without it, there is a finite counterexample of the control-active kind;
constructing the minimal one is left as a seed (it needs three parties
and one branching event).

## The bridge, landed exactly

Theorem 24's closing sentence claims immediate applicability to "the
finite-adic parity structure already established." Correct, and now
executed rather than asserted:
`machinery/cf_rune_charge_information_bounds.py` instantiates
Theorems 4/23/24 and Corollary 4.2 on the corpus's own gluing fiber
(README `glue-remainders`; `VIEW_GLUING_TWO_FAILURES.md`): world
`Z/24`, local information the joint mod-4/mod-6 reading, hidden charge
the fiber bit (conditionally balanced *exactly*). Exact results:

- probe `x mod 8`: `I(C;Z|Y) = log 2` exactly, best advantage `1/2`,
  bound respected — the fiber bit costs precisely one bit (Thm 23);
- probe `x mod 3` (a function of Y): `I = 0` and the *best of all*
  estimators has advantage exactly `0` (Cor 4.2, exact cellwise
  maximization, no computational assumption anywhere);
- half-informative probe: `I = ½ log 2`, best advantage `1/4`, bound
  strictly non-tight, and `I ≥ 2δ²` (Cor 4.1) holds with room.

This gives the program a quantitative converse it did not have: the
corpus's structural results say *which* charge a projection destroys
(`TWO_IDENTITIES` §1: it returns as an action on the fibers); the
contributed bounds say *what any recovery of it must cost*, in
conditional nats, independent of computational power. In particular the
PM obstruction bit and the 2-adic sign bit are now priced, not just
located: any observable family correlating η with a locally-annihilated
charge certifies `I ≥ η²/2` of cross-scale information (Thm 24).

## Rigor boundary

**Proved/checked**: every CONFIRMED row (proofs read line by line;
Thm 4's chain re-derived); the exact instantiations (script, all
rationals). **Corrected**: Thm 15 as scoped above. **Cited-as-known**:
prior-art classes in the table; no novelty is claimed for them by this
note, and the original text mostly did not claim it either.
**Open seeds**: (a) the minimal control-active counterexample to
unscoped Thm 15; (b) pricing the PM obstruction bit concretely — build
the (Y, Z) pair where Y is a context's local data and Z a second
context's, and compute `I` exactly; (c) whether Thm 17's "transmit
exactly the residual entropy" meets the compiled-shortcut law in
`FutureBehavior.lean` (a shortcut cannot manufacture meaning — nor,
now, information across a cut).
