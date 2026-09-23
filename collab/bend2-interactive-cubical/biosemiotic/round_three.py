#!/usr/bin/env python3
"""Round three of instruments, each licensed by a checked term.

  §J  KRAMA (physics/KramaNairapeksya: a total is indifferent to the enumeration, spending
      only assoc and comm).  Every scalar reading of a coda (click count, tempo, mātrā,
      guru count) is such a total, so it is blind to EVERY permutation of the intervals —
      not only reversal (§H).  The Meru cell (n syllables, k gurus) is the permutation
      orbit; C(n,k) is its size.  Measured: within each cell, the entropy of the
      arrangements the whales actually use against log2 C(n,k).  The gap is the information
      that lives in the order and that no total can see.
  §K  SIGN BIRTH, PER SIGN (hieroglyphics II: चिह्नजन्म ⟺ संरचनासंपीडनलाभ > 0).  §8.4 varied the
      lens; here the lens is fixed (metre) and each candidate sign is tested on its own:
      a metre earns a sign iff giving it an entry in the sign table shortens the two-part
      description of the corpus.  Measured: the born inventory, and its relation to the 24
      human type names.
  §L  TWO CLANS AS TWO READINGS (ApurvaIndriyam at the clan level; PariksaDvaya).  The
      Dominica file carries two vocal clans (EC1, EC2).  Is the clan distinction a metre
      distinction, a tempo distinction, or joint?  Measured: I(clan; metre), I(clan; tempo),
      I(clan; both); and inside the shared metre LLLL (the 5R family), whether tempo alone
      separates the clans — and the transport of an EC2 5R3 coda to EC1's LLLL tempo.
  §M  ROUND TRIP ŚEṢA (residue/Ekatva; CompressionIsTransport; Vishvayantra.lossless).
      The lossless recoding a ↦ (f a, fibre point) round-trips exactly; a lens that drops
      the fibre does not, and the residue is exactly what the lens threw away.  Measured on
      every coda: c → lens_R → re-expressed at another whale's tempo → lens_R → back at the
      original tempo, versus c, for R ∈ {10, 100, 1000} and the exact (gcd) shape.  Then
      the same round trip on the net over a superposition of real codas.
"""
import csv, sys, os, collections, math, random, subprocess, itertools
random.seed(11)
SRC_C, SRC_D = sys.argv[1], sys.argv[2]
HVM = os.environ.get("HVM", "hvm")
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
def H(counter):
    N = sum(counter.values()); return -sum(v / N * math.log2(v / N) for v in counter.values())
def MI(pairs):
    a = collections.Counter(x for x, _ in pairs); b = collections.Counter(y for _, y in pairs)
    j = collections.Counter(pairs); return H(a) + H(b) - H(j)
tsv = []

# ---------------------------------------------------------------- §J
print("§J  KRAMA — order inside the Meru cell: what every total is blind to")
cell = collections.defaultdict(collections.Counter)
for c in codas:
    m = metre(c["icis"]); cell[(len(m), m.count('G'))][m] += 1
tot_codas = len(codas); Hcell = H(collections.Counter({k: sum(v.values()) for k, v in cell.items()}))
Harr = sum(sum(v.values()) / tot_codas * H(v) for v in cell.values())
Hmax = sum(sum(v.values()) / tot_codas * math.log2(math.comb(*k)) for k, v in cell.items())
print(f"  H(metre) = H(cell) + H(arrangement | cell) = {Hcell:.3f} + {Harr:.3f} = {Hcell+Harr:.3f} bits; "
      f"krama-indifferent bound on the second term (uniform over C(n,k)): {Hmax:.3f} bits")
print(f"  {'cell (n,k)':>10} {'C(n,k)':>6} {'codas':>6} {'used':>5} {'H(arr)':>7} {'log2C':>6}  top arrangements")
for k, v in sorted(cell.items(), key=lambda kv: -sum(kv[1].values()))[:12]:
    n = sum(v.values()); C = math.comb(*k)
    top = ", ".join(f"{m} {c}" for m, c in v.most_common(4))
    print(f"  {str(k):>10} {C:>6} {n:>6} {len(v):>5} {H(v):>7.3f} {math.log2(C):>6.3f}  {top}")
    tsv.append(("J_cell", k[0], k[1], C, n, len(v), round(H(v), 3), round(math.log2(C), 3)))
# the totals, explicitly: fraction of coda pairs with equal (n, k) but different metre
same_cell_diff = sum(1 for v in cell.values() for a in v for b in v if a != b)

