#!/usr/bin/env python3
"""The corpus's instruments run on the Dominica sperm-whale codas, each reading
named by the checked term that licenses it.  Inputs: DominicaCodas.csv and
sperm-whale-dialogues.csv (Sharma et al. 2024).  Outputs: stdout + out/instrument_*.tsv
+ out/prastara_*.hvm4.

  §A  METRE (theorems/metre: MatraVarnaGuru, PrastaraPankti, Matramerus/Virahāṅka,
      Meru, DurationIsSyllablesPlusGuru).  A coda's inter-click intervals, read in
      units of its shortest interval, are a laghu/guru pattern: a mātrā-vṛtta.
      Piṅgala's three pratyayas — saṅkhyā 2ⁿ, meru C(n,k), mātrā = Virahāṅka —
      count the space the repertoire lives in; uddiṣṭa gives each coda its row
      in the prastāra.  Computed: the metres the whales use out of all metres.
  §B  NERODE (theorems/automata/NerodeYantra).  The readout factors along time iff
      next readout is a function of the current one.  Computed: H(next class |
      last k classes) on each whale's ordered codas vs a shuffled null — the
      set-valued shadow of "out ∘ δ ≡ g ∘ out".
  §C  ENCOUNTER (kernel/TheEncounterOfTwoPeers…, README §6 revelation vs
      generation).  A coda by B right after a coda by A: transported (same shape,
      fibre moved) or generated (new shape).  Computed against same-whale steps
      and a null.
  §D  SIGN BIRTH (hieroglyphics II: चिह्नजन्म ⟺ संरचनासंपीडनलाभ > 0; Laghava).
      A class is a sign iff it compresses more than it costs.  Computed: two-part
      description length of the corpus at each lens R; the lens where compression
      stops paying is the lens at which sign birth stops.
  §E  DECATEGORIFICATION (abstracts 21, 28; kernel/TheCountingSemanticsIsA
      Decategorification…).  The Zipf slope is a function of the lens, not of
      the whales.  Computed: rank–frequency slope at each R.
  §F  ONE-LIPSCHITZ CROSSINGS (physics/SthairyaSutra).  The tempo trajectory's
      modulus along an exchange.  Computed: quantiles of |drift| per step.
"""
import csv, sys, os, math, collections, random, statistics, itertools
CODAS = sys.argv[1]; DIAL = sys.argv[2]
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
random.seed(7)

def read_codas(path):
    rows = []
    for r in csv.DictReader(open(path, encoding="utf-8-sig")):
        n = int(r["nClicks"]); icis = [int(round(float(r[f"ICI{i}"]) * 1000)) for i in range(1, n)]
        if n < 2 or any(x <= 0 for x in icis): continue
        rows.append(dict(type=r.get("CodaType", "?"), clan=r.get("Clan", "?"), icis=tuple(icis),
                         rec=r.get("REC", "")[:6], whale=int(float(r["Whale"])) if "Whale" in r else None,
                         t=float(r["TsTo"]) if "TsTo" in r else None))
    return rows
