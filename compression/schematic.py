#!/usr/bin/env python3
"""
schematic.py — the SchematicOperation as a codec: rules that PERVADE.

Fixes the error the kernel names in
`TheInstalledOperationHasNoPervasionSoTheKernelMemorises`:

  §1  a GROUND install — control `t ≡ lhs` — fires at one term: a single
      key/value pair, "the kernel is a lookup table."  generative.py's
      productions N→(a,b) are exactly this: memorisation.
  §3  a SCHEMATIC install — control carrying a SUBSTITUTION WITNESS —
      fires at EVERY instance of a schema with a variable slot: one rule
      covers a Tm-indexed family.  "GENERALISATION IS FREE ... MEMORISATION
      IS WHAT COSTS."
  §4  the substitution witness (which filler) MUST be kept: it is the fibre
      over the emission, and collapsing it is the loss the carrier law
      prices — `advance` refuses to dedupe.  So the filler is CODED, never
      scored away.

So here a production is a SCHEMA with one hole:   a · x · b   (fixed a, b;
x the variable).  It fires wherever `a`, then anything, then `b` occurs.
The schema is installed ONCE and pervades every filler; the filler x is the
fibre, emitted per occurrence.  The law (a,b) is learned once and applies to
unboundedly many x — the letter of §3.

Acceptance is laghava (MDL): a schema occurring k times over distinct-enough
fillers turns each `a x b` (3 symbols) into `S x` (2 symbols) — saves k, less
the one 2-symbol schema.  Install iff that is positive; halt at the plateau.
weights ⇒ traces: schema induction is a deterministic function of the causal
data, regrown on decode; zero grammar transmitted.  Lossless: S expands to
`a x b` exactly, checked by re-decode.

Nothing scores the enabled list (kernel's prohibition): the filler is coded
by an adaptive order-1 measure used only to order the arithmetic code — the
named projection weight=π(trace) — never stored, and the code inverts exactly
so the fibre is not lost to its shadow.
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

class SymCoder:
    """Code a symbol over the alphabet by binary decomposition, order-1
    (previous symbol) adaptive.  The projection; nothing stored."""
    def __init__(s): s.tab={}
    def _p(s,ctx,node): return s.tab.get((ctx<<6)|node,2048)
    def _u(s,ctx,node,bit):
        k=(ctx<<6)|node; v=s.tab.get(k,2048); s.tab[k]=v+(((bit<<12)-v)>>4)
    def enc(s,e,ctx,sym,nb):
        node=1
        for i in range(nb-1,-1,-1):
            b=(sym>>i)&1; p1=s._p(ctx,node); p0=4096-p1
            p0=1 if p0<1 else(4095 if p0>4095 else p0)
            e.bit(p0,b); s._u(ctx,node,b); node=(node<<1)|b
    def dec(s,d,ctx,nb):
        node=1
        for i in range(nb-1,-1,-1):
            p1=s._p(ctx,node); p0=4096-p1
            p0=1 if p0<1 else(4095 if p0>4095 else p0)
            b=d.bit(p0); s._u(ctx,node,b); node=(node<<1)|b
        return node-(1<<nb)

# ── schema induction: schemata a·x·b, one variable slot, laghava-greedy ──
#
# A schema application in the sequence is a 3-slot record (S, filler, ·).
# We keep the sequence as a flat list where a schema occurrence is encoded
# inline as [MARK, sid, filler].  MARK is a reserved symbol.

# The sequence is a list of CELLS: an int < 256 is a terminal; a tuple
# (sid, filler) is a schema application.  Matching only ever sees three
# consecutive TERMINAL cells, so a match can never span a schema record.
def _gap_counts(cells):
    frames={}
    i=0; n=len(cells)
    while i<n-2:
        a,x,b=cells[i],cells[i+1],cells[i+2]
        if type(a) is int and type(x) is int and type(b) is int:
            d=frames.setdefault((a,b),{})
            d[x]=d.get(x,0)+1
        i+=1
    return frames

def install_schemata(data, max_schemata=4096):
    cells=list(data)
    schemata=[]
    while len(schemata)<max_schemata:
        frames=_gap_counts(cells)
        best=None; bestgain=0
        for (a,b),fillers in frames.items():
            if len(fillers)<2: continue        # ≥2 fillers = genuine pervasion, not a ground trigram
            gain=sum(fillers.values())-2       # laghava: 3→1 cell each, save 2 per occ, less the schema
            if gain>bestgain: bestgain=gain; best=(a,b)
        if best is None: break
        a,b=best; sid=len(schemata); schemata.append((a,b))
        out=[]; i=0; n=len(cells)
        while i<n:
            if (i<n-2 and cells[i]==a and cells[i+2]==b
                    and type(cells[i]) is int and type(cells[i+1]) is int and type(cells[i+2]) is int):
                out.append((sid, cells[i+1])); i+=3
            else:
                out.append(cells[i]); i+=1
        cells=out
    return cells, schemata

def _expand(cells, schemata, out):
    for c in cells:
        if type(c) is int: out.append(c)
        else:
            sid,filler=c; a,b=schemata[sid]; out.append(a); out.append(filler); out.append(b)

def compress(data:bytes)->bytes:
    cells, schemata = install_schemata(data)
    nsch=len(schemata)
    nb=8
    schb=max(1,(nsch-1).bit_length()) if nsch>1 else 1
    enc=REnc(); tc=SymCoder(); sc=SymCoder(); fc=SymCoder()
    flag=SymCoder()
    ctx=0; ntop=0
    for c in cells:
        isS = 0 if type(c) is int else 1
        flag.enc(enc, ctx&0x3F, isS, 1)
        if isS:
            sid,filler=c
            sc.enc(enc, 0, sid, schb)
            fc.enc(enc, ctx&0x3F, filler, nb)
            ctx=filler
        else:
            tc.enc(enc, ctx&0x3F, c, nb); ctx=c
        ntop+=1
    payload=enc.finish()
    hdr=bytearray(b"SCHM")+struct.pack("<QI",len(data),nsch)
    # schema table, coded (regrows free but we store it: it is tiny and its
    # induction is order-dependent, so we transmit the (a,b) pairs directly).
    sb=REnc(); sbc=SymCoder()
    for (a,b) in schemata:
        sbc.enc(sb,0,a,nb); sbc.enc(sb,0,b,nb)
    spay=sb.finish(); hdr+=struct.pack("<I",len(spay))+spay
    hdr+=struct.pack("<I",ntop)
    arc=bytes(hdr)+payload
    if decompress(arc)!=data: raise AssertionError("schematic: roundtrip certificate FAILED")
    compress.nsch=nsch; compress.ntop=ntop
    return arc

def decompress(arc:bytes)->bytes:
    assert arc[:4]==b"SCHM"; off=4
    N,nsch=struct.unpack_from("<QI",arc,off); off+=12
    slen,=struct.unpack_from("<I",arc,off); off+=4
    spay=arc[off:off+slen]; off+=slen
    nb=8
    sd=RDec(spay); sbc=SymCoder(); schemata=[]
    for _ in range(nsch):
        a=sbc.dec(sd,0,nb); b=sbc.dec(sd,0,nb); schemata.append((a,b))
    ntop,=struct.unpack_from("<I",arc,off); off+=4
    payload=arc[off:]
    schb=max(1,(nsch-1).bit_length()) if nsch>1 else 1
    dec=RDec(payload); tc=SymCoder(); sc=SymCoder(); fc=SymCoder(); flag=SymCoder()
    ctx=0; cells=[]
    for _ in range(ntop):
        isS=flag.dec(dec,ctx&0x3F,1)
        if isS:
            sid=sc.dec(dec,0,schb); filler=fc.dec(dec,ctx&0x3F,nb)
            cells.append((sid,filler)); ctx=filler
        else:
            sym=tc.dec(dec,ctx&0x3F,nb); cells.append(sym); ctx=sym
    out=bytearray(); _expand(cells,schemata,out)
    return bytes(out[:N])

def bench(data,label):
    n=len(data); t0=time.time(); c=compress(data); dt=time.time()-t0
    rows=[("schematic",len(c)),("generative?", None),("gzip-9",len(zlib.compress(data,9))),
          ("bz2-9",len(bz2.compress(data,9))),("lzma",len(lzma.compress(data,preset=9)))]
    print(f"\n{label}: {n} bytes  ({dt:.1f}s)")
    print(f"  {compress.nsch} schemata (a·x·b, ≥2 fillers each), "
          f"top stream {compress.ntop} records")
    for nm,sz in rows:
        if sz is None: continue
        print(f"  {nm:12s} {sz:9d}  {n/sz:6.2f}x  {8*sz/n:5.3f} bpc")
    assert decompress(c)==data; print("  [certificate] roundtrip exact")

if __name__=="__main__":
    if sys.argv[1:] and sys.argv[1]=="bench":
        for f in sys.argv[2:]: bench(open(f,"rb").read(),f)
    else: print(__doc__)
