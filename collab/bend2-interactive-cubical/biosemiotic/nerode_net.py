#!/usr/bin/env python3
"""A Nerode acceptor LEARNED from half the whale dialogues and RUN on the net over a
superposition of held-out per-whale class sequences (NerodeYantra / MyhillNerodeMinimalMachine).
The acceptor's states are the lens-10 classes seen; its transitions are the class pairs that
occur in the training half.  A held-out sequence survives iff every one of its transitions is in
the learned support; the rest erase.  What survives measures how much of the whales' sequential
structure a first-order (k = 1) Nerode machine holds — the set-valued shadow of §B.
"""
import csv, sys, os, collections, random, subprocess, re
random.seed(11)
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
rows = []
for r in csv.DictReader(open(sys.argv[1], encoding="utf-8-sig")):
    n = int(r["nClicks"]); icis = [int(round(float(r[f"ICI{i}"]) * 1000)) for i in range(1, n)]
    if n < 2 or any(x <= 0 for x in icis): continue
    rows.append(dict(rec=r["REC"][:6], whale=int(float(r["Whale"])), t=float(r["TsTo"]), icis=tuple(icis)))
def lens(i, R=10):
    T = sum(i); return (len(i), tuple((x * R + T // 2) // T for x in i))
seqs = collections.defaultdict(list)
for c in sorted(rows, key=lambda c: (c["rec"], c["t"])): seqs[(c["rec"], c["whale"])].append(lens(c["icis"]))
keys = list(seqs); random.shuffle(keys); half = len(keys) // 2
train, test = keys[:half], keys[half:]
ids = {}
def cid(x):
    if x not in ids: ids[x] = len(ids) + 1
    return ids[x]
support = set()
for k in train:
    s = [cid(x) for x in seqs[k]]
    support |= {(a, b) for a, b in zip(s, s[1:])}
tests = [[cid(x) for x in seqs[k]] for k in test if 3 <= len(seqs[k]) <= 8]
random.shuffle(tests); tests = tests[:24]
def accepted(s): return all((a, b) in support for a, b in zip(s, s[1:]))
py = [accepted(s) for s in tests]
print(f"classes {len(ids)}; training transitions in support {len(support)}; held-out sequences run {len(tests)}; python says accepted {sum(py)}")
# emit: the support as a numeric switch on (a*1000+b)
def sup(ts):
    if len(ts) == 1: return ts[0]
    h = len(ts)//2; return f"&L{{{sup(ts[:h])}, {sup(ts[h:])}}}"
keys_ = sorted(a * 1000 + b for a, b in support)
lines = ["// Nerode acceptor learned from half the whale dialogues, run over a superposition of",
 "// held-out per-whale class sequences.  @ok = the learned transition support (a numeric",
 "// switch on a*1000+b); @acc walks a sequence; a sequence whose every step is in the support",
 "// survives as #Accepted{seq}; any other erases.  Survivors = what a k=1 Nerode machine holds.",
 "@ok = λ{ " + "; ".join(f"{k}: 1" for k in keys_) + "; _: λp. 0 }",
 "@acc = λ&prev. λ{[]: 1; <>: λ&h. λt. λ{0: 0; _: λp. @acc(h, t)}(@ok((prev * 1000) + h))}",
 "@run = λ{[]: 1; <>: λ&h. λt. @acc(h, t)}",
 "@keep = λ&s. λ{0: &{}; _: λp. #Accepted{s}}(@run(s))",
 "@seqs = " + sup(["[" + ", ".join(map(str, s)) + "]" for s in tests]),
 "@main = @keep(@seqs)"]
open(os.path.join(OUT, "nerode_acceptor.hvm4"), "w").write("\n".join(lines) + "\n")
p = subprocess.run([os.environ.get("HVM", "hvm"), os.path.join(OUT, "nerode_acceptor.hvm4"), "-s", "-C40"], capture_output=True, text=True)
out = re.sub(r"\x1b\[[0-9;]*m", "", p.stdout + p.stderr)
acc = out.count("#Accepted"); it = re.search(r"Itrs:\s+(\d+)", out)
print(f"net says accepted {acc}; interactions {it.group(1) if it else '?'}; agreement with python: {acc == sum(py)}")
print(out[:1500])
with open(os.path.join(OUT, "instrument_nerode_net.log"), "w") as f: f.write(out)
