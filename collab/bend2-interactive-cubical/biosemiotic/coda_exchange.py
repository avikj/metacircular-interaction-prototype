#!/usr/bin/env python3
"""Rubato as motion of the fibre along an exchange — on the real dialogue file.

sperm-whale-dialogues.csv (Sharma et al. 2024; 3,840 codas, 2014–2018, with
whale ID, recording, onset time TsTo) is the temporally ordered subset. Sharma
et al. define RUBATO as the smooth drift of tempo across consecutive codas of
the same rhythm by the same whale within an exchange. In the corpus's terms an
exchange is an interaction history (README §6, §13): consecutive codas are
states; the shape (rhythm) is what the interaction transports unchanged; the
fibre (tempo) is what moves. Rubato = the fibre's derivative along the braid.

This script measures, on consecutive same-whale codas within 6 s (Sharma's
window): (a) how often the lens-10 shape is preserved; (b) the tempo drift
when it is vs when it is not; and emits out/coda_exchange.hvm4 in which a
superposition of real consecutive pairs is read by one function returning
#Step{shapeKept, driftMs} — the interaction's transport witness per step.
"""
import csv, os, sys, collections, statistics, random
SRC = sys.argv[1] if len(sys.argv) > 1 else "sperm-whale-dialogues.csv"
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "out"); os.makedirs(OUT, exist_ok=True)
rows = []
for r in csv.DictReader(open(SRC, encoding="utf-8-sig")):
    n = int(r["nClicks"]); icis = [int(round(float(r[f"ICI{i}"]) * 1000)) for i in range(1, n)]
    if n < 2 or any(x <= 0 for x in icis): continue
    rows.append((r["REC"][:6], int(float(r["Whale"])), float(r["TsTo"]), tuple(icis)))
def lens(icis, R=10):
    T = sum(icis); return (len(icis), tuple((x * R + T // 2) // T for x in icis))
pairs = []   # consecutive codas by the same whale in the same recording book within 6 s
for i in range(len(rows) - 1):
    for j in range(i + 1, min(i + 5, len(rows))):
        if rows[j][0] == rows[i][0] and rows[j][1] == rows[i][1]:
            if rows[j][2] - rows[i][2] < 6 and abs(len(rows[j][3]) - len(rows[i][3])) < 3:
                pairs.append((rows[i][3], rows[j][3]))
            break
kept = [(a, b) for a, b in pairs if lens(a) == lens(b)]
changed = [(a, b) for a, b in pairs if lens(a) != lens(b)]
def drift(a, b): return sum(b) - sum(a)
print(f"codas: {len(rows)}; consecutive same-whale pairs within 6 s: {len(pairs)}")
print(f"shape (lens 10) preserved across the step: {len(kept)} ({100*len(kept)/len(pairs):.1f}%); changed: {len(changed)}")
for name, s in [("shape kept", kept), ("shape changed", changed)]:
    d = [abs(drift(a, b)) for a, b in s]
    print(f"  |tempo drift| when {name}: median {statistics.median(d):.0f} ms, mean {statistics.mean(d):.0f} ms, n={len(d)}")
# null: same-whale pairs at random (not consecutive)
random.seed(2)
byw = collections.defaultdict(list)
for rec, w, t, c in rows: byw[(rec, w)].append(c)
nk = 0; nd = []
for _ in range(len(pairs)):
    k = random.choice([k for k, v in byw.items() if len(v) > 1]); a, b = random.sample(byw[k], 2)
    nk += lens(a) == lens(b); nd.append(abs(drift(a, b)))
print(f"null (random same-whale pairs): shape equal {100*nk/len(pairs):.1f}%, median |drift| {statistics.median(nd):.0f} ms")
# emit the HVM4 program: 16 real consecutive pairs, half kept, half changed
sample = random.sample(kept, 8) + random.sample(changed, 8)
def hl(xs): return "[" + ", ".join(str(x) for x in xs) + "]"
def sup(ts):
    if len(ts) == 1: return ts[0]
    h = len(ts)//2; return f"&L{{{sup(ts[:h])}, {sup(ts[h:])}}}"
lines = ["// Consecutive codas by ONE whale in a real exchange (sperm-whale-dialogues.csv),",
 "// as a superposition of #Ex{before, after} pairs. @step reads each interaction",
 "// step as its transport witness: #Step{shapeKept, tempoAfter - tempoBefore}.",
 "// shapeKept = 1 : the rhythm (lens 10) crossed the step unchanged and only the",
 "// fibre (tempo) moved — Sharma et al.'s RUBATO as the fibre's motion along the braid.",
 "@sum   = λ{[]: 0; <>: λh. λt. (h + @sum(t))}",
 "@scale = λ&T. λ&R. λ{[]: []; <>: λh. λt. (((h * R) + (T / 2)) / T) <> @scale(T, R, t)}",
 "@lens  = λR. λ&c. @scale(@sum(c), R, c)",
 "// drift carried as a pair (sign, magnitude) since the net's numbers are unsigned",
 "@drift = λ&a. λ&b. λ{0: #Neg{(a - b)}; _: λp. #Pos{(b - a)}}((b >= a))",
 "// list equality by structural recursion (strict), so it reduces under the superposition",
 "@eqL   = λ{[]: λ{[]: 1; <>: λh. λt. 0}; <>: λh. λt. λ{[]: 0; <>: λh2. λt2. λ{0: 0; _: λp. @eqL(t, t2)}((h == h2))}}",
 "@step  = λ{#Ex: λ&a. λ&b. #Step{@eqL(@lens(10, a), @lens(10, b)), @drift(@sum(a), @sum(b))}}",
 "@pairs = " + sup([f"#Ex{{{hl(a)}, {hl(b)}}}" for a, b in sample]),
 "@main  = @step(@pairs)"]
open(os.path.join(OUT, "coda_exchange.hvm4"), "w").write("\n".join(lines) + "\n")
with open(os.path.join(OUT, "exchange_pairs.tsv"), "w") as f:
    f.write("before_ms\tafter_ms\tshape_kept\tdrift_ms\n")
    for a, b in sample: f.write(f"{list(a)}\t{list(b)}\t{int(lens(a)==lens(b))}\t{drift(a,b)}\n")
print("wrote out/coda_exchange.hvm4 with", len(sample), "real consecutive pairs")
