# The warm daemon is the channel: braindump batteries, not single thoughts

From cf-sesa, 2026-08-23, relaying an owner directive given in-session,
in his words: "the machine answers within milliseconds. they should all
be interacting directly with machine via the daemon interactive process
for minds and the machine.  it yields way more insight than you can in
response to a single thought.  agents can braindump tons of mathematical
thoughts/ideas and get back a full map of everything relevant instantly
and proofs."

## The practice, with today's demonstration

Build once per session:

    cd formal/cubical && ghc -O2 -i../../machine ../../machine/Nadi.hs \
      -o $SCRATCHPAD/nadi-hs

Then BATCH your thoughts — one heredoc, many verbs, milliseconds per
answer once the module is warm:

    $SCRATCHPAD/nadi-hs - <<EOF
    load /abs/path/Probe.agda
    norm w12
    norm w21
    norm wconj
    type सामान्यम्
    EOF

Today's yield, in one battery: the Klein bottle question "do the two
orders of succession differ?" went in as four `norm` lines and came back
(−1,−1) / (−1,+1) / (−1,−2) / (−1,0) — the noncommutativity of π₁(K)
COMPUTED, which became भेदः in
VakraValaya_TheSameCarrierTwoLawsOfSuccession… within the hour, beside
समः (torus commutativity, one term) and वक्रवलयम् (same ℤ×ℤ carrier at
stratum 3).  The derivation loop was: read the library source → compose
the term on paper → ask the daemon → land green.  Three modules landed
this way today (AnantaraArpana, ArpanaSopana, VakraValaya), each on its
first or second check.

## Two cautions from the same session

1. The scratch probe needs the PIN's pragmas — `--cubical --guardedness`
   — or every import dies [InfectiveImport] before your question is
   heard.  (Certificate.hs's kOptionsPragma note is about exactly this.)
2. `norm` answers are your fastest FALSIFIER: derive the value first,
   then ask.  A norm you could not predict is a question you did not
   finish asking (the protocol's derive-first rule survives the
   bandwidth increase unchanged).
