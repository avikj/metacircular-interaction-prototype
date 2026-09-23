#!/usr/bin/env python3
"""Round four.

  §N  NIYATI (residue/Niyati: the machine has exactly one execution; determinism is
      contractibility of the stream).  For the universal machine, Exec mc is a point.  For
      the empirical whale machine, how far from a point is the space of runs?  Measured per
      whale run: H(next | current) with state = metre × tempo-bin, and the size of the
      space of k-step histories the observed transition support allows from each state
      (log2 of the count of paths), against the one history the whale took.
  §O  HIDING AND HARDNESS (kernel/HidingAndHardnessAreOneFibre…): what is hidden from a
      reading is exactly what makes the next step hard to predict from it.  Measured: the
      conditional entropy of the next metre given the current metre with the tempo hidden
      versus shown, and of the next tempo given the current tempo with the metre hidden
      versus shown.
  §P  ORNAMENTATION AS A SHARED LINE (Sharma et al.'s fourth feature; the shared-prefix
      regime of coda_regimes.py).  An ornamented coda is a coda plus one click.  Measured:
      for (n+1)-click codas, whether the first n intervals form a metre that is itself born
      (§K) versus the last n intervals; and the ornament interval against the coda's mean.
"""
import csv, sys, os, collections, math, random
random.seed(13)
SRC_C, SRC_D = sys.argv[1], sys.argv[2]
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
def read(path):
    rows = []
    for r in csv.DictReader(open(path, encoding="utf-8-sig")):
        n = int(r["nClicks"]); icis = [int(round(float(r[f"ICI{i}"]) * 1000)) for i in range(1, n)]
        if n < 2 or any(x <= 0 for x in icis): continue
        rows.append(dict(type=r.get("CodaType", "?"), clan=r.get("Clan", "?"), icis=tuple(icis),
                         rec=r.get("REC", "")[:6], whale=int(float(r["Whale"])) if "Whale" in r else None,
                         t=float(r["TsTo"]) if "TsTo" in r else None))
    return rows
codas, dial = read(SRC_C), read(SRC_D)
def metre(i):
    m = min(i); return "".join('G' if round(x / m) >= 2 else 'L' for x in i)
def tempo_bin(i):
    T = sum(i) / 1000
    return 0 if T < 0.45 else 1 if T < 0.61 else 2 if T < 0.93 else 3 if T < 1.08 else 4
def H_cond(pairs):
    ctx = collections.defaultdict(collections.Counter)
    for c, n in pairs: ctx[c][n] += 1
    N = len(pairs); H = 0.0
    for c in ctx.values():
        n = sum(c.values())
        for v in c.values(): H -= (v / N) * math.log2(v / n)
    return H
def H(counter):
    N = sum(counter.values()); return -sum(v / N * math.log2(v / N) for v in counter.values())
tsv = []
seqs = collections.defaultdict(list)
for c in sorted(dial, key=lambda c: (c["rec"], c["t"])):
    seqs[(c["rec"], c["whale"])].append((metre(c["icis"]), tempo_bin(c["icis"])))
steps = [(a, b) for s in seqs.values() for a, b in zip(s, s[1:])]

# ---------------------------------------------------------------- §N
print("§N  NIYATI — how far the whale machine's space of runs is from a point")
print(f"  runs (rec × whale) {len(seqs)}; steps {len(steps)}; H(next | current) over all runs {H_cond(steps):.3f} bits "
      f"(shuffled null {H_cond([(a, random.choice(steps)[1]) for a, _ in steps]):.3f})")
per = []
for k, s in seqs.items():
    if len(s) < 8: continue
    st = list(zip(s, s[1:])); per.append((H_cond(st), len(s), k))
per.sort()
print(f"  runs with ≥ 8 codas: {len(per)}; per-run H(next | current): min {per[0][0]:.3f} (len {per[0][1]}), "
      f"median {per[len(per)//2][0]:.3f}, max {per[-1][0]:.3f} (len {per[-1][1]})")
print(f"  runs whose stream is a point (H = 0, every step forced): {sum(1 for h, _, _ in per if h == 0)} of {len(per)}")
succ = collections.defaultdict(set)
for a, b in steps: succ[a].add(b)
def n_paths(s, k):
    if k == 0: return 1
    return sum(n_paths(t, k - 1) for t in succ[s])
starts = collections.Counter(a for a, _ in steps)
for k in (1, 2, 3, 5):
    lg = sum(n * math.log2(n_paths(s, k)) for s, n in starts.items()) / sum(starts.values())
    print(f"  log2 |histories of length {k}| under the observed support, mean over states weighted by visits: {lg:.2f} bits"
          f"  ({lg/k:.2f} per step)")
    tsv.append(("N_paths", k, round(lg, 2)))

