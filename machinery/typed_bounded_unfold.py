"""Unary typed terms: definitional unfolding changes bounded denotation."""
from dataclasses import dataclass
from machinery.qap_informative_macro import eye, mul
from machinery.residual_language_growth import A,D,P,key


@dataclass(frozen=True)
class Var: pass

@dataclass(frozen=True)
class App:
    head: str
    arg: object


def subst(body, arg):
    return arg if isinstance(body,Var) else App(body.head,subst(body.arg,arg))


def unfold(t, definitions):
    if isinstance(t,Var): return t
    a=unfold(t.arg,definitions)
    return unfold(subst(definitions[t.head],a),definitions) if t.head in definitions else App(t.head,a)


def size(t): return 0 if isinstance(t,Var) else 1+size(t.arg)


def denote(t, interpretation):
    if isinstance(t,Var): return eye(3)
    return mul(interpretation[t.head],denote(t.arg,interpretation))


BASE={"A":A,"D":D,"P":P}
BODY=App("A",App("P",Var()))             # M(x) := A(P(x))


def terms(heads,budget):
    out={Var()}
    for _ in range(budget):
        out |= {App(h,t) for h in heads for t in tuple(out) if size(t)<budget}
    return {t for t in out if size(t)<=budget}


def denotation_language(heads,budget,interpretation):
    return {key(denote(t,interpretation)) for t in terms(heads,budget)}

