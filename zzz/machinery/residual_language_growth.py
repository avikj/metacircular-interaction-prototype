"""A residual-derived macro changes the next cost-bounded action language.

The carrier is Q^3.  P projects to e0, A maps e0,e1 to e1, and D maps
e1 to e2. Matrix multiplication represents sequential action:
the rightmost operator acts first.
"""
from fractions import Fraction as F
from machinery.qap_informative_macro import M, eye, sub, mul, compile_macro

ZERO = M([[0,0,0],[0,0,0],[0,0,0]])
P = M([[1,0,0],[0,0,0],[0,0,0]])
A = M([[0,0,0],[1,1,0],[0,0,0]])
D = M([[0,0,0],[0,0,0],[0,1,0]])


def key(a): return tuple(tuple(r) for r in a)


def bounded_actions(generators, budget):
    """All matrices denoted by nonempty words of declared generator cost."""
    reached={}
    frontier=[(g, c, name) for name,g,c in generators]
    while frontier:
        x,c,w=frontier.pop()
        if c>budget: continue
        k=key(x)
        if k not in reached or c<reached[k][0]: reached[k]=(c,w)
        for name,g,d in generators:
            if c+d<=budget: frontier.append((mul(g,x),c+d,name+w))
    return reached


def run_cycle():
    q=sub(eye(3),P)
    first=compile_macro(P,A)              # M1 = AP = PAP + B1C1
    m1=first["body"]
    primitives=(("A",A,1),("D",D,1),("P",P,1))
    before=bounded_actions(primitives,2)
    after=bounded_actions(primitives+(("M",m1,1),),2)
    next_action=mul(D,m1)                 # D(AP) = DAP
    next_residual=mul(mul(q,D),m1)        # Q D M1
    second=compile_macro(P,mul(D,m1))     # treats next action as future operator
    return {"first":first,"before":before,"after":after,
            "next_action":next_action,"next_residual":next_residual,
           "second":second,"primitives":primitives}


if __name__ == "__main__":
    z=run_cycle()
    print({"before":len(z["before"]),"after":len(z["after"]),
           "next_word":z["after"][key(z["next_action"])],
           "second_rank":len(z["second"]["B"][0])})
