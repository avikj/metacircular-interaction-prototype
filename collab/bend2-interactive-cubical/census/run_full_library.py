import os, re, json, subprocess, sys, time
CUB="/home/user/metacircular-interaction-prototype/formal/cubical"
SCR="/tmp/claude-0/-home-user-metacircular-interaction-prototype/98a59276-66db-5e22-b339-f55edeeecf29/scratchpad"
os.chdir(CUB)
mods=json.load(open(f"{SCR}/allmods.json"))
machinery=open(f"{SCR}/machinery.txt").read()
MASTER=f"{SCR}/master_graph.tsv"
LOG=f"{SCR}/run_full.log"
done_names=set()
if os.path.exists(MASTER):
    for l in open(MASTER):
        done_names.add(l.split("\t",1)[0])
env=dict(os.environ, LC_ALL="C.UTF-8", LANG="C.UTF-8")

def log(m):
    open(LOG,"a").write(f"[{time.strftime('%H:%M:%S')}] {m}\n")

def emit_batch(batch, tag):
    # batch: list of (modname, names). returns list of scraped tsv lines or None on failure.
    hdr="{-# OPTIONS --cubical --guardedness #-}\nmodule CensusB where\n"
    hdr+="open import Agda.Builtin.Reflection\nopen import Agda.Builtin.List\nopen import Agda.Builtin.String\nopen import Agda.Builtin.Nat\nopen import Agda.Builtin.Unit\n"
    imps="".join(f"import {m} as B{i}\n" for i,(m,_) in enumerate(batch))
    qs=[]
    for i,(m,nn) in enumerate(batch):
        for n in nn: qs.append(f"B{i}.{n}")
    if not qs: return []
    namelist="  ( " + "\n  ∷ ".join("quote "+q for q in qs) + "\n  ∷ [] )"
    macro='\nmacro\n  emitGraph : List Name -> Term -> TC ⊤\n  emitGraph ns _ = bindTC (joinAll ns "") λ s -> typeError (strErr "GRAPH_BEGIN\\n" ∷ strErr s ∷ strErr "GRAPH_END" ∷ [])\n'
    src=hdr+imps+"\n"+machinery+macro+"\n_g_ : ⊤\n_g_ = emitGraph\n"+namelist+"\n"
    open("CensusB.agda","w",encoding="utf-8").write(src)
    try:
        r=subprocess.run(["agda","CensusB.agda"],env=env,capture_output=True,text=True,timeout=900)
        out=r.stdout+r.stderr
    except subprocess.TimeoutExpired:
        return None
    if "GRAPH_BEGIN" not in out:
        return None
    body=out.split("GRAPH_BEGIN",1)[1].split("GRAPH_END",1)[0].strip("\n")
    return [l for l in body.split("\n") if "\t" in l]

def process(batch, depth=0):
    # filter already-done modules' names not needed; try, split on failure
    tag=f"d{depth}n{len(batch)}"
    res=emit_batch(batch, tag)
    if res is not None:
        newlines=[l for l in res if l.split("\t",1)[0] not in done_names]
        with open(MASTER,"a") as f:
            for l in newlines:
                f.write(l+"\n"); done_names.add(l.split("\t",1)[0])
        log(f"OK batch {len(batch)} mods -> +{len(newlines)} decls (total {len(done_names)})")
        return
    if len(batch)==1:
        log(f"FAIL module {batch[0][0]} (skipped)")
        return
    mid=len(batch)//2
    process(batch[:mid], depth+1)
    process(batch[mid:], depth+1)

BATCH=25
# skip modules whose names are all already done
todo=[(m,nn) for (m,nn) in mods if any((f"{m.split('.')[-1]}" or True) for n in nn)]
log(f"START full run: {len(mods)} modules, {sum(len(n) for _,n in mods)} names")
for i in range(0, len(mods), BATCH):
    process(mods[i:i+BATCH])
    log(f"progress: {i+BATCH}/{len(mods)} modules scanned, {len(done_names)} decls captured")
log(f"DONE: {len(done_names)} declarations in master_graph.tsv")
print("done")