# ---------------------------------------------------------------- §K
print("\n§K  SIGN BIRTH PER SIGN — which metres earn an entry in the sign table")
mc = collections.Counter(metre(c["icis"]) for c in codas); N = sum(mc.values())
def spell_bits(m): return 2 * math.log2(len(m) + 1) + len(m)      # Elias-ish length + one bit per syllable
def total_bits(S):
    # two-part code: table (spelling of each sign) + per coda: escape-flag + (index in table | spelling)
    nS = sum(mc[m] for m in S); nE = N - nS
    table = sum(spell_bits(m) for m in S)
    flag = 0.0
    for n_ in (nS, nE):
        if n_: flag -= n_ * math.log2(n_ / N)
    body = sum(-mc[m] * math.log2(mc[m] / nS) for m in S) if nS else 0.0
    body += sum(mc[m] * spell_bits(m) for m in mc if m not in S)
    return table + flag + body
S = set(); cur = total_bits(S)
cands = sorted(mc, key=lambda m: -mc[m])
born = []
while True:
    best = None
    for m in cands:
        if m in S: continue
        b = total_bits(S | {m})
        if best is None or b < best[0]: best = (b, m)
    if best is None or best[0] >= cur: break
    S.add(best[1]); born.append((best[1], mc[best[1]], cur - best[0])); cur = best[0]
print(f"  metres {len(mc)}; corpus {N} codas; no signs: {total_bits(set()):.0f} bits; born signs {len(S)}: {cur:.0f} bits ({cur/N:.2f} per coda)")
print(f"  last born sign: {born[-1][0]} ({born[-1][1]} codas, gain {born[-1][2]:.1f} bits); first refused: "
      + (lambda m: f"{m} ({mc[m]} codas, gain {cur - total_bits(S | {m}):.1f})")(max((m for m in mc if m not in S), key=lambda m: mc[m])))
typ_m = collections.defaultdict(collections.Counter)
for c in codas: typ_m[c["type"]][metre(c["icis"])] += 1
named_metres = {}
for t, v in typ_m.items():
    m, k = v.most_common(1)[0]
    if k / sum(v.values()) >= 0.5 and not t.endswith("NOISE"): named_metres.setdefault(m, []).append(t)
print(f"  human types with a majority metre: {sum(len(v) for v in named_metres.values())}; their distinct metres: {len(named_metres)}; "
      f"of these born: {sum(1 for m in named_metres if m in S)}")
print(f"  born signs with no human type name: {sum(1 for m in S if m not in named_metres)}  e.g. "
      + ", ".join(f"{m} ({mc[m]})" for m in sorted(S, key=lambda m: -mc[m]) if m not in named_metres)[:200])
for m, n, g in born: tsv.append(("K_born", m, n, round(g, 1), ";".join(named_metres.get(m, []))))
print("  born inventory (metre, codas, gain in bits, human names):")
for m, n, g in born: print(f"    {m:<10} {n:>5} {g:>8.1f}  {' '.join(named_metres.get(m, []))}")

# ---------------------------------------------------------------- §L
print("\n§L  TWO CLANS AS TWO READINGS — EC1 vs EC2")
cl = [(c["clan"], metre(c["icis"]), tempo_bin(c["icis"]), c["type"]) for c in codas]
Hclan = H(collections.Counter(x[0] for x in cl))
for name, f in [("metre", lambda x: x[1]), ("tempo bin", lambda x: x[2]), ("metre × tempo", lambda x: (x[1], x[2])),
                ("click count", lambda x: len(x[1])), ("human type", lambda x: x[3])]:
    mi = MI([(x[0], f(x)) for x in cl]); print(f"  I(clan; {name:<14}) = {mi:.3f} bits of H(clan) = {Hclan:.3f}")
    tsv.append(("L_MI", name, round(mi, 3), round(Hclan, 3)))
ll = [x for x in cl if x[1] == "LLLL"]
print(f"  inside metre LLLL ({len(ll)} codas): EC1 {sum(1 for x in ll if x[0]=='EC1')}, EC2 {sum(1 for x in ll if x[0]=='EC2')}; "
      f"I(clan; tempo | LLLL) = {MI([(x[0], x[2]) for x in ll]):.3f} of H(clan | LLLL) = {H(collections.Counter(x[0] for x in ll)):.3f}")
for clan in ("EC1", "EC2"):
    tb = collections.Counter(x[2] for x in ll if x[0] == clan)
    print(f"    {clan} LLLL tempo bins: " + " ".join(f"{b}:{tb[b]}" for b in range(5))
          + "   types: " + ", ".join(f"{t} {n}" for t, n in collections.Counter(x[3] for x in ll if x[0]==clan).most_common(3)))
