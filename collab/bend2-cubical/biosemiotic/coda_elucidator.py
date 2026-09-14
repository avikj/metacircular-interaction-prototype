#!/usr/bin/env python3
"""The elucidator on real sperm whale codas — compression-is-transport, run on data.

A coda is a click sequence; its inter-click intervals (ICIs) are the object.
Sharma et al. 2024 (Nature Comms 15:3617) factor a coda into two context-free
features: RHYTHM (the ICI vector normalised by total duration; tempo-invariant)
and TEMPO (the total duration).  That is the corpus's elucidator exactly:

    coda  ≃  (tempo, rhythm)         m ≃ (start, shape) in elucidator.bend

with tempo the fibre (which scaling) and rhythm the transport-invariant shape.
Here the factoring is exact in integers: ICIs in milliseconds, tempo = their
sum, and the EXACT shape = ICIs divided by their gcd (the primitive rhythm
vector), so that   coda = gcd * shape   reconstructs on the nose — a Path, not
an approximation.  The per-mille rhythm (Sharma's) is the same shape read
through a lossy lens (rounding); the lossless one is the fibre law's.

Input: DominicaCodas.csv from https://github.com/pratyushasharma/sw-combinatoriality
(Dominica Sperm Whale Project, 2005–2018; 8718 codas, 9 ICI columns, CodaType
= the annotated rhythm class, Clan, Unit).

Outputs (to stdout and to ./out/):
  * exact factorisation of every coda; reconstruction verified for all;
  * collapse statistics: how many distinct exact shapes / per-mille rhythms
    each annotated CodaType has, and how many codas share ONE shape node;
  * coda_superposition.hvm4: a sample of real codas as one superposition,
    factored by the same shape function on the HVM4 net (see RESULTS.txt).
"""
import csv, math, os, sys, collections, functools, random

SRC = sys.argv[1] if len(sys.argv) > 1 else "DominicaCodas.csv"
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "out")
os.makedirs(OUT, exist_ok=True)

def gcd_list(xs):
    return functools.reduce(math.gcd, xs, 0)