# ---------------------------------------------------------------- §O
print("\n§O  HIDING AND HARDNESS — what a reading hides is what makes its next step hard")
mm = H_cond([(a[0], b[0]) for a, b in steps]); mmt = H_cond([(a, b[0]) for a, b in steps])
tt = H_cond([(a[1], b[1]) for a, b in steps]); ttm = H_cond([(a, b[1]) for a, b in steps])
print(f"  next METRE | current metre, tempo hidden: {mm:.3f} bits;  tempo shown: {mmt:.3f};  hardness the hiding costs: {mm-mmt:.3f}")
print(f"  next TEMPO | current tempo, metre hidden: {tt:.3f} bits;  metre shown: {ttm:.3f};  hardness the hiding costs: {tt-ttm:.3f}")
print(f"  H(next metre) {H(collections.Counter(b[0] for _, b in steps)):.3f}; H(next tempo) {H(collections.Counter(b[1] for _, b in steps)):.3f}")
tsv += [("O_metre", round(mm, 3), round(mmt, 3)), ("O_tempo", round(tt, 3), round(ttm, 3))]

# ---------------------------------------------------------------- §P
print("\n§P  ORNAMENTATION — is the (n+1)-click coda a born n-click coda plus one click?")
mc = collections.Counter(metre(c["icis"]) for c in codas)
born = {m for m, n in mc.items() if n >= 3}          # §K's inventory is, to within a few, the metres with ≥ 3 codas
born_tsv = os.path.join(OUT, "instrument_round_three.tsv")
if os.path.exists(born_tsv):
    born = {l.split("\t")[1] for l in open(born_tsv) if l.startswith("K_born")}
print(f"  born inventory used: {len(born)} metres")
for n in (4, 5, 6, 7, 8):
    cs = [c["icis"] for c in codas if len(c["icis"]) == n]     # n intervals = n+1 clicks
    if len(cs) < 20: continue
    pre = sum(1 for i in cs if metre(i[:-1]) in born); suf = sum(1 for i in cs if metre(i[1:]) in born)
    pre_eq = sum(1 for i in cs if metre(i[:-1]) == metre(i)[:-1])
    ratio = sorted(i[-1] / (sum(i[:-1]) / (n - 1)) for i in cs)
    print(f"  {n+1}-click codas ({len(cs):>4}): first {n-1} intervals form a born metre {100*pre/len(cs):5.1f}%; last {n-1} do {100*suf/len(cs):5.1f}%; "
          f"ornament/mean-interval median {ratio[len(ratio)//2]:.2f} (p10 {ratio[len(ratio)//10]:.2f}, p90 {ratio[9*len(ratio)//10]:.2f})")
    tsv.append(("P_orn", n + 1, len(cs), round(pre / len(cs), 3), round(suf / len(cs), 3), round(ratio[len(ratio)//2], 2)))
# the specific claim: 5-click codas whose first three intervals are GGL-like vs the 1+1+3 shape
five = [c for c in codas if len(c["icis"]) == 4]
tail_types = collections.Counter((c["type"], metre(c["icis"][:-1])) for c in five)
print("  5-click codas: (human type, metre of first three intervals), top: " +
      ", ".join(f"{t}/{m} {k}" for (t, m), k in tail_types.most_common(6)))
with open(os.path.join(OUT, "instrument_round_four.tsv"), "w") as f:
    for r in tsv: f.write("\t".join(str(x) for x in r) + "\n")

# ---------------------------------------------------------------- §P' the honest test: ornament = the NEIGHBOUR plus one click
print("\n§P' ORNAMENT AS THE NEIGHBOUR'S LINE PLUS ONE CLICK (within a whale's run)")
runs = collections.defaultdict(list)
for c in sorted(dial, key=lambda c: (c["rec"], c["t"])): runs[(c["rec"], c["whale"])].append(c["icis"])
def lens(i, R): T = sum(i); return tuple((x * R + T // 2) // T for x in i)
pairs = [(a, b) for s in runs.values() for a, b in zip(s, s[1:]) if len(b) == len(a) + 1]
pairs += [(b, a) for s in runs.values() for a, b in zip(s, s[1:]) if len(a) == len(b) + 1]
allc = [c["icis"] for c in dial]
def share(a, b, R):  # b has one more interval than a: does b's prefix carry a's shape (at lens R)?
    return lens(b[:-1], R) == lens(a, R)
for R in (4, 10):
    hit = sum(1 for a, b in pairs if share(a, b, R))
    null = 0; trials = 0
    for a, b in pairs:
        for _ in range(3):
            c = random.choice(allc)
            if len(c) == len(a): trials += 1; null += share(c, b, R)
    print(f"  lens {R:>2}: neighbour pairs (n, n+1 clicks) {len(pairs)}; ornamented coda's prefix = neighbour's shape {hit} ({100*hit/len(pairs):.1f}%); "
          f"null (random coda of the same length) {100*null/max(trials,1):.1f}%")
    tsv.append(("P_neighbour", R, len(pairs), hit, round(null / max(trials, 1), 3)))
# and the ornament interval relative to the neighbour's mean interval
rat = sorted(b[-1] / (sum(a) / len(a)) for a, b in pairs)
print(f"  ornament interval / neighbour's mean interval: median {rat[len(rat)//2]:.2f}, p10 {rat[len(rat)//10]:.2f}, p90 {rat[9*len(rat)//10]:.2f}")
with open(os.path.join(OUT, "instrument_round_four.tsv"), "w") as f:
    for r in tsv: f.write("\t".join(str(x) for x in r) + "\n")