# the metres exclusive to a clan (with at least 10 codas)
by_clan = collections.defaultdict(collections.Counter)
for x in cl: by_clan[x[1]][x[0]] += 1
excl = {c: [m for m, v in by_clan.items() if sum(v.values()) >= 10 and v[c] == sum(v.values())] for c in ("EC1", "EC2")}
print(f"  metres (≥10 codas) heard only in EC1: {len(excl['EC1'])}; only in EC2: {len(excl['EC2'])} {excl['EC2']}")
# transport: an EC2 5R3 coda to EC1's median LLLL tempo
def median(xs): xs = sorted(xs); return xs[len(xs) // 2]
T1 = median([sum(c["icis"]) for c in codas if c["clan"] == "EC1" and metre(c["icis"]) == "LLLL"])
T2 = median([sum(c["icis"]) for c in codas if c["clan"] == "EC2" and metre(c["icis"]) == "LLLL"])
print(f"  median LLLL tempo: EC1 {T1} ms, EC2 {T2} ms (ratio {T2/T1:.2f})")
ex = next(c for c in codas if c["clan"] == "EC2" and c["type"] == "5R3")
s = [round(x * 1000 / sum(ex["icis"])) for x in ex["icis"]]
tr = [round(x * T1 / 1000) for x in s]
near = min((c for c in codas if c["clan"] == "EC1" and metre(c["icis"]) == "LLLL"), key=lambda c: sum(abs(a - b) for a, b in zip(c["icis"], tr)))
print(f"  EC2 5R3 {list(ex['icis'])} → shape {s} → at EC1 tempo {tr}; nearest real EC1 coda {list(near['icis'])} is a {near['type']}")

# ---------------------------------------------------------------- §M
print("\n§M  ROUND TRIP ŚEṢA — c → lens → other tempo → lens → own tempo, versus c")
def lens(i, R): T = sum(i); return [(x * R + T // 2) // T for x in i]
def shape_exact(i): g = math.gcd(*i); return [x // g for x in i]
def from_shape(s, T): S = sum(s); return [(x * T + S // 2) // S for x in s]
others = [sum(c["icis"]) for c in codas]
rows = []
for R in (10, 100, 1000, "exact"):
    resid = collections.Counter(); tot = 0
    for c in codas:
        i = c["icis"]; T = sum(i); TB = random.choice(others)
        L = (lambda x: shape_exact(x)) if R == "exact" else (lambda x: lens(x, R))
        back = from_shape(L(from_shape(L(i), TB)), T)
        d = sum(abs(a - b) for a, b in zip(i, back)); resid[d == 0] += 1; tot += d
    frac = resid[True] / len(codas)
    print(f"  lens {str(R):>5}: round trip exact on {resid[True]}/{len(codas)} ({100*frac:.1f}%); mean |śeṣa| {tot/len(codas):.2f} ms per coda")
    tsv.append(("M_roundtrip", R, resid[True], len(codas), round(tot / len(codas), 2)))
# on the net: 18 real codas in one superposition, R = 1000, each sent to the next one's tempo and back
sample = [c["icis"] for c in codas[:18]]
def hl(x): return "[" + ", ".join(str(v) for v in x) + "]"
def sup(xs): return xs[0] if len(xs) == 1 else f"&L{{{xs[0]}, {sup(xs[1:])}}}"
prog = ["// round trip through another whale's tempo, on a superposition of 18 real codas (R = 1000)",
        "@sum   = λ{[]: 0; <>: λh. λt. (h + @sum(t))}",
        "@scale = λ&T. λ&R. λ{[]: []; <>: λh. λt. (((h * R) + (T / 2)) / T) <> @scale(T, R, t)}",
        "@lens  = λR. λ&c. @scale(@sum(c), R, c)",
        "@mulT  = λ&T. λ{[]: []; <>: λh. λt. (((h * T) + 500) / 1000) <> @mulT(T, t)}",
        "@ad    = λ&a. λ&b. λ{0: (b - a); _: λp. (a - b)}(a > b)",
        "@sesa  = λ{[]: λq. 0; <>: λh. λt. λ{[]: 0; <>: λk. λu. (@ad(h, k) + @sesa(t, u))}}",
        "@rt    = λ&c. λTB. @mulT(@sum(c), @lens(1000, @mulT(TB, @lens(1000, c))))",
        "@trip  = λ&c. λTB. #Trip{@sesa(c, @rt(c, TB)), c}",
        "@pairs = " + sup([f"@trip({hl(c)}, {sum(sample[(k+1) % len(sample)])})" for k, c in enumerate(sample)]),
        "@main  = @pairs"]
open(os.path.join(OUT, "coda_roundtrip.hvm4"), "w").write("\n".join(prog) + "\n")
p = subprocess.run([HVM, os.path.join(OUT, "coda_roundtrip.hvm4"), "-s", "-C40"], capture_output=True, text=True)
lines = [l for l in p.stdout.splitlines() if l.startswith("#Trip")]
print(f"  on the net (out/coda_roundtrip.hvm4): {len(lines)} trips collapsed; " +
      [l for l in p.stdout.splitlines() if "Itrs" in l][0].strip())
for l in lines[:6]: print("    " + l)
print("    …")
open(os.path.join(OUT, "roundtrip_run.log"), "w").write(p.stdout + p.stderr)
with open(os.path.join(OUT, "instrument_round_three.tsv"), "w") as f:
    for r in tsv: f.write("\t".join(str(x) for x in r) + "\n")
