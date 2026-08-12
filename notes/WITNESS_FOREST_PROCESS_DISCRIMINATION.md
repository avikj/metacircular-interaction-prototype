# Incremental witness forests are optimal zero-error process experiments

## 1. Operational reading

Let a finite deterministic process have state set `X`, admitted actions `A`,
and observations `O`. An experiment consists of an action word `w` followed by
one terminal observation `o`. Starting from `x`, it returns the deterministic
classical outcome

\[
o(w\cdot x).                                                       \tag{1}
\]

Encode that outcome as the diagonal pure density operator
`|o(w x)><o(w x)|`. For two initial states `x,y`, its trace distance is

\[
D_{w,o}(x,y)=
\begin{cases}
0,&o(wx)=o(wy),\\
1,&o(wx)\ne o(wy).
\end{cases}                                                       \tag{2}

Thus trace distance one is exactly perfect zero-error discrimination by the
declared experiment.

## 2. Forest-depth theorem

`INCREMENTAL_WITNESS_FOREST` seeds synchronous state pairs that disagree on a
new observation and runs reverse BFS through paired actions.

**Theorem 2.1.** For every pair reached by that forest, its pointer depth is
exactly

\[
\min\{|w|:\exists o\in O_{\rm new},\ D_{w,o}(x,y)=1\}.             \tag{3}

Following its pointers supplies an experiment attaining the minimum.

**Proof.** A seed has depth zero and differs immediately under its stored
observation, so (3) holds. A reverse edge labelled `a` from pair `(x,y)` to
`(ax,ay)` prepends `a` to every distinguishing word of the target. Reverse BFS
therefore reaches a pair after `d` layers iff some length-`d` action word sends
it to an immediate-disagreement seed. BFS minimality excludes every shorter
word. Equation (2) translates immediate disagreement into trace distance one.
`square`

The terminal observation is a separate instrument application; forest depth
counts action/intervention length only. This is the `0.13` forecast
qualification, not a correction to the equality.

## 3. Incremental process meaning

Adding observations does not globally rebuild process memory. It creates new
perfect-discrimination seeds only inside old predictive classes. Reverse
reachability identifies exactly which previously indistinguishable histories
gain a zero-error experiment, and the predecessor forest stores one shortest
experiment for each.

Old inter-block experiments remain valid. Withdrawing an observation
invalidates the chosen experiments rooted at its seeds; alternative roots may
repair them. The forest is therefore an executable bank of process-
discrimination certificates, not merely an automaton implementation detail.

## 4. Quantum boundary

For this declared interface, the output states are diagonal point masses.
Quantizing their notation does not shorten the action word: trace distance
becomes one exactly when a classical observation already differs. The forest
has found the minimum such word.

This is not a universal no-go against coherent control of actions. A different
model could allow superpositions of action words, phase-sensitive access to
internal transitions, noncommuting quantum instruments, or bounded-error
discrimination. None is present in the deterministic action/terminal-
observation interface. Under this interface, a claimed quantum improvement
must change the admitted experiment, not re-encode (1) in Hilbert space.

## 5. Change to the organism

The incremental witness forest should be exposed as the process layer's
zero-error experiment compiler:

- pointer length = minimum intervention depth;
- terminal label = final instrument;
- replay = discrimination certificate;
- shared suffix = reusable experimental subroutine;
- observation withdrawal = certificate dependency invalidation.

The next storage optimization—choosing predecessor pointers to share suffixes—
must preserve these minimum depths. It is a proof-DAG compression problem, not
a reduction in process-discrimination complexity.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_witness_forest_process_discrimination.py \
  test_incremental_witness_forest.py
python3 witness_forest_process_discrimination.py
```

The theorem is proved above. Tests compare reverse-BFS depths with independent
word enumeration. No coherent-action oracle, bounded-error quantum query
bound, physical process tensor, thermodynamic cost, indefinite causal order,
or spacetime claim is made.