codas = read_codas(CODAS); dial = read_codas(DIAL)
def lens(icis, R=10):
    T = sum(icis); return (len(icis), tuple((x * R + T // 2) // T for x in icis))
print(f"codas {len(codas)}  dialogue codas {len(dial)}")

# ---------------------------------------------------------------- §A METRE
def moras(icis):
    m = min(icis); return tuple(max(1, int(round(x / m))) for x in icis)      # Nārāyaṇa's {1,2,3,…} samāsa
def pattern(icis):
    return tuple('G' if q >= 2 else 'L' for q in moras(icis))                  # Piṅgala's laghu/guru
def matra(p): return sum(2 if s == 'G' else 1 for s in p)                      # matraOf
def uddista(p):  # Piṅgala's uddiṣṭa: the row of a pattern in the prastāra (1-based; laghu at i adds 2^i)
    return 1 + sum(2 ** i for i, s in enumerate(p) if s == 'L')
def virahanka(n):
    a, b = 1, 1
    for _ in range(n): a, b = b, a + b
    return a
def binom(n, k): return math.comb(n, k)
pats = collections.Counter(pattern(c["icis"]) for c in codas)
print("\n§A  METRE — the repertoire inside Piṅgala's prastāra (laghu = shortest interval, guru ≥ 2 of it)")
print("varṇa n | metres used / saṅkhyā 2ⁿ | codas | meru row occupancy (k guru: used/C(n,k))")
byn = collections.defaultdict(dict)
for p, c in pats.items(): byn[len(p)][p] = c
with open(os.path.join(OUT, "instrument_metre.tsv"), "w") as f:
    f.write("varna\tpattern\tuddista\tmatra\tguru\tcodas\ttop_types\n")
    for n in sorted(byn):
        used = byn[n]; tot = sum(used.values())
        occ = []
        for k in range(n + 1):
            u = sum(1 for p in used if p.count('G') == k); occ.append(f"{k}:{u}/{binom(n,k)}")
        print(f"{n:7} | {len(used):3} / {2**n:<4} | {tot:5} | " + " ".join(occ))
        for p, c in sorted(used.items(), key=lambda kv: -kv[1]):
            types = collections.Counter(cd["type"] for cd in codas if pattern(cd["icis"]) == p).most_common(3)
            f.write(f"{n}\t{''.join(p)}\t{uddista(p)}\t{matra(p)}\t{p.count('G')}\t{c}\t{types}\n")
mat = collections.Counter(matra(pattern(c["icis"])) for c in codas)
print("mātrā weight m | codas | distinct metres used / Virahāṅka M(m) (all laghu-guru metres of weight m)")
for m in sorted(mat):
    used = len({pattern(c["icis"]) for c in codas if matra(pattern(c["icis"])) == m})
    print(f"{m:14} | {mat[m]:5} | {used} / {virahanka(m)}")
# the annotated types read as metres: how many patterns per type, dominant pattern
print("annotated type -> dominant laghu/guru metre (share), distinct metres")
tp = collections.defaultdict(collections.Counter)
for c in codas: tp[c["type"]][pattern(c["icis"])] += 1
for t, cnt in sorted(tp.items(), key=lambda kv: -sum(kv[1].values()))[:14]:
    p, k = cnt.most_common(1)[0]; print(f"  {t:8} {''.join(p):10} {k/sum(cnt.values()):.2f}  {len(cnt)} metres")
nar = collections.Counter(moras(c["icis"]) for c in codas)
print(f"Nārāyaṇa samāsa (mora vector over {{1,2,3,…}}): {len(nar)} distinct vectors for {len(codas)} codas; top:",
      [(v, k) for v, k in nar.most_common(6)])

# ---------------------------------------------------------------- §B NERODE
print("\n§B  NERODE — does the next readout factor through the current? (per-whale ordered codas, lens-10 class)")
seqs = collections.defaultdict(list)
for c in sorted(dial, key=lambda c: (c["rec"], c["t"])): seqs[(c["rec"], c["whale"])].append(lens(c["icis"]))
def H_cond(seqs, k):
    ctx = collections.defaultdict(collections.Counter)
    for s in seqs.values():
        for i in range(k, len(s)): ctx[tuple(s[i-k:i])][s[i]] += 1
    N = sum(sum(c.values()) for c in ctx.values()); H = 0.0
    for c in ctx.values():
        n = sum(c.values())
        for v in c.values(): H -= (v / N) * math.log2(v / n)
    return H, N
def shuffled(seqs):
    pool = [x for s in seqs.values() for x in s]; random.shuffle(pool); out = {}; i = 0
    for key, s in seqs.items(): out[key] = pool[i:i+len(s)]; i += len(s)
    return out
print("k | H(next | last k) bits | N | shuffled-null H | classes")
classes = len({x for s in seqs.values() for x in s})
null = shuffled(seqs)
with open(os.path.join(OUT, "instrument_nerode.tsv"), "w") as f:
    f.write("k\tH\tN\tH_null\n")
    for k in range(0, 4):
        H, N = H_cond(seqs, k); Hn, _ = H_cond(null, k)
        print(f"{k} | {H:6.3f} | {N:5} | {Hn:6.3f} | {classes}"); f.write(f"{k}\t{H:.4f}\t{N}\t{Hn:.4f}\n")
# determinism shadow: fraction of steps where next == argmax(next | current)
ctx = collections.defaultdict(collections.Counter)
for s in seqs.values():
    for i in range(1, len(s)): ctx[s[i-1]][s[i]] += 1
hit = sum(c.most_common(1)[0][1] for c in ctx.values()); tot = sum(sum(c.values()) for c in ctx.values())
print(f"argmax-next given current: {hit}/{tot} = {hit/tot:.3f}  (a factoring out∘δ = g∘out would give 1.000)")

# ---------------------------------------------------------------- §C ENCOUNTER
print("\n§C  ENCOUNTER — B's coda right after A's: transported shape (revelation) or new shape (generation)")
ordered = sorted(dial, key=lambda c: (c["rec"], c["t"]))
cross, same = [], []
for i in range(len(ordered) - 1):
    a, b = ordered[i], ordered[i+1]
    if a["rec"] != b["rec"] or b["t"] - a["t"] >= 6: continue
    (cross if a["whale"] != b["whale"] else same).append((a, b))
def stats(pairs):
    kept = [ (a, b) for a, b in pairs if lens(a["icis"]) == lens(b["icis"]) ]
    dr = [abs(sum(b["icis"]) - sum(a["icis"])) for a, b in kept]
    return len(pairs), len(kept), (statistics.median(dr) if dr else float('nan'))
pool = [c for c in dial]
nullpairs = [(random.choice(pool), random.choice(pool)) for _ in range(4000)]
for name, pr in [("same whale (A then A)", same), ("cross whale (A then B)", cross), ("null (random pairs)", nullpairs)]:
    n, k, md = stats(pr); print(f"  {name:24} steps {n:5}  shape kept {k:5} ({100*k/n:.1f}%)  median |Δtempo| when kept {md:.0f} ms")
overlap = sum(1 for a, b in cross if b["t"] < a["t"] + sum(a["icis"]) / 1000)
print(f"  cross-whale steps that OVERLAP the previous coda (the crossing, Encounter §7): {overlap}/{len(cross)}")
with open(os.path.join(OUT, "instrument_encounter.tsv"), "w") as f:
    f.write("kind\tsteps\tshape_kept\tmedian_abs_drift_ms\n")
    for name, pr in [("same", same), ("cross", cross), ("null", nullpairs)]:
        n, k, md = stats(pr); f.write(f"{name}\t{n}\t{k}\t{md:.1f}\n")

# ---------------------------------------------------------------- §D SIGN BIRTH / MDL over the lens
print("\n§D  SIGN BIRTH — two-part description length of the EC1 corpus at each lens R (bits)")
ec1 = [c for c in codas if c["clan"] == "EC1" and "NOISE" not in c["type"]]
def L_total(R):
    cls = collections.defaultdict(list)
    for c in ec1: cls[lens(c["icis"], R)].append(c["icis"])
    K = len(cls); model = 0.0; data = 0.0
    for key, members in cls.items():
        n = len(key[1]); cent = [sum(m[i] * 1000 / sum(m) for m in members) / len(members) for i in range(n)]
        model += n * 10                                       # 10 bits per centroid coordinate (per-mille)
        for m in members:
            T = sum(m); data += math.log2(K)                  # which sign
            for i in range(n):                                # residual per interval, per-mille
                r = abs(m[i] * 1000 / T - cent[i]); data += math.log2(1 + 2 * r)
    return K, model, data, model + data
print("R | signs K | model bits | data bits | total bits | bits per coda")
with open(os.path.join(OUT, "instrument_signbirth.tsv"), "w") as f:
    f.write("R\tK\tmodel\tdata\ttotal\n")
    for R in [1, 2, 3, 4, 5, 6, 8, 10, 12, 15, 20, 30, 50, 100]:
        K, mo, da, tot = L_total(R); print(f"{R:3} | {K:5} | {mo:10.0f} | {da:10.0f} | {tot:10.0f} | {tot/len(ec1):6.2f}")
        f.write(f"{R}\t{K}\t{mo:.0f}\t{da:.0f}\t{tot:.0f}\n")

# ---------------------------------------------------------------- §E ZIPF vs LENS
print("\n§E  DECATEGORIFICATION — Zipf slope of class frequencies as a function of the lens")
print("R | classes | slope (log rank vs log freq, OLS) | top-class share")
with open(os.path.join(OUT, "instrument_zipf.tsv"), "w") as f:
    f.write("R\tclasses\tslope\ttop_share\n")
    for R in [2, 3, 5, 10, 20, 50, 100, 1000]:
        cnt = collections.Counter(lens(c["icis"], R) for c in ec1)
        fr = sorted(cnt.values(), reverse=True); xs = [math.log(i+1) for i in range(len(fr))]; ys = [math.log(v) for v in fr]
        mx, my = sum(xs)/len(xs), sum(ys)/len(ys)
        slope = sum((x-mx)*(y-my) for x, y in zip(xs, ys)) / sum((x-mx)**2 for x in xs)
        print(f"{R:4} | {len(fr):5} | {slope:7.3f} | {fr[0]/len(ec1):.3f}"); f.write(f"{R}\t{len(fr)}\t{slope:.4f}\t{fr[0]/len(ec1):.4f}\n")

# ---------------------------------------------------------------- §F LIPSCHITZ
print("\n§F  ONE-LIPSCHITZ CROSSINGS — |Δtempo| per same-whale step, shape kept (ms)")
dr = sorted(abs(sum(b["icis"]) - sum(a["icis"])) for a, b in same if lens(a["icis"]) == lens(b["icis"]))
rel = sorted(abs(sum(b["icis"]) - sum(a["icis"])) / sum(a["icis"]) for a, b in same if lens(a["icis"]) == lens(b["icis"]))
q = lambda xs, p: xs[int(p * (len(xs) - 1))]
print(f"  n {len(dr)}  median {q(dr,.5)}  p90 {q(dr,.9)}  p99 {q(dr,.99)}  max {dr[-1]} ms;  relative: median {q(rel,.5):.3f} p90 {q(rel,.9):.3f} p99 {q(rel,.99):.3f}")

# ---------------------------------------------------------------- HVM4: the prastāra as a superposition
def sup(ts):
    if len(ts) == 1: return ts[0]
    h = len(ts)//2; return f"&L{{{sup(ts[:h])}, {sup(ts[h:])}}}"
n = 4
words = ["".join(w) for w in itertools.product("GL", repeat=n)]      # Piṅgala's 2ⁿ metres of n syllables
def hl(w): return "[" + ", ".join("2" if s == "G" else "1" for s in w) + "]"
real = [pattern(c["icis"]) for c in codas if len(c["icis"]) == n]
top = collections.Counter(real).most_common(3)
lines = ["// Piṅgala's prastāra of the 4-syllable metres (saṅkhyā 2⁴ = 16) handed to the net as ONE",
 "// superposition; each metre carried as its mātrā list (laghu 1, guru 2).  @meru sorts a",
 "// metre into its Meru cell (varṇa, guru) — PrastaraPankti: the guru-count fibre IS C(n,k);",
 "// @matra reads its mātrā (MatraVarnaGuru: mātrā = varṇa + guru).  Collapse enumerates",
 "// every metre with its cell and weight in one pass.",
 "@len   = λ{[]: 0; <>: λh. λt. (1 + @len(t))}",
 "@guru  = λ{[]: 0; <>: λh. λt. ((h - 1) + @guru(t))}",
 "@sum   = λ{[]: 0; <>: λh. λt. (h + @sum(t))}",
 "@meru  = λ&m. #Cell{@len(m), @guru(m), @sum(m)}",
 "@prastara = " + sup([hl(w) for w in words]),
 "@main = @meru(@prastara)"]
open(os.path.join(OUT, "prastara_meru.hvm4"), "w").write("\n".join(lines) + "\n")
lines2 = ["// The same prastāra, with a spec: keep the metres that REAL 4-interval codas use most",
 f"// (the three commonest laghu/guru patterns of 4-interval codas: {[(''.join(p),k) for p,k in top]}).",
 "// Every other metre of the 16 erases: the repertoire as survivors of Piṅgala's enumeration.",
 "@eqL   = λ{[]: λ{[]: 1; <>: λh. λt. 0}; <>: λh. λt. λ{[]: 0; <>: λh2. λt2. λ{0: 0; _: λp. @eqL(t, t2)}((h == h2))}}",
 "@any   = λ&m. " + " .|. ".join(f"@eqL(m, {hl(''.join(p))})" for p, _ in top),
 "@keep  = λ&m. λ{0: &{}; _: λp. #Used{m}}(@any(m))",
 "@prastara = " + sup([hl(w) for w in words]),
 "@main = @keep(@prastara)"]
open(os.path.join(OUT, "prastara_spec.hvm4"), "w").write("\n".join(lines2) + "\n")
print("\nwrote out/prastara_meru.hvm4, out/prastara_spec.hvm4")