def shape_exact(icis):          # primitive rhythm vector: the transport-invariant
    g = gcd_list(icis)
    return g, tuple(x // g for x in icis)

def shape_permille(icis):       # Sharma's rhythm, read through a rounding lens
    T = sum(icis)
    return T, tuple((x * 1000 + T // 2) // T for x in icis)

def from_shape(fibre, shape):   # the inverse transport: reconstruct the coda
    return tuple(fibre * s for s in shape)

rows = []
with open(SRC, encoding="utf-8-sig") as f:
    for r in csv.DictReader(f):
        n = int(r["nClicks"])
        icis = [int(round(float(r[f"ICI{i}"]) * 1000)) for i in range(1, n)]
        if n < 2 or any(x <= 0 for x in icis):
            continue
        rows.append((r["CodaType"], r["Clan"], r["Unit"], n, tuple(icis)))

print(f"codas read: {len(rows)}   (from {SRC})")

# 1. the factoring is an identity: every coda reconstructs from (fibre, shape)
bad = 0
for _, _, _, _, icis in rows:
    g, s = shape_exact(icis)
    if from_shape(g, s) != icis:
        bad += 1
print(f"lossless check  coda == gcd * shape : {len(rows)-bad}/{len(rows)} exact, {bad} failures")

# 2. collapse: distinct shapes per annotated rhythm type
by_type = collections.defaultdict(list)
for t, clan, unit, n, icis in rows:
    by_type[t].append(icis)

print("\nCodaType  n_codas  distinct_exact_shapes  distinct_permille_rhythms  largest_shared_node")
tot_exact = tot_pm = 0
for t, lst in sorted(by_type.items(), key=lambda kv: -len(kv[1])):
    ex = collections.Counter(shape_exact(i)[1] for i in lst)
    pm = collections.Counter(shape_permille(i)[1] for i in lst)
    tot_exact += len(ex); tot_pm += len(pm)
    print(f"{t:9} {len(lst):7} {len(ex):22} {len(pm):26} {max(ex.values()):8}")
print(f"\nTOTAL codas {len(rows)}; exact shape nodes {tot_exact}; per-mille rhythm nodes {tot_pm}; annotated rhythm types {len(by_type)}")


# 2b. THE LENS: at millisecond resolution almost every coda is its own shape node
#     (the exact fibre is near-unique); the collapse into rhythm CLASSES is a
#     quotient by a coarser observation. We read the same data through lenses of
#     decreasing resolution (bins per unit of normalised duration) and count the
#     shape nodes, the largest node, and the purity of nodes w.r.t. the annotated
#     CodaType (EC1 clan, non-noise codas only, as in Sharma et al.'s analysis).
def lens(icis, res):
    T = sum(icis)
    return (len(icis), tuple((x * res + T // 2) // T for x in icis))
ec1 = [(t, i) for t, clan, unit, n, i in rows if clan == "EC1" and "NOISE" not in t]
print(f"\nEC1 non-noise codas: {len(ec1)}; annotated types: {len(set(t for t,_ in ec1))}")
print("lens_res  shape_nodes  max_node  purity(nodes of one annotated type)")
lens_table = []
for res in [1000, 200, 100, 50, 20, 10, 5, 3, 2]:
    nodes = collections.defaultdict(collections.Counter)
    for t, i in ec1:
        nodes[lens(i, res)][t] += 1
    purity = sum(1 for v in nodes.values() if len(v) == 1) / len(nodes)
    mx = max(sum(v.values()) for v in nodes.values())
    lens_table.append((res, len(nodes), mx, purity))
    print(f"{res:8} {len(nodes):12} {mx:9}   {purity:.3f}")
nodes = collections.defaultdict(collections.Counter)
for t, i in ec1:
    nodes[lens(i, 10)][t] += 1
print("largest nodes at lens 10 (shape -> annotated types): the annotated type mixes rhythm with TEMPO")
for k, v in sorted(nodes.items(), key=lambda kv: -sum(kv[1].values()))[:6]:
    print("   ", k, dict(v))
with open(os.path.join(OUT, "lens_resolution.tsv"), "w") as f:
    f.write("lens_res\tshape_nodes\tmax_node\tpurity\n")
    for r in lens_table:
        f.write("\t".join(str(x) for x in r) + "\n")

# 3. tempo is the fibre: within one exact shape, the tempos that occur
shape_to_tempos = collections.defaultdict(list)
for t, clan, unit, n, icis in rows:
    g, s = shape_exact(icis)
    shape_to_tempos[(t, s)].append(sum(icis))
multi = [(k, v) for k, v in shape_to_tempos.items() if len(v) > 1]
print(f"exact shapes carrying >1 coda: {len(multi)}; example fibres (type, shape) -> tempos(ms):")
for k, v in sorted(multi, key=lambda kv: -len(kv[1]))[:6]:
    print("   ", k[0], k[1], "->", sorted(v)[:12], ("..." if len(v) > 12 else ""))

# 4. emit an HVM4 superposition of real codas: the whole sample handed in at once
random.seed(1)
sample_types = ["5R3", "1+1+3", "4R2", "5R1", "3R", "4D"]
picked = []
for t in sample_types:
    lst = [i for i in by_type.get(t, []) if len(i) <= 5]
    picked += [(t, i) for i in random.sample(lst, min(3, len(lst)))]

def hvm_list(xs):
    return "[" + ", ".join(str(x) for x in xs) + "]"

def sup_tree(terms, label="L"):
    if len(terms) == 1:
        return terms[0]
    h = len(terms) // 2
    return f"&{label}{{{sup_tree(terms[:h], label)}, {sup_tree(terms[h:], label)}}}"

lines = ["// REAL sperm whale codas (Dominica Sperm Whale Project, Sharma et al. 2024),",
         "// inter-click intervals in ms, handed to the net as ONE superposition.",
         "// @shape (Sharma's rhythm: ICI per-mille of total duration) commutes over the",
         "// superposition; codas of one rhythm class at different tempos give the SAME",
         "// shape term and the net shares it (DUP-SUP annihilation). Collapse with -C.",
         "//",
         "// sample (CodaType: ICIs ms):"]
for t, i in picked:
    lines.append(f"//   {t}: {list(i)}")
lines += [
 "",
 "@sum   = λ{[]: 0; <>: λh. λt. (h + @sum(t))}",
 "@scale = λ&T. λ{[]: []; <>: λh. λt. (((h * 1000) + (T / 2)) / T) <> @scale(T, t)}",
 "// rhythm = the ICI vector normalised by total duration (tempo-invariant shape)",
 "@shape = λ&c. @scale(@sum(c), c)",
 "// tempo  = the fibre: total duration",
 "@tempo = λc. @sum(c)",
 "// the elucidation: coda ↦ #Coda{tempo, rhythm}, the lossless reading (fibre law)",
 "@elucidate = λ&c. #Coda{@tempo(c), @shape(c)}",
 "",
 "@codas = " + sup_tree([hvm_list(i) for _, i in picked]),
 "",
 "// every coda in the superposition factored in one pass over the shared graph",
 "@main = @elucidate(@codas)",
]
open(os.path.join(OUT, "coda_superposition.hvm4"), "w").write("\n".join(lines) + "\n")

# 5. the shape-only pass: a superposition whose collapse shows the shared nodes
lines2 = ["// Same real codas; only the rhythm (shape) is read. Equal shapes are ONE node.",
          "@sum   = λ{[]: 0; <>: λh. λt. (h + @sum(t))}",
          "@scale = λ&T. λ{[]: []; <>: λh. λt. (((h * 1000) + (T / 2)) / T) <> @scale(T, t)}",
          "@shape = λ&c. @scale(@sum(c), c)",
          "@codas = " + sup_tree([hvm_list(i) for _, i in picked]),
          "@main = @shape(@codas)"]
open(os.path.join(OUT, "coda_shape_only.hvm4"), "w").write("\n".join(lines2) + "\n")

# 6. exact (gcd) factoring for the same sample, with reconstruction check on the net
def hvm_pair(t, i):
    g, s = shape_exact(i)
    return f"#Coda{{{g}, {hvm_list(s)}}}"
lines3 = ["// EXACT factoring: coda = gcd * primitive shape. The net reconstructs each coda",
          "// from its (fibre, shape) pair and compares structurally with the original (===).",
          "// Result 1 on every branch = the factoring is an identity, checked by execution.",
          "@mul  = λ&k. λ{[]: []; <>: λh. λt. (h * k) <> @mul(k, t)}",
          "@from = λ{#Coda: λg. λs. @mul(g, s)}",
          "@check = λ{#Pair: λ&orig. λfac. (@from(fac) === orig)}",
          "@pairs = " + sup_tree([f"#Pair{{{hvm_list(i)}, {hvm_pair(t,i)}}}" for t, i in picked]),
          "@main = @check(@pairs)"]
open(os.path.join(OUT, "coda_exact_roundtrip.hvm4"), "w").write("\n".join(lines3) + "\n")

# 7. write the sample as data for the record
with open(os.path.join(OUT, "sample_codas.tsv"), "w") as f:
    f.write("CodaType\tICIs_ms\ttempo_ms\tgcd\texact_shape\tpermille_rhythm\n")
    for t, i in picked:
        g, s = shape_exact(i); T, pm = shape_permille(i)
        f.write(f"{t}\t{list(i)}\t{T}\t{g}\t{list(s)}\t{list(pm)}\n")
print(f"\nwrote {OUT}/coda_superposition.hvm4, coda_shape_only.hvm4, coda_exact_roundtrip.hvm4, sample_codas.tsv ({len(picked)} real codas)")
