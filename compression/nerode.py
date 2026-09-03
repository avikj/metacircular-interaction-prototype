#!/usr/bin/env python3
"""
nerode.py — the online Nerode quotient machine (DMC), the theory realized.

Not a fixed set of context tables.  A finite-state machine whose STATES ARE
equivalence classes.  It starts minimal (one byte-tree, order-0, no prior) and
REWRITES ITSELF: when a transition is taken often enough and its target state
is shared, the target is CLONED — a dedicated state is split off for that
context, inheriting a scaled share of its parent's counts (transport).  That
is obstruction -> propose -> install: the quotient is refined exactly where the
data presents distinction, and left coarse (shared) where it does not.  This is
the effective quotient computed online — Nerode / state-merging — the
self-rewriting automaton the whole framework describes.

No prior; the machine grows from the data.  Certified lossless; the growth is a
deterministic function of the causal past so the decoder rebuilds the identical
machine — zero model transmitted.
"""
from __future__ import annotations
import sys, struct, zlib, bz2, lzma, math, time

MASK32=(1<<32)-1; K_TOP=1<<24
class REnc:
    def __init__(s): s.low=0;s.range=MASK32;s.cache=0;s.cs=1;s.out=bytearray()
    def _sl(s):
        if s.low<0xFF000000 or s.low>MASK32:
            c=s.cache
            while True:
                s.out.append((c+(s.low>>32))&0xFF);c=0xFF;s.cs-=1
                if s.cs==0:break
            s.cache=(s.low>>24)&0xFF
        s.cs+=1;s.low=(s.low<<8)&MASK32
    def bit(s,p0,b):
        bound=(s.range>>12)*p0
        if b==0:s.range=bound
        else:s.low+=bound;s.range-=bound
        while s.range<K_TOP:s.range=(s.range<<8)&MASK32;s._sl()
    def finish(s):
        for _ in range(5):s._sl()
        return bytes(s.out)
class RDec:
    def __init__(s,d):
        s.d=d;s.p=1;s.range=MASK32;s.code=0
        for _ in range(4):s.code=((s.code<<8)|s._b())&MASK32
    def _b(s):
        v=s.d[s.p] if s.p<len(s.d) else 0;s.p+=1;return v
    def bit(s,p0):
        bound=(s.range>>12)*p0
        if s.code<bound:s.range=bound;b=0
        else:s.code-=bound;s.range-=bound;b=1
        while s.range<K_TOP:s.range=(s.range<<8)&MASK32;s.code=((s.code<<8)|s._b())&MASK32
        return b

CLONE1=2.0        # min count on the taken transition to consider a split
CLONE2=2.0        # min "surplus" in the shared target
class DMC:
    def __init__(s):
        # order-0 byte tree: states 1..255 internal, 256..511 leaves->root(1).
        N=512
        s.n0=[0]*N; s.n1=[0]*N; s.c0=[0.2]*N; s.c1=[0.2]*N
        for st in range(1,256):
            s.n0[st]=2*st; s.n1[st]=2*st+1
        for st in range(256,512):
            s.n0[st]=1; s.n1[st]=1
        s.p=1; s.bitcount=0.0
    def _clone(s,pstate,bit,nx):
        cnt = s.c1[pstate] if bit else s.c0[pstate]
        tot = s.c0[nx]+s.c1[nx]
        if cnt>CLONE1 and tot>cnt+CLONE2:
            r=cnt/tot
            new=len(s.n0)
            s.n0.append(s.n0[nx]); s.n1.append(s.n1[nx])
            c0n=s.c0[nx]*r; c1n=s.c1[nx]*r
            s.c0.append(c0n); s.c1.append(c1n)
            s.c0[nx]-=c0n; s.c1[nx]-=c1n
            if bit: s.n1[pstate]=new
            else:   s.n0[pstate]=new
            return new
        return nx
    def p0_12(s):
        a=s.c0[s.p]; b=s.c1[s.p]; return int(4096.0*a/(a+b))
    def step(s,bit):
        p=s.p
        # code-length accounting (learning curve)
        a=s.c0[p]; b=s.c1[p]; pr=(b/(a+b)) if bit else (a/(a+b))
        s.bitcount+=-math.log2(pr)
        nx = s.n1[p] if bit else s.n0[p]
        nx = s._clone(p,bit,nx)
        if bit: s.c1[p]+=1.0
        else:   s.c0[p]+=1.0
        s.p=nx

def compress(data:bytes)->bytes:
    enc=REnc(); M=DMC()
    for x in data:
        for kb in range(7,-1,-1):
            bit=(x>>kb)&1
            p0=M.p0_12(); p0=1 if p0<1 else(4095 if p0>4095 else p0)
            enc.bit(p0,bit); M.step(bit)
    payload=enc.finish(); arc=b"NERO"+struct.pack("<Q",len(data))+payload
    if decompress(arc)!=data: raise AssertionError("nerode: roundtrip certificate FAILED")
    compress.bits=M.bitcount; compress.states=len(M.n0)
    return arc

def decompress(arc:bytes)->bytes:
    assert arc[:4]==b"NERO"; n,=struct.unpack_from("<Q",arc,4); dec=RDec(arc[12:])
    M=DMC(); out=bytearray()
    for _ in range(n):
        v=1
        for _ in range(8):
            p0=M.p0_12(); p0=1 if p0<1 else(4095 if p0>4095 else p0)
            bit=dec.bit(p0); M.step(bit); v=(v<<1)|bit
        out.append(v&0xFF)
    return bytes(out)

if __name__=="__main__":
    if sys.argv[1:] and sys.argv[1]=="bench":
        for f in sys.argv[2:]:
            d=open(f,"rb").read(); c=compress(d); n=len(d)
            print(f"{f}: {n} -> {len(c)}  {8*len(c)/n:.3f} bpc  states={compress.states}")
    else: print(__doc__)
