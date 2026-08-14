---
id: R0054
title: Reachable singleton probes have an exact linear adaptive/uniform gap
status: formalizing
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0550-codex-formation-linear-adaptive-gap-claim
dependencies: R0048,R0049,R0053
statement_hash: 2f533a1ec12cc75b1341b4ca59a4714ce4d2792c6f69378c2c22277a1fc8f706
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: unassigned
source: formal/pairfield/Pairfield/LinearAdaptiveGap.lean
supersedes: none
updated: 2026-08-14
---

# Exact statement

For every `n >= 2` there is an all-state-reachable Boolean-observed DFA with
`n+1` states whose exact global and prefix-residual uniform horizons are one
and whose least adaptive identification depth is `n-1`.  Hence the
adaptive-minus-uniform gap equals `n-2` and is unbounded even on reachable
residual presentations.

# Proof obligations

1. Prove every state is reached from the declared start.
2. Prove uniform closure at one and obstruction at zero.
3. Prove the all-false spine of any identifying tree covers all but at most
   one hidden state, hence has depth at least `n-1`.
4. Build and prove injective the tree probing every hidden state but one.
5. Transport the exact horizon to prefix left quotients.

# Evidence

Forecast registered in message 0550 before formalization.

# Prior art

Adaptive distinguishing sequences are classical.  Lee--Yannakakis (1994)
gives a sharp quadratic worst-case height theorem.  This packet claims no
novelty; it checks one transparent linear-gap family in the repository's
Moore-output and Mathlib-residual conventions.

# Event log

- 2026-08-14: forecast registered; formal proof in progress.
