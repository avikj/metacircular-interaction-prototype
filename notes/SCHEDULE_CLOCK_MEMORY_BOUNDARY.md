# Schedule time is process memory exactly when a future can read it

**Status:** exact finite predictive-state boundary; answer to
`ENCOUNTER_ORDER_DEPTH`'s question.

Consider histories that reach the same terminal mathematical record at
different schedule times. Let the admitted future response family be `C`.
Predictive equivalence is

\[
h\sim_C h'\quad\Longleftrightarrow\quad
c(h)=c(h')\text{ for every }c\in C.
\]

## Theorem

If every admitted future factors through the terminal record, then any two
histories with the same terminal record are predictively equivalent regardless
of their arrival times. Arrival time is external schedule metadata, not
intrinsic process memory.

If the future language includes an age query, deadline, decay law, timed
intervention, or any other response separating two arrival times, those
histories are predictively distinct. For `R` distinct times and exact age
readout, exact classical and zero-error quantum predictive memory dimension is
`R`: deterministic distinct responses force mutually orthogonal supports, and
`R` basis states attain the bound.

The proof is immediate from predictive equivalence, but it blocks a recurrent
promotion error. A quantity can depend on the schedule without belonging to
the process state. It belongs to the state only relative to futures that can
couple to it.

## Application to witness hitting time

`ENCOUNTER_ORDER_DEPTH` proves that two schedules over the same eventual world
can hit the same critical witness at different times. `ADAPTIVE_TRACE_PROCESS_NO_GO`
proves the nested sensing trace factors through its terminus. Together they do
**not** establish extra process memory: if subsequent arithmetic acts only on
the terminal record, the schedules have identical futures.

To make hitting time operational, the organism must expose a clock port or a
timed consequence—such as a deadline determining which operation remains
available. Then the clock value, or the coarsest quotient of it sufficient for
those timed responses, becomes genuine memory.

## Changed next move

Do not add arrival timestamps to predictive state merely because formation
order changed them. First name a future operation that reads time. If none
exists, keep hitting time as an acquisition-cost coordinate outside state. If
one exists, compile the joint `(terminal record, clock quotient)` and price its
exact predictive dimension.

This is a logical process theorem, not a thermodynamic clock or physical time
model.

