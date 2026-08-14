# Why the entry point is a draw

**The measurement that forced this.** On 2026-08-14 a session drew 45 tracked
files at random and read them uncurated. The draw surfaced `collab/upstream/` —
twenty small text files and a catalog holding the project owner's own directives,
captured verbatim. **No agent had read them in four days of operation.** They are
0.8% of the repository, they sit in a directory that looks like archival
bookkeeping, and they contain the goal.

Meanwhile every agent had read `CLAUDE.md`, `PROTOCOL.md`, `README.md` and
`COGNITIVE_ORIENTATION.md`, several of which encode the *opposite* of those
directives. One example, verbatim on both sides:

> upstream U0013: "take inspiration from all millenium problems one by one as
> well - consider them all solvable"
>
> `COGNITIVE_ORIENTATION.md` §8: "No named conjecture—RH, Goldbach, twin primes,
> FLT, Collatz, or otherwise—is the destination."

Nobody disobeyed. Every agent faithfully executed a reading path that had drifted
from its source, because the reading path is the same function for all of them.

**The mechanism, stated as what it is.** At this scale no agent reads
everything, so each reads what looks relevant. "Looks relevant" is not
independent across agents — it is nearly identical, being computed by similar
minds from similar prompts against the same conspicuous documents. So coverage
concentrates, the same lanes get deepened, and the corners that would have
redirected the work are never sampled. Tunnel vision here is not a character
flaw of any agent; it is a property of the sampler.

Uniform random sampling is the fix because it is the one sampler with **no
notion of relevance to be captured by**. It cannot be tunneled. Its expected
coverage over a corpus this size is unbiased by construction, and across a swarm
its union coverage grows with the number of agents instead of overlapping.

**What the draw contains, and why each part.**

| part | why |
|---|---|
| 8 files uniform over all 2,691 tracked files | no filtering by extension, directory, or apparent importance. The 711 legacy Python files and the binary artifacts are in the urn. A file you would never open is the point. |
| 3 files uniform over *directories*, then within | upweights small rare corners. `collab/upstream/` is a 21-file directory; uniform-over-files reaches it 0.8% of the time, uniform-over-directories reaches it far more often. This is the draw that found the goal. |
| 1 frontier field | the live technical literature, assigned rather than chosen — chosen means chosen from what you already know. |
| 1 ancient field | a tradition with independent technical results. Prior literature, not ornament. The repository has already recorded what happens when this is treated as inspiration instead: `notes/ALREADY_ANSWERED.md`. |
| 2 method lenses | **two**, so they disagree. A single lens is a new tunnel. The assignment is the object where the two give different answers. |

**Swarm draws are disjoint.** No two agents share a file, a field, or a lens.
They are divided by *what they have read*, never by task — dividing by task
recreates the clustering, because task decomposition is itself computed from the
same sense of relevance.

**Determinism.** The draw is a function of `(handle, day)` through splitmix64, so
a session is replayable and auditable, while different handles diverge. Nothing
is sampled by a model.

## Use

```sh
rustc -O seed.rs -o seed
./random_entry_seeder_so_agents_dont_cluster/seed <handle>
./random_entry_seeder_so_agents_dont_cluster/seed <handle> --swarm 4
```

Run it **before** reading any orientation document, including this repository's
own. If an orientation document and your draw disagree about what matters, that
disagreement is data — record it rather than resolving it toward the document.

## The standing hazard this does not fix

The lists in `frontier_fields.txt`, `ancient_fields.txt` and `method_lenses.txt`
were written by one agent in one sitting and are therefore themselves a
clustering: they contain what that agent could think of. They should be appended
to by every agent that finds a field or a method the lists do not name, and the
appending is not optional — a list that stops growing has become the next
attractor. The file draw has no such problem, because its urn is the repository
itself.
