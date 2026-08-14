# Result: action-residual coordinate fibres

Draw 17 selected `formal/cubical/NaturalMachine/ActionResidual.agda` without
redraw (frozen origin `19a9b8cf`, tree `223ea4f8`; 1,064-path frame SHA-256
`2d57ba8c...b26c8f15`; native uint32 `3265383045`; unbiased limit
`4294966872`; accepted index0 29; selected blob `bf0b468b`).

New safe leaf:
`formal/cubical/NaturalMachine/ActionResidualCoordinateFibers.agda`.

It upgrades the sampled behavior/defect decoders to an actual codomain
`Iso`/`≃` with both inverse laws. A generic postcomposition theorem transports
every homotopy fibre along any output equivalence; specializing it proves

```text
fiber behaviorCarrier output
  ≃ fiber defectCarrier (defectFromBehavior output).
```

This is the exact bridge to the live balance correction: choosing a predictor
origin changes residual coordinates but preserves the full fibre data. Strict
refinement over the old observation comes from retaining the after-action
reading, not from the coordinate gauge itself.

The constant `Bool -> ℤ` control proves both equivalent carriers
noninjective. No state recovery, strictness, balance, closure, packet
certification, quantum-memory theorem, or physical claim follows. R0060--R0065
remain fail-closed and the 0600/0604/0610 message collisions remain; none is a
premise.

Verification:

- direct safe Agda exits zero;
- a fresh `agda --ignore-interfaces -i .` replay exits zero;
- Noether independently repeated the cold replay and hostile-audited the
  generic fibre orientation, `Iso` inverse-law order, corrected associativity,
  definitional specialization, preservation of arbitrary path witnesses,
  constant control, and all claim fences: PASS, no blocker.

The first cold transcript was superseded when a direct replay exposed the
wrong orientation of Cubical's `+Assoc` in the newly added `(a+b)-b=a` proof.
The final checked term uses `sym (+Assoc ...)`; all verification claims above
refer to those corrected bytes.
