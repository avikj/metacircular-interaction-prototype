# Hand-written HVM4 for the light benchmark with FLAT constructors: one #C per
# cell, bare #TF/#TG/#HD actions.  "peano" keeps the emitter's #Suc/#Zer naturals;
# "native" uses HVM4 numbers.  Run: python3 gen.py && for f in flat_*.hvm4; do hvm $f -S -s; done
def nat(n): return "#Zer" if n == 0 else "#Suc{%s}" % nat(n-1)
def cell(i, enc):
    tf, tg, rp, hd = i % 3 + 1, (i * 2) % 4, i % 2, i % 5
    if enc == "peano": return "#C{%s, %s, %s, %s}" % (nat(tf), nat(tg), nat(rp), nat(hd))
    return "#C{%d, %d, %d, %d}" % (tf, tg, rp, hd)
def sup(items, depth=0):
    if len(items) == 1: return items[0]
    h = len(items) // 2
    return "&L%d{%s, %s}" % (depth, sup(items[:h], depth+1), sup(items[h:], depth+1))
def lst(items):
    s = "#Nil"
    for it in reversed(items): s = "#Con{%s, %s}" % (it, s)
    return s
prog_peano = """@add = λa. λb. λ{#Zer: λy. y; #Suc: λp. λy. #Suc{@add(p)(y)}}(a)(b)
@zero = #Zer
"""
prog_native = """@add = λa. λb. (a + b)
@zero = 0
"""
common = """@step = λc. λa. λ{#TF: λ{#C: λtf. λtg. λrp. λhd. #C{@zero, @add(tf)(tg), rp, hd}}; #TG: λ{#C: λtf. λtg. λrp. λhd. #C{tf, @zero, @add(tg)(rp), hd}}; #HD: λ{#C: λtf. λtg. λrp. λhd. #C{tf, tg, rp, @zero}}}(a)(c)
@observe = λ{#C: λtf. λtg. λrp. λhd. rp}
@perturb = λc. λw. λ{#Nil: λc2. c2; #Con: λa. λrest. λc2. @perturb(@step(c2)(a))(rest)}(w)(c)
@word = #Con{#TF, #Con{#TG, #Con{#HD, #Con{#TF, #Con{#TG, #Con{#TF, #Con{#TG, #Con{#HD, #Nil}}}}}}}}
@prog = λc. @observe(@perturb(c)(@word))
@mapProg = λ{#Nil: #Nil; #Con: λc. λrest. #Con{@prog(c), @mapProg(rest)}}
"""
for enc, pre in [("peano", prog_peano), ("native", prog_native)]:
    for N in [1, 2, 4, 8, 16, 32]:
        cells = [cell(i, enc) for i in range(N)]
        open("flat_%s_list_%d.hvm4" % (enc, N), "w").write(pre + common + "@main = @mapProg(%s)\n" % lst(cells))
        open("flat_%s_supin_%d.hvm4" % (enc, N), "w").write(pre + common + "@main = @prog(%s)\n" % sup(cells))
