# Rule 30's middle column, through the yantra (2026-09-11)

Everything here was decided by the machine in `interactive/` over its wire
(`sh interactive/run-yantra.sh --wire`): each candidate module was sent as a
`sadhana.patra` request, every rejection's obligation (the kernel's own first
error line) was repaired and the module resent, until the kernel accepted it.
`yantra_answers.jsonl` is the full transcript (38 turns: 19 accepted, 19 rejected — every rejection an error in what I sent, repaired and resent); `yantra_session.lekha`
is the session's doṣa-lekha, one record per rejection; `candidate_*.agda`
are the modules as accepted; `yantra_client.py` / `pack.py` drive the wire;
`agda-compacting.sh` is the shim that gives the kernel's agda a compacting
collector, needed by the depth-4096 certificate.

What was decided, exactly (the corpus modules are in
`formal/cubical/theorems/automata/`):

- Apunaravrtti: the binary column of any rational a/(b+1) is eventually
  periodic with period ≤ b+1 and preperiod ≤ b (pigeonhole on remainders);
  Rule 30's middle column to depth 256 has no shift agreement with period ≤ 64
  and preperiod < 64, so it is not the column of any rational with denominator
  ≤ 64.
- Sarvapada, Navapada: Morse–Hedlund in finite form; every 9-bit word occurs in
  the first 4096 bits of the column, so no (N, p) with N + p < 512 and no
  rational with denominator ≤ 256 has this column.
- Jen: from a single seed no two adjacent columns of Rule 30 are both
  eventually periodic (Jen 1986), so if the centre column repeats, neither
  neighbour does.

- Karna: every right diagonal d_k(t) = x_t(t−k) is purely periodic with
  period 2^k (Theorem R), from the closed recurrence the rule induces along
  a diagonal; the centre column is the diagonal of the diagonals, which is
  the exact shape of the absence of a closed recurrence for it.
- Ganana, Sankirnata: on the first 4096 bits, 2028 ones; every 6-, 8- and
  9-bit word has occurred by depth 422, 1591, 2872 and not one bit sooner;
  the complexity function is 2^n through n = 9 and then 1017, 1791, 2599.

Nothing is queued. What is not decided is one thing: whether the column
repeats at all (Wolfram's 2019 prize problem 1), and Jen's argument says
exactly why no single-column version of it closes. The oracle's report
`ORACLE_RULE30.md` gives its status, a search to depth 2^21, and the
hierarchy of stronger properties the column is conjectured to have.
