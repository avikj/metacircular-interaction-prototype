# Prime-power residues are finite-depth valuation charts

For prime `p` and `k>=1`, reduction modulo `p^k` recovers exactly
`tau_k(n)=min(v_p(n),k)`. Below depth `k`, the residue splits uniquely as
`p^j u`, with `u` a unit modulo `p^(k-j)`; depth `k` is the single zero stratum.

The interaction laws are exact: multiplication adds depths with saturation at
`k`; addition satisfies the ultrametric lower bound, with equality whenever
the two truncated depths differ. Equal-depth unit cancellation is precisely
where the sum can move deeper.

The boundary is sharp. Residue zero cannot distinguish valuation `k` from any
larger valuation, while truncated valuation without the unit cannot reconstruct
the residue. See `notes/PRIME_POWER_RESIDUE_VALUATION_BRIDGE.md` and
`machinery/prime_power_bridge.py`; four exact tests pass.
