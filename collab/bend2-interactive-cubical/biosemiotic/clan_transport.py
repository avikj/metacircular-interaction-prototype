#!/usr/bin/env python3
"""Dialect translation on the net (§8.13 executed as search inside evaluation).

EC2's 5R3 codas and EC1's 5R1 codas share the metre LLLL and differ in tempo by 3.4x.
Program: superpose real EC2 5R3 codas; transport each along the fibre to EC1's median 5R1
tempo (fibre law: shape kept, tempo replaced); keep only those whose transported form lies
within ε of a real EC1 5R1 coda, interval by interval; erase the rest.  What survives is the
translation, certified inside the evaluation; each survivor is printed beside its source.
"""
import csv, sys, os, subprocess, math
SRC_C = sys.argv[1]; HVM = os.environ.get("HVM", "hvm")
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
rows = []
for r in csv.DictReader(open(SRC_C, encoding="utf-8-sig")):
    n = int(r["nClicks"]); icis = [int(round(float(r[f"ICI{i}"]) * 1000)) for i in range(1, n)]
    if n < 2 or any(x <= 0 for x in icis): continue
    rows.append((r["Clan"], r["CodaType"], tuple(icis)))
def median(xs): xs = sorted(xs); return xs[len(xs) // 2]
ec1 = [i for c, t, i in rows if c == "EC1" and t == "5R1"]
ec2 = [i for c, t, i in rows if c == "EC2" and t == "5R3"]
T1 = median([sum(i) for i in ec1])
ref = [median([i[k] for i in ec1]) for k in range(4)]
src = ec2[:24]; EPS = 6
def hl(x): return "[" + ", ".join(str(v) for v in x) + "]"
def sup(xs): return xs[0] if len(xs) == 1 else f"&L{{{xs[0]}, {sup(xs[1:])}}}"
prog = [f"// EC2 5R3 → EC1 5R1 by transport along the fibre; EC1 median 5R1 tempo {T1} ms, median intervals {ref}; ε = {EPS} ms",
        "@sum   = λ{[]: 0; <>: λh. λt. (h + @sum(t))}",
        "@scale = λ&T. λ&R. λ{[]: []; <>: λh. λt. (((h * R) + (T / 2)) / T) <> @scale(T, R, t)}",
        "@lens  = λR. λ&c. @scale(@sum(c), R, c)",
        "@mulT  = λ&T. λ{[]: []; <>: λh. λt. (((h * T) + 500) / 1000) <> @mulT(T, t)}",
        f"@toEC1 = λc. @mulT({T1}, @lens(1000, c))",
        "@ad    = λ&a. λ&b. λ{0: (b - a); _: λp. (a - b)}(a > b)",
        "@near  = λ{[]: λq. 1; <>: λh. λt. λ{[]: 0; <>: λk. λu. (@near(t, u) .&. (@ad(h, k) < " + str(EPS + 1) + "))}}",
        "@keep  = λ&c. λ{0: &{}; _: λp. #Translated{c, @toEC1(c)}}(@near(@toEC1(c), " + hl(ref) + "))",
        "@src   = " + sup([hl(c) for c in src]),
        "@main  = @keep(@src)"]
open(os.path.join(OUT, "coda_clan_transport.hvm4"), "w").write("\n".join(prog) + "\n")
p = subprocess.run([HVM, os.path.join(OUT, "coda_clan_transport.hvm4"), "-s", "-C40"], capture_output=True, text=True)
surv = [l for l in p.stdout.splitlines() if l.startswith("#Translated")]
print(f"EC2 5R3 sources superposed: {len(src)}; EC1 median 5R1 tempo {T1} ms, median intervals {ref}, ε = {EPS} ms")
print(f"survivors (transported form within ε of EC1's median 5R1, certified inside the evaluation): {len(surv)}")
for l in surv: print("  " + l)
print("  " + [l for l in p.stdout.splitlines() if "Itrs" in l][0].strip())
# the same test in Python over ALL EC2 5R3 codas, for the rate
ok = 0
for c in ec2:
    s = [(x * 1000 + sum(c) // 2) // sum(c) for x in c]; t = [(x * T1 + 500) // 1000 for x in s]
    ok += all(abs(a - b) <= EPS for a, b in zip(t, ref))
print(f"over all {len(ec2)} EC2 5R3 codas: {ok} ({100*ok/len(ec2):.1f}%) land within ε of EC1's median 5R1 when transported;"
      f" EC1's own 5R1 codas within ε of their median: {sum(all(abs(a-b)<=EPS for a,b in zip(i,ref)) for i in ec1)} of {len(ec1)} ({100*sum(all(abs(a-b)<=EPS for a,b in zip(i,ref)) for i in ec1)/len(ec1):.1f}%)")
open(os.path.join(OUT, "clan_transport_run.log"), "w").write(p.stdout + p.stderr)
