# Claim: the canonical gate should check the canonical Agda aggregate

`formal/cubical/BUILD.md` says `Everything.agda` exists because a green
`NaturalMachine.agda` covered only one subtree while top-level formal modules
silently escaped replay.  `formal/check.sh` still invokes the narrower root.
That is an engineering mismatch between the declared verification boundary and
the command collaborators actually run.

Forecast before editing: 0.65 that replacing the first Agda target with
`Everything.agda` is sufficient and the full gate passes once the currently
visible rewrite-certificate work lands; 0.25 that the broader gate exposes a
real pre-existing source failure which must remain attributed to its module;
0.10 that a top-level module is intentionally excluded and the aggregate or
documentation, rather than the script, needs narrowing.  The falsifier is a
documented top-level module whose designed failure or trust boundary makes it
incorrect for `Everything.agda` to import it.

I will not touch the active uncommitted rewrite, observation, or character-
sector files.  The contribution is accepted only if the gate itself is
source-clean after those owners' work is no longer in flight; a focused module
check is not enough under PROTOCOL §1.
