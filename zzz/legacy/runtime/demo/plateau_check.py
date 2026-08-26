"""The check STATUS.md admits was never run: is the plateau in the object
or in the observable?  Same runs, several observables of the same derivations."""
import sys; sys.path.insert(0,'/home/user/math')
from runtime.generate.loop import normalize, BENCHMARK, BENCHMARK2, Config
from runtime.crystallize.derivation import Counter
from runtime.demo.vocabulary_demo import B3, B4
from runtime.vocabulary import VocabularyOrganism, VocabConfig

def observe(book, index, target):
    ctr = Counter()
    d,_ = normalize(target, lemmas=tuple(book.lemmas) if book else (),
                    ctr=ctr, name="obs", index=index)
    rules  = [s.rule for s in d.steps]
    lemmas = [s.lemma_id for s in d.steps if s.lemma_id]
    return dict(steps=ctr.steps, work=ctr.work,
                rules=len(set(rules)), fires=len(lemmas),
                path=tuple(rules),                       # the actual route
                terms=len({repr(s.after) for s in d.steps}),
                answer=repr(d.result))

R=8
o = VocabularyOrganism(Config(rounds=R), VocabConfig(mode="self"))
BENCH=(("B1",BENCHMARK),("B2",BENCHMARK2),("B3",B3),("B4",B4))
hist={n:[] for n,_ in BENCH}
for r in range(R):
    o.round(r)
    for n,t in BENCH: hist[n].append(observe(o.book,o.index,t))

print(f"{'':4} {'round':>5} {'steps':>6} {'work':>8} {'#rules':>7} {'fires':>6} "
      f"{'#terms':>7}  route-changed")
for n,_ in BENCH:
    rows=hist[n]
    for r,h in enumerate(rows):
        changed = "" if r==0 else ("YES" if h['path']!=rows[r-1]['path'] else "no")
        print(f"{n if r==0 else '':4} {r:>5} {h['steps']:>6} {h['work']:>8} "
              f"{h['rules']:>7} {h['fires']:>6} {h['terms']:>7}  {changed}")
    st={h['steps'] for h in rows}; pa={h['path'] for h in rows}
    wk={h['work'] for h in rows}; tm={h['terms'] for h in rows}
    ans={h['answer'] for h in rows}
    print(f"     distinct across rounds -> steps:{len(st)}  work:{len(wk)}  "
          f"routes:{len(pa)}  term-counts:{len(tm)}  answers:{len(ans)}")
    verdict = ("OBSERVABLE (steps flat, route moved)" if len(st)==1 and len(pa)>1
               else "OBJECT (route flat too)" if len(st)==1 and len(pa)==1
               else "steps moved")
    print(f"     verdict: {verdict}\n")
