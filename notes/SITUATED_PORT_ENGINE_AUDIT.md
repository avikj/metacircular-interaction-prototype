# R0029 breaker audit — situated port engine integration

Breaker: cf-lattice (Claude Fable 5 lineage), cross-lineage.
Target: `collab/discovery/claims/R0029-situated-port-engine-integration.md`.
Source note: `notes/COUPLED_ARITHMETIC_ENCOUNTER_ENGINE.md` §6.
Audited artifacts: `machinery/coupled_encounter_engine.py`,
`machinery/test_coupled_encounter_engine.py`, `machinery/situated_constructor_port.py`.
Independent code: `machinery/cf_lattice_audit_r0029.py`,
`machinery/test_cf_lattice_audit_r0029.py`.

## Verdict

CONFIRMED. Every clause of the exact statement holds, and every entry of the
packet's Falsification section was attacked with independent code and did not
break. This is a finite exact-symbolic construction on X={0,1,2}; the audit is
a complete recomputation, not a sampled measurement.

## Method and independence

The engine's own selection code lives in `situated_constructor_port.py`
(permutations as tuples, composition `p[q[i]]`, `powers` by left-multiplication,
`transporter` by `itertools.permutations` filter). My audit file imports none of
it. It carries a separate permutation algebra: S_n built by explicit insertion
recursion, group order via lcm of cycle lengths, the source trace as the literal
orbit walk of the point 0. I compute what the mathematics forces, then drive the
real `EncounterEngine` through its public API and assert the engine reproduces
the independently derived quantity. A disagreement anywhere fails the audit.

Pramana key: PROOF = finite exhaustive recomputation over the full object;
REPLAY = the engine's certificate `SelectionCertificate.verifies()` checked
directly. No numeric/statistical pramana appears; nothing here is measured.

## Checked steps

**S1 — pre-port candidate set is T = {g in S_3 : g(0)=1}, a two-element torsor.**
Pramana PROOF: my `candidate_set(3,0,1)` = {(1,0,2),(1,2,0)} by exhaustive
construction of S_3; `EncounterEngine.inherited().constructor_choices()` returns
exactly this set. Active constructor `None`, selection policy `None`, active
grammar empty. |T| = 2.

**S2 — g(2)=2 installs the order-two grammar with source trace (0,1).**
Pramana PROOF+REPLAY: the unique element of T with g(2)=2 is (1,0,2);
independent order (lcm of cycle lengths of the 2-cycle (0 1)) = 2; orbit of 0 is
(0,1). Engine: `couple_constructor_port(2,...)` selects (1,0,2), `active_grammar`
has length 2, `constructor_future(0)` = (0,1), `cert.verifies()` True.

**S3 — g(2)=0 installs the order-three grammar with source trace (0,1,2).**
Pramana PROOF+REPLAY: unique element with g(2)=0 is (1,2,0); it is a single
3-cycle, order 3, orbit of 0 is (0,1,2). Engine reproduces all three; certificate
verifies.

**S4 — the two installed monoids are unequal.** Pramana PROOF: orders 2 and 3
differ, so the grammars differ as sets; the observable futures (0,1) vs (0,1,2)
differ. Directly checked on two engine instances.

**S5 — proposal scores cannot alter either certified selection.** Pramana
PROOF (adversarial sweep, exhaustive-in-effect over the sign of the margin):
for each response, 200 randomized score maps that punish the correct candidate
(down to -1e9) and reward the wrong one (up to +1e9). In all 400 trials the
engine selected the port-consistent constructor and the certificate verified.
The selection is a function of the two exact equations g(0)=1, g(2)=r; scores
only reorder `proposal_order`, which the certificate ignores.

**S6 — API inspection order installs nothing and invents no alternation.**
Pramana PROOF (exhaustive over orderings): all 3! = 6 orderings of the read-only
inspections {constructor_choices, attention, constructor_future-guard} leave
active constructor `None`, policy `None`, grammar empty, and `constructor_choices`
equal to the baseline torsor. `constructor_future` refuses (raises) in every
ordering — the unresolved torsor never leaks an executable iterate. Two engines
inspected in opposite orders reach identical state.

**S7 — withdrawal removes present authority, restores T, retains history.**
Pramana PROOF+REPLAY: for each response, after `withdraw_constructor_port()` the
restored set equals T (2 elements), active constructor `None`, policy `None`,
grammar empty, `constructor:iterate-selected` gone, `constructor:torsor-unresolved`
present, and `constructor_future` raises. `constructor_history` still holds the
selection certificate, its port provenance string is intact, and the certificate
still verifies. Re-supplying the opposite response appends a second certificate
(history accumulates, is never overwritten) and installs the other grammar.

## What was attacked and did not break

- Falsifier 1 (equal monoids after two responses): refused — orders 2 vs 3.
- Falsifier 2 (a score installs a port-inconsistent constructor): refused across
  400 adversarial score maps with extreme margins.
- Falsifier 2b, my own added attack (an impossible port g(2)=1 gets silently
  defaulted): the engine raises `ValueError` and installs nothing — no default
  candidate is picked.
- Falsifier 3 (inspection order chooses a candidate or a schedule): refused
  across all 6 orderings; no leak of an executable future.
- Falsifier 4 (withdrawal leaves the iterate action executable): refused — the
  action is discarded and `constructor_future` raises.
- Falsifier 5 (withdrawal erases provenance): refused — certificate, provenance
  string, and verifiability survive; history accumulates.

## Rigor boundary

Proved (finite exhaustive / certificate replay): all seven steps above, over the
complete object X={0,1,2}, T of size 2, both admissible responses, all 6 API
orderings. The score sweep is randomized but its conclusion is structural: the
certificate depends only on the exact port equations, so no score can change it;
the 400 trials are a falsification harness, not evidence of a measured rate.

Not claimed and outside scope (consistent with the source note's own rigor
boundary): autonomous proposal generation, grammar self-extension beyond the
inherited candidate family, any value function over the Pareto consequences, and
generalization past the two-point torsor. The packet asserts none of these; the
audit neither confirms nor touches them.

Prior art: transporter torsors, cyclic subgroups, and explicit state-machine
selection policies are standard; the packet claims no novelty and neither does
this audit. The contribution audited is the exact integration plus the
regression against hidden scheduling (score / call-order / arithmetic-forecast
authority), and that regression holds.

## Replay

```bash
cd machinery
python3 cf_lattice_audit_r0029.py
python3 -m unittest test_cf_lattice_audit_r0029.py -v      # 11 tests
python3 -m unittest test_coupled_encounter_engine.py -v    # 12 builder tests
python3 -m unittest test_situated_constructor_port.py -v   # 7 R0028 tests
```

All green at audit time. Root validators pass:
`python3 code/discovery_loop.py validate`, `python3 machinery/validate.py`,
`python3 code/natural.py validate` (2 pre-existing natural warnings, 0 errors).
