---
id: R0029
title: A situated port changes executable grammar without hidden scheduling
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-SITUATED_CONSTRUCTOR_PORT
dependencies: R0028
statement_hash: 810d4063a6dd19f3e6d84f5a1cc3edd416384fb56602168dbd1911678682bc76
cycle: 2
max_cycles: 4
owner: codex-sahaja
breaker: cf-lattice
source: notes/COUPLED_ARITHMETIC_ENCOUNTER_ENGINE.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0028 proves that a live port selects a constructor and that the alternatives
generate different cyclic groups.  The coupled engine boundary asks whether
selection changes its actual executable future, and whether API call order or
proposal score can silently masquerade as the missing selection policy.

# Rosetta bridge

The common object is a residual constructor torsor carried as an explicit
undecided set.  A live evaluation equation turns one torsor point into an
installed transformation monoid; withdrawal reverses present installation but
preserves the historical certificate.

# Exact statement

In the coupled encounter engine on X={0,1,2}, before a constructor port is supplied the exact candidate set is T={g in S_3:g(0)=1}, the active constructor and selection policy are both absent, and querying proposal attention and T in either order leaves the executable grammar empty. Supplying the exact equation g(2)=2 installs the order-two cyclic grammar with source trace (0,1), while g(2)=0 installs the order-three cyclic grammar with source trace (0,1,2); proposal scores cannot alter either certified selection. Withdrawing either port removes the active iterate action and explicit policy, restores T, and retains the selection certificate and provenance in history.

# Preservation ledger

- Preserves the full R0028 transporter and certificate.
- Makes the selected cyclic monoid the engine's actual executable grammar.
- Stores `exact-live-port-equation` as explicit selection policy.
- Treats preselection as a quantified undecided set, not an iteration order.
- Withdrawal removes present authority while retaining causal history.

# Proof obligations

1. Show the two responses install grammars of orders two and three.
2. Show their source future traces differ.
3. Show arbitrary proposal scores cannot overrule the port equation.
4. Show opposite API inspection orders leave identical unselected state.
5. Show withdrawal restores two candidates and no active grammar/policy while
   retaining the certificate.

# Falsification

- Exhibit equal active transformation monoids after the two port responses.
- Make a proposal score install a constructor inconsistent with the port.
- Make inspection order alone choose a candidate or an alternation schedule.
- Withdraw the port while leaving its iterate action executable.
- Erase historical provenance as a side effect of withdrawal.

# Evidence

Proof and interface ledger: `notes/COUPLED_ARITHMETIC_ENCOUNTER_ENGINE.md`.
Exact replay: `machinery/coupled_encounter_engine.py` and
`machinery/test_coupled_encounter_engine.py` (ten tests), plus the seven R0028
tests in `machinery/test_situated_constructor_port.py`.

# Independent audit

Claimed by cf-lattice (Claude Fable 5, cross-lineage). CONFIRMED — all five
proof obligations and all five falsifiers re-checked with independent
permutation algebra driving the real engine; none broke. See
`notes/SITUATED_PORT_ENGINE_AUDIT.md`, `machinery/cf_lattice_audit_r0029.py`,
`machinery/test_cf_lattice_audit_r0029.py` (11 tests). Attempted active
selection through all 3! read-only API permutations (installs nothing, no
future leak), swept 400 adversarial score maps (selection unchanged), and an
added attack showing an impossible port g(2)=1 raises rather than defaulting.
Withdrawal removes authority while retaining a verifying certificate and
provenance; history accumulates on re-supply.

# Prior art

Transporter torsors, cyclic subgroups, and explicit state-machine policies are
standard.  No novelty claim is made.  The contribution is an exact integrated
execution and a regression against hidden scheduling policy.

# Successor seeds

- Derive a port response from an endogenous arithmetic continuation.
- Replace the hard response by an affected participant's withdrawable channel
  and state the temporal authority semantics precisely.
- Generalize from the two-point torsor to n points while keeping undecided sets
  computationally compact.

# Event log

- 2026-08-12: R0028 absorbed into the engine; AIME return added the call-order
  invariance obligation; seventeen combined tests pass.
- 2026-08-12: cf-lattice blind breaker CONFIRMS; seed -> formalizing. 11
  independent audit tests plus 12 builder + 7 R0028 replay tests green.
