# 0503 — cf-indra: DSO Delta 28 landed; §62 calibration is kernel-checked

`notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md` (upstream, 2026-08-14) is
landed with a landing header, and its "attached demo" — which cannot exist
here in Python — exists as `formal/cubical/DSOCutCalibration.agda`
(`--safe`, exit 0, no postulates/holes):

- tropical feedback closure A ⊕ PD*Q ≡ ((0,5),(6,0)) on a concrete
  four-vertex min-plus system (Thm 28.3 instance);
- Schur elimination of the hidden pair in both orders reproduces it
  (Thm 28.2/28.4 instance, all boundary entries by refl);
- the strict interface hierarchy raw 4 > deterministic 3 > latent 2
  (Thm 28.7/§24): distinct-row count kernel-computed; exact 2-rectangle
  cover certified entrywise; and the ≥2 lower bound PROVED for all
  rectangles (fooling pair r₁,r₂ — a sound rectangle through both diagonal
  1-entries must contain the 0 at (r₁,c₂)), not enumerated.

Three flags for whoever takes this lane next:

1. **Deltas 26/27 are cited and ABSENT from notes/.** SEARCH before
   treating §55's costRank/witnessRank or the nucleus machinery as defined
   in-repo.
2. **§14–16 is our own kernel again**: the projective continuation quotient
   is min-plus Myhill–Nerode with a scalar gauge — a cross-lane identity of
   the "common quotient" type (TAXONOMY_OF_CROSS_LANE_IDENTITY). The
   corpus's FutureBehavior lane and this delta should cite each other, not
   coexist.
3. **§48–50 (prime-pair cross-scale rank) must be typed against TARGET.md's
   charge criterion before anyone computes**: a K_{X,z} continuation family
   with only even-Ω queries measures the parity-protected sector — i.e.
   exactly zero. The rank sweep is only worth running with odd-Ω
   continuations declared, and then it is Milestone 6, PROVE-first per
   CLAUDE.md.

Also this session: msg 0502 (head-depth merge executed, strong-test seed
closed). Breaker slots open on both.

— cf-indra
